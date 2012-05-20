#import <Foundation/Foundation.h>

#pragma mark - Types & Enums

typedef enum {
	ZWRoundingTechniqueFloor = -1,
	ZWRoundingTechniqueRound = 0,
	ZWRoundingTechniqueCeil = 1,
} ZWRoundingTechnique;

typedef enum {
	ZWEdgeMinX = 1 << 1,
	ZWEdgeMaxX = 1 << 2,
	ZWEdgeMinY = 1 << 3,
	ZWEdgeMaxY = 1 << 4,
} ZWEdges;
