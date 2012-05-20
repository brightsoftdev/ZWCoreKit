#import "CGImage+ZWExtensions.h"
#import "CGColorSpace+ZWExtensions.h"
#if TARGET_SDK_IOS
#import <ImageIO/ImageIO.h>
#endif

CGImageRef CGImageCreateWithContentsOfFile(NSString *file) {
	return CGImageCreateWithContentsOfURL([NSURL fileURLWithPath:file]);
}
CGImageRef CGImageCreateWithContentsOfURL(NSURL *url) {
	if(url != nil) {
		CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef)url, nil);
		if(src != nil) {
			CGImageRef img = CGImageSourceCreateImageAtIndex(src, 0, nil);
			CFRelease(src);
			return img;
		}
	}
	return nil;
}
CGImageRef CGImageCreateWithData(NSData *data) {
	if(data != nil) {
		CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
		if(src != nil) {
			CGImageRef img = CGImageSourceCreateImageAtIndex(src, 0, nil);
			CFRelease(src);
			return img;
		}
	}
	return nil;
}
CGImageRef CGImageCreateWithPixelData(NSData *data, 
									  size_t width, 
									  size_t height,
									  size_t bitsPerComponent,
									  size_t bitsPerPixel,
									  size_t bytesPerRow,
									  CGColorSpaceRef colorSpace,
									  CGBitmapInfo bitmapInfo,
									  const CGFloat *decode,
									  _Bool shouldInterpolate,
									  CGColorRenderingIntent intent) {
	CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	CGImageRef img = CGImageCreate(width,
								   height,
								   bitsPerComponent,
								   bitsPerPixel,
								   bytesPerRow,
								   colorSpace,
								   bitmapInfo,
								   dataProvider,
								   decode,
								   shouldInterpolate,
								   intent);
	CGDataProviderRelease(dataProvider);
	return img;
}
CGImageRef CGImageCreateCopyWithAlphaChannel(CGImageRef image) {
	CGRect rect = CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image));
	CGContextRef ctx = CGBitmapContextCreate(nil, 
											 rect.size.width, 
											 rect.size.height, 
											 8, 
											 rect.size.width * 4, 
											 CGColorSpaceDeviceRGB(),
											 kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
	CGContextClearRect(ctx, rect);
	CGContextDrawImage(ctx, rect, image);
	CGImageRef newImage = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	return newImage;
}
CGImageRef CGImageCreateByMasking(CGImageRef image, CGImageRef mask) {
	CGImageRef source = nil;
	CGImageAlphaInfo sourceInfo = CGImageGetAlphaInfo(image);
	if(sourceInfo == kCGImageAlphaNone || sourceInfo == kCGImageAlphaNoneSkipLast || sourceInfo == kCGImageAlphaNoneSkipFirst) {
		source = CGImageCreateCopyWithAlphaChannel(image);
	} else {
		source = CGImageRetain(image);
	}
	
	CGImageRef maskedImage = CGImageCreateWithMask(source, mask);
	CGImageRelease(source);
	
	return maskedImage;
}
BOOL CGImageWriteToFile(CGImageRef image, NSString *file, NSString *type) {
	return CGImageWriteToURL(image, [NSURL fileURLWithPath:file], type);
}
BOOL CGImageWriteToURL(CGImageRef image, NSURL *url, NSString *type) {
	if(image != nil && url != nil && type != nil) {
		CGImageDestinationRef dst = CGImageDestinationCreateWithURL((__bridge CFURLRef)url, (__bridge CFStringRef)type, 1, nil);
		if(dst != nil) {
			CGImageDestinationAddImage(dst, image, nil);
			BOOL result = CGImageDestinationFinalize(dst);
			CFRelease(dst);
			return result;
		}
	}
	return NO;
}
BOOL CGImageWriteToData(CGImageRef image, NSMutableData *data, NSString *type) {
	if(image != nil && data != nil && type != nil) {
		CGImageDestinationRef dst = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data, (__bridge CFStringRef)type, 1, nil);
		if(dst != nil) {
			CGImageDestinationAddImage(dst, image, nil);
			BOOL result = CGImageDestinationFinalize(dst);
			CFRelease(dst);
			return result;
		}
	}
	return NO;
}

