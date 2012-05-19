#import <Foundation/Foundation.h>


@interface NSFetchRequest (ZWExtensions)

+ (id)fetchRequestWithEntity:(NSEntityDescription *)pEntity;
+ (id)fetchRequestWithEntityForName:(NSString *)pEntityName inManagedObjectContext:(NSManagedObjectContext *)pManagedObjectContext;

@end
