#import "ZWWeakRuntimeProxy.h"
#import "ZWWeakRuntime.h"
#import <objc/runtime.h>

#if ZW_WEAK_RUNTIME_PROXY

#if __has_feature(objc_arc)
#error ZWWeakRuntimeProxy.m must be compiled with the -fno-objc-arc flag
#endif

@interface ZWWeakRuntimeProxy : NSProxy {
	Class weakTargetClass;
	id weakTarget;
}

+ (ZWWeakRuntimeProxy *)proxyWithTarget:(id)pTarget;
- (void)getStrongTarget:(id *)pLocation;

@end
@implementation ZWWeakRuntimeProxy

#pragma mark - Initialization

+ (ZWWeakRuntimeProxy *)proxyWithTarget:(id)pTarget {
	if(pTarget) {
		return [[ZWWeakRuntimeProxy alloc] initWithTarget:pTarget];
	}
	return nil;
}
- (id)initWithTarget:(id)pTarget {
	pTarget = [pTarget retain];
	weakTargetClass = [pTarget class];
	ZWWeakRuntimeRegisterWeak(&weakTarget, pTarget);
	[pTarget release];
	return self;
}

- (void)getStrongTarget:(id *)pLocation {
	if(pLocation) {
		*pLocation = ZWWeakRuntimeLoadWeakRetained(&weakTarget);
	}
}

#pragma mark - NSProxy

- (Class)class {
	return weakTargetClass;
}
- (NSString *)description {
	id strongTarget = nil;
	[self getStrongTarget:&strongTarget];
	[strongTarget autorelease];
	
	if(strongTarget) {
		return [strongTarget description];
	}
	return @"(null)";
}
- (NSString *)debugDescription {
	id strongTarget = nil;
	[self getStrongTarget:&strongTarget];
	[strongTarget autorelease];
	
	if(strongTarget) {
		return [strongTarget debugDescription];
	}
	return @"(null)";
}
- (void)forwardInvocation:(NSInvocation *)pInvocation {
	id strongTarget = nil;
	[self getStrongTarget:&strongTarget];
	[pInvocation invokeWithTarget:strongTarget];
	[strongTarget release];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)pSelector {
	return [NSMethodSignature instanceMethodSignatureForSelector:pSelector];
}

#pragma mark - Dealloc

- (void)dealloc {
    ZWWeakRuntimeUnregisterWeak(&weakTarget);
	weakTarget = nil;
    [super dealloc];
}

@end

id ZWWeakRef(id object) {
	if(object_getClass(object) == [ZWWeakRuntimeProxy class]) {
		return [object retain];
	}
	return [ZWWeakRuntimeProxy proxyWithTarget:object];
}
id ZWStrongRef(id object) {
	if(object_getClass(object) == [ZWWeakRuntimeProxy class]) {
		id strongTarget = nil;
		[object getStrongTarget:&strongTarget];
		return strongTarget;
	}
	return [object retain];
}

#endif