#import "ZWConcurrentOperation.h"

@interface ZWConcurrentOperation() {
}

@property (assign, getter = isFinished) BOOL finished;
@property (assign, getter = isExecuting) BOOL executing;
@property (assign, getter = isCancelled) BOOL cancelled;
@property (assign) dispatch_queue_t queue;

@end
@implementation ZWConcurrentOperation

#pragma mark - Class Properties

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)pKey {
	if([pKey isEqualToString:@"isFinished"] ||
	   [pKey isEqualToString:@"isExecuting"] ||
	   [pKey isEqualToString:@"isCancelled"]) {
		return NO;
	}
	return [super automaticallyNotifiesObserversForKey:pKey];
}

#pragma mark - Properties

@synthesize finished;
@synthesize executing;
@synthesize cancelled;
@synthesize queue;

- (BOOL)isConcurrent {
	return YES;
}

#pragma mark - Initialization

- (id)init {
	if((self = [super init])) {
		self.queue = dispatch_queue_create(nil, nil);
	}
	return self;
}

#pragma mark - NSOperation

- (void)start {
	if(self.isExecuting && self.isFinished && self.isCancelled) {
		return;
	}
	[self willChangeValueForKey:@"isExecuting"];
	self.executing = YES;
	[self didChangeValueForKey:@"isExecuting"];
	if(!self.isCancelled) {		
		dispatch_async(self.queue, ^{
			if(!self.isCancelled) {
				[self main];
			}
			[self willChangeValueForKey:@"isExecuting"];
			self.executing = NO;
			[self didChangeValueForKey:@"isExecuting"];
			[self willChangeValueForKey:@"isFinished"];
			self.finished = YES;
			[self didChangeValueForKey:@"isFinished"];
		});
	}
}

#pragma mark - Dealloc

- (void)dealloc {
    dispatch_release(queue);
}

@end
