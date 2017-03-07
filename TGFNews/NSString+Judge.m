//
//  NSString+Judge.m
//  TGFNews
//
//  Created by 谭高丰 on 16/3/15.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "NSString+Judge.h"
#import <RegexKitLite.h>

@implementation NSString (Judge)
+ (BOOL)isNotBlank:(NSString*)source
{
    if(source == nil || [source isEqual:[NSNull null]] || source.length == 0 || [source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return NO;
    }
    return YES;
}
+ (BOOL)isBlank:(NSString*)source
{
    if(source == nil || [source isEqual:[NSNull null]] || source.length == 0 || [source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    }
    return NO;
}
//非0正整数验证.
+(BOOL) isNumNotZero:(NSString*)source
{
    if ([NSString isBlank:source]) {
        return NO;
    }
    NSString* format=@"^[1-9]\\d*$";
    return [source isMatchedByRegex:format];
}
//正整数验证(带0).
+(BOOL) isPositiveNum:(NSString*)source
{
    if ([NSString isBlank:source]) {
        return NO;
    }
    NSString* format=@"^[1-9]\\d*|0$";
    return [source isMatchedByRegex:format];
}
//整数验证.
+(BOOL) isInt:(NSString*)source
{
    if ([NSString isBlank:source]) {
        return NO;
    }
    NSString* format=@"^-?[1-9]\\d*$";
    return [source isMatchedByRegex:format];
}
//小数正验证.
+(BOOL) isFloat:(NSString*)source
{
    if ([NSString isBlank:source]) {
        return NO;
    }
    if ([NSString isPositiveNum:source]) {
        return YES;
    }
    NSString* format=@"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
    return [source isMatchedByRegex:format];
}
// 是否是纯数字
+ (BOOL)isValidNumber:(NSString*)value
{
    NSString* num = @"^[0-9]+$";
    NSPredicate *regextestnum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    return [regextestnum evaluateWithObject:value];;
}
//包换不是数字英文字母验证.
+(BOOL) isNotNumAndLetter:(NSString*)source
{
    if ([NSString isBlank:source]) {
        return YES;
    }
    NSString* format=@"[^a-zA-Z0-9]+";
    return [source isMatchedByRegex:format];
}
//日期验证.
+(BOOL) isDate:(NSString*)source
{
    if ([NSString isBlank:source]) {
        return NO;
    }
    NSString* format=@"^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2} CST$";
    return [source isMatchedByRegex:format];
}
//URL路径过滤掉随机数.
+(NSString*) urlFilterRan:(NSString*)urlPath
{
    NSString *regex = @"(.*)([\\?|&]ran=[^&]+)";
    return [urlPath stringByReplacingOccurrencesOfRegex:regex withString:@"$1"];
}
+(NSString *)getUniqueStrByUUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    retStr=[retStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [retStr lowercaseString];
}
//验证Email是否正确.
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//传真验证
+ (BOOL)isValidateFax:(NSString *)fax
{
    NSString *faxRegex = @"^(([0-9]{3})|([0-9]{4}))[-]\\d{6,8}$";
    NSPredicate *faxTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", faxRegex];
    return [faxTest evaluateWithObject:fax];
}
//判断手机号
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：139 138 137 136 135 134 147 150 151 152 157 158 159 178 182 183 184 187 188
     * 联通：130 131 132 155 156 185 186 145 176
     * 电信：133 153 177 180 181 189
     * 卫星通信: 1349
     * 虚拟运营商: 170
     */
    NSString * MOBILE = @"(^13\\d{9})$|((^14)[5,7]\\d{8}$)|(^15[0,1,2,3,5,6,7,8,9]\\d{8}$)|((^17)[0,6,7,8]\\d{8}$)|(^18\\d{9}$)";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//判断手机号及其后四位
+ (BOOL)isValidatePhone:(NSString *)phoneNumber {
    if ([NSString isPositiveNum:phoneNumber]) {
        if (phoneNumber.length == 11) {
            if ([self validateMobile:phoneNumber]) {
                return YES;
            } else {
                return NO; }
        } else if (phoneNumber.length == 4) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    return YES;
}
+ (NSString *)stringForObject:(NSString *)source {
    if (source == nil || [source isEqual:[NSNull null]]) {
        return @"";
    } else {
        return source;
    }
}
// 判断是否有效银行卡号
+ (BOOL) isValidCreditNumber:(NSString*)value {
    BOOL result = NO;
    NSInteger length = [value length];
    if (length >= 13) {
        result = [self isValidNumber:value];
        if (result)
        {
            int sum = 0;
            int digit = 0;
            int addend = 0;
            BOOL timesTwo = false;
            for (NSInteger i = value.length - 1; i >= 0; i--)
            {
                digit = [value characterAtIndex:i] - '0';
                if (timesTwo) {
                    addend = digit * 2;
                    if (addend > 9) {
                        addend -= 9;
                    }
                } else {
                    addend = digit;
                }
                sum += addend;
                timesTwo = !timesTwo;
            }
            int modulus = sum % 10;
            return modulus == 0;
        }
    }else {
        result = FALSE;
    }
    return result;
}
//身份证验证
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) {
        return false;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0){
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0, 1)].intValue +
                         [value substringWithRange:NSMakeRange(10,1)].intValue)*7 +
                ([value substringWithRange:NSMakeRange(1, 1)].intValue +
                 [value substringWithRange:NSMakeRange(11,1)].intValue)*9 +
                ([value substringWithRange:NSMakeRange(2, 1)].intValue +
                 [value substringWithRange:NSMakeRange(12,1)].intValue)*10 +
                ([value substringWithRange:NSMakeRange(3, 1)].intValue +
                 [value substringWithRange:NSMakeRange(13,1)].intValue)*5 +
                ([value substringWithRange:NSMakeRange(4, 1)].intValue +
                 [value substringWithRange:NSMakeRange(14,1)].intValue)*8 +
                ([value substringWithRange:NSMakeRange(5, 1)].intValue +
                 [value substringWithRange:NSMakeRange(15,1)].intValue)*4 +
                ([value substringWithRange:NSMakeRange(6, 1)].intValue +
                 [value substringWithRange:NSMakeRange(16,1)].intValue)*2 +
                [value substringWithRange:NSMakeRange(7,1)].intValue *1 +
                [value substringWithRange:NSMakeRange(8,1)].intValue *6 +
                [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        default:
            return NO;
    }
}
//获得简写的单号
+ (NSString *)shortStringForOrderID:(NSString *)orderID{
    if (orderID == nil || [orderID isEqual:[NSNull null]]) {
        return @"";
    } else {
        NSString *firstChar = [orderID substringToIndex:1];
        NSString *firstThreeChars = [orderID substringToIndex:3];
        NSString *shortId;
        if ([firstChar isEqualToString:@"1"]) {
            //实体销售单,取后17位
            shortId = [orderID substringFromIndex:orderID.length - 17];
        }else if ([firstChar isEqualToString:@"2"]){
            //实体退货单,取后15位
            shortId = [orderID substringFromIndex:orderID.length - 15];
        }else if ([firstThreeChars isEqualToString:@"ROW"]){
            //微店销售单,去掉前三位
            // shortId = [orderID substringFromIndex:3];
            //最新需求不做处理
            shortId = orderID;
        }else if ([firstThreeChars isEqualToString:@"RBW"]){
            //微店退货单,去掉前三位
            //shortId = [orderID substringFromIndex:3];
            //最新需求不做处理
            shortId = orderID;
        }else if ([firstChar isEqualToString:@"8"]){
            //退货单,取后15位
            shortId = [orderID substringFromIndex:orderID.length - 15];
        }
        return shortId;
    }
}
@end
