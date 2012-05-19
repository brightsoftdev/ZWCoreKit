#import "ZWLocationMonitor.h"

@interface ZWLocationMonitor() <CLLocationManagerDelegate> {
}

@property (strong) CLLocationManager *locationManager;
@property (assign) ZWLocationMonitorState mutableState;
@property (strong) NSError *mutableError;
@property (strong) CLLocation *mutableLocation;
@property (strong) NSCondition *waitCondition;
@property (assign) BOOL updating;
@property (assign) BOOL continuous;

+ (CLLocation *)lastLocation;
+ (void)setLastLocation:(CLLocation *)pValue;

- (BOOL)isValidLocation:(CLLocation *)pLocation;
- (BOOL)startUpdatingLocation:(BOOL)pIgnoreAuthorizationStatus;
- (void)stopUpdatingLocation;

@end
@implementation ZWLocationMonitor

#pragma mark - Class Properties

static CLLocation *ZWLocationMonitorLastLocation = nil;
+ (CLLocation *)lastLocation {
	return ZWLocationMonitorLastLocation;
}
+ (void)setLastLocation:(CLLocation *)pValue {
	ZWLocationMonitorLastLocation = pValue;
}

#pragma mark - Properties

@dynamic state;
@dynamic error;
@dynamic location;

@dynamic desiredAccuracy;
@synthesize acceptableAccuracy;
@synthesize requiredAccuracy;
@synthesize maximumAge;

@synthesize delegate;

@synthesize locationManager;
@synthesize mutableState;
@synthesize mutableError;
@synthesize mutableLocation;
@synthesize waitCondition;
@synthesize updating;
@synthesize continuous;

- (ZWLocationMonitorState)state {
	return self.mutableState;
}
- (NSError *)error {
	return self.mutableError;
}
- (CLLocation *)location {
	if([self isValidLocation:self.mutableLocation]) {
		return self.mutableLocation;
	}
	return nil;
}
- (void)setDesiredAccuracy:(CLLocationAccuracy)pValue {
	@synchronized(self) {
		self.locationManager.desiredAccuracy = pValue;
	}
}
- (CLLocationAccuracy)desiredAccuracy {
	@synchronized(self) {
		return self.locationManager.desiredAccuracy;
	}
	return kCLLocationAccuracyBest;
}

#pragma mark - Initialization

+ (ZWLocationMonitor *)locationMonitorWithDesiredAccuracy:(CLLocationAccuracy)pDesiredAccuracy
									   acceptableAccuracy:(CLLocationAccuracy)pAcceptableAccuracy
										 requiredAccuracy:(CLLocationAccuracy)pRequiredAccuracy 
											   maximumAge:(CFTimeInterval)pMaximumAge {
	return [[self alloc] initWithDesiredAccuracy:pDesiredAccuracy
							  acceptableAccuracy:pAcceptableAccuracy
								requiredAccuracy:pRequiredAccuracy
									  maximumAge:pMaximumAge];
}
- (id)initWithDesiredAccuracy:(CLLocationAccuracy)pDesiredAccuracy
		   acceptableAccuracy:(CLLocationAccuracy)pAcceptableAccuracy
			 requiredAccuracy:(CLLocationAccuracy)pRequiredAccuracy 
				   maximumAge:(CFTimeInterval)pMaximumAge {
	if((self = [super init])) {
		acceptableAccuracy = pAcceptableAccuracy;
		requiredAccuracy = pRequiredAccuracy;
		maximumAge = pMaximumAge;
		
		mutableState = ZWLocationMonitorStateNone;
		mutableError = nil;
		mutableLocation = ([self isValidLocation:[[self class] lastLocation]]) ? [[self class] lastLocation] : nil;
		waitCondition = [[NSCondition alloc] init];
		updating = NO;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			self.locationManager = [[CLLocationManager alloc] init];
			self.locationManager.desiredAccuracy = pDesiredAccuracy;
			self.locationManager.delegate = self;
		});
	}
	return self;
}

#pragma mark - Actions

- (ZWLocationMonitorState)waitForLocation {
	return [self waitForLocationWithTimeout:0.0];
}
- (ZWLocationMonitorState)waitForLocationWithTimeout:(CFTimeInterval)pTimeout {
	// check if main thread
	if([NSThread isMainThread]) {
		ZWLog(@"WARNING: you cannot wait on the main thread. You must use a background thread");
		return ZWLocationMonitorStateNone;
	}
	
	// start updating
	if(![self startUpdatingLocation:NO]) {
		return self.state;
	}
	
	[self.waitCondition lock];
	
	// we're going to block the thread while state == none
	while(self.state == ZWLocationMonitorStateNone) {
		// get timeout date, if timeout is <= 0.0 then we never timeout
		NSDate *timeoutDate = (pTimeout > 0.0) ? [NSDate dateWithTimeIntervalSinceNow:pTimeout] : [NSDate distantFuture];
		
		// if waitUntilDate returns NO we timed out
		if(![self.waitCondition waitUntilDate:timeoutDate]) {
			if(self.state == ZWLocationMonitorStateNone) {
				self.mutableState = ZWLocationMonitorStateTimeout;
				break;
			}
		}
	}
	
	[self.waitCondition unlock];
	self.waitCondition = nil;
	
	// stop updating - if not continuous
	if(!self.continuous) {
		[self stopUpdatingLocation];
	}
	return self.state;
}
- (void)cancelWaitForLocation {
	[self.waitCondition lock];
	self.mutableState = ZWLocationMonitorStateCancelled;
	[self.waitCondition broadcast];
	[self.waitCondition unlock];
}

