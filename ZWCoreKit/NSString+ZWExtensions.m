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

#pragma mark - HTML Utilities

typedef struct {
	const char *escapeSequence;
	unichar uchar;
} ZWNSStringHTMLEscapeMap;

// Taken from http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
// Ordered by uchar lowest to highest for bsearching
static ZWNSStringHTMLEscapeMap ZWNSStringAsciiHTMLEscapeMap[] = {
	// A.2.2. Special characters
	{ "&quot;", 34 },
	{ "&amp;", 38 },
	{ "&apos;", 39 },
	{ "&lt;", 60 },
	{ "&gt;", 62 },
	
    // A.2.1. Latin-1 characters
	{ "&nbsp;", 160 }, 
	{ "&iexcl;", 161 }, 
	{ "&cent;", 162 }, 
	{ "&pound;", 163 }, 
	{ "&curren;", 164 }, 
	{ "&yen;", 165 }, 
	{ "&brvbar;", 166 }, 
	{ "&sect;", 167 }, 
	{ "&uml;", 168 }, 
	{ "&copy;", 169 }, 
	{ "&ordf;", 170 }, 
	{ "&laquo;", 171 }, 
	{ "&not;", 172 }, 
	{ "&shy;", 173 }, 
	{ "&reg;", 174 }, 
	{ "&macr;", 175 }, 
	{ "&deg;", 176 }, 
	{ "&plusmn;", 177 }, 
	{ "&sup2;", 178 }, 
	{ "&sup3;", 179 }, 
	{ "&acute;", 180 }, 
	{ "&micro;", 181 }, 
	{ "&para;", 182 }, 
	{ "&middot;", 183 }, 
	{ "&cedil;", 184 }, 
	{ "&sup1;", 185 }, 
	{ "&ordm;", 186 }, 
	{ "&raquo;", 187 }, 
	{ "&frac14;", 188 }, 
	{ "&frac12;", 189 }, 
	{ "&frac34;", 190 }, 
	{ "&iquest;", 191 }, 
	{ "&Agrave;", 192 }, 
	{ "&Aacute;", 193 }, 
	{ "&Acirc;", 194 }, 
	{ "&Atilde;", 195 }, 
	{ "&Auml;", 196 }, 
	{ "&Aring;", 197 }, 
	{ "&AElig;", 198 }, 
	{ "&Ccedil;", 199 }, 
	{ "&Egrave;", 200 }, 
	{ "&Eacute;", 201 }, 
	{ "&Ecirc;", 202 }, 
	{ "&Euml;", 203 }, 
	{ "&Igrave;", 204 }, 
	{ "&Iacute;", 205 }, 
	{ "&Icirc;", 206 }, 
	{ "&Iuml;", 207 }, 
	{ "&ETH;", 208 }, 
	{ "&Ntilde;", 209 }, 
	{ "&Ograve;", 210 }, 
	{ "&Oacute;", 211 }, 
	{ "&Ocirc;", 212 }, 
	{ "&Otilde;", 213 }, 
	{ "&Ouml;", 214 }, 
	{ "&times;", 215 }, 
	{ "&Oslash;", 216 }, 
	{ "&Ugrave;", 217 }, 
	{ "&Uacute;", 218 }, 
	{ "&Ucirc;", 219 }, 
	{ "&Uuml;", 220 }, 
	{ "&Yacute;", 221 }, 
	{ "&THORN;", 222 }, 
	{ "&szlig;", 223 }, 
	{ "&agrave;", 224 }, 
	{ "&aacute;", 225 }, 
	{ "&acirc;", 226 }, 
	{ "&atilde;", 227 }, 
	{ "&auml;", 228 }, 
	{ "&aring;", 229 }, 
	{ "&aelig;", 230 }, 
	{ "&ccedil;", 231 }, 
	{ "&egrave;", 232 }, 
	{ "&eacute;", 233 }, 
	{ "&ecirc;", 234 }, 
	{ "&euml;", 235 }, 
	{ "&igrave;", 236 }, 
	{ "&iacute;", 237 }, 
	{ "&icirc;", 238 }, 
	{ "&iuml;", 239 }, 
	{ "&eth;", 240 }, 
	{ "&ntilde;", 241 }, 
	{ "&ograve;", 242 }, 
	{ "&oacute;", 243 }, 
	{ "&ocirc;", 244 }, 
	{ "&otilde;", 245 }, 
	{ "&ouml;", 246 }, 
	{ "&divide;", 247 }, 
	{ "&oslash;", 248 }, 
	{ "&ugrave;", 249 }, 
	{ "&uacute;", 250 }, 
	{ "&ucirc;", 251 }, 
	{ "&uuml;", 252 }, 
	{ "&yacute;", 253 }, 
	{ "&thorn;", 254 }, 
	{ "&yuml;", 255 },
	
	// A.2.2. Special characters cont'd
	{ "&OElig;", 338 },
	{ "&oelig;", 339 },
	{ "&Scaron;", 352 },
	{ "&scaron;", 353 },
	{ "&Yuml;", 376 },
	
	// A.2.3. Symbols
	{ "&fnof;", 402 }, 
	
	// A.2.2. Special characters cont'd
	{ "&circ;", 710 },
	{ "&tilde;", 732 },
	
	// A.2.3. Symbols cont'd
	{ "&Alpha;", 913 }, 
	{ "&Beta;", 914 }, 
	{ "&Gamma;", 915 }, 
	{ "&Delta;", 916 }, 
	{ "&Epsilon;", 917 }, 
	{ "&Zeta;", 918 }, 
	{ "&Eta;", 919 }, 
	{ "&Theta;", 920 }, 
	{ "&Iota;", 921 }, 
	{ "&Kappa;", 922 }, 
	{ "&Lambda;", 923 }, 
	{ "&Mu;", 924 }, 
	{ "&Nu;", 925 }, 
	{ "&Xi;", 926 }, 
	{ "&Omicron;", 927 }, 
	{ "&Pi;", 928 }, 
	{ "&Rho;", 929 }, 
	{ "&Sigma;", 931 }, 
	{ "&Tau;", 932 }, 
	{ "&Upsilon;", 933 }, 
	{ "&Phi;", 934 }, 
	{ "&Chi;", 935 }, 
	{ "&Psi;", 936 }, 
	{ "&Omega;", 937 }, 
	{ "&alpha;", 945 }, 
	{ "&beta;", 946 }, 
	{ "&gamma;", 947 }, 
	{ "&delta;", 948 }, 
	{ "&epsilon;", 949 }, 
	{ "&zeta;", 950 }, 
	{ "&eta;", 951 }, 
	{ "&theta;", 952 }, 
	{ "&iota;", 953 }, 
	{ "&kappa;", 954 }, 
	{ "&lambda;", 955 }, 
	{ "&mu;", 956 }, 
	{ "&nu;", 957 }, 
	{ "&xi;", 958 }, 
	{ "&omicron;", 959 }, 
	{ "&pi;", 960 }, 
	{ "&rho;", 961 }, 
	{ "&sigmaf;", 962 }, 
	{ "&sigma;", 963 }, 
	{ "&tau;", 964 }, 
	{ "&upsilon;", 965 }, 
	{ "&phi;", 966 }, 
	{ "&chi;", 967 }, 
	{ "&psi;", 968 }, 
	{ "&omega;", 969 }, 
	{ "&thetasym;", 977 }, 
	{ "&upsih;", 978 }, 
	{ "&piv;", 982 }, 
	
	// A.2.2. Special characters cont'd
	{ "&ensp;", 8194 },
	{ "&emsp;", 8195 },
	{ "&thinsp;", 8201 },
	{ "&zwnj;", 8204 },
	{ "&zwj;", 8205 },
	{ "&lrm;", 8206 },
	{ "&rlm;", 8207 },
	{ "&ndash;", 8211 },
	{ "&mdash;", 8212 },
	{ "&lsquo;", 8216 },
	{ "&rsquo;", 8217 },
	{ "&sbquo;", 8218 },
	{ "&ldquo;", 8220 },
	{ "&rdquo;", 8221 },
	{ "&bdquo;", 8222 },
	{ "&dagger;", 8224 },
	{ "&Dagger;", 8225 },
    // A.2.3. Symbols cont'd  
	{ "&bull;", 8226 }, 
	{ "&hellip;", 8230 }, 
	
	// A.2.2. Special characters cont'd
	{ "&permil;", 8240 },
	
	// A.2.3. Symbols cont'd  
	{ "&prime;", 8242 }, 
	{ "&Prime;", 8243 }, 
	
	// A.2.2. Special characters cont'd
	{ "&lsaquo;", 8249 },
	{ "&rsaquo;", 8250 },
	
	// A.2.3. Symbols cont'd  
	{ "&oline;", 8254 }, 
	{ "&frasl;", 8260 }, 
	
	// A.2.2. Special characters cont'd
	{ "&euro;", 8364 },
	
	// A.2.3. Symbols cont'd  
	{ "&image;", 8465 },
	{ "&weierp;", 8472 }, 
	{ "&real;", 8476 }, 
	{ "&trade;", 8482 }, 
	{ "&alefsym;", 8501 }, 
	{ "&larr;", 8592 }, 
	{ "&uarr;", 8593 }, 
	{ "&rarr;", 8594 }, 
	{ "&darr;", 8595 }, 
	{ "&harr;", 8596 }, 
	{ "&crarr;", 8629 }, 
	{ "&lArr;", 8656 }, 
	{ "&uArr;", 8657 }, 
	{ "&rArr;", 8658 }, 
	{ "&dArr;", 8659 }, 
	{ "&hArr;", 8660 }, 
	{ "&forall;", 8704 }, 
	{ "&part;", 8706 }, 
	{ "&exist;", 8707 }, 
	{ "&empty;", 8709 }, 
	{ "&nabla;", 8711 }, 
	{ "&isin;", 8712 }, 
	{ "&notin;", 8713 }, 
	{ "&ni;", 8715 }, 
	{ "&prod;", 8719 }, 
	{ "&sum;", 8721 }, 
	{ "&minus;", 8722 }, 
	{ "&lowast;", 8727 }, 
	{ "&radic;", 8730 }, 
	{ "&prop;", 8733 }, 
	{ "&infin;", 8734 }, 
	{ "&ang;", 8736 }, 
	{ "&and;", 8743 }, 
	{ "&or;", 8744 }, 
	{ "&cap;", 8745 }, 
	{ "&cup;", 8746 }, 
	{ "&int;", 8747 }, 
	{ "&there4;", 8756 }, 
	{ "&sim;", 8764 }, 
	{ "&cong;", 8773 }, 
	{ "&asymp;", 8776 }, 
	{ "&ne;", 8800 }, 
	{ "&equiv;", 8801 }, 
	{ "&le;", 8804 }, 
	{ "&ge;", 8805 }, 
	{ "&sub;", 8834 }, 
	{ "&sup;", 8835 }, 
	{ "&nsub;", 8836 }, 
	{ "&sube;", 8838 }, 
	{ "&supe;", 8839 }, 
	{ "&oplus;", 8853 }, 
	{ "&otimes;", 8855 }, 
	{ "&perp;", 8869 }, 
	{ "&sdot;", 8901 }, 
	{ "&lceil;", 8968 }, 
	{ "&rceil;", 8969 }, 
	{ "&lfloor;", 8970 }, 
	{ "&rfloor;", 8971 }, 
	{ "&lang;", 9001 }, 
	{ "&rang;", 9002 }, 
	{ "&loz;", 9674 }, 
	{ "&spades;", 9824 }, 
	{ "&clubs;", 9827 }, 
	{ "&hearts;", 9829 }, 
	{ "&diams;", 9830 }
};

