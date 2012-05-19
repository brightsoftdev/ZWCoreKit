#import "ZWMD5.h"
#import "md5.h"

@implementation NSData (ZWMD5Extensions)

- (NSData *)md5Data {
	unsigned char digest[16];
	MD5([self bytes], [self length], digest);
	return [NSData dataWithBytes:digest length:16];
}
- (NSString *)md5 {
	unsigned char digest[20];
	char stringDigest[33];
	MD5([self bytes], [self length], digest);
	for(int i = 0; i < 16; ++i) {
		sprintf(stringDigest + i * 2, "%02x", digest[i]);
	}
	stringDigest[32] = 0;
	return [NSString stringWithCString:stringDigest encoding:NSASCIIStringEncoding];
}

@end

@implementation NSString (ZWMD5Extensions)

- (NSData *)md5Data {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] md5Data];
}
- (NSString *)md5 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] md5];
}

@end