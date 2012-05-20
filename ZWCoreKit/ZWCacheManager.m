#import "ZWCacheManager.h"
#import "NSString+ZWExtensions.h"

@interface ZWCacheManager() {
}

@property (strong) NSFileManager *fileManager;
@property (assign) BOOL cacheInfoDirty;
@property (assign) NSUInteger mutableSize;
@property (strong) NSDate *minModificationDate;
@property (strong) NSDate *maxModificationDate;

- (NSURL *)cacheDataURLForPath:(NSString *)pPath;
- (NSURL *)cacheDataURLForKeyPath:(NSString *)pKeyPath;
- (NSString *)cacheDataPathForKeyPath:(NSString *)pKeyPath;
- (NSUInteger)truncateCacheBeforeDate:(NSDate *)pDate size:(NSUInteger)pSize;
- (void)updateCacheInfo;

@end

@implementation ZWCacheManager

#pragma mark - Properties

@synthesize cacheURL;
@dynamic size;

@synthesize fileManager;
@synthesize cacheInfoDirty;
@synthesize mutableSize;
@synthesize minModificationDate;
@synthesize maxModificationDate;

- (NSUInteger)size {
	if(self.cacheInfoDirty) {
		[self updateCacheInfo];
	}
	return self.mutableSize;
}

#pragma mark - Initialization

- (id)initWithCacheURL:(NSURL *)pCacheURL {
	if((self = [super init])) {
		cacheURL = pCacheURL;
		self.fileManager = [[NSFileManager alloc] init];
		self.cacheInfoDirty = YES;
	}
	return self;
}
- (id)initWithCacheDirectoryName:(NSString *)pDirectoryName {
	NSString *path = NSHomeDirectory();
	path = [path stringByAppendingPathComponent:@"Library"];
	path = [path stringByAppendingPathComponent:@"Caches"];
	path = [path stringByAppendingPathComponent:pDirectoryName];
	return [self initWithCacheURL:[NSURL fileURLWithPath:path]];
}

#pragma mark - Actions

- (BOOL)cacheData:(NSData *)pData forPath:(NSString *)pPath {
	if(pData == nil) {
		return NO;
	}
	NSURL *url = [self cacheDataURLForPath:pPath];
	if(url == nil) {
		return NO;
	}
	
	if(![self.fileManager createDirectoryAtURL:url.URLByDeletingLastPathComponent
				   withIntermediateDirectories:YES
									attributes:nil 
										 error:nil]) {
		return NO;
	}
	
	if([pData writeToURL:url atomically:YES]) {
		self.cacheInfoDirty = YES;
		return YES;
	}
	
	return NO;
}
- (NSData *)cachedDataForPath:(NSString *)pPath {
	NSURL *url = [self cacheDataURLForPath:pPath];
	if(url == nil) {
		return nil;
	}
	return [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil];
}
- (BOOL)hasCachedDataForPath:(NSString *)pPath {
	NSURL *url = [self cacheDataURLForPath:pPath];
	if([url checkResourceIsReachableAndReturnError:nil]) {
		return YES;
	}
	return NO;
}
- (BOOL)removeCachedDataForPath:(NSString *)pPath {
	NSURL *url = [self cacheDataURLForPath:pPath];
	if(url != nil && 
	   [url checkResourceIsReachableAndReturnError:nil] &&
	   [self.fileManager removeItemAtURL:url error:nil]) {
		self.cacheInfoDirty = YES;
		return YES;
	}
	return NO;
}
- (NSTimeInterval)cachedDataAgeForPath:(NSString *)pPath {
	NSURL *url = [self cacheDataURLForPath:pPath];
	if(url != nil &&
	   [url checkResourceIsReachableAndReturnError:nil]) {
		NSDate *modificationDate = nil;
		[url getResourceValue:&modificationDate forKey:NSURLContentModificationDateKey error:nil];
		if(modificationDate != nil) {
			return [modificationDate timeIntervalSinceNow];
		}
	}
	return [[NSDate distantPast] timeIntervalSinceNow];
}
- (BOOL)touchCachedDataForPath:(NSString *)pPath {
	NSURL *url = [self cacheDataURLForPath:pPath];
	if(url != nil && 
	   [url checkResourceIsReachableAndReturnError:nil]) {
		return [url setResourceValue:[NSDate date] forKey:NSURLContentModificationDateKey error:nil];
	}
	return NO;
}
- (NSURL *)cacheDataURLForPath:(NSString *)pPath {
	if(pPath == nil) {
		return nil;
	}
	return [self.cacheURL URLByAppendingPathComponent:pPath];
}

