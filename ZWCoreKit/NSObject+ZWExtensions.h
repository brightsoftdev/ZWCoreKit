#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface NSObject (ZWExtensions)

/* exchanges a class method with another class method */
+ (BOOL)exchangeClassMethodSelector:(SEL)pSelector withSelector:(SEL)pNewSelector;

/* exchanges an instance method with another class instance method */
+ (BOOL)exchangeInstanceMethodSelector:(SEL)pSelector withSelector:(SEL)pNewSelector;

/* finds class methods with specified prefixes and swizzles in a new method without the prefix */
+ (BOOL)swizzleClassMethodsWithPrefix:(NSString *)pPrefix;

/* finds instance methods with specified prefixes and swizzles in a new method without the prefix */
+ (BOOL)swizzleInstanceMethodsWithPrefix:(NSString *)pPrefix;

/* adds a class method */
+ (Method)addClassMethodForSelector:(SEL)pSelector implementation:(IMP)pImplementation typeEncodings:(const char *)pTypeEncodings;
+ (Method)addClassMethodForSelector:(SEL)pSelector existingMethod:(Method)pMethod;

/* adds an instance method */
+ (Method)addInstanceMethodForSelector:(SEL)pSelector implementation:(IMP)pImplementation typeEncodings:(const char *)pTypeEncodings;
+ (Method)addInstanceMethodForSelector:(SEL)pSelector existingMethod:(Method)pMethod;

- (id)associatedObjectForKey:(const void *)pKey;
- (void)setAssociatedObject:(id)pObject forKey:(const void *)pKey policy:(objc_AssociationPolicy)pPolicy;

- (NSString *)pointerAsString;

- (void)performAsyncBlockInBackground:(void (^)(void))pBlock;
- (void)performSyncBlockInBackground:(void (^)(void))pBlock;

- (void)performAsyncBlockOnMainThread:(void (^)(void))pBlock;
- (void)performSyncBlockOnMainThread:(void (^)(void))pBlock;

- (NSDictionary *)dictionaryWithValuesForKeyPaths:(NSArray *)pKeyPaths;
- (void)setValuesForKeyPathsWithDictionary:(NSDictionary *)pDictionary;

@end
