#import "ZWStringFromNumberValueTransformer.h"

@implementation ZWStringFromNumberValueTransformer

+ (NSString *)valueTransformerName {
	return @"ZWStringFromNumber";
}
+ (Class)transformedValueClass {
	return [NSString class];
}
+ (BOOL)allowsReverseTransformation {
	return NO;
}
- (id)transformedValue:(id)pValue {
	if([pValue isKindOfClass:[NSNumber class]]) {
		return [NSString stringWithFormat:@"%@", pValue];
	}
	return nil;
}

@end
