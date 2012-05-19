#import "ZWBlockInvocation.h"

@implementation ZWBlockInvocation

#pragma mark - Properties

@synthesize handler;
@synthesize userInfo;

#pragma mark - Initialization

+ (ZWBlockInvocation *)invocationWithHandler:(void (^)(id userInfo))pHandler userInfo:(id)pUserInfo {
	return [[self alloc] initWithHandler:pHandler userInfo:pUserInfo];
}
- (id)initWithHandler:(void (^)(id userInfo))pHandler userInfo:(id)pUserInfo {
	if((self = [super init])) {
		handler = [pHandler copy];
		userInfo = pUserInfo;
	}
	return self;
}

- (void)invoke:(id)pSender {
	[self invoke];
}
- (void)invoke {
	if(handler != nil) {
		handler(userInfo);
	}
}

@end
