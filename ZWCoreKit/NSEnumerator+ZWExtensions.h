#import <Foundation/Foundation.h>


@interface NSEnumerator (ZWExtensions)

- (void)makeObjectsPerformBlock:(void (^)(id object))pBlock;

@end
