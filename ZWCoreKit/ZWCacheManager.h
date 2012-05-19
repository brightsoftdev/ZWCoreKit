#import <Foundation/Foundation.h>

@interface ZWCacheManager : NSObject

#pragma mark - Properties

@property (strong, readonly) NSURL *cacheURL;
@property (readonly) NSUInteger size;

#pragma mark - Initialization

- (id)initWithCacheURL:(NSURL *)pCacheURL;
- (id)initWithCacheDirectoryName:(NSString *)pDirectoryName;

#pragma mark - Actions

- (BOOL)cacheData:(NSData *)pData forPath:(NSString *)pPath;
- (NSData *)cachedDataForPath:(NSString *)pPath;
- (BOOL)hasCachedDataForPath:(NSString *)pPath;
- (BOOL)removeCachedDataForPath:(NSString *)pPath;
- (NSTimeInterval)cachedDataAgeForPath:(NSString *)pPath;
- (BOOL)touchCachedDataForPath:(NSString *)pPath;
- (NSURL *)cacheDataURLForPath:(NSString *)pPath;

- (BOOL)cacheData:(NSData *)pData forKeyPath:(NSString *)pKeyPath;
- (NSData *)cachedDataForKeyPath:(NSString *)pKeyPath;
- (BOOL)hasCachedDataForKeyPath:(NSString *)pKeyPath;
- (BOOL)removeCachedDataForKeyPath:(NSString *)pKeyPath;
- (NSTimeInterval)cachedDataAgeForKeyPath:(NSString *)pKeyPath;
- (BOOL)touchCachedDataForKeyPath:(NSString *)pKeyPath;
- (NSURL *)cacheDataURLForKeyPath:(NSString *)pKeyPath;

- (BOOL)purge;
- (void)truncateToMaximumSize:(NSUInteger)pMaximumSize;
- (void)truncateToMinimumDate:(NSDate *)pMinimumDate;

@end

#if DEBUG

@interface ZWCacheManagerTests : NSObject

- (void)run;

@end

#endif