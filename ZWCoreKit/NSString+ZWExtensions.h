#import <Foundation/Foundation.h>

@interface NSString (ZWExtensions)

+ (NSString *)stringWithData:(NSData *)pData encoding:(NSStringEncoding)pEncoding;
+ (NSString *)stringWithCardinalNumber:(NSInteger)pNumber;

- (CGRect)rectValue;
- (CGSize)sizeValue;
- (CGPoint)pointValue;

- (NSString *)stringByReplacingOccurrencesOfStrings:(NSArray *)pTargets withStrings:(NSArray *)pReplacements;

- (NSString *)relativePathToPath:(NSString *)pToPath;
- (NSString *)absolutePathToPath:(NSString *)pToPath;

- (NSString *)stringByRemovingCharactersInCharacterSet:(NSCharacterSet *)pCharacterSet;

- (NSString *)stringByRemovingHTML;

- (NSString *)stringByRemovingWhitespace;
- (NSString *)stringByTrimmingWhitespace;

- (NSString *)phoneNumber;
- (BOOL)isEmail;

- (NSString *)stringByURLEncoding:(NSStringEncoding)pEncoding;
- (NSString *)stringByURLDecoding:(NSStringEncoding)pEncoding;
 
@end