#import "NSManagedObject+ZWExtensions.h"

@implementation NSManagedObject (ZWExtensions)

+ (id)insertNewManagedObjectInContext:(NSManagedObjectContext *)pManagedObjectContext {
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:pManagedObjectContext];
}

@end