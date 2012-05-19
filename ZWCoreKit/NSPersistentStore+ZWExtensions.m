#import "NSPersistentStore+ZWExtensions.h"

@implementation NSPersistentStore (ZWExtensions)

- (void)setMetadataObject:(id)pObject forKey:(NSString *)pKey {
	NSMutableDictionary *metadata = [self.metadata mutableCopy];
	[metadata setObject:pObject forKey:pKey];
	[self setMetadata:metadata];
}
- (void)removeObjectFromMetadataForKey:(NSString *)pKey {
	NSMutableDictionary *metadata = [self.metadata mutableCopy];
	[metadata removeObjectForKey:pKey];
	[self setMetadata:metadata];
}

@end
