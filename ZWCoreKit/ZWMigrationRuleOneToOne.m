#import "ZWMigrationRuleOneToOne.h"
#import "ZWMigrationManager.h"
#import "NSFetchRequest+ZWExtensions.h"


@implementation ZWMigrationRuleOneToOne

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
			NSManagedObject *destinationObject = [NSEntityDescription insertNewObjectForEntityForName:self.destinationEntityName inManagedObjectContext:pMigrationManager.destinationContext];
			if(![self migrateSourceObject:sourceObject toDestinationObject:destinationObject manager:pMigrationManager error:pError]) {
				return NO;
			}
		}
	}
	return YES;
}
- (BOOL)migrateSourceObject:(NSManagedObject *)pSourceObject toDestinationObject:(NSManagedObject *)pDestinationObject manager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError {
	return YES;
}

@end
