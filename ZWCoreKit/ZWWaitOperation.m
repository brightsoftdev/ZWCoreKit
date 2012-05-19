#import "ZWWaitOperation.h"

@interface ZWWaitOperation() {

}

@property (retain) NSCondition *condition;

@end
@implementation ZWWaitOperation

#pragma mark - Properties

@synthesize waitTimeInterval;
@synthesize condition;

#pragma mark - Initialization

+ (id)operationWithWaitTimeInterval:(NSTimeInterval)pWaitTimeInterval {
	return [[self alloc] initWithWaitTimeInterval:pWaitTimeInterval];
}
- (id)initWithWaitTimeInterval:(NSTimeInterval)pWaitTimeInterval {
	if((self = [super init])) {
		waitTimeInterval = pWaitTimeInterval;
		self.condition = [[NSCondition alloc] init];
	}
	return self;
}

#pragma mark - Actions

- (void)cancel {
	[super cancel];
	[self.condition signal];
}

#pragma mark - Main

- (void)main {
	@autoreleasepool {
		[self.condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:self.waitTimeInterval]];
	}
}


@end
