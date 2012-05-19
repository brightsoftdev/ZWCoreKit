@interface ZWValueTransformer : NSValueTransformer {

}

+ (NSString *)valueTransformerName;
+ (void)registerValueTransformer;
+ (ZWValueTransformer *)valueTransformer;

@end
