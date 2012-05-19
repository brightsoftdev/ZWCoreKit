#import <Foundation/Foundation.h>

@interface ZWBlockInvocation : NSObject

#pragma mark - Properties

@property (copy) void (^handler)(id userInfo);
@property (strong) id userInfo;

#pragma mark - Initialization

+ (ZWBlockInvocation *)invocationWithHandler:(void (^)(id userInfo))pHandler userInfo:(id)pUserInfo;
- (id)initWithHandler:(void (^)(id userInfo))pHandler userInfo:(id)pUserInfo;

#pragma mark - Invoking

- (IBAction)invoke:(id)pSender;
- (void)invoke;

@end
