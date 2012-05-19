#import "NSPersistentStoreCoordinator+ZWExtensions.h"

static void *managedObjectContextsKey;
static void *parentManagedObjectContextKey;

@implementation NSPersistentStoreCoordinator (ZWExtensions)

- (NSMutableDictionary *)NSPersistentStoreCoordinator_ZWExtensions_managedObjectContexts {
	NSMutableDictionary *managedObjectContexts = [self associatedObjectForKey:managedObjectContextsKey];
	if(managedObjectContexts == nil) {
		managedObjectContexts = [NSMutableDictionary dictionaryWithCapacity:10];
		[self setAssociatedObject:managedObjectContexts forKey:managedObjectContextsKey policy:OBJC_ASSOCIATION_RETAIN];
	}
	return managedObjectContexts;
}
- (void)NSPersistentStoreCoordinator_ZWExtensions_threadWillExitNotification:(NSNotification *)pNotification {
	NSThread *thread = [pNotification object];
	@synchronized(self) {
		// get contexts
		NSManagedObjectContext *context = [self managedObjectContextForThread:thread parentContext:nil];
		NSManagedObjectContext *parentContext = [context associatedObjectForKey:parentManagedObjectContextKey];
		
		// remove notifications
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSThreadWillExitNotification object:thread];
		if(parentContext != nil) {
			[[NSNotificationCenter defaultCenter] removeObserver:parentContext name:NSManagedObjectContextDidSaveNotification object:context];
		}
		
		// clean up
		[context setAssociatedObject:nil forKey:parentManagedObjectContextKey policy:OBJC_ASSOCIATION_RETAIN];
		[[self NSPersistentStoreCoordinator_ZWExtensions_managedObjectContexts] removeObjectForKey:[context pointerAsString]];
	}
}
- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)pThread parentContext:(NSManagedObjectContext *)pParentContext {
	NSThread *useThread = pThread;
	@synchronized(self) {
		NSMutableDictionary *contexts = [self NSPersistentStoreCoordinator_ZWExtensions_managedObjectContexts];
		NSString *threadKey = [useThread pointerAsString];
		NSManagedObjectContext *threadContext = [contexts objectForKey:threadKey];
		if(threadContext == nil) {
			threadContext = [[NSManagedObjectContext alloc] init];
			[threadContext setPersistentStoreCoordinator:self];
			if(pParentContext != nil) {
				[threadContext setAssociatedObject:pParentContext forKey:parentManagedObjectContextKey policy:OBJC_ASSOCIATION_RETAIN];
				[[NSNotificationCenter defaultCenter] addObserver:pParentContext
														 selector:@selector(mergeChangesFromContextDidSaveNotification:)
															 name:NSManagedObjectContextDidSaveNotification
														   object:threadContext];
			}
			[contexts setObject:threadContext forKey:threadKey];
		}
	}
	return nil;
}
- (NSManagedObjectContext *)managedObjectContextForCurrentThreadWithParentContext:(NSManagedObjectContext *)pParentContext {
	return [self managedObjectContextForThread:[NSThread currentThread] parentContext:pParentContext];
}

@end
