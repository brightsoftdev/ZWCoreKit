#import "ZWCollectionIsEmptyValueTransformer.h"


@implementation ZWCollectionIsEmptyValueTransformer

+ (void)load {
	@autoreleasepool {
		[self registerValueTransformer];
	}
}
+ (NSString *)valueTransformerName {
	return @"ZWCollectionIsEmpty";
}
+ (Class)transformedValueClass {
	return [NSNumber class];
}
+ (BOOL)allowsReverseTransformation {
	return NO;
}
- (id)transformedValue:(id)pValue {
	if([pValue respondsToSelector:@selector(count)]) {
		return [NSNumber numberWithBool:([pValue count] == 0)];
	}
	return [NSNumber numberWithBool:YES];
}

@end
