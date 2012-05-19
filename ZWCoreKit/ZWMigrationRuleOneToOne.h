#import <CoreData/CoreData.h>
#import "ZWMigrationRule.h"


@interface ZWMigrationRuleOneToOne : ZWMigrationRule {

}

#pragma mark - Migration

- (BOOL)migrateSourceObject:(NSManagedObject *)pSourceObject toDestinationObject:(NSManagedObject *)pDestinationObject manager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError;

@end