// Taken from http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
// This is table A.2.2 Special Characters
static ZWNSStringHTMLEscapeMap ZWNSStringUnicodeHTMLEscapeMap[] = {
	// C0 Controls and Basic Latin
	{ "&quot;", 34 },
	{ "&amp;", 38 },
	{ "&apos;", 39 },
	{ "&lt;", 60 },
	{ "&gt;", 62 },
	
	// Latin Extended-A
	{ "&OElig;", 338 },
	{ "&oelig;", 339 },
	{ "&Scaron;", 352 },
	{ "&scaron;", 353 },
	{ "&Yuml;", 376 },
	
	// Spacing Modifier Letters
	{ "&circ;", 710 },
	{ "&tilde;", 732 },
    
	// General Punctuation
	{ "&ensp;", 8194 },
	{ "&emsp;", 8195 },
	{ "&thinsp;", 8201 },
	{ "&zwnj;", 8204 },
	{ "&zwj;", 8205 },
	{ "&lrm;", 8206 },
	{ "&rlm;", 8207 },
	{ "&ndash;", 8211 },
	{ "&mdash;", 8212 },
	{ "&lsquo;", 8216 },
	{ "&rsquo;", 8217 },
	{ "&sbquo;", 8218 },
	{ "&ldquo;", 8220 },
	{ "&rdquo;", 8221 },
	{ "&bdquo;", 8222 },
	{ "&dagger;", 8224 },
	{ "&Dagger;", 8225 },
	{ "&permil;", 8240 },
	{ "&lsaquo;", 8249 },
	{ "&rsaquo;", 8250 },
	{ "&euro;", 8364 },
};

