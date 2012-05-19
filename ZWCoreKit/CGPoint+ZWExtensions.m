#import "CGPoint+ZWExtensions.h"

CGPoint CGPointOnLineClosestToPoint(CGPoint point, CGPoint lineStart, CGPoint lineEnd, BOOL constrainToLineSegment) {
	float lineMag = CGPointDistance( lineEnd, lineStart );
	if (lineMag == 0) {
		if (constrainToLineSegment)
			return lineStart;
		else
			return point;
	}
	
    float u = ( ( ( point.x - lineStart.x ) * ( lineEnd.x - lineStart.x ) ) +
			   ( ( point.y - lineStart.y ) * ( lineEnd.y - lineStart.y ) ) ) /
	( lineMag * lineMag );
	
	if (constrainToLineSegment) {
		u = fmaxf(0, fminf(1, u));
	}
	
	CGPoint intersection;
    intersection.x = lineStart.x + u * ( lineEnd.x - lineStart.x );
    intersection.y = lineStart.y + u * ( lineEnd.y - lineStart.y );
	
    return intersection;
}