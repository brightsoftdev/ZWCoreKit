#import <Foundation/Foundation.h>
#import "ZWWeakRuntimeClang.h"
#import "ZWWeakRuntimeProxy.h"

/**
 * ZWWeakRuntime
 *
 * Shared weak runtime storage. These methods handle registering weak pointers to their values and ensuring they get zeroed out.
 *
 */

id ZWWeakRuntimeLoadWeakRetained(id *address) NS_RETURNS_RETAINED; /* loads a stored weak reference strongly and returns it retained */
void ZWWeakRuntimeUnregisterWeak(id *address); /* this unregisters a weak reference */
void ZWWeakRuntimeRegisterWeak(id *address, id value); /* this registers a weak reference */