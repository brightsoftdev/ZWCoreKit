#import <Foundation/Foundation.h>

#define DEG2RAD(__V__) __V__ * M_PI / 180.0
#define RAD2DEG(__V__) __V__ * 180.0 / M_PI

static inline NSString *ZWGloballyUniqueIdentifier() {
	return [[NSProcessInfo processInfo] globallyUniqueString];
}
static inline NSString* ZWResourcePath(NSString *name) {
	return [[NSBundle mainBundle] pathForResource:name ofType:nil];
}
static inline NSURL* ZWResourceURL(NSString *name) {
	return [[NSBundle mainBundle] URLForResource:name withExtension:nil];
}
static inline NSString *ZWResourcePathInBundle(NSString *name, NSBundle *bundle) {
	return [bundle pathForResource:name ofType:nil];
}
static inline NSURL *ZWResourceURLInBundle(NSString *name, NSBundle *bundle) {
	return [bundle URLForResource:name withExtension:nil];
}

#define NSStandardUserDefaults [NSUserDefaults standardUserDefaults]
#define NSDefaultNotificationCenter [NSNotificationCenter defaultCenter]

#if DEBUG
#define ZWLog(s, ...) NSLog( @"<%p %@:(%s|%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define ZWLog(s, ...)
#endif

#define ZWRetain(obj) { void *robj = (__bridge_retained void *)obj; robj = nil; }

#define ZWRelease(obj) { void *robj = (__bridge void *)obj; id robj2 = (__bridge_transfer id)robj; robj2 = nil; }

#if TARGET_SDK_OSX
#define CGRectFromString(v) NSRectFromString(v)
#define CGSizeFromString(v) NSSizeFromString(v)
#define CGPointFromString(v) NSPointFromString(v)
#define NSStringFromCGRect(v) NSStringFromRect(v)
#define NSStringFromCGSize(v) NSStringFromSize(v)
#define NSStringFromCGPoint(v) NSStringFromPoint(v)
#endif
