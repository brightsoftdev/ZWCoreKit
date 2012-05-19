#import "NSEnumerator+ZWExtensions.h"


@implementation NSEnumerator (ZWExtensions)

- (void)makeObjectsPerformBlock:(void (^)(id object))pBlock {
	if(pBlock == nil) {
		return;
	}
	for(id object in self) {
		pBlock(object);
	}
}

@end
