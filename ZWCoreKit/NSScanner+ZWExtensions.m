#import "NSScanner+ZWExtensions.h"

@implementation NSScanner (ZWExtensions)

- (BOOL)scanRegularExpression:(NSRegularExpression *)pRegularExpression intoString:(__autoreleasing NSString **)pString {
	NSUInteger scanLocation = self.scanLocation;
	
	NSString *scanString = [self.string substringFromIndex:scanLocation];
	NSRange resultRange = [pRegularExpression rangeOfFirstMatchInString:scanString options:NSMatchingAnchored range:NSMakeRange(0, scanString.length)];
	if(resultRange.location != NSNotFound) {
		*pString = [scanString substringWithRange:resultRange];
		self.scanLocation += resultRange.length;
		return YES;
	}
	self.scanLocation = scanLocation;
	return NO;
}
- (BOOL)scanRegularExpression:(NSRegularExpression *)pRegularExpression intoString:(__autoreleasing NSString **)pString result:(__autoreleasing NSTextCheckingResult **)pResult {
	NSUInteger scanLocation = self.scanLocation;
	
	NSString *scanString = [self.string substringFromIndex:scanLocation];
	NSTextCheckingResult *result = [pRegularExpression firstMatchInString:scanString options:NSMatchingAnchored range:NSMakeRange(0, scanString.length)];
	if(result != nil) {
		*pString = [scanString substringWithRange:[result rangeAtIndex:0]];
		*pResult = result;
		self.scanLocation += result.range.length;
		return YES;
	}
	
	self.scanLocation = scanLocation;
	return NO;
}
- (BOOL)scanTokenWithBoundaries:(NSString *)pBoundaries intoString:(__autoreleasing NSString **)pResult {
	return [self scanTokenWithStartBoundary:pBoundaries endBoundary:pBoundaries intoString:pResult];
}
- (BOOL)scanTokenWithStartBoundary:(NSString *)pStartBoundary endBoundary:(NSString *)pEndBoundary intoString:(__autoreleasing NSString **)pResult {
	NSUInteger scanLocation = self.scanLocation;
	if([self scanString:pStartBoundary intoString:nil] &&
	   [self scanUpToString:pEndBoundary intoString:pResult] &&
	   [self scanString:pEndBoundary intoString:nil]) {
		return YES;
	}
	self.scanLocation = scanLocation;
	return NO;
}


@end
