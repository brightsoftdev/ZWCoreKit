#import <Foundation/Foundation.h>

@interface NSNotificationCenter (ZWExtensions)

- (id)addObserverForName:(NSString *)pName object:(id)pObject usingBlock:(void (^)(NSNotification *notification))pBlock;

@end