- (BOOL)cacheData:(NSData *)pData forKeyPath:(NSString *)pKeyPath {
	return [self cacheData:pData forPath:[self cacheDataPathForKeyPath:pKeyPath]];
}
- (NSData *)cachedDataForKeyPath:(NSString *)pKeyPath {
	return [self cachedDataForPath:[self cacheDataPathForKeyPath:pKeyPath]];
}
- (BOOL)hasCachedDataForKeyPath:(NSString *)pKeyPath {
	return [self hasCachedDataForPath:[self cacheDataPathForKeyPath:pKeyPath]];
}
- (BOOL)removeCachedDataForKeyPath:(NSString *)pKeyPath {
	return [self removeCachedDataForPath:[self cacheDataPathForKeyPath:pKeyPath]];
}
- (NSTimeInterval)cachedDataAgeForKeyPath:(NSString *)pKeyPath {
	return [self cachedDataAgeForPath:[self cacheDataPathForKeyPath:pKeyPath]];
}
- (BOOL)touchCachedDataForKeyPath:(NSString *)pKeyPath {
	return [self touchCachedDataForPath:[self cacheDataPathForKeyPath:pKeyPath]];
}
- (NSURL *)cacheDataURLForKeyPath:(NSString *)pKeyPath {
	return [self cacheDataURLForPath:[self cacheDataPathForKeyPath:pKeyPath]];
}

- (BOOL)purge {
	if([self.fileManager removeItemAtURL:self.cacheURL error:nil]) {
		self.mutableSize = 0;
		self.minModificationDate = nil;
		self.maxModificationDate = nil;
		return YES;
	}
	return NO;
}
- (void)truncateToMaximumSize:(NSUInteger)pMaximumSize {
	if(self.cacheInfoDirty) {
		[self updateCacheInfo];
	}
	if(self.size <= pMaximumSize) {
		return;
	}
	
	NSTimeInterval stepInterval = MAX(10.0, (self.maxModificationDate.timeIntervalSinceReferenceDate - self.minModificationDate.timeIntervalSinceReferenceDate) / 10.0);
	NSUInteger step = 1;
	NSUInteger currentSize = self.size;
	
	while(currentSize > pMaximumSize) {
		NSDate *truncateDate = [self.minModificationDate dateByAddingTimeInterval:stepInterval * step++];
		currentSize -= [self truncateCacheBeforeDate:truncateDate size:currentSize - pMaximumSize];
	}
}
- (void)truncateToMinimumDate:(NSDate *)pMinimumDate {
	if(self.cacheInfoDirty) {
		[self updateCacheInfo];
	}
	[self truncateCacheBeforeDate:pMinimumDate size:NSUIntegerMax];
}

#pragma mark - Private Actions

- (NSString *)cacheDataPathForKeyPath:(NSString *)pKeyPath {
	if(pKeyPath == nil) {
		return nil;
	}
	return [[pKeyPath componentsSeparatedByString:@"."] componentsJoinedByString:@"/"];
}

