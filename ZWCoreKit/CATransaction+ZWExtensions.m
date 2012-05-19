#import "CATransaction+ZWExtensions.h"

@implementation CATransaction (ZWExtensions)

+ (void)commitWithDuration:(CFTimeInterval)pDuration transactions:(void (^)(void))pTransactions {
	[self commitWithDuration:pDuration delay:0.0 transactions:pTransactions completionBlock:nil];
}
+ (void)commitWithDuration:(CFTimeInterval)pDuration delay:(CFTimeInterval)pDelay transactions:(void (^)(void))pTransactions {
	[self commitWithDuration:pDuration delay:pDelay transactions:pTransactions completionBlock:nil];
}
+ (void)commitWithDuration:(CFTimeInterval)pDuration transactions:(void (^)(void))pTransactions completionBlock:(void (^)(void))pCompletionBlock {
	[self commitWithDuration:pDuration delay:0.0 transactions:pTransactions completionBlock:pCompletionBlock];
}
+ (void)commitWithDuration:(CFTimeInterval)pDuration delay:(CFTimeInterval)pDelay transactions:(void (^)(void))pTransactions completionBlock:(void (^)(void))pCompletionBlock {
	if(pTransactions != nil) {
		void (^block)(void) = ^{
			[CATransaction begin];
			[CATransaction setAnimationDuration:pDuration];
			if(pCompletionBlock != nil) {
				[CATransaction setCompletionBlock:pCompletionBlock];
			}
			pTransactions();
			[CATransaction commit];
		};
		if(pDelay > 0.0) {
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, pDelay * NSEC_PER_SEC), dispatch_get_main_queue(), block);
		} else {
			dispatch_sync(dispatch_get_main_queue(), block);
		}
	}
}
+ (void)enableActionsForTransactions:(void (^)(void))pTransactions {
	if(pTransactions != nil) {
		BOOL state = [CATransaction disableActions];
		[CATransaction setDisableActions:NO];
		pTransactions();
		[CATransaction setDisableActions:state];
	}
}
+ (void)disableActionsForTransactions:(void (^)(void))pTransactions {
	if(pTransactions != nil) {
		BOOL state = [CATransaction disableActions];
		[CATransaction setDisableActions:YES];
		pTransactions();
		[CATransaction setDisableActions:state];
	}
}
+ (void)setActionsDisabled:(BOOL)pActionsDisabled forTransactions:(void (^)(void))pTransactions {
	if(pActionsDisabled) {
		[self disableActionsForTransactions:pTransactions];
	} else {
		[self enableActionsForTransactions:pTransactions];
	}
}

@end