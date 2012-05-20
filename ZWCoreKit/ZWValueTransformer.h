#import <Foundation/Foundation.h>
#import "ZWValueTransformer.h"

@interface ZWValueTransformer : NSValueTransformer {

}

+ (NSString *)valueTransformerName;
+ (void)registerValueTransformer;
+ (ZWValueTransformer *)valueTransformer;

@end
