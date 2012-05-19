#import "NSUserDefaults+ZWExtensions.h"


@implementation NSUserDefaults (ZWExtensions)

#if TARGET_SDK_IOS
- (UIColor *)colorForKey:(NSString *)pKey {
	return [self unarchivedObjectForKey:pKey];
}
- (void)setColor:(UIColor *)pColor forKey:(NSString *)pKey {
	[self setArchivedObject:pColor forKey:pKey];
}
#elif TARGET_SDK_OSX
- (NSColor *)colorForKey:(NSString *)pKey {
	return [self unarchivedObjectForKey:pKey];
}
- (void)setColor:(NSColor *)pColor forKey:(NSString *)pKey {
	[self setArchivedObject:pColor forKey:pKey];
}
#endif

- (void)setArchivedObject:(id)pObject forKey:(NSString *)pKey {
	if(pObject == nil) {
		[self removeObjectForKey:pKey];
	} else {
		[self setObject:[NSKeyedArchiver archivedDataWithRootObject:pObject] forKey:pKey];
	}
}
- (id)unarchivedObjectForKey:(NSString *)pKey {
	id value = [self objectForKey:pKey];
	if(value != nil) {
		return [NSKeyedUnarchiver unarchiveObjectWithData:value];
	}
	return nil;
}

@end
