//
//  NSString+Judge.h
//  TGFNews
//
//  Created by 谭高丰 on 16/3/15.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Judge)
+ (BOOL)isNotBlank:(NSString*)source;
+ (BOOL)isBlank:(NSString*)source;
//正整数验证(带0).
+(BOOL) isPositiveNum:(NSString*)source;
//非0正整数验证.
+(BOOL) isNumNotZero:(NSString*)source;
//不是数字英文字母验证.
+(BOOL) isNotNumAndLetter:(NSString*)source;
//整数验证.
+(BOOL) isInt:(NSString*)source;
//小数正验证.
+(BOOL) isFloat:(NSString*)source;
//日期验证.
+(BOOL) isDate:(NSString*)source;
// 是否是纯数字
+ (BOOL)isValidNmber:(NSString*)value;
//URL路径过滤掉随机数.
+(NSString*) urlFilterRan:(NSString*)urlPath;
+(NSString *)getUniqueStrByUUID;
//验证Email是否正确.
+ (BOOL)isValidateEmail:(NSString *)email;
//传真验证
+ (BOOL)isValidateFax:(NSString *)fax;
//验证手机号
+ (BOOL)validateMobile:(NSString *)mobileNum;
//判断手机号及其后四位
+ (BOOL)isValidatePhone:(NSString *)phoneNumber;
+ (NSString *)stringForObject:(NSString *)source;
//有效银行卡号验证
+ (BOOL) isValidCreditNumber:(NSString*)value;
//身份证验证
+ (BOOL) validateIDCardNumber:(NSString *)value;
//获得简写的单号
+ (NSString *)shortStringForOrderID:(NSString *)orderID;
@end
