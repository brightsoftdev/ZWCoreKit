#import "NSSet+ZWExtensions.h"


@implementation NSSet (ZWExtensions)

- (NSArray *)sortedArrayUsingComparator:(NSComparator)pComparator {
	return [[self allObjects] sortedArrayUsingComparator:pComparator];
}

@end
