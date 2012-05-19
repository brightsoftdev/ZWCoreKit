#import "ZWMigrationRule.h"


@interface ZWMigrationRule() {	
	NSString *sourceEntityName;
	NSString *destinationEntityName;
}
@end
@implementation ZWMigrationRule

#pragma mark - Properties

@synthesize sourceEntityName;
@synthesize destinationEntityName;

#pragma mark - Initialization

+ (id)migrationRuleWithSourceEntityName:(NSString *)pSourceEntityName destinationEntityName:(NSString *)pDestinationEntityName {
	return [[self alloc] initWithSourceEntityName:pSourceEntityName destinationEntityName:pDestinationEntityName];
}
- (id)initWithSourceEntityName:(NSString *)pSourceEntityName destinationEntityName:(NSString *)pDestinationEntityName {
	if((self = [super init])) {
		sourceEntityName = pSourceEntityName;
		destinationEntityName = pDestinationEntityName;
	}
	return self;
}

#pragma mark - Migration

- (BOOL)migrateWithManager:(ZWMigrationManager *)pMigrationManager error:(NSError **)pError {
	return YES;
}

#pragma mark - Dealloc


@end
