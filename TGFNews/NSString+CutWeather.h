//
//  NSString+CutWeather.h
//  百捷新闻
//
//  Created by 谭高丰 on 15/10/27.
//  Copyright (c) 2015年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CutWeather)
+ (NSString *)cutOutWeather:(NSString *)weather;
+ (NSString *)cutOutDate:(NSString *)date;
+ (NSString *)HaiziConvertPinyin:(NSString *)hanzi;

//通过字体描述获得具体的字体大小
+ (NSString *)fontSizeTofontMark:(NSString *)mark;
@end
