#import "ZWWeakRuntimeClang.h"
#import "ZWWeakRuntime.h"

#if ZWWeakRuntimeClang

#if __has_feature(objc_arc)
#error ZWWeakRuntimeClang.m must be compiled with the -fno-objc-arc flag
#endif

#import <objc/runtime.h>
#import <dlfcn.h>

/**
 * NEXT Helper
 * This helper helps find existing weak runtime functions and use it instead of our own impelementation.
 */
#define NEXT(name, ...) do { \
	static dispatch_once_t fptrOnce; \
	static __typeof__(&name) fptr; \
	dispatch_once(&fptrOnce, ^{ \
		fptr = dlsym(RTLD_NEXT, #name); \
	}); \
	if(fptr) { \
		return fptr(__VA_ARGS__); \
	} \
} while(0)

/**
 * Private Objective-C Methods
 * These methods are in the weak runtime so we must implement them. If weak runtime is available we'll use it instead since
 * it has far superior optimisations.
 */
id objc_initWeak(id *address, id value) {
	NEXT(objc_initWeak, address, value);
	*address = 0;
	return objc_storeWeak(address, value);
}
void objc_copyWeak(id *to, id *from) {
	NEXT(objc_copyWeak, to, from);
	id value = objc_loadWeakRetained(from);
	objc_initWeak(to, value);
	objc_release(value);
}
void objc_moveWeak(id *to, id *from) {
	NEXT(objc_moveWeak, to, from);
	objc_copyWeak(to, from);
	objc_destroyWeak(from);
}
void objc_destroyWeak(id *address) {
	NEXT(objc_destroyWeak, address);
	objc_storeWeak(address, 0);
}

id objc_loadWeakRetained(id *address) {
	NEXT(objc_loadWeakRetained, address);
	return ZWWeakRuntimeLoadWeakRetained(address);
}
id objc_loadWeak(id *address) {
	NEXT(objc_loadWeak, address);
	return objc_autorelease(objc_loadWeakRetained(address));
}
id objc_storeWeak(id *address, id value) {
	NEXT(objc_storeWeak, address, value);
	
	objc_retain(value);
	
	ZWWeakRuntimeUnregisterWeak(address);
	
	*address = value;
	if(value) {
		ZWWeakRuntimeRegisterWeak(address, value);
	}
	
	return objc_autorelease(value);
}

#endif