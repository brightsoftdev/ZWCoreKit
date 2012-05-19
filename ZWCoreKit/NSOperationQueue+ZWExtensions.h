#import <Foundation/Foundation.h>

@interface NSOperationQueue (ZWExtensions)

+ (NSOperationQueue *)sharedConcurrentQueue;
+ (NSOperationQueue *)sharedSerialQueue;

- (void)addOperations:(NSArray *)pOperations completionBlock:(void (^)(NSArray *operations))pCompletionBlock;
- (void)addOperation:(NSOperation *)pOperation completionBlock:(void (^)(NSOperation *operation))pCompletionBlock;

@end