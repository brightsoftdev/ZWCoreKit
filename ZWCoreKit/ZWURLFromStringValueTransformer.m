#import "ZWURLFromStringValueTransformer.h"

@implementation ZWURLFromStringValueTransformer

+ (void)load {
	@autoreleasepool {
		[self registerValueTransformer];
	}
}
+ (NSString *)valueTransformerName {
	return @"ZWURLFromString";
}
+ (Class)transformedValueClass {
	return [NSURL class];
}
+ (BOOL)allowsReverseTransformation {
	return YES;
}
- (id)transformedValue:(id)pValue {
	if([pValue isKindOfClass:[NSString class]]) {
		return [NSURL URLWithString:pValue];
	}
	return nil;
}
- (id)reverseTransformedValue:(id)pValue {
	if([pValue isKindOfClass:[NSURL class]]) {
		return [(NSURL *)pValue absoluteString];
	}
	return nil;
}

@end
