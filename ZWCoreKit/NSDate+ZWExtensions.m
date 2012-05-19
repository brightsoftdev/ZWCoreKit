#import "NSDate+ZWExtensions.h"

@implementation NSDate (ZWExtensions)

+ (NSCalendar *)gregorianCalendar {
	static NSCalendar *_gregorianCalendar = nil;
	if(_gregorianCalendar == nil) {
		_gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	}
	return _gregorianCalendar;
}
+ (NSDate *)today {
	NSDate *now = [NSDate date];
	NSDateComponents *components = [[self gregorianCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
	components.hour = components.minute = components.second = 0;
	return [[self gregorianCalendar] dateFromComponents:components];
}
+ (NSDate *)tomorrow {
	NSDate *now = [NSDate date];
	NSDateComponents *components = [[self gregorianCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
	components.hour = components.minute = components.second = 0;
	components.day += 1;
	return [[self gregorianCalendar] dateFromComponents:components];
}
+ (NSDate *)yesterday {
	NSDate *now = [NSDate date];
	NSDateComponents *components = [[self gregorianCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
	components.hour = components.minute = components.second = 0;
	components.day -= 1;
	return [[self gregorianCalendar] dateFromComponents:components];
}
- (BOOL)isBefore:(NSDate *)pOtherDate {
	return ([self compare:pOtherDate] == NSOrderedAscending);
}
- (BOOL)isAfter:(NSDate *)pOtherDate {
	return ([self compare:pOtherDate] == NSOrderedDescending);
	
}

@end
