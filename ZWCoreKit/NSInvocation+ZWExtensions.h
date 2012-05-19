#import <Foundation/Foundation.h>


@interface NSInvocation (ZWExtensions)

+ (id)invocationWithTarget:(NSObject *)pTarget selector:(SEL)pSelector;
+ (id)invocationWithTarget:(NSObject *)pTarget selector:(SEL)pSelector arguments:(NSArray *)pArguments;
- (void)setObjectArgument:(id)pObjectArgument atIndex:(NSInteger)pIndex;

@end
