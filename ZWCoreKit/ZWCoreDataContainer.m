#import "ZWCoreDataContainer.h"
#import "NSObject+ZWExtensions.h"

@interface ZWCoreDataContainer()  {
	NSMutableDictionary *managedObjectContextsDictionary;
	NSManagedObjectModel *managedObjectModel;
	NSURL *persistentStoreURL;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSManagedObjectContext *managedObjectContext;
}

- (void)threadWillExitNotificiation:(NSNotification *)pNotificiation;

@end
@implementation ZWCoreDataContainer

#pragma mark - Properties

@synthesize managedObjectModelURL;
@synthesize managedObjectModel;
@synthesize persistentStoreURL;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;

#pragma mark - Initialization

+ (ZWCoreDataContainer *)coreDataContainerWithManagedObjectModelURL:(NSURL *)pManagedObjectModelURL 
												 persistentStoreURL:(NSURL *)pPersistentStoreURL
														  storeType:(NSString *)pStoreType
													  configuration:(NSString *)pConfiguration
															options:(NSDictionary *)pOptions {
	return [[self alloc] initWithManagedObjectModelURL:pManagedObjectModelURL 
									persistentStoreURL:pPersistentStoreURL 
											 storeType:pStoreType
										 configuration:pConfiguration 
											   options:pOptions];
}
- (id)initWithManagedObjectModelURL:(NSURL *)pManagedObjectModelURL 
				 persistentStoreURL:(NSURL *)pPersistentStoreURL 
						  storeType:(NSString *)pStoreType
					  configuration:(NSString *)pConfiguration
							options:(NSDictionary *)pOptions {
	if((self = [super init])) {
		NSAssert([NSThread currentThread] == [NSThread mainThread], @"ZWCoreDataContainer must be created on the main thread");
		managedObjectContextsDictionary = [[NSMutableDictionary alloc] init];
		
		managedObjectModelURL = pManagedObjectModelURL;
		persistentStoreURL = pPersistentStoreURL;
		
		NSError *error = nil;
		
		managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:managedObjectModelURL];
		persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
		if(![persistentStoreCoordinator addPersistentStoreWithType:pStoreType
													 configuration:pConfiguration
															   URL:persistentStoreURL
														   options:pOptions
															 error:&error]) {
			ZWLog(@"Error creating persistent store.. clearing data and re-creating");
			[[NSFileManager defaultManager] removeItemAtPath:[persistentStoreURL path] error:&error];
			if(![persistentStoreCoordinator addPersistentStoreWithType:pStoreType
														 configuration:pConfiguration
																   URL:persistentStoreURL
															   options:pOptions
																 error:&error]) {
				abort(); 
			}
			error = nil;
		};
		error = nil;
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
		[managedObjectContext save:&error];
		
		[managedObjectContextsDictionary setObject:managedObjectContext forKey:[[NSThread currentThread] pointerAsString]];
		
		if(error != nil) {
			ZWLog(@"Fatal error with Core Data setup: %@", error);
			abort();
		}
	}
	return self;
}

#pragma mark - Saving

- (BOOL)save:(NSError **)pError {	
	if(![managedObjectContext save:pError]) {
		ZWLog(@"Error saving managedObjectContext");
		return NO;
	}
	return YES;
}

#pragma mark - Multi-Threading

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)pThread automaticallyMergeChangesOnSave:(BOOL)pAutomaticallyMergeChangesOnSave {
	if(pThread == nil || [pThread isMainThread]) {
		return managedObjectContext;
	}
	NSManagedObjectContext *threadManagedObjectContext = [managedObjectContextsDictionary objectForKey:[pThread pointerAsString]];
	if(threadManagedObjectContext == nil) {
		threadManagedObjectContext = [[NSManagedObjectContext alloc] init];
		[threadManagedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
		[managedObjectContextsDictionary setObject:threadManagedObjectContext forKey:[pThread pointerAsString]];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(threadWillExitNotificiation:)
													 name:NSThreadWillExitNotification
												   object:pThread];
	}
	[[NSNotificationCenter defaultCenter] removeObserver:managedObjectContext
													name:NSManagedObjectContextDidSaveNotification
												  object:threadManagedObjectContext];
	if(pAutomaticallyMergeChangesOnSave) {
		[[NSNotificationCenter defaultCenter] addObserver:managedObjectContext
												 selector:@selector(mergeChangesFromContextDidSaveNotification:)
													 name:NSManagedObjectContextDidSaveNotification
												   object:threadManagedObjectContext];
	}
	return threadManagedObjectContext;
}

#pragma mark - Observers & Notifications

- (void)threadWillExitNotificiation:(NSNotification *)pNotificiation {
	NSThread *thread = [pNotificiation object];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSThreadWillExitNotification
												  object:thread];
	[[NSNotificationCenter defaultCenter] removeObserver:managedObjectContext
													name:NSManagedObjectContextDidSaveNotification
												  object:[managedObjectContextsDictionary objectForKey:[thread pointerAsString]]];
	[managedObjectContextsDictionary removeObjectForKey:[thread pointerAsString]];
}

#pragma mark - Dealloc

- (void)dealloc {
}

@end
