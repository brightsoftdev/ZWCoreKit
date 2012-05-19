#import "ObjC+ZWExtensions.h"

Method ZWGetMethodForSelector(Class cls, SEL selector);
BOOL ZWExchangeMethodImplementations(Class cls, SEL selector1, SEL selector2);
BOOL ZWAddAndExchangeMethodImplementations(Class cls, SEL selector1, SEL selector2);
BOOL ZWSwizzleMethodsWithPrefix(Class cls, NSString *prefix);
Method ZWAddMethod(Class cls, SEL selector, IMP implementation, const char *typeEncodings);

#pragma mark - 

Method ZWGetMethodForSelector(Class cls, SEL selector) {
	unsigned int methodsCount = 0;
	Method *methods = class_copyMethodList(cls, &methodsCount);
	if(methods) {
		for(NSInteger i = 0; i < methodsCount; ++i) {
			Method method = methods[i];
			if(sel_isEqual(method_getName(method), selector)) {
				free(methods);
				return method;
			}
		}
		free(methods);
	}
	return nil;
}
Method ZWClassMethodForSelector(Class cls, SEL selector) {
	return ZWGetMethodForSelector(object_getClass(cls), selector);
}
Method ZWInstanceMethodForSelector(Class cls, SEL selector) {
	return ZWGetMethodForSelector(cls, selector);
}

#pragma mark -

BOOL ZWExchangeMethodImplementations(Class cls, SEL selector1, SEL selector2) {
	Method m1 = ZWGetMethodForSelector(cls, selector1);
	Method m2 = ZWGetMethodForSelector(cls, selector2);
	if(m1 && m2) {
		method_exchangeImplementations(m1, m2);
		return YES;
	}
	return NO;
}

BOOL ZWExchangeClassMethodImplementations(Class cls, SEL selector1, SEL selector2) {
	return ZWExchangeMethodImplementations(object_getClass(cls), selector1, selector2);
}

BOOL ZWExchangeInstanceMethodImplementations(Class cls, SEL selector1, SEL selector2) {
	return ZWExchangeMethodImplementations(cls, selector1, selector2);
}

#pragma mark -


BOOL ZWAddAndExchangeMethodImplementations(Class cls, SEL selector1, SEL selector2) {
	Method s1 = class_getInstanceMethod(cls, selector1);
	Method s2 = class_getInstanceMethod(cls, selector2);
	
	ZWAddMethod(cls, method_getName(s1), method_getImplementation(s1), method_getTypeEncoding(s1));
	ZWAddMethod(cls, method_getName(s2), method_getImplementation(s2), method_getTypeEncoding(s2));
	
	return ZWExchangeMethodImplementations(cls, selector1, selector2);
}
BOOL ZWAddAndExchangeClassMethodImplementations(Class cls, SEL selector1, SEL selector2) {
	return ZWAddAndExchangeMethodImplementations(object_getClass(cls), selector1, selector2);
}
BOOL ZWAddAndExchangeInstanceMethodImplementations(Class cls, SEL selector1, SEL selector2) {
	return ZWAddAndExchangeMethodImplementations(cls, selector1, selector2);
}

#pragma mark -

BOOL ZWSwizzleMethodsWithPrefix(Class cls, NSString *prefix) {
	unsigned int methodsCount = 0;
	Method *methods = class_copyMethodList(cls, &methodsCount);
	if(methods) {
		for(NSInteger i = 0; i < methodsCount; ++i) {
			Method method = methods[i];
			SEL methodSelector = method_getName(method);
			NSString *methodSelectorName = NSStringFromSelector(methodSelector);
			if([methodSelectorName hasPrefix:prefix]) {
				NSString *targetMethodSelectorName = [methodSelectorName stringByReplacingOccurrencesOfString:prefix withString:@""];
				SEL targetSelector = NSSelectorFromString(targetMethodSelectorName);
				
				if(!class_addMethod(cls, targetSelector, method_getImplementation(method), method_getTypeEncoding(method))) {
					free(methods);
					return NO;
				}
			}
		}
		free(methods);
	}
	return YES;
}
BOOL ZWSwizzleClassMethodsWithPrefix(Class cls, NSString *prefix) {
	return ZWSwizzleMethodsWithPrefix(object_getClass(cls), prefix);
}
BOOL ZWSwizzleInstanceMethodsWithPrefix(Class cls, NSString *prefix) {
	return ZWSwizzleMethodsWithPrefix(cls, prefix);
}

#pragma mark - 

Method ZWAddMethod(Class cls, SEL selector, IMP implementation, const char *typeEncodings) {
	if(class_addMethod(cls, selector, implementation, typeEncodings)) {
		return ZWGetMethodForSelector(cls, selector);
	}
	return nil;
}

Method ZWAddClassMethod(Class cls, SEL selector, IMP implementation, const char *typeEncodings) {
	return ZWAddMethod(object_getClass(cls), selector, implementation, typeEncodings);
}
Method ZWAddClassMethodWithMethod(Class cls, Method method) {
	return ZWAddMethod(object_getClass(cls), method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

Method ZWAddInstanceMethod(Class cls, SEL selector, IMP implementation, const char *typeEncodings) {
	return ZWAddMethod(cls, selector, implementation, typeEncodings);
}
Method ZWAddInstanceMethodWithMethod(Class cls, Method method) {
	return ZWAddMethod(cls, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

