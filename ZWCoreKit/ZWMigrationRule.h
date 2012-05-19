#import <CoreData/CoreData.h>
@class ZWMigrationManager;


@interface ZWMigrationRule : NSObject {
}

#pragma mark - Properties

@property (strong, readonly) NSString *sourceEntityName;
@property (strong, readonly) NSString *destinationEntityName;

#pragma mark - Initialization

+ (id)migrationRuleWithSourceEntityName:(NSString *)pSourceEntityName destinationEntityName:(NSString *)pDestinationEntityName;
- (id)initWithSourceEntityName:(NSString *)pSourceEntityName destinationEntityName:(NSString *)pDestinationEntityName;

#pragma mark - Migration

- (BOOL)migrateWithManager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError;

@end