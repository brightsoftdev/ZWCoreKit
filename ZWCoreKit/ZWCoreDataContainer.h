#import <CoreData/CoreData.h>


@interface ZWCoreDataContainer : NSObject {
}

#pragma mark - Properties

@property (strong, readonly) NSURL *managedObjectModelURL;
@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSURL *persistentStoreURL;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

#pragma mark - Initialization

+ (ZWCoreDataContainer *)coreDataContainerWithManagedObjectModelURL:(NSURL *)pManagedObjectModelURL 
												 persistentStoreURL:(NSURL *)pPersistentStoreURL
														  storeType:(NSString *)pStoreType
													  configuration:(NSString *)pConfiguration
															options:(NSDictionary *)pOptions;
- (id)initWithManagedObjectModelURL:(NSURL *)pManagedObjectModelURL 
				 persistentStoreURL:(NSURL *)pPersistentStoreURL 
						  storeType:(NSString *)pStoreType
					  configuration:(NSString *)pConfiguration
							options:(NSDictionary *)pOptions;

#pragma mark - Saving

- (BOOL)save:(NSError **)pError;

#pragma mark - Multi-Threading

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)pThread automaticallyMergeChangesOnSave:(BOOL)pAutomaticallyMergeChangesOnSave;

@end
