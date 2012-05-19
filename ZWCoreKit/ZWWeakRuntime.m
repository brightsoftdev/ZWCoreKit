#import "ZWWeakRuntime.h"

#if __has_feature(objc_arc)
#error ZWWeakRuntime.m must be compiled with the -fno-objc-arc flag
#endif

#import <objc/runtime.h>
#import <pthread.h>

/**
 * ZWWeakRuntimeStorage Object
 * stores a weak target strongly against the target
 * when the target deallocs this object will dealloc and nil the target
 */
@interface ZWWeakRuntimeStorage : NSObject {
@public
	id target;
}
+ (ZWWeakRuntimeStorage *)storageForObject:(id)pObject;
@end
@implementation ZWWeakRuntimeStorage

+ (ZWWeakRuntimeStorage *)storageForObject:(id)pObject {
	static char storageKey;
	ZWWeakRuntimeStorage *storage = objc_getAssociatedObject(pObject, &storageKey);
	if(!storage) {
		storage = [[ZWWeakRuntimeStorage alloc] init];
		storage->target = pObject;
		objc_setAssociatedObject(pObject, &storageKey, storage, OBJC_ASSOCIATION_RETAIN);
		[storage release];
	}
	return storage;
}
- (oneway void)release {
	[super release];
}
- (void)dealloc {
	target = nil;
	ZWWeakRuntimeUnregisterWeak(&self);
	[super dealloc];
}
@end

/**
 * ZWWeakRuntime Methods
 */
static pthread_mutex_t ZWWeakRuntimeMutex;

void ZWWeakRuntimeInit(void);
void ZWWeakRuntimeInit() {
	static dispatch_once_t initOnce = 0;
	dispatch_once(&initOnce, ^{
		pthread_mutexattr_t mutexAttr;
		pthread_mutexattr_init(&mutexAttr);
		pthread_mutexattr_settype(&mutexAttr, PTHREAD_MUTEX_RECURSIVE);
		pthread_mutex_init(&ZWWeakRuntimeMutex, &mutexAttr);
		pthread_mutexattr_destroy(&mutexAttr);
	});
}

id ZWWeakRuntimeLoadWeakRetained(id *address) {
	ZWWeakRuntimeInit();
	
	id value = nil;
	pthread_mutex_lock(&ZWWeakRuntimeMutex);
	{
		ZWWeakRuntimeStorage *storage = [(ZWWeakRuntimeStorage *)*address retain];
		if(storage) {
			value = [storage->target retain];
			[storage release];
		}
	}
	pthread_mutex_unlock(&ZWWeakRuntimeMutex);
	
	return value;
}

void ZWWeakRuntimeUnregisterWeak(id *address) {
	ZWWeakRuntimeInit();
	
	pthread_mutex_lock(&ZWWeakRuntimeMutex);
	{
		*address = nil;
	}
	pthread_mutex_unlock(&ZWWeakRuntimeMutex);
}

void ZWWeakRuntimeRegisterWeak(id *address, id value) {
	ZWWeakRuntimeInit();
	
	pthread_mutex_lock(&ZWWeakRuntimeMutex);
	{
		*address = [ZWWeakRuntimeStorage storageForObject:value];
		
	}
	pthread_mutex_unlock(&ZWWeakRuntimeMutex);
}