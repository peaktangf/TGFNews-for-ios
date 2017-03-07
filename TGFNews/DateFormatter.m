

#import "DateFormatter.h"
static NSDateFormatter *_instance = nil;
@implementation DateFormatter

+ (NSDateFormatter *)currentFormatter{
    @synchronized(self){
        if (_instance == nil)
        {
            _instance = [[NSDateFormatter alloc] init];
        }
    }
	return _instance;
}

// ================================================================================================
//  dateToStringCustom
// ================================================================================================
+ (NSString *) dateToStringCustom:(NSDate *)date formatString:(NSString *)formatString {
	NSDateFormatter *dateFormatter = [DateFormatter currentFormatter];
	[NSTimeZone resetSystemTimeZone];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	[dateFormatter setDateFormat:formatString];
	return [dateFormatter stringFromDate:date];
}
// ================================================================================================
//  stringToDateCustom
// ================================================================================================
+ (NSDate *) stringToDateCustom:(NSString *)dateString formatString:(NSString *)formatString {
	NSDateFormatter *dateFormatter = [DateFormatter currentFormatter];
	[NSTimeZone resetSystemTimeZone];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	[dateFormatter setDateFormat:formatString];
	return [dateFormatter dateFromString:dateString];
}

@end
