#import "ZWCollectionIsNotEmptyValueTransformer.h"


@implementation ZWCollectionIsNotEmptyValueTransformer

+ (NSString *)valueTransformerName {
	return @"ZWCollectionIsNotEmpty";
}
+ (Class)transformedValueClass {
	return [NSNumber class];
}
+ (BOOL)allowsReverseTransformation {
	return NO;
}
- (id)transformedValue:(id)pValue {
	if([pValue respondsToSelector:@selector(count)]) {
		return [NSNumber numberWithBool:([pValue count] > 0)];
	}
	return [NSNumber numberWithBool:NO];
}

@end
