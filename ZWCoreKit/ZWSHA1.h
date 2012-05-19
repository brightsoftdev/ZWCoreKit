@interface NSData (ZWSHA1Extensions)

- (NSData *)sha1Data;
- (NSString *)sha1;

@end

@interface NSString (ZWSHA1Extensions)

- (NSData *)sha1Data;
- (NSString *)sha1;

@end
