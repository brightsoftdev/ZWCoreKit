#import "ZWCacheManager.h"

@interface ZWURLCacheManager : ZWCacheManager

#pragma mark - Initialization

+ (ZWURLCacheManager *)sharedURLCacheManager;

#pragma mark - Actions

- (BOOL)cacheData:(NSData *)pData forURL:(NSURL *)pURL;
- (BOOL)hasCachedDataForURL:(NSURL *)pURL;
- (NSData *)cachedDataForURL:(NSURL *)pURL;
- (BOOL)removeCachedDataForURL:(NSURL *)pURL;
- (NSTimeInterval)cachedDataAgeForURL:(NSURL *)pURL;
- (BOOL)touchCachedDataForURL:(NSURL *)pURL;
- (NSURL *)cacheDataURLForURL:(NSURL *)pURL;

@end
