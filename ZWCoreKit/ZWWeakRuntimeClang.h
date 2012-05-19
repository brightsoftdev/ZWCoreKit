#import <Foundation/Foundation.h>

/**
 * Clang Runtime
 *
 * This extension allows __weak to be used assuming that a Other C Flags "-Xclang -fobjc-runtime-has-weak" is added.
 * It simply implements missing functions that ARC uses to create the weak system. It's implementation is much slower than ARC's but still usable.
 *
 * NOTE:
 *
 * this may get you a reject notice from the app store, these runtime functions are not "public" though are part of the opensource objc headers.
 * Unfortunately there is no other way to get using __weak support otherwise.
 */

#ifndef ZWWeakRuntimeClang
#define ZWWeakRuntimeClang 0
#endif 

#if ZWWeakRuntimeClang

id objc_retain(id object); /* ARC implements */
void objc_release(id object); /* ARC implements */
id objc_autorelease(id object); /* ARC implements */

id objc_initWeak(id *address, id value); /* we implement */
void objc_copyWeak(id *to, id *from); /* we implement */
void objc_moveWeak(id *to, id *from); /* we implement */
void objc_destroyWeak(id *address); /* we implement */

id objc_loadWeakRetained(id *address); /* we implement */
id objc_loadWeak(id *address); /* we implement */
id objc_storeWeak(id *address, id value); /* we implement */

#endif