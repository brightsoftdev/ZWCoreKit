@interface NSDate (ZWExtensions)

+ (NSCalendar *)gregorianCalendar;
+ (NSDate *)today;
+ (NSDate *)tomorrow;
+ (NSDate *)yesterday;
- (BOOL)isBefore:(NSDate *)pOtherDate;
- (BOOL)isAfter:(NSDate *)pOtherDate;
- (BOOL)isOrBefore:(NSDate *)pOtherDate;
- (BOOL)isOrAfter:(NSDate *)pOtherDate;

- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)wasYesterday;

@end
