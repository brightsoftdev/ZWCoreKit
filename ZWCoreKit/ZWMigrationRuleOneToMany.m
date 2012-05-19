#import "ZWMigrationRuleOneToMany.h"
#import "ZWMigrationManager.h"
#import "NSFetchRequest+ZWExtensions.h"


@implementation ZWMigrationRuleOneToMany

#pragma mark - Migration

- (BOOL)migrateWithManager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError {
	NSEntityDescription *entity = [NSEntityDescription entityForName:self.sourceEntityName inManagedObjectContext:pMigrationManager.sourceContext];
	if(entity != nil) {
		NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntity:entity];
		[fetchRequest setReturnsObjectsAsFaults:YES];
		NSArray *fetchResult = [pMigrationManager.sourceContext executeFetchRequest:fetchRequest error:pError];
		if(*pError != nil ) {
			return NO;
		}
		for(NSManagedObject *sourceObject in fetchResult) {
			NSMutableArray *destinationObjects = [NSMutableArray array];
			NSInteger destinationObjectsCount = [self numberOfDestinationObjectsForSourceObject:sourceObject];
			for(NSInteger i = 0; i < destinationObjectsCount; ++i) {
				[destinationObjects addObject:[NSEntityDescription insertNewObjectForEntityForName:self.destinationEntityName inManagedObjectContext:pMigrationManager.destinationContext]];
			}
			if(![self migrateSourceObject:sourceObject toDestinationObjects:destinationObjects manager:pMigrationManager error:pError]) {
				return NO;
			}
		}
	}
	return YES;
}
- (NSInteger)numberOfDestinationObjectsForSourceObject:(NSManagedObject *)pSourceObject {
	return 0;
}
- (BOOL)migrateSourceObject:(NSManagedObject *)pSourceObject toDestinationObjects:(NSArray *)pDestinationObjects manager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError {
	return YES;
}

@end
