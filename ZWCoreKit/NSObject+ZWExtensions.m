#import "NSObject+ZWExtensions.h"
#import "NSAutoreleasePool+ZWExtensions.h"
#import <objc/runtime.h>
#import <objc/message.h>



#pragma mark - NSObject

@implementation NSObject (ZWExtensions)

/* exchanges a class method with another class method */
+ (BOOL)exchangeClassMethodSelector:(SEL)pSelector withSelector:(SEL)pNewSelector {
	return ZWExchangeClassMethodImplementations(self.class, pSelector, pNewSelector);
}

/* exchanges a class instance method with another class instance method */
+ (BOOL)exchangeInstanceMethodSelector:(SEL)pSelector withSelector:(SEL)pNewSelector {
	return ZWExchangeInstanceMethodImplementations(self.class, pSelector, pNewSelector);
}

/* finds class methods with specified prefixes and swizzles in a new method without the prefix */
+ (BOOL)swizzleClassMethodsWithPrefix:(NSString *)pPrefix {
	return ZWSwizzleClassMethodsWithPrefix(self.class, pPrefix);
	
}

/* finds instance methods with specified prefixes and swizzles in a new method without the prefix */
+ (BOOL)swizzleInstanceMethodsWithPrefix:(NSString *)pPrefix {
	return ZWSwizzleInstanceMethodsWithPrefix(self.class, pPrefix);
}

/* adds a class method */
+ (Method)addClassMethodForSelector:(SEL)pSelector implementation:(IMP)pImplementation typeEncodings:(const char *)pTypeEncodings {
	return ZWAddClassMethod(self.class, pSelector, pImplementation, pTypeEncodings);
}
+ (Method)addClassMethodForSelector:(SEL)pSelector existingMethod:(Method)pMethod {
	return ZWAddClassMethod(self.class, pSelector, method_getImplementation(pMethod), method_getTypeEncoding(pMethod));
}

/* adds an instance method */
+ (Method)addInstanceMethodForSelector:(SEL)pSelector implementation:(IMP)pImplementation typeEncodings:(const char *)pTypeEncodings {
	return ZWAddInstanceMethod(self.class, pSelector, pImplementation, pTypeEncodings);
}
+ (Method)addInstanceMethodForSelector:(SEL)pSelector existingMethod:(Method)pMethod {
	return ZWAddInstanceMethod(self.class, pSelector, method_getImplementation(pMethod), method_getTypeEncoding(pMethod));
}

- (id)associatedObjectForKey:(const void *)pKey {
	return objc_getAssociatedObject(self, pKey);
}
- (void)setAssociatedObject:(id)pObject forKey:(const void *)pKey policy:(objc_AssociationPolicy)pPolicy {
	objc_setAssociatedObject(self, pKey, pObject, pPolicy);
}

- (NSString *)pointerAsString {
	return [NSString stringWithFormat:@"%p", self];
}

- (void)performAsyncBlockInBackground:(void (^)(void))pBlock {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), pBlock);
}
- (void)performSyncBlockInBackground:(void (^)(void))pBlock {
	dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), pBlock);
}
- (void)performAsyncBlockOnMainThread:(void (^)(void))pBlock {
	dispatch_async(dispatch_get_main_queue(), pBlock);
}
- (void)performSyncBlockOnMainThread:(void (^)(void))pBlock {
	dispatch_sync(dispatch_get_main_queue(), pBlock);
}

- (NSDictionary *)dictionaryWithValuesForKeyPaths:(NSArray *)pKeyPaths {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[pKeyPaths count]];
	for(id keyPath in pKeyPaths) {
		[dictionary setObject:[self valueForKeyPath:keyPath] forKey:keyPath];
	}
	return dictionary;
}
- (void)setValuesForKeyPathsWithDictionary:(NSDictionary *)pDictionary {
	for(id keyPath in pDictionary) {
		[self setValue:[pDictionary objectForKey:keyPath] forKeyPath:keyPath];
	}
}

@end
