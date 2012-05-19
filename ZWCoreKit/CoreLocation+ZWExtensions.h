#import <CoreLocation/CoreLocation.h>

typedef enum {
	ZWDistanceFormatKilometersAndMeters = 0,
	ZWDistanceFormatKilometersAlways,
	ZWDistanceFormatMetersAlways,
} ZWDistanceFormat;

extern CGFloat ZWMercatorOffset;
extern CGFloat ZWMercatorRadius;

extern CLLocationDistance ZWDistanceBetween(CLLocationCoordinate2D location1, CLLocationCoordinate2D location2);
extern NSString* ZWHumanReadableDistance(CLLocationDistance distance, ZWDistanceFormat format);
extern NSString* ZWHumanReadableDistanceBetween(CLLocationCoordinate2D location1, CLLocationCoordinate2D location2, ZWDistanceFormat format);