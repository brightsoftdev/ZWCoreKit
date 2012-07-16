#import "ZWValueTransformer.h"


@implementation ZWValueTransformer

+ (BOOL)allowsReverseTransformation {
	return NO;
}
+ (ZWValueTransformer *)valueTransformer {
	id valueTransformer = [self valueTransformerForName:NSStringFromClass([self class])];
	if(valueTransformer == nil || ![valueTransformer isKindOfClass:[self class]]) {
		valueTransformer = [[self alloc] init];
	}
	return (ZWValueTransformer *)valueTransformer;
}

@end
