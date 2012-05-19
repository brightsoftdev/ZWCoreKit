#import <CoreLocation/CoreLocation.h>


@interface CLLocation (ZWExtensions)

+ (id)locationWithCoordinate:(CLLocationCoordinate2D)pCoordinate;
+ (id)locationWithLatitude:(CLLocationDegrees)pLatitude longitude:(CLLocationDegrees)pLongitude;

@end