- (BOOL)startContinuousMonitor {
	if(self.continuous) {
		return YES;
	}
	if([self startUpdatingLocation:NO]) {
		self.mutableState = ZWLocationMonitorStateNone;
		self.continuous = YES;
		return YES;
	} else {
		return NO;
	}
}
- (void)stopContinuousMonitor {
	if(!self.continuous) {
		return;
	}
	[self stopUpdatingLocation];
	self.continuous = NO;
}

#pragma mark - Private Actions

- (BOOL)isValidLocation:(CLLocation *)pLocation {
	if(pLocation == nil) {
		return NO;
	}
	
	// too inaccurate
	if(pLocation.horizontalAccuracy > self.requiredAccuracy ||
	   pLocation.verticalAccuracy > self.requiredAccuracy) {
		return NO;
	}
	
	// too old
	if([[pLocation.timestamp dateByAddingTimeInterval:self.maximumAge] compare:[NSDate date]] == NSOrderedAscending) {
		return NO;
	}
	
	return YES;
}
- (BOOL)startUpdatingLocation:(BOOL)pIgnoreAuthorizationStatus {
	if(self.updating) {
		return YES;
	}
	
	// have we prompted before for authorization
	BOOL prompted = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.apple.CoreLocation.PromptedAuthorization"];
	if([CLLocationManager locationServicesEnabled] || pIgnoreAuthorizationStatus || !prompted) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.apple.CoreLocation.PromptedAuthorization"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		self.updating = YES;
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			self.locationManager.desiredAccuracy = self.desiredAccuracy;
			
			// immediately dispatch to location
			[self locationManager:self.locationManager didUpdateToLocation:self.locationManager.location fromLocation:self.location];
			
			// start updates
			[self.locationManager startUpdatingLocation];
			
		});
		
		return YES;
	} else {
		self.mutableState = ZWLocationMonitorStateAuthorizationDenied;
		return NO;
	}
}
- (void)stopUpdatingLocation {
	if(!self.updating) {
		return;
	}
	self.updating = NO;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.locationManager.desiredAccuracy = self.desiredAccuracy;
		[self.locationManager stopUpdatingLocation];
	});
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)pLocationManager didUpdateToLocation:(CLLocation *)pNewLocation fromLocation:(CLLocation *)pOldLocation {
	// store lastLocation
	[[self class] setLastLocation:pNewLocation];
	
	if([self isValidLocation:pNewLocation]) {
		[self.waitCondition lock];
		
		// store old location and save new location and set state to valid
		CLLocation *oldLocation = self.location;
		self.mutableLocation = pNewLocation;
		self.mutableState = ZWLocationMonitorStateLocationValid;
		
		// if we're within our acceptable accuracy broadcast immediately
		if(self.location.horizontalAccuracy <= self.acceptableAccuracy &&
		   self.location.verticalAccuracy <= self.acceptableAccuracy) {
			[self.waitCondition broadcast];
		}
		
		[self.waitCondition unlock];
		
		// notify delegate
		if([self.delegate respondsToSelector:@selector(locationMonitor:didUpdateToLocation:fromLocation:)]) {
			[self.delegate locationMonitor:self didUpdateToLocation:self.location fromLocation:oldLocation];
		}
	}
}
- (void)locationManager:(CLLocationManager *)pLocationManager didFailWithError:(NSError *)pError {
	[self.waitCondition lock];
	
	// check error domain
	if([pError.domain isEqualToString:kCLErrorDomain]) {
		if(pError.code == kCLErrorDenied) {
			self.mutableState = ZWLocationMonitorStateAuthorizationDenied;
		} else if(pError.code == kCLErrorLocationUnknown) {
			self.mutableState = ZWLocationMonitorStateLocationUnknown;
		} else {
			self.mutableState = ZWLocationMonitorStateLocationError;
			self.mutableError = pError;
		}
	} else {
		self.mutableState = ZWLocationMonitorStateLocationError;
		self.mutableError = pError;
	}
	
	[self.waitCondition broadcast];
	[self.waitCondition unlock];
	
	// notify delegate
	if([self.delegate respondsToSelector:@selector(locationMonitor:didFailWithError:)]) {
		[self.delegate locationMonitor:self didFailWithError:self.error];
	}
}

#pragma mark - Dealloc

- (void)dealloc {
    [self cancelWaitForLocation];
	self.delegate = nil;
}

@end
