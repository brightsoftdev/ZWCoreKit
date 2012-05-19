#import "ZWMigrationRuleManyToOne.h"
#import "ZWMigrationManager.h"
#import "NSFetchRequest+ZWExtensions.h"


@implementation ZWMigrationRuleManyToOne

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
		if([fetchResult count] > 0) {
			NSManagedObject *destinationObject = [NSEntityDescription insertNewObjectForEntityForName:self.destinationEntityName inManagedObjectContext:pMigrationManager.destinationContext];
			return [self migrateSourceObjects:fetchResult toDestinationObject:destinationObject manager:pMigrationManager error:pError];
		}
	}
	return YES;
}
- (BOOL)migrateSourceObjects:(NSArray *)pSourceObjects toDestinationObject:(NSManagedObject *)pDestinationObject manager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError {
	return YES;
}

@end
