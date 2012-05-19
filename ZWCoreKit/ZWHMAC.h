@interface NSData (ZWHMACExtensions)

- (NSData *)hmacSHA1DataForKey:(NSString *)pKey;
- (NSString *)hmacSHA1ForKey:(NSString *)pKey;

@end

@interface NSString (ZWHMACExtensions)

- (NSData *)hmacSHA1DataForKey:(NSString *)pKey;
- (NSString *)hmacSHA1ForKey:(NSString *)pKey;

@end
