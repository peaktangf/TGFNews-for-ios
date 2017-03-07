




#import <Foundation/Foundation.h>

static NSString *kNSDateHelperFormatFullDateWithTime    = @"MMM d, yyyy h:mm a";
static NSString *kNSDateHelperFormatFullDate            = @"MMM d, yyyy";
static NSString *kNSDateHelperFormatShortDateWithTime   = @"MMM d h:mm a";
static NSString *kNSDateHelperFormatShortDate           = @"MMM d";
static NSString *kNSDateHelperFormatWeekday             = @"EEEE";
static NSString *kNSDateHelperFormatWeekdayWithTime     = @"EEEE h:mm a";
static NSString *kNSDateHelperFormatTime                = @"h:mm a";
static NSString *kNSDateHelperFormatTimeWithPrefix      = @"'at' h:mm a";
static NSString *kNSDateHelperFormatSQLDate             = @"yyyy-MM-dd";
static NSString *kNSDateHelperFormatSQLTime             = @"HH:mm:ss";
static NSString *kNSDateHelperFormatSQLDateWithTime     = @"yyyy-MM-dd HH:mm";
static NSString *kNSDateHelperFormatSQLDateWithTimes     = @"yyyy-MM-dd HH:mm:ss";
static NSString *kNSDateHelperFormatDateNoYear          = @"MM-dd";

@interface DateFormatter : NSObject

+ (NSString *)dateToStringCustom:(NSDate *)date formatString:(NSString *)formatString;

+ (NSDate *)stringToDateCustom:(NSString *)dateString formatString:(NSString *)formatString;

@end
