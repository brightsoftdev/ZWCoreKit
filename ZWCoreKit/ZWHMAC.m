#import "ZWHMAC.h"
#import "hmac.h"

@implementation NSData (ZWHMACExtensions)

- (NSData *)hmacSHA1DataForKey:(NSString *)pKey {
	unsigned char digest[20];
	HMACSHA1([self bytes], [self length], (const unsigned char *)pKey.UTF8String, pKey.length, digest);
	return [NSData dataWithBytes:digest length:20];
}
- (NSString *)hmacSHA1ForKey:(NSString *)pKey {
	unsigned char digest[20];
	char stringDigest[41];
	HMACSHA1([self bytes], [self length], (const unsigned char *)pKey.UTF8String, pKey.length, digest);
	for(int i = 0; i < 20; ++i) {
		sprintf(stringDigest + i * 2, "%02x", digest[i]);
	}
	stringDigest[40] = 0;
	return [NSString stringWithCString:stringDigest encoding:NSASCIIStringEncoding];
}

@end

@implementation NSString (ZWHMACExtensions)

- (NSData *)hmacSHA1DataForKey:(NSString *)pKey {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] hmacSHA1DataForKey:pKey];
}
- (NSString *)hmacSHA1ForKey:(NSString *)pKey {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] hmacSHA1ForKey:pKey];
}

@end