#import "CGPattern+ZWExtensions.h"

static void CGPatternZWExtensions_drawPatternImage(void* info, CGContextRef context) {
	CGImageRef image = (CGImageRef)info;
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
}
static void CGPatternZWExtensions_releasePatternImage(void* info) {
	CGImageRelease(info);
}
CGPatternRef CGPatternCreateWithImage(CGImageRef image) {
	NSUInteger width = CGImageGetWidth(image);
	NSUInteger height = CGImageGetHeight(image);
	static const CGPatternCallbacks callbacks = {
		0, 
		&CGPatternZWExtensions_drawPatternImage, 
		&CGPatternZWExtensions_releasePatternImage
	};
	CGPatternRef pattern = CGPatternCreate((CGImageRef)CFRetain(image),
										   CGRectMake(0.0, 0.0, width, height), 
										   CGAffineTransformMake(1, 0, 0, 1, 0, 0),
										   width,
										   height,
										   kCGPatternTilingConstantSpacing,
										   TRUE,
										   &callbacks);
	return pattern;
}