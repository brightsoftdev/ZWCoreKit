#import <CoreData/CoreData.h>
#import "ZWMigrationRule.h"
#import "ZWMigrationRuleOneToOne.h"
#import "ZWMigrationRuleOneToMany.h"
#import "ZWMigrationRuleManyToOne.h"


@interface ZWMigrationManager : NSObject {
}

#pragma mark - Properties

@property (strong, readonly) NSManagedObjectModel *sourceModel;
@property (strong, readonly) NSPersistentStoreCoordinator *sourceCoordinator;
@property (strong, readonly) NSPersistentStore *sourceStore;
@property (strong, readonly) NSManagedObjectContext *sourceContext;

@property (strong, readonly) NSManagedObjectModel *destinationModel;
@property (strong, readonly) NSPersistentStoreCoordinator *destinationCoordinator;
@property (strong, readonly) NSPersistentStore *destinationStore;
@property (strong, readonly) NSManagedObjectContext *destinationContext;

#pragma mark - Initialization

+ (id)migrationManagerForSourceModelURL:(NSURL *)pSourceModelURL destinationModelURL:(NSURL *)pDestinationModelURL;
+ (id)migrationManagerWithSourceModel:(NSManagedObjectModel *)pSourceModel destinationModel:(NSManagedObjectModel *)pDestinationModel;
- (id)initWithSourceModel:(NSManagedObjectModel *)pSourceModel destinationModel:(NSManagedObjectModel *)pDestinationModel;

#pragma mark - Migration

- (BOOL)migrateStoreFromURL:(NSURL *)pSourceStoreURL 
					   type:(NSString *)pSourceStoreType 
					options:(NSDictionary *)pSourceStoreOptions 
					  rules:(NSArray *)pMigrationRules
		   toDestinationURL:(NSURL *)pDestinationURL 
			destinationType:(NSString *)pDestinationStoreType 
		 destinationOptions:(NSDictionary *)pDestinationOptions
					  error:(NSError **)pError;

@end
