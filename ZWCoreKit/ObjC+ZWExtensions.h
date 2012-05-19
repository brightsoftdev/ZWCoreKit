#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark -

extern Method ZWClassMethodForSelector(Class cls, SEL selector);
extern Method ZWInstanceMethodForSelector(Class cls, SEL selector);

#pragma mark -

extern BOOL ZWExchangeClassMethodImplementations(Class cls, SEL selector1, SEL selector2);
extern BOOL ZWExchangeInstanceMethodImplementations(Class cls, SEL selector1, SEL selector2);

#pragma mark -

extern BOOL ZWAddAndExchangeClassMethodImplementations(Class cls, SEL selector1, SEL selector2);
extern BOOL ZWAddAndExchangeInstanceMethodImplementations(Class cls, SEL selector1, SEL selector2);

#pragma mark -

extern BOOL ZWSwizzleClassMethodsWithPrefix(Class cls, NSString *prefix);
extern BOOL ZWSwizzleInstanceMethodsWithPrefix(Class cls, NSString *prefix);

#pragma mark -

extern Method ZWAddClassMethod(Class cls, SEL selector, IMP implementation, const char *typeEncodings);
extern Method ZWAddClassMethodWithMethod(Class cls, Method method);

#pragma mark -

extern Method ZWAddInstanceMethod(Class cls, SEL selector, IMP implementation, const char *typeEncodings);
extern Method ZWAddInstanceMethodWithMethod(Class cls, Method method);