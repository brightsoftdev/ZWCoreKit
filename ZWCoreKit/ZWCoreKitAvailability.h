#import <Availability.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Accelerate/Accelerate.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#define TARGET_SDK_IOS 1
#define TARGET_SDK_OSX 0
#else
#define TARGET_SDK_IOS 0
#define TARGET_SDK_OSX 1
#endif

#if __has_feature(objc_arc_weak)
#define OBJC_ARC_WEAK 1
#else
#define OBJC_ARC_WEAK 0
#endif

#if TARGET_SDK_IOS
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import <CoreText/CoreText.h>
#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>
#endif

#if TARGET_SDK_OSX
#import <Quartz/Quartz.h>
#import <OpenGL/OpenGL.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#endif