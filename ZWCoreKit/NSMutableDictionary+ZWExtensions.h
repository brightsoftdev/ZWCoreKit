#import <Foundation/Foundation.h>


@interface NSMutableDictionary (ZWExtensions)

- (void)setInteger:(NSInteger)pValue forKey:(NSString *)pKey;
- (void)setUnsignedInteger:(NSInteger)pValue forKey:(NSString *)pKey;
- (void)setFloat:(float)pValue forKey:(NSString *)pKey;
- (void)setDouble:(double)pValue forKey:(NSString *)pKey;
- (void)setBool:(BOOL)pValue forKey:(NSString *)pKey;

- (void)setRect:(CGRect)pValue forKey:(NSString *)pKey;
- (void)setSize:(CGSize)pValue forKey:(NSString *)pKey;
- (void)setPoint:(CGPoint)pValue forKey:(NSString *)pKey;

@end
