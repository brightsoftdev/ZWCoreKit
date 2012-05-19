#import <QuartzCore/QuartzCore.h>


@interface CALayer (ZWExtensions)

+ (id)layerWithFrame:(CGRect)pFrame;
+ (id)layerWithSize:(CGSize)pSize;
+ (id)layerWithImage:(CGImageRef)pImage;
+ (id)layerWithImageNamed:(NSString *)pImageName;
- (void)removeAllSublayers;

#pragma mark - Frame

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGSize frameSize;

@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;

@property (nonatomic, assign) CGFloat frameMinX;
@property (nonatomic, assign) CGFloat frameCenterX;
@property (nonatomic, assign) CGFloat frameMaxX;
@property (nonatomic, assign) CGFloat frameMinY;
@property (nonatomic, assign) CGFloat frameCenterY;
@property (nonatomic, assign) CGFloat frameMaxY;

@property (nonatomic, assign) CGPoint frameTopLeft;
@property (nonatomic, assign) CGPoint frameTopCenter;
@property (nonatomic, assign) CGPoint frameTopRight;

@property (nonatomic, assign) CGPoint frameCenterLeft;
@property (nonatomic, assign) CGPoint frameCenter;
@property (nonatomic, assign) CGPoint frameCenterRight;

@property (nonatomic, assign) CGPoint frameBottomLeft;
@property (nonatomic, assign) CGPoint frameBottomCenter;
@property (nonatomic, assign) CGPoint frameBottomRight;

#pragma mark - Bounds

@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGPoint boundsOrigin;
@property (nonatomic, assign) CGSize boundsSize;

@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;

@property (nonatomic, assign) CGFloat boundsMinX;
@property (nonatomic, assign) CGFloat boundsCenterX;
@property (nonatomic, assign) CGFloat boundsMaxX;
@property (nonatomic, assign) CGFloat boundsMinY;
@property (nonatomic, assign) CGFloat boundsCenterY;
@property (nonatomic, assign) CGFloat boundsMaxY;

@property (nonatomic, assign) CGPoint boundsTopLeft;
@property (nonatomic, assign) CGPoint boundsTopCenter;
@property (nonatomic, assign) CGPoint boundsTopRight;

@property (nonatomic, assign) CGPoint boundsCenterLeft;
@property (nonatomic, assign) CGPoint boundsCenter;
@property (nonatomic, assign) CGPoint boundsCenterRight;

@property (nonatomic, assign) CGPoint boundsBottomLeft;
@property (nonatomic, assign) CGPoint boundsBottomCenter;
@property (nonatomic, assign) CGPoint boundsBottomRight;

#pragma mark - Utility

- (void)moveFrameToWholePixelsByRounding;
- (void)moveFrameToWholePixelsByFlooring;
- (void)moveFrameToWholePixelsByCeiling;

@end
