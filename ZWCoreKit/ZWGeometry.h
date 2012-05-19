#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
	ZWEdgeMinX = 1 << 1,
	ZWEdgeMaxX = 1 << 2,
	ZWEdgeMinY = 1 << 3,
	ZWEdgeMaxY = 1 << 4,
} ZWEdges;

#if TARGET_SDK_OSX
#define CGRectFromString(v) NSRectFromString(v)
#define CGSizeFromString(v) NSSizeFromString(v)
#define CGPointFromString(v) NSPointFromString(v)
#define NSStringFromCGRect(v) NSStringFromRect(v)
#define NSStringFromCGSize(v) NSStringFromSize(v)
#define NSStringFromCGPoint(v) NSStringFromPoint(v)
#endif