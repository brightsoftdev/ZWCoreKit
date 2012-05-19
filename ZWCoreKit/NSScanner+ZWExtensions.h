#import <Foundation/Foundation.h>

@interface NSScanner (ZWExtensions)

- (BOOL)scanRegularExpression:(NSRegularExpression *)pRegularExpression intoString:(__autoreleasing NSString **)pString;
- (BOOL)scanRegularExpression:(NSRegularExpression *)pRegularExpression intoString:(__autoreleasing NSString **)pString result:(__autoreleasing NSTextCheckingResult **)pResult;
- (BOOL)scanTokenWithBoundaries:(NSString *)pBoundary intoString:(__autoreleasing NSString **)pResult;
- (BOOL)scanTokenWithStartBoundary:(NSString *)pStartBoundary endBoundary:(NSString *)pEndBoundary intoString:(__autoreleasing NSString **)pResult;

@end
