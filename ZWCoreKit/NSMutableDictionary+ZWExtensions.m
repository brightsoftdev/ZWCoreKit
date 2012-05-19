#import "NSMutableDictionary+ZWExtensions.h"


@implementation NSMutableDictionary (ZWExtensions)

- (void)setInteger:(NSInteger)pValue forKey:(NSString *)pKey {
	[self setObject:[NSNumber numberWithInteger:pValue] forKey:pKey];
}
- (void)setUnsignedInteger:(NSInteger)pValue forKey:(NSString *)pKey {	
	[self setObject:[NSNumber numberWithUnsignedInteger:pValue] forKey:pKey];
}
- (void)setFloat:(float)pValue forKey:(NSString *)pKey {
	[self setObject:[NSNumber numberWithFloat:pValue] forKey:pKey];
}
- (void)setDouble:(double)pValue forKey:(NSString *)pKey {
	[self setObject:[NSNumber numberWithFloat:pValue] forKey:pKey];
}
- (void)setBool:(BOOL)pValue forKey:(NSString *)pKey {
	[self setObject:[NSNumber numberWithBool:pValue] forKey:pKey];
}

- (void)setRect:(CGRect)pValue forKey:(NSString *)pKey {
	[self setObject:NSStringFromCGRect(pValue) forKey:pKey];
}
- (void)setSize:(CGSize)pValue forKey:(NSString *)pKey {
	[self setObject:NSStringFromCGSize(pValue) forKey:pKey];
}
- (void)setPoint:(CGPoint)pValue forKey:(NSString *)pKey {
	[self setObject:NSStringFromCGPoint(pValue) forKey:pKey];
}

@end
