#import "ZWURLCacheManager.h"

@interface ZWURLCacheManager() {
	
}

- (NSString *)cacheDataPathForURL:(NSURL *)pURL;

@end
@implementation ZWURLCacheManager

#pragma mark - Initialization

+ (ZWURLCacheManager *)sharedURLCacheManager {
	static ZWURLCacheManager *sharedURLCacheManager = nil;
	static dispatch_once_t sharedURLCacheManagerOnce;
	dispatch_once(&sharedURLCacheManagerOnce, ^{
		sharedURLCacheManager = [[ZWURLCacheManager alloc] initWithCacheDirectoryName:@"URLCache"];
		[sharedURLCacheManager truncateToMaximumSize:1024 * 1024 * 100];
	});
	return sharedURLCacheManager;
}

#pragma mark - Actions

- (BOOL)cacheData:(NSData *)pData forURL:(NSURL *)pURL {
	return [self cacheData:pData forPath:[self cacheDataPathForURL:pURL]];
}
- (BOOL)hasCachedDataForURL:(NSURL *)pURL {
	return [self hasCachedDataForPath:[self cacheDataPathForURL:pURL]];
}
- (NSData *)cachedDataForURL:(NSURL *)pURL {
	return [self cachedDataForPath:[self cacheDataPathForURL:pURL]];
}
- (BOOL)removeCachedDataForURL:(NSURL *)pURL {
	return [self removeCachedDataForPath:[self cacheDataPathForURL:pURL]];
}
- (NSTimeInterval)cachedDataAgeForURL:(NSURL *)pURL {
	return [self cachedDataAgeForPath:[self cacheDataPathForURL:pURL]];
}
- (BOOL)touchCachedDataForURL:(NSURL *)pURL {
	return [self touchCachedDataForPath:[self cacheDataPathForURL:pURL]];
}
- (NSURL *)cacheDataURLForURL:(NSURL *)pURL {
	return [self cacheDataURLForPath:[self cacheDataPathForURL:pURL]];
}

#pragma mark - Private Actions

- (NSString *)cacheDataPathForURL:(NSURL *)pURL {
	if(pURL == nil) {
		return nil;
	}
	NSString *path = pURL.description;
	NSUInteger length = path.length;
	unichar *buffer = (unichar *)malloc(length * sizeof(unichar));
	[path getCharacters:buffer range:NSMakeRange(0, length)];
	
	for(NSInteger i = 0; i < length; ++i) {
		unichar c = buffer[i];
		if((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' || c == '.') {
			continue;
		}
		buffer[i] = '-';
	}
	path = [NSString stringWithCharacters:buffer length:length];
	free(buffer);
	return path;
}

@end
