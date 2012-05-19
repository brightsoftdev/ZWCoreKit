#import <CoreData/CoreData.h>
#import "ZWMigrationRule.h"


@interface ZWMigrationRuleOneToMany : ZWMigrationRule {

}

#pragma mark - Migration

- (NSInteger)numberOfDestinationObjectsForSourceObject:(NSManagedObject *)pSourceObject;
- (BOOL)migrateSourceObject:(NSManagedObject *)pSourceObject toDestinationObjects:(NSArray *)pDestinationObjects manager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError;

@end
