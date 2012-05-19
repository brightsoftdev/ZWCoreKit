#import "NSData+ZWExtensions.h"
#import "md5.h"
#import "sha1.h"

@implementation NSData (ZWExtensions)

- (NSString *)hexString {
	NSMutableString *buffer = [NSMutableString stringWithCapacity:[self length] * 2];
	const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
	for(NSUInteger i = 0; i < [self length]; ++i) {
		[buffer appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
	}
	return buffer;
}

@end