- (NSString *)stringByHTMLEntityDecoding {
	if(!self.length) {
		return self;
	}
	
	NSRange range = NSMakeRange(0, self.length);
	NSRange subrange = [self rangeOfString:@"&" options:NSBackwardsSearch range:range];
	
	if(subrange.length == 0) {
		return self;
	}
	
	NSMutableString *decodedString = [self mutableCopy];
	do {
		NSRange semiColonRange = NSMakeRange(subrange.location, NSMaxRange(range) - subrange.location);
		semiColonRange = [self rangeOfString:@";" options:0 range:semiColonRange];
		range = NSMakeRange(0, subrange.location);
		// if we don't find a semicolon in the range, we don't have a sequence
		if (semiColonRange.location == NSNotFound) {
			continue;
		}
		NSRange escapeRange = NSMakeRange(subrange.location, semiColonRange.location - subrange.location + 1);
		NSString *escapeString = [self substringWithRange:escapeRange];
		NSUInteger length = [escapeString length];
		// a squence must be longer than 3 (&lt;) and less than 11 (&thetasym;)
		if(length > 3 && length < 11) {
			if([escapeString characterAtIndex:1] == '#') {
				unichar char2 = [escapeString characterAtIndex:2];
				if(char2 == 'x' || char2 == 'X') {
					// Hex escape squences &#xa3;
					NSString *hexSequence = [escapeString substringWithRange:NSMakeRange(3, length - 4)];
					NSScanner *scanner = [NSScanner scannerWithString:hexSequence];
					unsigned value;
					if([scanner scanHexInt:&value] && value < USHRT_MAX && value > 0 && [scanner scanLocation] == length - 4) {
						unichar uchar = value;
						NSString *charString = [NSString stringWithCharacters:&uchar length:1];
						[decodedString replaceCharactersInRange:escapeRange withString:charString];
					}
				} else {
					// Decimal Sequences &#123;
					NSString *numberSequence = [escapeString substringWithRange:NSMakeRange(2, length - 3)];
					NSScanner *scanner = [NSScanner scannerWithString:numberSequence];
					int value;
					if([scanner scanInt:&value] && value < USHRT_MAX && value > 0 && [scanner scanLocation] == length - 3) {
						unichar uchar = value;
						NSString *charString = [NSString stringWithCharacters:&uchar length:1];
						[decodedString replaceCharactersInRange:escapeRange withString:charString];
					}
				}
			} else {
				// "standard" sequences
				for (unsigned i = 0; i < sizeof(ZWNSStringAsciiHTMLEscapeMap) / sizeof(ZWNSStringHTMLEscapeMap); ++i) {
					if([escapeString isEqualToString:[NSString stringWithUTF8String:ZWNSStringAsciiHTMLEscapeMap[i].escapeSequence]]) {
						[decodedString replaceCharactersInRange:escapeRange withString:[NSString stringWithCharacters:&ZWNSStringAsciiHTMLEscapeMap[i].uchar length:1]];
						break;
					}
				}
			}
		}
	} while ((subrange = [self rangeOfString:@"&" options:NSBackwardsSearch range:range]).length != 0);
	return decodedString;
}

@end
