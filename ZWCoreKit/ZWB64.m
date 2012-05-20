#import "ZWB64.h"
#import "NSString+ZWExtensions.h"

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const char decodingTable[] = {
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 62, 65, 65, 65, 63, 
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 65, 65, 65, 65, 65, 65, 
	65,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 65, 65, 65, 65, 65, 
	65, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65, 65,
};

@implementation NSData (ZWB64Extensions)

- (NSData *)base64EncodedData {
	return [[self base64Encoded] dataUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)base64Encoded {
	if([self length] == 0) {
		return @"";
	}
	char *characters = malloc((([self length] + 2) / 3) * 4);
	if(characters == nil) {
		return nil;
	}
	
	NSUInteger length = 0;
	NSUInteger i = 0;
	while(i < [self length]) {
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while(bufferLength < 3 && i < [self length]) {
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		}
		
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		
		if(bufferLength > 1) {
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		} else {
			characters[length++] = '=';
		}
		
		if(bufferLength > 2) {
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		} else {
			characters[length++] = '=';
		}
	}
	
	return [[NSString alloc] initWithBytesNoCopy:characters
										   length:length
										 encoding:NSASCIIStringEncoding
									 freeWhenDone:YES];
}

- (NSData *)base64DecodedData {
	NSString *string = [NSString stringWithData:self encoding:NSUTF8StringEncoding];
	if(string == nil) {
		return nil;
	}
	if([string length] == 0) {
		return [NSData data];
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if(characters == nil) {
		return nil;
	}
	
	char *bytes = malloc((([string length] + 3) / 4) * 3);
	if(bytes == nil) {
		return nil;
	}
	
	NSUInteger length = 0;
	NSUInteger i = 0;
	while(YES) {
		char buffer[4];
		short bufferLength;
		for(bufferLength = 0; bufferLength < 4; ++i) {
			if(characters[i] == '\0') {
				break;
			}
			if(isspace(characters[i]) || characters[i] == '=') {
				continue;
			}
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if(buffer[bufferLength++] == CHAR_MAX) {
				free(bytes);
				return nil;
			}
		}
		
		if(bufferLength == 0) {
			break;
		}
		if(bufferLength == 1) {
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if(bufferLength > 2) {
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		}
		if(bufferLength > 3) {
			bytes[length++] = (buffer[2] << 6) | buffer[3];
		}
	}
	realloc(bytes, length);
	
	return [NSData dataWithBytesNoCopy:bytes length:length];
}
- (NSString *)base64Decoded {
	return [NSString stringWithData:[self base64DecodedData] encoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (ZWB64Extensions)

- (NSData *)base64EncodedData {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] base64EncodedData];
}
- (NSString *)base64Encoded {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] base64Encoded];
}

- (NSData *)base64DecodedData {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] base64DecodedData];
}
- (NSString *)base64Decoded {
	return [[self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO] base64Decoded];
}

@end