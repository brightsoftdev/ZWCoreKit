#import <CoreData/CoreData.h>
#import <Availability.h>

@interface NSManagedObjectContext (ZWExtensions)

- (NSArray *)fetchObjectsWithEntityName:(NSString *)pEntityName error:(NSError **)pError;
- (NSArray *)fetchObjectsWithEntityName:(NSString *)pEntityName predicate:(NSPredicate *)pPredicate error:(NSError **)pError;
- (void)insertObjects:(NSSet *)pSet;
- (void)insertObjectsFromArray:(NSArray *)pArray;
- (void)deleteObjects:(NSSet *)pSet;
- (void)deleteObjectsFromArray:(NSArray *)pArray;

- (NSSet *)objectIdentifiersForObjects:(NSSet *)pObjects;
- (NSSet *)objectsForObjectIdentifiers:(NSSet *)pIdentifiers;

@end
