#import "CGContext+ZWExtensions.h"

void CGContextDrawImageAtPoint(CGContextRef context, CGPoint point, CGImageRef image) {
	CGContextSaveGState(context);
	CGSize size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	CGContextTranslateCTM(context, point.x, point.y);
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, size.width, size.height), image);
	CGContextRestoreGState(context);
}
void CGContextDrawImageAtPointWithAnchorPoint(CGContextRef context, CGPoint point, CGPoint anchorPoint, CGImageRef image) {
	CGContextSaveGState(context);
	CGSize size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	anchorPoint = CGPointMake(MAX(0.0, MIN(1.0, anchorPoint.x)), MAX(0.0, MIN(1.0, anchorPoint.y)));
	CGContextTranslateCTM(context, -anchorPoint.x * size.width, -anchorPoint.y * size.height);
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, size.width, size.height), image);
	CGContextRestoreGState(context);
}

void CGContextPerformBlock(CGContextRef context, void (^block)(CGContextRef ctx)) {
	if(block == nil) {
		return;
	}
	CGContextSaveGState(context);
	block(context);
	CGContextRestoreGState(context);
}