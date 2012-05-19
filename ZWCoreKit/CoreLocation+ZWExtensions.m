#import "CoreLocation+ZWExtensions.h"


CGFloat ZWMercatorOffset = 268435456;
CGFloat ZWMercatorRadius = 85445659.44705395;

CLLocationDistance ZWDistanceBetween(CLLocationCoordinate2D location1, CLLocationCoordinate2D location2) {
	CLLocation *l1 = [[CLLocation alloc] initWithLatitude:location1.latitude longitude:location1.longitude];
	CLLocation *l2 = [[CLLocation alloc] initWithLatitude:location2.latitude longitude:location2.longitude];
	CLLocationDistance d = [l1 distanceFromLocation:l2];
	return d;
}
NSString* ZWHumanReadableDistance(CLLocationDistance distance, ZWDistanceFormat format) {
	CLLocationDistance kilometers = distance / 1000.0;
	if(kilometers >= 30000.0) {
		return @"unknown";
	} else if(distance < 100) {
		switch(format) {
			case ZWDistanceFormatKilometersAlways :
				return @"< 0.1km";
			case ZWDistanceFormatMetersAlways :
				return @"< 100m";
			case ZWDistanceFormatKilometersAndMeters :
				return @"< 100m";
		}
	} else {
		static NSNumberFormatter *distanceNumberFormatter;
		static dispatch_once_t distanceNumberFormatterOnce;
		dispatch_once(&distanceNumberFormatterOnce, ^{
			distanceNumberFormatter = [[NSNumberFormatter alloc] init];
			[distanceNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			
		});
		
		if(format == ZWDistanceFormatKilometersAlways) {
			[distanceNumberFormatter setMaximumFractionDigits:1];
			return [NSString stringWithFormat:@"%@km", [distanceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:kilometers]]];
		} else if(format == ZWDistanceFormatMetersAlways) {
			[distanceNumberFormatter setMaximumFractionDigits:0];
			return [NSString stringWithFormat:@"%@m", [distanceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:distance]]];
		} else if(format == ZWDistanceFormatKilometersAndMeters) {
			if(kilometers >= 1.0) {
				[distanceNumberFormatter setMaximumFractionDigits:1];
				return [NSString stringWithFormat:@"%@km", [distanceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:kilometers]]];
			} else {
				[distanceNumberFormatter setMaximumFractionDigits:0];
				return [NSString stringWithFormat:@"%@m", [distanceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:distance]]];
			}
		}
		return @"";
	}
}
NSString* ZWHumanReadableDistanceBetween(CLLocationCoordinate2D location1, CLLocationCoordinate2D location2, ZWDistanceFormat format) {
	return ZWHumanReadableDistance(ZWDistanceBetween(location1, location2), format);
}