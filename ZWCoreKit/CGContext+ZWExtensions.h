#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

extern void CGContextDrawImageAtPoint(CGContextRef context, CGPoint point, CGImageRef image);
extern void CGContextDrawImageAtPointWithAnchorPoint(CGContextRef context, CGPoint point, CGPoint anchorPoint, CGImageRef image);

extern void CGContextPerformBlock(CGContextRef context, void (^block)(CGContextRef ctx));