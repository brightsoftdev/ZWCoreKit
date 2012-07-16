#import "ZWCollectionHasMultipleValueTransformer.h"


@implementation ZWCollectionHasMultipleValueTransformer

+ (NSString *)valueTransformerName {
	return @"ZWCollectionHasMultiple";
}
+ (Class)transformedValueClass {
	return [NSNumber class];
}
+ (BOOL)allowsReverseTransformation {
	return NO;
}
- (id)transformedValue:(id)pValue {
	if([pValue respondsToSelector:@selector(count)]) {
		return [NSNumber numberWithBool:([pValue count] > 1)];
	}
	return [NSNumber numberWithBool:NO];
}

@end
