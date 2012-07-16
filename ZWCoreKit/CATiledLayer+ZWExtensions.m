#import "CATiledLayer+ZWExtensions.h"
#import "NSObject+ZWExtensions.h"

@implementation CATiledLayer (ZWExtensions)

+ (void)load {
#if !OBJC_ARC_WEAK
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
#endif
		@autoreleasepool {
			[self exchangeClassMethodSelector:@selector(fadeDuration) withSelector:@selector(zw_fadeDuration)];
		}
#if !OBJC_ARC_WEAK
	});
#endif
}

static CFTimeInterval CATiledLayer_ZWExtensions_fadeDuration = 0.0;
+ (void)setFadeDuration:(CFTimeInterval)pFadeDuration {
	CATiledLayer_ZWExtensions_fadeDuration = pFadeDuration;
}
+ (CFTimeInterval)zw_fadeDuration {
	return CATiledLayer_ZWExtensions_fadeDuration;
}

@end
