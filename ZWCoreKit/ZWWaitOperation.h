#import <Foundation/Foundation.h>

@interface ZWWaitOperation : ZWConcurrentOperation

#pragma mark - Properties

@property (readonly) NSTimeInterval waitTimeInterval;

#pragma mark - Initialization

+ (id)operationWithWaitTimeInterval:(NSTimeInterval)pWaitTimeInterval;
- (id)initWithWaitTimeInterval:(NSTimeInterval)pWaitTimeInterval;

@end