CGRect CGImageGetRectForResize(CGImageRef image, CGSize size, CGImageResizeMode mode) {
	size.width = floorf(size.width);
	size.height = floorf(size.height);
	CGSize originalSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	CGRect rect = CGRectZero;
	
	switch(mode) {
		case CGImageResizeModeTopLeft :
			rect.size = originalSize;
			rect.origin.x = 0.0;
			rect.origin.y = 0.0;
			break;
		case CGImageResizeModeTop :
			rect.size = originalSize;
			rect.origin.x = ((size.width - rect.size.width) / 2.0);
			rect.origin.y = 0.0;
			break;
		case CGImageResizeModeTopRight :
			rect.size = originalSize;
			rect.origin.x = (size.width - rect.size.width);
			rect.origin.y = 0.0;
			break;
		case CGImageResizeModeLeft :
			rect.size = originalSize;
			rect.origin.x = 0.0;
			rect.origin.y = ((size.height - rect.size.height) / 2.0);
			break;
		case CGImageResizeModeCenter :
			rect.size = originalSize;
			rect.origin.x = ((size.width - rect.size.width) / 2.0);
			rect.origin.y = ((size.height - rect.size.height) / 2.0);
			break;
		case CGImageResizeModeRight :
			rect.size = originalSize;
			rect.origin.x = (size.width - rect.size.width);
			rect.origin.y = ((size.height - rect.size.height) / 2.0);
			break;
		case CGImageResizeModeBottomLeft :
			rect.size = originalSize;
			rect.origin.x = 0.0;
			rect.origin.y = (size.height - rect.size.height);
			break;
		case CGImageResizeModeBottom :
			rect.size = originalSize;
			rect.origin.x = ((size.width - rect.size.width) / 2.0);
			rect.origin.y = (size.height - rect.size.height);
			break;
		case CGImageResizeModeBottomRight :
			rect.size = originalSize;
			rect.origin.x = (size.width - rect.size.width);
			rect.origin.y = (size.height - rect.size.height);
			break;
		case CGImageResizeModeScaleToFill :
			rect.size = size;
			rect.origin.x = 0.0;
			rect.origin.y = 0.0;
			break;
		case CGImageResizeModeScaleAspectFill :
			rect.size = size;
			if(originalSize.width > originalSize.height) {
				rect.size = CGSizeMake(size.width * (originalSize.width / originalSize.height), size.height);
			} else {
				rect.size = CGSizeMake(size.width, size.height * (originalSize.height /originalSize.width));
			}
			rect.origin.x = ((size.width - rect.size.width) / 2.0); 
			rect.origin.y = ((size.height - rect.size.height) / 2.0);
			break;
		case CGImageResizeModeScaleAspectFit :
			rect.size = size;
			if(originalSize.width > originalSize.height) {
				rect.size = CGSizeMake(size.width, size.height * (originalSize.height /originalSize.width));
			} else {
				rect.size = CGSizeMake(size.width * (originalSize.width / originalSize.height), size.height);
			}
			rect.origin.x = ((size.width - rect.size.width) / 2.0); 
			rect.origin.y = ((size.height - rect.size.height) / 2.0);
			break;
		default :
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image resize mode"];
			break;
	}
	
	return rect;
}
CGImageRef CGImageResize(CGImageRef image, CGSize size, CGImageResizeMode mode) {
	size.width = floorf(size.width);
	size.height = floorf(size.height);
	CGRect rect = CGImageGetRectForResize(image, size, mode);
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image);
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
	CGContextRef ctx = CGBitmapContextCreate(nil,
											 size.width,
											 size.height,
											 8,
											 size.width * 4,
											 colorSpace,
											 bitmapInfo);
	CGContextClearRect(ctx, CGRectMake(0, 0, size.width, size.height));
	CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
	CGContextDrawImage(ctx, rect, image);
	CGImageRef resizedImage = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	return resizedImage;
}
CGImageRef CGImagePrerender(CGImageRef image, CGSize size, CGImageResizeMode mode, CGColorSpaceRef colorSpace, CGBitmapInfo bitmapInfo) {
	size.width = floorf(size.width);
	size.height = floorf(size.height);
	CGRect rect = CGImageGetRectForResize(image, size, mode);
	CGContextRef ctx = CGBitmapContextCreate(nil,
											 size.width,
											 size.height,
											 8,
											 size.width * 4,
											 colorSpace,
											 bitmapInfo);
	CGContextClearRect(ctx, CGRectMake(0, 0, size.width, size.height));
	CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
	CGContextDrawImage(ctx, rect, image);
	CGImageRef prerenderedImage = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	return prerenderedImage;
}