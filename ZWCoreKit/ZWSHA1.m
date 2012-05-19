#import "ZWSHA1.h"
#import "sha1.h"

@implementation NSData (ZWSHA1Extensions)

- (NSData *)sha1Data {
	unsigned char digest[20];
	SHA1([self bytes], [self length], digest);
	return [NSData dataWithBytes:digest length:20];
}
- (NSString *)sha1 {
	unsigned char digest[20];
	char stringDigest[41];
	SHA1([self bytes], [self length], digest);
	for(int i = 0; i < 20; ++i) {
		sprintf(stringDigest + i * 2, "%02x", digest[i]);
	}
	stringDigest[40] = 0;
	return [NSString stringWithCString:stringDigest encoding:NSASCIIStringEncoding];
}

@end

@implementation NSString (ZWSHA1Extensions)

- (NSData *)sha1Data {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] sha1Data];
}
- (NSString *)sha1 {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] sha1];
}

@end