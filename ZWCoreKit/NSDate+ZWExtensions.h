@interface NSDate (ZWExtensions)

+ (NSCalendar *)gregorianCalendar;
+ (NSDate *)today;
+ (NSDate *)tomorrow;
+ (NSDate *)yesterday;
- (BOOL)isBefore:(NSDate *)pOtherDate;
- (BOOL)isAfter:(NSDate *)pOtherDate;

@end
