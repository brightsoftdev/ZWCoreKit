#import "ZWMigrationManager.h"


@interface ZWMigrationManager() {	
	NSManagedObjectModel *sourceModel;
	NSPersistentStoreCoordinator *sourceCoordinator;
	NSPersistentStore *sourceStore;
	NSManagedObjectContext *sourceContext;
	
	NSManagedObjectModel *destinationModel;
	NSPersistentStoreCoordinator *destinationCoordinator;
	NSPersistentStore *destinationStore;
	NSManagedObjectContext *destinationContext;
}
@end
@implementation ZWMigrationManager

#pragma mark - Properties

@synthesize sourceModel;
@synthesize sourceCoordinator;
@synthesize sourceStore;
@synthesize sourceContext;

@synthesize destinationModel;
@synthesize destinationCoordinator;
@synthesize destinationStore;
@synthesize destinationContext;

#pragma mark - Initialization

+ (id)migrationManagerForSourceModelURL:(NSURL *)pSourceModelURL destinationModelURL:(NSURL *)pDestinationModelURL {
	NSManagedObjectModel *s = [[NSManagedObjectModel alloc] initWithContentsOfURL:pSourceModelURL];
	NSManagedObjectModel *d = [[NSManagedObjectModel alloc] initWithContentsOfURL:pDestinationModelURL];
	if(s != nil && d != nil) {
		return [self migrationManagerWithSourceModel:s destinationModel:d];
	}
	return nil;
}
+ (id)migrationManagerWithSourceModel:(NSManagedObjectModel *)pSourceModel destinationModel:(NSManagedObjectModel *)pDestinationModel {
	return [[self alloc] initWithSourceModel:pSourceModel destinationModel:pDestinationModel];
}
- (id)initWithSourceModel:(NSManagedObjectModel *)pSourceModel destinationModel:(NSManagedObjectModel *)pDestinationModel {
	if((self = [super init])) {
		sourceModel = pSourceModel;
		destinationModel = pDestinationModel;
	}
	return self;
}

#pragma mark - Migration

- (BOOL)migrateStoreFromURL:(NSURL *)pSourceStoreURL 
					   type:(NSString *)pSourceStoreType 
					options:(NSDictionary *)pSourceStoreOptions 
					  rules:(NSArray *)pMigrationRules
		   toDestinationURL:(NSURL *)pDestinationURL 
			destinationType:(NSString *)pDestinationStoreType 
		 destinationOptions:(NSDictionary *)pDestinationStoreOptions
					  error:(NSError **)pError {
	
	// urls
	NSURL *sourceStoreURL = pSourceStoreURL;
	NSURL *destinationStoreTempURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] stringByAppendingPathExtension:@"ckMigration"]];
	NSURL *destinationStoreFinalURL = pDestinationURL;
	
	// error
	NSError *error = nil;
	NSInteger stage = 0;
	NSInteger stageCount = 3;
	do {
		// 0 - setup
		if(stage == 0) {
			// source
			NSDictionary *sourceStoreMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil URL:sourceStoreURL error:&error];
			if(error != nil) {
				break;
			}
			NSString *sourceStoreType = [sourceStoreMetadata objectForKey:NSStoreTypeKey];
			sourceCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:sourceModel];
			sourceStore = [sourceCoordinator addPersistentStoreWithType:sourceStoreType configuration:nil URL:sourceStoreURL options:pSourceStoreOptions error:&error];
			if(error != nil) {
				break;
			}
			sourceContext = [[NSManagedObjectContext alloc] init];
			[sourceContext setPersistentStoreCoordinator:sourceCoordinator];
			
			// destination
			destinationCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:destinationModel];
			destinationStore = [destinationCoordinator addPersistentStoreWithType:pDestinationStoreType configuration:nil URL:destinationStoreTempURL options:pDestinationStoreOptions error:&error];
			if(error != nil) {
				break;
			}
			destinationContext = [[NSManagedObjectContext alloc] init];
			[destinationContext setPersistentStoreCoordinator:destinationCoordinator];
		}
		// 1 - migration
		else if(stage == 1) {
			for(ZWMigrationRule *migrationRule in pMigrationRules) {
				if(![migrationRule migrateWithManager:self error:&error]) {
					break;
				}
			}
			if(error != nil) {
				break;
			}
		}
		// 2 - saving
		else if(stage == 2) {
			// save
			if(![destinationContext save:&error]) {
				break;
			}
			
			// close stores
			[sourceCoordinator removePersistentStore:sourceStore error:nil];
			[destinationCoordinator removePersistentStore:destinationStore error:nil];
			
			NSFileManager *fileManager = [[NSFileManager alloc] init];
			
			// remove any existing file at destination
			if([fileManager fileExistsAtPath:[destinationStoreFinalURL path]]) {
				if(![fileManager removeItemAtURL:destinationStoreFinalURL error:&error]) {
					break;
				}
			}
			
			// move temporary to final
			if(![fileManager moveItemAtURL:destinationStoreTempURL toURL:destinationStoreFinalURL error:&error]) {
				break;
			}
		}
		
	} while(++stage < stageCount && error == nil);
	
	// close stores
	if(sourceStore != nil && [[sourceCoordinator persistentStores] containsObject:sourceStore]) {
		[sourceCoordinator removePersistentStore:sourceStore error:nil];
	}
	if(destinationStore != nil && [[destinationCoordinator persistentStores] containsObject:destinationStore]) {
		[destinationCoordinator removePersistentStore:destinationStore error:nil];
	}
	
	if(pError != nil) {
		*pError = error;
	}
	return (error == nil);
}

#pragma mark - Dealloc



@end
