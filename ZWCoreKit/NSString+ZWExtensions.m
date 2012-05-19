#import "NSString+ZWExtensions.h"
#import "NSData+ZWExtensions.h"

@implementation NSString (ZWExtensions)

+ (NSString *)stringWithData:(NSData *)pData encoding:(NSStringEncoding)pEncoding {
	return [[NSString alloc] initWithData:pData encoding:pEncoding];
}
+ (NSString *)stringWithCardinalNumber:(NSInteger)pNumber {
    NSString *stringNumber = [NSString stringWithFormat:@"%ld", (long)pNumber];
	
    if( [stringNumber hasSuffix:@"11"] || [stringNumber hasSuffix:@"12"] || [stringNumber hasSuffix:@"13"] ) {
        return [NSString stringWithFormat:@"%ldth", (long)pNumber];
    } else if( [stringNumber hasSuffix:@"1"] ) {
        return [NSString stringWithFormat:@"%ldst", (long)pNumber];
    } else if( [stringNumber hasSuffix:@"2"] ) {
        return [NSString stringWithFormat:@"%ldnd", (long)pNumber];
    } else if( [stringNumber hasSuffix:@"3"] ) {
        return [NSString stringWithFormat:@"%ldrd", (long)pNumber];
    }
    return [NSString stringWithFormat:@"%ldth", (long)pNumber];
}

- (CGRect)rectValue {
	return CGRectFromString(self);
}
- (CGSize)sizeValue {
	return CGSizeFromString(self);
}
- (CGPoint)pointValue {
	return CGPointFromString(self);
}

- (NSString *)stringByReplacingOccurrencesOfStrings:(NSArray *)pTargets withStrings:(NSArray *)pReplacements {
	NSString *output = [self copy];
	for(NSInteger i = 0; i < [pTargets count]; ++i) {
		NSString *target = [pTargets objectAtIndex:i];
		NSString *replacement = [pReplacements objectAtIndex:i];
		output = [output stringByReplacingOccurrencesOfString:target
												   withString:replacement];
	}
	return output;
}

- (NSString *)relativePathToPath:(NSString *)pToPath {
	// set paths
	NSString *path = self;
	NSString *toPath = pToPath;
	
	// check if paths are not absolute
	if(![path isAbsolutePath]) {
		NSAssert(NO, @"Path is not an absolute path: %@", path);
		return nil;
	} else if(![toPath isAbsolutePath]) {
		NSAssert(NO, @"Directory path is not an absolute path: %@", toPath);
	}
	
	// get components
	NSMutableArray *pathComponents = [[[path stringByStandardizingPath] pathComponents] mutableCopy];
	NSMutableArray *toPathComponents = [[[toPath stringByStandardizingPath] pathComponents] mutableCopy];
	
	// get strip count
	NSInteger stripCount = 0;
	NSInteger length = MIN([pathComponents count], [toPathComponents count]);
	for(NSInteger i = 0; i < length; ++i) {
		NSString *pathComponent = [pathComponents objectAtIndex:i];
		NSString *toPathComponent = [toPathComponents objectAtIndex:i];
		
		if([pathComponent isEqualToString:toPathComponent]) {
			stripCount++;
		}
	}
	
	// strip components
	[pathComponents removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, stripCount)]];
	[toPathComponents removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, stripCount)]];
	
	// combine components
	NSMutableArray *finalPathComponents = [NSMutableArray array];
	[finalPathComponents addObjectsFromArray:toPathComponents];
	for(NSInteger i = 0; i < [pathComponents count]; ++i) {
		[finalPathComponents insertObject:@".." atIndex:0];
	}
	
	// final path
	NSString *finalPath = [NSString pathWithComponents:finalPathComponents];
	if([finalPath isAbsolutePath]) {
		NSAssert(NO, @"Final path is an absolute path: %@", finalPath);
		return nil;
	}
	return finalPath;
}
- (NSString *)absolutePathToPath:(NSString *)pToPath {
	// set paths
	NSString *path = self;
	NSString *toPath = pToPath;
	
	// check if filePath is relative
	if([path isAbsolutePath]) {
		NSAssert(NO, @"Path is not a relative path: %@", path);
		return nil;
	}
	// check if toPath is absolute
	else if(![toPath isAbsolutePath]) {
		NSAssert(NO, @"Directory path is not an absolute path: %@", toPath);
	}
	
	// get components
	NSMutableArray *pathComponents = [[path pathComponents] mutableCopy];
	NSMutableArray *toPathComponents = [[[toPath stringByStandardizingPath] pathComponents] mutableCopy];
	
	// strip components
	while([pathComponents count] > 0) {
		NSString *pathComponent = [pathComponents objectAtIndex:0];
		
		if([pathComponent isEqualToString:@".."]) {
			[pathComponents removeObjectAtIndex:0];
			[toPathComponents removeLastObject];
		} else if([pathComponent isEqualToString:@"."]) {
			[pathComponents removeObjectAtIndex:0];
		} else {
			break;
		}
	}
	
	// combine components
	NSMutableArray *finalPathComponents = [NSMutableArray array];
	[finalPathComponents addObjectsFromArray:toPathComponents];
	[finalPathComponents addObjectsFromArray:pathComponents];
	
	NSString *finalPath = [NSString pathWithComponents:finalPathComponents];
	if(![finalPath isAbsolutePath]) {
		NSAssert(NO, @"Final path is not an absolute path: %@", finalPath);
		return nil;
	}
	return finalPath;
}

