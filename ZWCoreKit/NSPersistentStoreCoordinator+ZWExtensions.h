#import <CoreData/CoreData.h>

@interface NSPersistentStoreCoordinator (ZWExtensions)

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)pThread parentContext:(NSManagedObjectContext *)pParentContext;
- (NSManagedObjectContext *)managedObjectContextForCurrentThreadWithParentContext:(NSManagedObjectContext *)pParentContext;

@end
