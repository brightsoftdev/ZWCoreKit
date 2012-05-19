#import "NSOperation+ZWExtensions.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation NSOperation (ZWExtensions)

@dynamic isCancelled;
@dynamic isFinished;
@dynamic isExecuted;
@dynamic isReady;
@dynamic isConcurrent;

+ (id)operation {
	return [[self alloc] init];
}
- (void)executeInBackgroundWithDelegate:(id)pDelegate didEndSelector:(SEL)pDidEndSelector {
	dispatch_queue_t currentQueue = dispatch_get_current_queue();
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self startAndWaitUntilFinished];
		dispatch_async(currentQueue, ^{
			objc_msgSend(pDelegate, pDidEndSelector, self);
		});
	});
}
- (void)executeInBackgroundWithCompletionHandler:(void (^)(id operation))pCompletionHandler {
	dispatch_queue_t currentQueue = dispatch_get_current_queue();
	pCompletionHandler = [pCompletionHandler copy];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self startAndWaitUntilFinished];
		dispatch_async(currentQueue, ^{
			if(pCompletionHandler != nil) {
				pCompletionHandler(self);
			}
		});
	});
}
- (void)startAndWaitUntilFinished {
	[self start];
	[self waitUntilFinished];
}

@end