- (NSUInteger)truncateCacheBeforeDate:(NSDate *)pDate size:(NSUInteger)pSize {
	NSUInteger truncatedSize = 0;
	
	NSArray *propertyKeys = [NSArray arrayWithObjects:
							 NSURLIsDirectoryKey,
							 NSURLIsRegularFileKey,
							 NSURLContentModificationDateKey,
							 NSURLFileSizeKey,
							 nil];
	NSDirectoryEnumerator *enumerator = [self.fileManager enumeratorAtURL:self.cacheURL
											   includingPropertiesForKeys:propertyKeys
																  options:0
															 errorHandler:nil];
	NSURL *url = nil;
	while((url = [enumerator nextObject]) != nil) {
		if(truncatedSize >= pSize) {
			break;
		}
		
		NSNumber *urlIsDirectory = nil;
		NSNumber *urlIsRegularFile = nil;
		NSDate *urlContentModificationDate = nil;
		NSNumber *urlFileSize = nil;
		
		[url getResourceValue:&urlIsDirectory forKey:NSURLIsDirectoryKey error:nil];
		[url getResourceValue:&urlIsRegularFile forKey:NSURLIsRegularFileKey error:nil];
		[url getResourceValue:&urlContentModificationDate forKey:NSURLContentModificationDateKey error:nil];
		[url getResourceValue:&urlFileSize forKey:NSURLFileSizeKey error:nil];
		
		// regular files only
		if([urlIsRegularFile boolValue]) {
			if([urlContentModificationDate compare:pDate] == NSOrderedAscending) {
				if([self.fileManager removeItemAtURL:url error:nil]) {
					truncatedSize += [urlFileSize unsignedIntegerValue];
					self.cacheInfoDirty = YES;
				}
			}
		}
	}
	
	return truncatedSize;
}
- (void)updateCacheInfo {
	@synchronized(self) {
		NSArray *propertyKeys = [NSArray arrayWithObjects:
								 NSURLIsDirectoryKey,
								 NSURLIsRegularFileKey,
								 NSURLContentModificationDateKey,
								 NSURLFileSizeKey,
								 nil];
		NSDirectoryEnumerator *enumerator = [self.fileManager enumeratorAtURL:self.cacheURL
												   includingPropertiesForKeys:propertyKeys
																	  options:0
																 errorHandler:nil];
		
		NSUInteger updateSize = 0;
		NSTimeInterval updateMin = [[NSDate distantFuture] timeIntervalSinceReferenceDate];
		NSTimeInterval updateMax = [[NSDate distantPast] timeIntervalSinceReferenceDate];
		
		for(NSURL *url in enumerator) {
			NSNumber *urlIsDirectory = nil;
			NSNumber *urlIsRegularFile = nil;
			NSDate *urlContentModificationDate = nil;
			NSNumber *urlFileSize = nil;
			
			[url getResourceValue:&urlIsDirectory forKey:NSURLIsDirectoryKey error:nil];
			[url getResourceValue:&urlIsRegularFile forKey:NSURLIsRegularFileKey error:nil];
			[url getResourceValue:&urlContentModificationDate forKey:NSURLContentModificationDateKey error:nil];
			[url getResourceValue:&urlFileSize forKey:NSURLFileSizeKey error:nil];
			
			// regular files only
			if([urlIsRegularFile boolValue]) {
				updateSize += [urlFileSize unsignedIntegerValue];
				
				NSTimeInterval time = urlContentModificationDate.timeIntervalSinceReferenceDate;
				if(time < updateMin) {
					updateMin = time;
				}
				if(time > updateMax) {
					updateMax = time;
				}
			}
			
		}
		
		self.minModificationDate = [NSDate dateWithTimeIntervalSinceReferenceDate:updateMin];
		self.maxModificationDate = [NSDate dateWithTimeIntervalSinceReferenceDate:updateMax];
		self.mutableSize = updateSize;
		self.cacheInfoDirty = NO;
	}
}

@end


#if DEBUG

@implementation ZWCacheManagerTests

