#import <Foundation/Foundation.h>


@interface NSArray (ZWExtensions)

- (id)firstObject;
- (id)lastObject;
- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)pArray;

- (NSArray *)allObjectsWithKindOfClass:(Class)pClass;
- (id)firstObjectWithKindOfClass:(Class)pClass;
- (void)enumerateObjectsWithKindOfClass:(Class)pClass usingBlock:(void (^)(id object, NSUInteger index, BOOL *stop))pBlock;

@end
