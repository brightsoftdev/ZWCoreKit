#import "NSFetchRequest+ZWExtensions.h"


@implementation NSFetchRequest (ZWExtensions)

+ (id)fetchRequestWithEntity:(NSEntityDescription *)pEntity {
	NSFetchRequest *result = [[self alloc] init];
	if(result != nil) {
		[result setEntity:pEntity];
	}
	return result;
}
+ (id)fetchRequestWithEntityForName:(NSString *)pEntityName inManagedObjectContext:(NSManagedObjectContext *)pManagedObjectContext {
	return [self fetchRequestWithEntity:[NSEntityDescription entityForName:pEntityName inManagedObjectContext:pManagedObjectContext]];
}

@end
