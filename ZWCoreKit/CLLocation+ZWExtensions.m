#import "CLLocation+ZWExtensions.h"


@implementation CLLocation (ZWExtensions)

+ (id)locationWithCoordinate:(CLLocationCoordinate2D)pCoordinate {
	return [self locationWithLatitude:pCoordinate.latitude longitude:pCoordinate.longitude];
}
+ (id)locationWithLatitude:(CLLocationDegrees)pLatitude longitude:(CLLocationDegrees)pLongitude {
	return [[self alloc] initWithLatitude:pLatitude longitude:pLongitude];
}

@end
