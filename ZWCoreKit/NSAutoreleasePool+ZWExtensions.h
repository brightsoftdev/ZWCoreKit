#if !__has_feature(objc_arc)
@interface NSAutoreleasePool (ZWExtensions)

+ (void)performBlockWithAutoreleasePool:(void (^)(void))pBlock;

@end
#endif
