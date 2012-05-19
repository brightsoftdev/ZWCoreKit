#import "NSCoder+ZWExtensions.h"


@implementation NSCoder (ZWExtensions)

- (void)encodeObjectsFromDictionary:(NSDictionary *)pDictionary {
	for(NSString *key in pDictionary) {
		id object = [pDictionary objectForKey:key];
		[self encodeObject:object forKey:key];
	}
}
- (void)encodeObjectsFromTarget:(id)pTarget forKeys:(NSArray *)pKeys {
	for(NSString *key in pKeys) {
		id object = [pTarget valueForKey:key];
		[self encodeObject:object forKey:key];
	}
}
- (void)decodeObjectsToTarget:(id)pTarget forKeys:(NSArray *)pKeys {
	for(NSString *key in pKeys) {
		id object = [self decodeObjectForKey:key];
		[pTarget setValue:object forKey:key];
	}
}
- (void)encodeObjectsFromTarget:(id)pTarget forKeyPaths:(NSArray *)pKeyPaths {
	for(NSString *keyPath in pKeyPaths) {
		id object = [pTarget valueForKeyPath:keyPath];
		[self encodeObject:object forKey:keyPath];
	}
}
- (void)decodeObjectsToTarget:(id)pTarget forKeyPaths:(NSArray *)pKeyPaths {
	for(NSString *keyPath in pKeyPaths) {
		id object = [self decodeObjectForKey:keyPath];
		[pTarget setValue:object forKeyPath:keyPath];
	}
}

@end
