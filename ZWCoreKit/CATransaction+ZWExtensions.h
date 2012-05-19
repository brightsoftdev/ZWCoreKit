#import <QuartzCore/QuartzCore.h>

@interface CATransaction (ZWExtensions)

+ (void)commitWithDuration:(CFTimeInterval)pDuration transactions:(void (^)(void))pTransactions;
+ (void)commitWithDuration:(CFTimeInterval)pDuration delay:(CFTimeInterval)pDelay transactions:(void (^)(void))pTransactions;
+ (void)commitWithDuration:(CFTimeInterval)pDuration transactions:(void (^)(void))pTransactions completionBlock:(void (^)(void))pCompletionBlock;
+ (void)commitWithDuration:(CFTimeInterval)pDuration delay:(CFTimeInterval)pDelay transactions:(void (^)(void))pTransactions completionBlock:(void (^)(void))pCompletionBlock;
+ (void)enableActionsForTransactions:(void (^)(void))pTransactions;
+ (void)disableActionsForTransactions:(void (^)(void))pTransactions;
+ (void)setActionsDisabled:(BOOL)pActionsDisabled forTransactions:(void (^)(void))pTransactions;

@end