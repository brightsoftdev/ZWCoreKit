#import "CGPath+ZWExtensions.h"

CGPathRef CGPathCreateWithRoundedRect(CGRect rect, NSUInteger cornerRadius) {
	CGMutablePathRef path = CGPathCreateMutable();
	int x_left = rect.origin.x;
	int x_left_center = rect.origin.x + cornerRadius;
	int x_right_center = rect.origin.x + rect.size.width - cornerRadius;
	int x_right = rect.origin.x + rect.size.width;
	int y_top = rect.origin.y;
	int y_top_center = rect.origin.y + cornerRadius;
	int y_bottom_center = rect.origin.y + rect.size.height - cornerRadius;
	int y_bottom = rect.origin.y + rect.size.height;
	
	/* Begin! */
	CGPathMoveToPoint(path, nil, x_left, y_top_center);
	
	/* First corner */
	CGPathAddArcToPoint(path, nil, x_left, y_top, x_left_center, y_top, cornerRadius);
	CGPathAddLineToPoint(path, nil, x_right_center, y_top);
	
	/* Second corner */
	CGPathAddArcToPoint(path, nil, x_right, y_top, x_right, y_top_center, cornerRadius);
	CGPathAddLineToPoint(path, nil, x_right, y_bottom_center);
	
	/* Third corner */
	CGPathAddArcToPoint(path, nil, x_right, y_bottom, x_right_center, y_bottom, cornerRadius);
	CGPathAddLineToPoint(path, nil, x_left_center, y_bottom);
	
	/* Fourth corner */
	CGPathAddArcToPoint(path, nil, x_left, y_bottom, x_left, y_bottom_center, cornerRadius);
	CGPathAddLineToPoint(path, nil, x_left, y_top_center);
	
	return path;
}