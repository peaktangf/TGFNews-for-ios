//
//  NSString+CutWeather.m
//  百捷新闻
//
//  Created by 谭高丰 on 15/10/27.
//  Copyright (c) 2015年 谭高丰. All rights reserved.
//

#import "NSString+CutWeather.h"

@implementation NSString (CutWeather)
+ (NSString *)cutOutWeather:(NSString *)weather
{
    NSRange range = NSMakeRange(2, weather.length - 3);
    NSString *str = [weather substringWithRange:range];
    return str;
}
+ (NSString *)cutOutDate:(NSString *)date
{
    NSString *str = [date substringFromIndex:date.length - 3];
    return str;
}
+ (NSString *)HaiziConvertPinyin:(NSString *)hanzi
{
    NSMutableString *pinyin = [[NSMutableString alloc] initWithString:hanzi];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, 0, kCFStringTransformStripDiacritics, NO);
    NSString *pinyinStr = pinyin;
    pinyinStr = [pinyinStr stringByReplacingOccurrencesOfString:@" "  withString:@""];
    return pinyinStr;
}

+ (NSString *)fontSizeTofontMark:(NSString *)mark {
    
    NSString *fontSize = nil;
    if ([mark isEqualToString:@"小"]) {
        fontSize = @"17";
    }
    else if ([mark isEqualToString:@"中"]) {
        fontSize = @"19";
    }
    else if ([mark isEqualToString:@"大"]) {
        fontSize = @"21";
    }
    else if ([mark isEqualToString:@"超大"]) {
        fontSize = @"23";
    }
    else if ([mark isEqualToString:@"巨大"]) {
        fontSize = @"25";
    }
    else {
        fontSize = @"27";
    }
    return fontSize;
}
@end
