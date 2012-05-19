#if TARGET_SDK_IOS
#import "ZWReachabilityMonitor.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

NSString *ZWReachabilityMonitorStatusDidChangeNotification = @"ZWReachabilityMonitorStatusDidChange";
NSString *ZWReachabilityMonitorDidStartNotification = @"ZWReachabilityMonitorDidStart";
NSString *ZWReachabilityMonitorDidStopNotification = @"ZWReachabilityMonitorDidStop";

static void ZWReachabilityMonitorCallback(SCNetworkReachabilityRef ref, SCNetworkReachabilityFlags flags, void *info);
static void ZWReachabilityMonitorCallback(SCNetworkReachabilityRef ref, SCNetworkReachabilityFlags flags, void *info) {
	@autoreleasepool {
		ZWReachabilityMonitor *monitor = (__bridge ZWReachabilityMonitor *)info;
		[NSDefaultNotificationCenter postNotificationName:ZWReachabilityMonitorStatusDidChangeNotification
												   object:monitor];
	}
};

@interface ZWReachabilityMonitor() {
	SCNetworkReachabilityRef ref;
	SCNetworkReachabilityContext refContext;
	BOOL localWiFi;
	
	dispatch_queue_t queue;
}

@end
@implementation ZWReachabilityMonitor

#pragma mark - Properties

@dynamic status;
@dynamic connectionRequired;
@synthesize monitoring;

- (ZWReachabilityStatus)status {
	__block ZWReachabilityStatus status = ZWReachabilityStatusNone;
	dispatch_sync(queue, ^{
		if(ref != nil) {
			SCNetworkReachabilityFlags flags;
			if(SCNetworkReachabilityGetFlags(ref, &flags)) {
				// local wifi
				{
					if((flags & kSCNetworkReachabilityFlagsReachable) &&
					   (flags & kSCNetworkReachabilityFlagsIsDirect)) {
						status = ZWReachabilityStatusWiFi;
					}
				}
				// other
				{
					if((flags & kSCNetworkReachabilityFlagsConnectionRequired)) {
						status = ZWReachabilityStatusWiFi;
					}
					
					if(((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
					   ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
						if((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
							status = ZWReachabilityStatusWiFi;
						}
					}
					
					if((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)  {
						status = ZWReachabilityStatusWWAN;
					}
				}
			}
		}
	});
	return status;
}
- (BOOL)connectionRequired {
	__block BOOL result = NO;
	dispatch_sync(queue, ^{
		if(ref == nil) {
			SCNetworkReachabilityFlags flags;
			if(SCNetworkReachabilityGetFlags(ref, &flags)) {
				result = (flags & kSCNetworkReachabilityFlagsConnectionRequired);
			}
		}
	});
	return result;
}

#pragma mark - Initialization

+ (ZWReachabilityMonitor *)reachabilityWithHostName:(NSString *)pHostName {
	ZWReachabilityMonitor *reachability = [[self alloc] init];
	reachability->ref = SCNetworkReachabilityCreateWithName(nil, pHostName.UTF8String);
	if(reachability->ref != nil) {
		return reachability;
	}
	return nil;
}
+ (void)monitorReachabilityWithHostName:(NSString *)pHostName statusHandler:(void (^)(ZWReachabilityStatus, BOOL *))pStatusHandler {
	if(pStatusHandler == nil) {
		return;
	}
	
	ZWReachabilityMonitor *monitor = [ZWReachabilityMonitor reachabilityWithHostName:pHostName];
	void (^block)(NSNotification *notification) = ^(NSNotification *notification) {
		ZWReachabilityMonitor *m = [notification object];
		BOOL stop = NO;
		pStatusHandler(m.status, &stop);
		if(stop) {
			[m stopMonitor];
			CFBridgingRelease((__bridge CFTypeRef)m);
		}
	};
	
	[[NSNotificationCenter defaultCenter] addObserverForName:ZWReachabilityMonitorStatusDidChangeNotification
													  object:monitor
													   queue:[NSOperationQueue currentQueue] 
												  usingBlock:block];
	[monitor startMonitor];
	CFBridgingRetain(monitor);
}

- (id)init {
	if((self = [super init])) {
		queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
	}
	return self;
}

#pragma mark - Actions

- (BOOL)startMonitor {
	__block BOOL result = NO;
	dispatch_sync(queue, ^{
		if(monitoring) {
			result = YES;
			return;
		}
		refContext = (SCNetworkReachabilityContext){
			0,
			(void *)CFBridgingRetain(self),
			nil,
			nil,
			nil,
		};
		
		if(SCNetworkReachabilitySetCallback(ref, ZWReachabilityMonitorCallback, &refContext)) {
			monitoring = SCNetworkReachabilityScheduleWithRunLoop(ref, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		}
		
		result = monitoring;
		dispatch_async(dispatch_get_main_queue(), ^{
			[NSDefaultNotificationCenter postNotificationName:ZWReachabilityMonitorDidStartNotification object:self];	
		});
	});
	return result;
}
- (void)stopMonitor {
	dispatch_sync(queue, ^{
		if(!monitoring) {
			return;
		}
		
		SCNetworkReachabilityUnscheduleFromRunLoop(ref, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		
		CFBridgingRelease(refContext.info);
		refContext = (SCNetworkReachabilityContext){
			0,
			nil,
			nil,
			nil,
			nil,
		};
		
		monitoring = NO;
		dispatch_async(dispatch_get_main_queue(), ^{
			[NSDefaultNotificationCenter postNotificationName:ZWReachabilityMonitorDidStopNotification object:self];
		});
	});
	
}

#pragma mark - Dealloc

- (void)dealloc {
    [self stopMonitor];
	CFRelease(ref);
	dispatch_release(queue);
}

@end
#endif