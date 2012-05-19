#import <CoreData/CoreData.h>

@interface NSPersistentStore (ZWExtensions)

- (void)setMetadataObject:(id)pObject forKey:(NSString *)pKey;
- (void)removeObjectFromMetadataForKey:(NSString *)pKey;

@end