- (NSString *)stringByRemovingCharactersInCharacterSet:(NSCharacterSet *)pCharacterSet {
	NSMutableString *s = [NSMutableString stringWithString:self];
	NSInteger i = 0;
	for(i = 0; i < [s length]; ++i) {
		unichar c = [s characterAtIndex:i];
		if([pCharacterSet characterIsMember:c]) {
			[s deleteCharactersInRange:NSMakeRange(i, 1)];
			i--;
		}
	}
	return s;
}
- (NSString *)stringByRemovingHTML {
	NSRange r;
	NSString *s = [self copy];
	while((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
		s = [s stringByReplacingCharactersInRange:r withString:@""];
	}
    
	s = [s stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	s = [s stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	s = [s stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	s = [s stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
	s = [s stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
	return s;
}

- (NSString *)stringByRemovingWhitespace {
	return [self stringByRemovingCharactersInCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSString *)stringByTrimmingWhitespace {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
}

- (NSString *)phoneNumber {
	NSTextCheckingResult *r = [NSTextCheckingResult phoneNumberCheckingResultWithRange:NSMakeRange(0, [self length]) phoneNumber:self];
	if(r.resultType == NSTextCheckingTypePhoneNumber) {
		return [r phoneNumber];
	}
	return nil;
}
- (BOOL)isEmail {
	static NSPredicate *_emailPredicate = nil;
	if(_emailPredicate == nil) {
		NSString *emailRegEx =
		@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
		@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
		@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
		@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
		@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
		@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
		@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
		_emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	}
	return [_emailPredicate evaluateWithObject:[self lowercaseString]];
}

const static char *URLReservedChars = "!*'();:@&=+$,/?#[]";
- (NSString *)stringByURLEncoding:(NSStringEncoding)pEncoding {
	NSString *s = [self stringByAddingPercentEscapesUsingEncoding:pEncoding];
	NSInteger len = strlen(URLReservedChars);
	for(NSInteger i = 0; i < len; ++i) {
		char c = URLReservedChars[i];
		s = [s stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", c]
										 withString:[NSString stringWithFormat:@"%%%2x", c]];
	}
	return s;
}
- (NSString *)stringByURLDecoding:(NSStringEncoding)pEncoding {
	NSString *s = [self stringByReplacingPercentEscapesUsingEncoding:pEncoding];
	s = [s stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	NSInteger len = strlen(URLReservedChars);
	for(NSInteger i = 0; i < len; ++i) {
		char c = URLReservedChars[i];
		s = [s stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%%%2x", c]
										 withString:[NSString stringWithFormat:@"%c", c]
											options:NSCaseInsensitiveSearch
											  range:NSMakeRange(0, [s length])];
	}
	return s;
}

@end
