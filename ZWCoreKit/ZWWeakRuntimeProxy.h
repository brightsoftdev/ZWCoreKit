#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 * Proxy Runtime
 *
 * This extension allows ZWWeakRef and ZWStrongRef.
 * It uses an NSProxy standin that completely "spoofs" the weak referenced object.
 *
 * NOTE:
 *
 * You must use ZWStrongRef to re-establish a strong reference to an object that was referenced from ZWWeakRef.
 */


#ifndef ZW_WEAK_RUNTIME_PROXY
#define ZW_WEAK_RUNTIME_PROXY 1
#endif 

#if ZW_WEAK_RUNTIME_PROXY

id ZWWeakRef(id object) NS_RETURNS_RETAINED;
id ZWStrongRef(id object) NS_RETURNS_RETAINED;

#endif