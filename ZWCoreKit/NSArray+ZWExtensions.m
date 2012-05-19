#import "NSArray+ZWExtensions.h"


@implementation NSArray (ZWExtensions)

- (id)firstObject {
	if([self count] == 0) {
		return nil;
	}
	return [self objectAtIndex:0];
}
- (id)lastObject {
	if([self count] == 0) {
		return nil;
	}
	return [self objectAtIndex:[self count] - 1];
}
- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)pArray {
	NSMutableArray *array = [self mutableCopy];
	[array removeObjectsInArray:pArray];
	return array;
}

- (NSArray *)allObjectsWithKindOfClass:(Class)pClass {
	NSMutableArray *objects = [NSMutableArray array];
	for(id object in self) {
		if([object isKindOfClass:pClass]) {
			[objects addObject:object];
		}
	}
	return objects;
}
- (id)firstObjectWithKindOfClass:(Class)pClass {
	for(id object in self) {
		if([object isKindOfClass:pClass]) {
			return object;
		}
	}
	return nil;
}
- (void)enumerateObjectsWithKindOfClass:(Class)pClass usingBlock:(void (^)(id object, NSUInteger index, BOOL *stop))pBlock {
	if(pBlock == nil) {
		return;
	}
	BOOL stop = NO;
	for(NSInteger i = 0; i < [self count]; ++i) {
		id object = [self objectAtIndex:i];
		if([object isKindOfClass:pClass]) {
			pBlock(object, i, &stop);
		}
		if(stop) {
			break;
		}
	}
}

@end
