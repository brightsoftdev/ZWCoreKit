#import <Foundation/Foundation.h>


@interface NSIndexPath (ZWExtensions)

- (NSUInteger)firstIndex;
- (NSUInteger)lastIndex;
- (NSIndexPath *)indexPathByIncrementingLastIndex;
- (NSIndexPath *)indexPathByReplacingIndexAtPosition:(NSUInteger)pPosition withIndex:(NSUInteger)pIndex;
- (NSIndexPath *)indexPathByAddingIndexPath:(NSIndexPath *)pIndexPath;
- (NSIndexPath *)indexPathByAddingIndexInFront:(NSUInteger)pIndex;
- (NSIndexPath *)subIndexPathFromPosition:(NSUInteger)pPosition;
- (NSIndexPath *)subIndexPathToPosition:(NSUInteger)pPosition;
- (NSIndexPath *)subIndexPathWithRange:(NSRange)pRange;

@end
