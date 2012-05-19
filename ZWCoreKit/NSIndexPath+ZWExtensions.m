#import "NSIndexPath+ZWExtensions.h"


@implementation NSIndexPath (ZWExtensions)

- (NSUInteger)firstIndex {
	return [self indexAtPosition:0];
}
- (NSUInteger)lastIndex {
	return [self indexAtPosition:[self length] - 1];
}
- (NSIndexPath *)indexPathByIncrementingLastIndex {
	NSUInteger lastIndex = [self lastIndex];
	NSIndexPath *temp = [self indexPathByRemovingLastIndex];
	return [temp indexPathByAddingIndex:++lastIndex];
}
- (NSIndexPath *)indexPathByReplacingIndexAtPosition:(NSUInteger)pPosition withIndex:(NSUInteger)pIndex {
	NSUInteger indexes[[self length]];
	[self getIndexes:indexes];
	indexes[pPosition] = pIndex;
	return [[NSIndexPath alloc] initWithIndexes:indexes length:[self length]];
}
- (NSIndexPath *)indexPathByAddingIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *path = [self copy];
	for(NSUInteger position = 0; position < indexPath.length; position++) {
		path = [path indexPathByAddingIndex:[indexPath indexAtPosition:position]];
	}
	return path;
}
- (NSIndexPath *)indexPathByAddingIndexInFront:(NSUInteger)pIndex {
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:pIndex];
	return [indexPath indexPathByAddingIndexPath:self];
}
- (NSIndexPath *)subIndexPathFromPosition:(NSUInteger)pPosition {
	return [self subIndexPathWithRange:NSMakeRange(pPosition, self.length - pPosition)];
}
- (NSIndexPath *)subIndexPathToPosition:(NSUInteger)pPosition {
	return [self subIndexPathWithRange:NSMakeRange(0, pPosition)];
}
- (NSIndexPath *)subIndexPathWithRange:(NSRange)pRange {
	NSIndexPath *path = [[NSIndexPath alloc] init];
	for(NSUInteger position = pRange.location; position < (pRange.location + pRange.length); position++) {
		path = [path indexPathByAddingIndex:[self indexAtPosition:position]];
	}
	return path;
}

@end
