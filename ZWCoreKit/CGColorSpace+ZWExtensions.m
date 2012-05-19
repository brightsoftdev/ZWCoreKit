#import "CGColorSpace+ZWExtensions.h"

CGColorSpaceRef (^CGColorSpaceDeviceRGB)(void) = ^{
	static CGColorSpaceRef colorSpaceDeviceRGB = nil;
	static dispatch_once_t colorSpaceDeviceRGBOnce = 0;
	dispatch_once(&colorSpaceDeviceRGBOnce, ^{
		colorSpaceDeviceRGB = CGColorSpaceCreateDeviceRGB();
	});
	return colorSpaceDeviceRGB;
};