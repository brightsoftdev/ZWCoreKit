#import <Foundation/Foundation.h>
#if TARGET_SDK_IOS
#import <UIKit/UIKit.h>
#endif
#if TARGET_SDK_OSX
#import <AppKit/AppKit.h>
#endif

@interface NSUserDefaults (ZWExtensions)

#pragma mark - Data Serialization

#if TARGET_SDK_IOS
- (UIColor *)colorForKey:(NSString *)pKey;
- (void)setColor:(UIColor *)pColor forKey:(NSString *)pKey;
#elif TARGET_SDK_OSX
- (NSColor *)colorForKey:(NSString *)pKey;
- (void)setColor:(NSColor *)pColor forKey:(NSString *)pKey;
#endif

- (void)setArchivedObject:(id)pObject forKey:(NSString *)pKey;
- (id)unarchivedObjectForKey:(NSString *)pKey;

@end