- (void)run {
	ZWCacheManager *cacheManager = [[ZWCacheManager alloc] initWithCacheDirectoryName:@"HelloWorld"];
	NSLog(@"Cache Manager URL: %@", cacheManager.cacheURL);
	NSMutableArray *tests = [NSMutableArray arrayWithCapacity:10];
	NSMutableArray *testNames = [NSMutableArray arrayWithCapacity:10];
	
	
	// WRITE
	{
		NSData *data = [@"Some String Content" dataUsingEncoding:NSUTF8StringEncoding];
		[tests addObject:^BOOL {
			return [cacheManager cacheData:data forPath:@"WriteTest.txt"];
		}];
		[testNames addObject:@"cache data for single file"];
		
		[tests addObject:^BOOL {
			return [cacheManager cacheData:data forPath:@"WriteSubdirectory/Test.txt"];
		}];
		[testNames addObject:@"cache data for sub path"];
	}
	
	// READ
	{
		[tests addObject:^BOOL {
			NSData *data = [cacheManager cachedDataForPath:@"WriteTest.txt"];
			if([[NSString stringWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"Some String Content"]) {
				return YES;
			}
			return NO;
		}];
		[testNames addObject:@"read cached data for path"];
		
		[tests addObject:^BOOL {
			NSData *data = [cacheManager cachedDataForPath:@"WriteSubdirectory/Test.txt"];
			if([[NSString stringWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"Some String Content"]) {
				return YES;
			}
			return NO;
		}];
		[testNames addObject:@"read cached data for sub path"];
	}
	
	// REMOVE
	{
		[tests addObject:^BOOL {
			void *bytes = malloc(1024 * 1024 * 10);
			NSData *bigData = [NSData dataWithBytesNoCopy:bytes length:1024 * 1024 * 10 freeWhenDone:YES];
			[cacheManager cacheData:bigData forPath:@"BigDataFile.dat"];
			return [cacheManager removeCachedDataForPath:@"BigDataFile.dat"];
		}];
		[testNames addObject:@"remove single file"];
		
		[tests addObject:^BOOL {
			void *bytes = malloc(1024 * 1024 * 10);
			NSData *bigData = [NSData dataWithBytesNoCopy:bytes length:1024 * 1024 * 10 freeWhenDone:YES];
			[cacheManager cacheData:bigData forPath:@"RemoveSubdirectory/BigDataFile.dat"];
			return [cacheManager removeCachedDataForPath:@"RemoveSubdirectory/BigDataFile.dat"];
		}];
		[testNames addObject:@"remove sub path"];
	}
	
	// SIZE
	{
		[tests addObject:^BOOL {
			void *bytes = malloc(1024 * 1024 * 10);
			NSData *bigData = [NSData dataWithBytesNoCopy:bytes length:1024 * 1024 * 10 freeWhenDone:YES];
			[cacheManager purge];
			[cacheManager cacheData:bigData forPath:@"BigDataFile.dat"];
			return fabs(bigData.length - cacheManager.size) < 1024 * 1024;
		}];
		[testNames addObject:@"size"];
	}
	
	// TRUNCATE
	{
		[tests addObject:^BOOL {
			[cacheManager truncateToMaximumSize:1024 * 1024 * 11];
			return (cacheManager.size <= 1024 * 1024 * 11);
		}];
		[testNames addObject:@"truncate to maximum size A"];
		
		[tests addObject:^BOOL {
			if(cacheManager.size <= 1024) {
				return NO;
			}
			[cacheManager truncateToMaximumSize:1024];
			return (cacheManager.size <= 1024);
		}];
		[testNames addObject:@"truncate to maximum size B"];
	}
	
	// PURGE
	{
		[tests addObject:^BOOL {
			return [cacheManager purge];
		}];
		[testNames addObject:@"purge"];
	}
	
	// RUN
	for(NSInteger i = 0; i < tests.count; ++i) {
		BOOL (^test)(void) = [tests objectAtIndex:i];
		if(test()) {
			NSLog(@"PASSED: %@", [testNames objectAtIndex:i]);
		} else {
			NSLog(@"FAILED: %@", [testNames objectAtIndex:i]);
		}
	}
	
}

@end

#endif