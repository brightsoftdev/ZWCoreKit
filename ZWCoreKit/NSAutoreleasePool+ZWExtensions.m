#if !__has_feature(objc_arc)
#import "NSAutoreleasePool+ZWExtensions.h"

@implementation NSAutoreleasePool (ZWExtensions)

+ (void)performBlockWithAutoreleasePool:(void (^)(void))pBlock {
	if(pBlock == nil) {
		return;
	}
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	pBlock();
	[pool drain];
}

@end
#endif