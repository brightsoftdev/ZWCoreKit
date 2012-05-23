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
- (BOOL)isOrBefore:(NSDate *)pOtherDate {
	NSComparisonResult r = [self compare:pOtherDate];
	return (r == NSOrderedSame || r == NSOrderedAscending);
}
- (BOOL)isOrAfter:(NSDate *)pOtherDate {
	NSComparisonResult r = [self compare:pOtherDate];
	return (r == NSOrderedSame || r == NSOrderedDescending);
}

- (BOOL)isToday {
	NSDateComponents *components = [[NSDate gregorianCalendar] components:NSDayCalendarUnit fromDate:self];
	NSDateComponents *todayComponents = [[NSDate gregorianCalendar] components:NSDayCalendarUnit fromDate:[NSDate date]];
	return (components.day == todayComponents.day);
}
- (BOOL)isTomorrow {
	NSDateComponents *components = [[NSDate gregorianCalendar] components:NSDayCalendarUnit fromDate:self];
	NSDateComponents *todayComponents = [[NSDate gregorianCalendar] components:NSDayCalendarUnit fromDate:[NSDate tomorrow]];
	return (components.day == todayComponents.day);
}
- (BOOL)wasYesterday {
	NSDateComponents *components = [[NSDate gregorianCalendar] components:NSDayCalendarUnit fromDate:self];
	NSDateComponents *todayComponents = [[NSDate gregorianCalendar] components:NSDayCalendarUnit fromDate:[NSDate yesterday]];
	return (components.day == todayComponents.day);
}

@end
