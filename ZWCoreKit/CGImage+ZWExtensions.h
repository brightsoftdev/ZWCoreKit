#import <QuartzCore/QuartzCore.h>

enum {
    CGImageResizeModeScaleToFill,
    CGImageResizeModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    CGImageResizeModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    CGImageResizeModeCenter,              // contents remain same size. positioned adjusted.
    CGImageResizeModeTop,
    CGImageResizeModeBottom,
    CGImageResizeModeLeft,
    CGImageResizeModeRight,
    CGImageResizeModeTopLeft,
    CGImageResizeModeTopRight,
    CGImageResizeModeBottomLeft,
    CGImageResizeModeBottomRight,
};
typedef NSUInteger CGImageResizeMode;

extern CGImageRef CGImageCreateWithContentsOfFile(NSString *file) CF_RETURNS_RETAINED;
extern CGImageRef CGImageCreateWithContentsOfURL(NSURL *url) CF_RETURNS_RETAINED;
extern CGImageRef CGImageCreateWithData(NSData *data);
extern CGImageRef CGImageCreateWithPixelData(NSData *data, 
											 size_t width, 
											 size_t height,
											 size_t bitsPerComponent,
											 size_t bitsPerPixel,
											 size_t bytesPerRow,
											 CGColorSpaceRef colorSpace,
											 CGBitmapInfo bitmapInfo,
											 const CGFloat *decode,
											 _Bool shouldInterpolate,
											 CGColorRenderingIntent intent) CF_RETURNS_RETAINED;
extern CGImageRef CGImageCreateCopyWithAlphaChannel(CGImageRef image) CF_RETURNS_RETAINED;
extern CGImageRef CGImageCreateByMasking(CGImageRef image, CGImageRef mask) CF_RETURNS_RETAINED;

extern BOOL CGImageWriteToFile(CGImageRef image, NSString *file, NSString *type);
extern BOOL CGImageWriteToURL(CGImageRef image, NSURL *url, NSString *type);
extern BOOL CGImageWriteToData(CGImageRef image, NSMutableData *data, NSString *type);

extern CGRect CGImageGetRectForResize(CGImageRef image, CGSize size, CGImageResizeMode mode);
extern CGImageRef CGImageResize(CGImageRef image, CGSize size, CGImageResizeMode mode) CF_RETURNS_RETAINED;
extern CGImageRef CGImagePrerender(CGImageRef image, CGSize size, CGImageResizeMode mode, CGColorSpaceRef colorSpace, CGBitmapInfo bitmapInfo) CF_RETURNS_RETAINED;