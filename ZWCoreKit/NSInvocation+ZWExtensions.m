#import "NSInvocation+ZWExtensions.h"


@implementation NSInvocation (ZWExtensions)

+ (id)invocationWithTarget:(NSObject *)pTarget selector:(SEL)pSelector {
	if(pTarget == nil) {
		return nil;
	}
	NSInvocation *invocation = [self invocationWithMethodSignature:[pTarget methodSignatureForSelector:pSelector]];
	[invocation setTarget:pTarget];
	[invocation setSelector:pSelector];
	return invocation;
}
+ (id)invocationWithTarget:(id)pTarget selector:(SEL)pSelector arguments:(NSArray *)pArguments {
	if(pTarget == nil) {
		return nil;
	}
	NSInvocation *invocation = [self invocationWithTarget:pTarget selector:pSelector];
	NSInteger nextArgumentIndex = 2;
	for(id argument in pArguments) {
		[invocation setObjectArgument:argument atIndex:nextArgumentIndex++];
		
	}
	[invocation retainArguments];
	return invocation;
}
- (void)setObjectArgument:(id)pObjectArgument atIndex:(NSInteger)pIndex {
	void *v = (__bridge void *)pObjectArgument;
	[self setArgument:&v atIndex:pIndex];
}

@end
