#import <Foundation/Foundation.h>
#if TARGET_SDK_IOS
#import <UIKit/UIKit.h>
#endif
#if TARGET_SDK_OSX
#import <AppKit/AppKit.h>
#endif


@interface NSDictionary (ZWExtensions)

- (NSInteger)integerForKey:(NSString *)pKey;
- (NSUInteger)unsignedIntegerForKey:(NSString *)pKey;
- (float)floatForKey:(NSString *)pKey;
- (double)doubleForKey:(NSString *)pKey;
- (BOOL)boolForKey:(NSString *)pKey;

- (CGRect)rectForKey:(NSString *)pKey;
- (CGSize)sizeForKey:(NSString *)pKey;
- (CGPoint)pointForKey:(NSString *)pKey;

@end
