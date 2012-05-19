#import <CoreData/CoreData.h>
#import "ZWMigrationRule.h"


@interface ZWMigrationRuleManyToOne : ZWMigrationRule {

}

#pragma mark - Migration

- (BOOL)migrateSourceObjects:(NSArray *)pSourceObjects toDestinationObject:(NSManagedObject *)pDestinationObject manager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError;

@end
