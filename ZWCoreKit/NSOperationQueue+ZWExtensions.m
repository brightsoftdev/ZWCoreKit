#import "NSOperationQueue+ZWExtensions.h"


@implementation NSOperationQueue (ZWExtensions)

+ (NSOperationQueue *)sharedConcurrentQueue {
	static NSOperationQueue *sharedConcurrentQueue;
	static dispatch_once_t sharedConcurrentQueueOnce;
	dispatch_once(&sharedConcurrentQueueOnce, ^{
		sharedConcurrentQueue = [[NSOperationQueue alloc] init];
	});
	return sharedConcurrentQueue;
}
+ (NSOperationQueue *)sharedSerialQueue {
	static NSOperationQueue *sharedSerialQueue;
	static dispatch_once_t sharedSerialQueueOnce;
	dispatch_once(&sharedSerialQueueOnce, ^{
		sharedSerialQueue = [[NSOperationQueue alloc] init];
		[sharedSerialQueue setMaxConcurrentOperationCount:1];
	});
	return sharedSerialQueue;
}
- (void)addOperations:(NSArray *)pOperations completionBlock:(void (^)(NSArray *operations))pCompletionBlock {
	pCompletionBlock = [pCompletionBlock copy];
	if(pCompletionBlock != nil) {
		dispatch_queue_t currentQueue = dispatch_get_current_queue();
		dispatch_retain(currentQueue);
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			[self addOperations:pOperations waitUntilFinished:YES];
			dispatch_sync(currentQueue, ^{
				pCompletionBlock(pOperations);
			});
			dispatch_release(currentQueue);
		});
	} else {
		[self addOperations:pOperations waitUntilFinished:NO];
	}
};
- (void)addOperation:(NSOperation *)pOperation completionBlock:(void (^)(NSOperation *operation))pCompletionBlock {
	pCompletionBlock = [pCompletionBlock copy];
	if(pCompletionBlock != nil) {
		dispatch_queue_t currentQueue = dispatch_get_current_queue();
		dispatch_retain(currentQueue);
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			[self addOperations:[NSArray arrayWithObject:pOperation] waitUntilFinished:YES];
			dispatch_sync(currentQueue, ^{
				pCompletionBlock(pOperation);
			});
			dispatch_release(currentQueue);
		});
	} else {
		[self addOperation:pOperation];
	}
}

@end