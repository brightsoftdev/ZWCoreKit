#import "CATiledLayer+ZWExtensions.h"


@implementation CATiledLayer (ZWExtensions)

+ (void)load {
	@autoreleasepool {
		[self exchangeClassMethodSelector:@selector(fadeDuration) withSelector:@selector(zw_fadeDuration)];
	}
}

static CFTimeInterval CATiledLayer_ZWExtensions_fadeDuration = 0.0;
+ (void)setFadeDuration:(CFTimeInterval)pFadeDuration {
	CATiledLayer_ZWExtensions_fadeDuration = pFadeDuration;
}
+ (CFTimeInterval)zw_fadeDuration {
	return CATiledLayer_ZWExtensions_fadeDuration;
}

@end
