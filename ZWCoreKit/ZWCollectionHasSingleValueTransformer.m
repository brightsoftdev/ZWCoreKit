#import "ZWCollectionHasSingleValueTransformer.h"


@implementation ZWCollectionHasSingleValueTransformer

+ (NSString *)valueTransformerName {
	return @"ZWCollectionHasSingle";
}
+ (Class)transformedValueClass {
	return [NSNumber class];
}
+ (BOOL)allowsReverseTransformation {
	return NO;
}
- (id)transformedValue:(id)pValue {
	if([pValue respondsToSelector:@selector(count)]) {
		return [NSNumber numberWithBool:([pValue count] == 1)];
	}
	return [NSNumber numberWithBool:NO];
}

@end
