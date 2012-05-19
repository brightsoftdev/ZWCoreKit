#if TARGET_SDK_IOS
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

extern NSString *ZWReachabilityMonitorStatusDidChangeNotification;

enum {
	ZWReachabilityStatusNone = 0,
	ZWReachabilityStatusWiFi,
	ZWReachabilityStatusWWAN,
};
typedef NSUInteger ZWReachabilityStatus;

@interface ZWReachabilityMonitor : NSObject

#pragma mark - Properties

@property (nonatomic, readonly) ZWReachabilityStatus status;
@property (nonatomic, readonly) BOOL connectionRequired;
@property (nonatomic, readonly) BOOL monitoring;

#pragma mark - Initialization

+ (ZWReachabilityMonitor *)reachabilityWithHostName:(NSString *)pHostName;
+ (void)monitorReachabilityWithHostName:(NSString *)pHostName statusHandler:(void (^)(ZWReachabilityStatus status, BOOL *stop))pStatusHandler;

#pragma mark - Actions

- (BOOL)startMonitor;
- (void)stopMonitor;

@end
#endif