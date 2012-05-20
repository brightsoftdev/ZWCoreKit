#import <Foundation/Foundation.h>

@interface NSData (ZWB64Extensions)

- (NSData *)base64EncodedData;
- (NSString *)base64Encoded;

- (NSData *)base64DecodedData;
- (NSString *)base64Decoded;

@end

@interface NSString (ZWB64Extensions)

- (NSData *)base64EncodedData;
- (NSString *)base64Encoded;

- (NSData *)base64DecodedData;
- (NSString *)base64Decoded;

@end