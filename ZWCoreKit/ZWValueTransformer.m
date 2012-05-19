#import "ZWValueTransformer.h"


@implementation ZWValueTransformer

+ (void)load {
	@autoreleasepool {
		[self registerValueTransformer];
	}
}
+ (NSString *)valueTransformerName {
	return NSStringFromClass([self class]);
}
+ (void)registerValueTransformer {
	[NSValueTransformer setValueTransformer:[[self alloc] init] forName:[self valueTransformerName]];
}
+ (BOOL)allowsReverseTransformation {
	return NO;
}
+ (ZWValueTransformer *)valueTransformer {
	id valueTransformer = [self valueTransformerForName:[self valueTransformerName]];
	if(valueTransformer == nil || ![valueTransformer isKindOfClass:[self class]]) {
		valueTransformer = [[self alloc] init];
	}
	return (ZWValueTransformer *)valueTransformer;
}

@end
