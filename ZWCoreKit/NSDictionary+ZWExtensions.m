#import "NSDictionary+ZWExtensions.h"


@implementation NSDictionary (ZWExtensions)

- (NSInteger)integerForKey:(NSString *)pKey {
	return [[self objectForKey:pKey] integerValue];
}
- (NSUInteger)unsignedIntegerForKey:(NSString *)pKey {
	return [[self objectForKey:pKey] unsignedIntegerValue];
}
- (float)floatForKey:(NSString *)pKey {
	return [[self objectForKey:pKey] floatValue];
}
- (double)doubleForKey:(NSString *)pKey {
	return [[self objectForKey:pKey] floatValue];
}
- (BOOL)boolForKey:(NSString *)pKey {
	return [[self objectForKey:pKey] boolValue];
}

- (CGRect)rectForKey:(NSString *)pKey {
	return CGRectFromString([self objectForKey:pKey]);
}
- (CGSize)sizeForKey:(NSString *)pKey {
	return CGSizeFromString([self objectForKey:pKey]);
}
- (CGPoint)pointForKey:(NSString *)pKey {
	return CGPointFromString([self objectForKey:pKey]);
}

@end
