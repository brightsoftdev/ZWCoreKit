#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#if TARGET_SDK_IOS
#import <UIKit/UIKit.h>
#endif
#if TARGET_SDK_OSX
#import <AppKit/AppKit.h>
#endif

/* rect */
static inline CGRect NSManagedObjectRectFromString(NSManagedObject *target, NSString *key) {
	[target willAccessValueForKey:key];
	NSString *v = [target primitiveValueForKey:key];
	[target didAccessValueForKey:key];
	return CGRectFromString(v);
};
static inline void NSManagedObjectSetRectAsString(NSManagedObject *target, NSString *key, CGRect value) {
	NSString *v = NSStringFromCGRect(value);
	[target willAccessValueForKey:key];
	[target setPrimitiveValue:v forKey:key];
	[target didAccessValueForKey:key];
};
/* size */
static inline CGSize NSManagedObjectSizeFromString(NSManagedObject *target, NSString *key) {
	[target willAccessValueForKey:key];
	NSString *v = [target primitiveValueForKey:key];
	[target didAccessValueForKey:key];
	return CGSizeFromString(v);
};
static inline void NSManagedObjectSetSizeAsString(NSManagedObject *target, NSString *key, CGSize value) {
	NSString *v = NSStringFromCGSize(value);
	[target willAccessValueForKey:key];
	[target setPrimitiveValue:v forKey:key];
	[target didAccessValueForKey:key];
};
/* point */
static inline CGPoint NSManagedObjectPointFromString(NSManagedObject *target, NSString *key) {
	[target willAccessValueForKey:key];
	NSString *v = [target primitiveValueForKey:key];
	[target didAccessValueForKey:key];
	return CGPointFromString(v);
};
static inline void NSManagedObjectSetPointAsString(NSManagedObject *target, NSString *key, CGPoint value) {
	NSString *v = NSStringFromCGPoint(value);
	[target willAccessValueForKey:key];
	[target setPrimitiveValue:v forKey:key];
	[target didAccessValueForKey:key];
};
/* unsigned integer */
static inline NSUInteger NSManagedObjectUnsignedIntegerFromNumber(NSManagedObject *target, NSString *key) {
	[target willAccessValueForKey:key];
	NSNumber *v = [target primitiveValueForKey:key];
	[target didAccessValueForKey:key];
	return [v unsignedIntegerValue];
};
static inline void NSManagedObjectSetUnsignedIntegerAsNumber(NSManagedObject *target, NSString *key, NSUInteger value) {
	NSNumber *v = [NSNumber numberWithUnsignedInteger:value];
	[target willAccessValueForKey:key];
	[target setPrimitiveValue:v forKey:key];
	[target didAccessValueForKey:key];
};
/* integer */
static inline NSInteger NSManagedObjectIntegerFromNumber(NSManagedObject *target, NSString *key) {
	[target willAccessValueForKey:key];
	NSNumber *v = [target primitiveValueForKey:key];
	[target didAccessValueForKey:key];
	return [v integerValue];
};
static inline void NSManagedObjectSetIntegerAsNumber(NSManagedObject *target, NSString *key, NSInteger value) {
	NSNumber *v = [NSNumber numberWithInteger:value];
	[target willAccessValueForKey:key];
	[target setPrimitiveValue:v forKey:key];
	[target didAccessValueForKey:key];
};
/* boolean */
static inline BOOL NSManagedObjectBooleanFromNumber(NSManagedObject *target, NSString *key) {
	[target willAccessValueForKey:key];
	NSNumber *v = [target primitiveValueForKey:key];
	[target didAccessValueForKey:key];
	return [v boolValue];
};
static inline void NSManagedObjectSetBooleanAsNumber(NSManagedObject *target, NSString *key, BOOL value) {
	NSNumber *v = [NSNumber numberWithBool:value];
	[target willAccessValueForKey:key];
	[target setPrimitiveValue:v forKey:key];
	[target didAccessValueForKey:key];
};
/* float */
static inline float NSManagedObjectFloatFromNumber(NSManagedObject *target, NSString *key) {
	[target willAccessValueForKey:key];
	NSNumber *v = [target primitiveValueForKey:key];
	[target didAccessValueForKey:key];
	return [v floatValue];
};
static inline void NSManagedObjectSetFloatAsNumber(NSManagedObject *target, NSString *key, float value) {
	NSNumber *v = [NSNumber numberWithFloat:value];
	[target willAccessValueForKey:key];
	[target setPrimitiveValue:v forKey:key];
	[target didAccessValueForKey:key];
};
/* double */
static inline double NSManagedObjectDoubleFromNumber(NSManagedObject *target, NSString *key) {
	[target willAccessValueForKey:key];
	NSNumber *v = [target primitiveValueForKey:key];
	[target didAccessValueForKey:key];
	return [v doubleValue];
};
static inline void NSManagedObjectSetDoubleAsNumber(NSManagedObject *target, NSString *key, double value) {
	NSNumber *v = [NSNumber numberWithDouble:value];
	[target willAccessValueForKey:key];
	[target setPrimitiveValue:v forKey:key];
	[target didAccessValueForKey:key];
};

@interface NSManagedObject (ZWExtensions)

+ (id)insertNewManagedObjectInContext:(NSManagedObjectContext *)pManagedObjectContext;

@end

