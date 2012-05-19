#import "NSManagedObjectContext+ZWExtensions.h"

@implementation NSManagedObjectContext (ZWExtensions)


- (NSArray *)fetchObjectsWithEntityName:(NSString *)pEntityName error:(NSError **)pError {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityForName:pEntityName inManagedObjectContext:self];
	return [self executeFetchRequest:fetchRequest error:pError];
}
- (NSArray *)fetchObjectsWithEntityName:(NSString *)pEntityName predicate:(NSPredicate *)pPredicate error:(NSError **)pError {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityForName:pEntityName inManagedObjectContext:self];
	[fetchRequest setPredicate:pPredicate];
	return [self executeFetchRequest:fetchRequest error:pError];
}
- (void)insertObjects:(NSSet *)pSet {
	for(NSManagedObject *object in pSet) {
		[self insertObject:object];
	}
}
- (void)insertObjectsFromArray:(NSArray *)pArray {
	for(NSManagedObject *object in pArray) {
		[self insertObject:object];
	}
}
- (void)deleteObjects:(NSSet *)pSet {
	for(NSManagedObject *object in pSet) {
		[self deleteObject:object];
	}
}
- (void)deleteObjectsFromArray:(NSArray *)pArray {
	for(NSManagedObject *object in pArray) {
		[self deleteObject:object];
	}
}

- (NSSet *)objectIdentifiersForObjects:(NSSet *)pObjects {
	NSMutableSet *identifiers = [NSMutableSet setWithCapacity:[pObjects count]];
	for(NSManagedObject *object in pObjects) {
		[identifiers addObject:[object objectID]];
	}
	return identifiers;
}
- (NSSet *)objectsForObjectIdentifiers:(NSSet *)pIdentifiers {
	NSMutableSet *objects = [NSMutableSet setWithCapacity:[pIdentifiers count]];
	for(NSManagedObjectID *identifier in pIdentifiers) {
		NSManagedObject *object = [self objectWithID:identifier];
		if(object != nil) {
			[objects addObject:object];
		}
	}
	return objects;
}


@end
