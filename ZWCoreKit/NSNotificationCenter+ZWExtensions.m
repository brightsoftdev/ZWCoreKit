#import "NSNotificationCenter+ZWExtensions.h"

@implementation NSNotificationCenter (ZWExtensions)

- (id)addObserverForName:(NSString *)pName object:(id)pObject usingBlock:(void (^)(NSNotification *notification))pBlock {
	return [self addObserverForName:pName object:pObject queue:[NSOperationQueue currentQueue] usingBlock:pBlock];
}

@end
