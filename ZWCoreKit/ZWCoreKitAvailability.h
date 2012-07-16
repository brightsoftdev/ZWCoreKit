#import <Availability.h>

#if TARGET_OS_IPHONE
#define TARGET_SDK_IOS 1
#define TARGET_SDK_OSX 0
#elif TARGET_IPHONE_SIMULATOR
#define TARGET_SDK_IOS 1
#define TARGET_SDK_OSX 0
#elif TARGET_OS_MAC
#define TARGET_SDK_IOS 0
#define TARGET_SDK_OSX 1
#else
#define TARGET_SDK_IOS 0
#define TARGET_SDK_OSX 0
#endif

#if __has_feature(objc_arc_weak)
	#define OBJC_ARC_WEAK 1
#else
	#define OBJC_ARC_WEAK 0
#endif