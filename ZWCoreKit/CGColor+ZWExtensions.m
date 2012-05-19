#import "CGColor+ZWExtensions.h"
#import "CGPattern+ZWExtensions.h"

CGColorRef CGColorCreateWithPatternImage(CGImageRef image) {
	CGColorSpaceRef colorSpace = CGColorSpaceCreatePattern(NULL);
	CGFloat components[1] = {1.0};
	CGPatternRef pattern = CGPatternCreateWithImage(image);
	CGColorRef color = CGColorCreateWithPattern(colorSpace, pattern, components);
	CGColorSpaceRelease(colorSpace);
	CGPatternRelease(pattern);
	return color;
}