#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

enum {
	ZWLocationMonitorStateNone = 0, /* none */
	ZWLocationMonitorStateAuthorizationDenied, /* user has disabled location services and we've already prompted */
	ZWLocationMonitorStateLocationValid, /* valid */
	ZWLocationMonitorStateLocationError, /* some error occured */
	ZWLocationMonitorStateLocationUnknown, /* unknown */
	ZWLocationMonitorStateTimeout, /* timed out */
	ZWLocationMonitorStateCancelled, /* cancelled */
};
typedef NSUInteger ZWLocationMonitorState;

@class ZWLocationMonitor;

@protocol ZWLocationMonitorDelegate <NSObject>

@optional

- (void)locationMonitor:(ZWLocationMonitor *)pMonitor didUpdateToLocation:(CLLocation *)pLocation fromLocation:(CLLocation *)pOldLocation;
- (void)locationMonitor:(ZWLocationMonitor *)pMonitor didFailWithError:(NSError *)pError;

@end

@interface ZWLocationMonitor : NSObject

#pragma mark - Properties

@property (readonly) ZWLocationMonitorState state; /* state */
@property (strong, readonly) NSError *error; /* any error */
@property (strong, readonly) CLLocation *location; /* last valid location */

@property (readonly) CLLocationAccuracy desiredAccuracy; /* what accuracy the gps will try to obtain */
@property (readonly) CLLocationAccuracy acceptableAccuracy; /* what accuracy is acceptable - will stop monitoring when it gets to this */
@property (readonly) CLLocationAccuracy requiredAccuracy; /* what accuracy is required - will fail if it never gets to this */
@property (readonly) CFTimeInterval maximumAge; /* maximum age a location can be */

#if OBJC_ARC_WEAK
@property (weak) id <ZWLocationMonitorDelegate> delegate;
#else
@property (assign) id <ZWLocationMonitorDelegate> delegate;
#endif

#pragma mark - Initialization

+ (ZWLocationMonitor *)locationMonitorWithDesiredAccuracy:(CLLocationAccuracy)pDesiredAccuracy
									   acceptableAccuracy:(CLLocationAccuracy)pAcceptableAccuracy
										 requiredAccuracy:(CLLocationAccuracy)pRequiredAccuracy 
											   maximumAge:(CFTimeInterval)pMaximumAge;
- (id)initWithDesiredAccuracy:(CLLocationAccuracy)pDesiredAccuracy
		   acceptableAccuracy:(CLLocationAccuracy)pAcceptableAccuracy
			 requiredAccuracy:(CLLocationAccuracy)pRequiredAccuracy 
				   maximumAge:(CFTimeInterval)pMaximumAge;

#pragma mark - Actions

- (ZWLocationMonitorState)waitForLocation;
- (ZWLocationMonitorState)waitForLocationWithTimeout:(NSTimeInterval)pTimeout;
- (void)cancelWaitForLocation;

- (BOOL)startContinuousMonitor;
- (void)stopContinuousMonitor;

@end
