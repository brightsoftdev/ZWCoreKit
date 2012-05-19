#import <Foundation/Foundation.h>


@interface NSOperation (ZWExtensions)

@property (nonatomic, readonly) BOOL isCancelled;
@property (nonatomic, readonly) BOOL isFinished;
@property (nonatomic, readonly) BOOL isExecuted;
@property (nonatomic, readonly) BOOL isReady;
@property (nonatomic, readonly) BOOL isConcurrent;

+ (id)operation;
- (void)executeInBackgroundWithDelegate:(id)pDelegate didEndSelector:(SEL)pDidEndSelector;
- (void)executeInBackgroundWithCompletionHandler:(void (^)(id operation))pCompletionHandler;
- (void)startAndWaitUntilFinished;

@end