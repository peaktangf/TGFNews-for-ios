//
//  UIImage+WeatherImage.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/17.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "UIImage+WeatherImage.h"

@implementation UIImage (WeatherImage)

//根据天气情况返回相应的图片
+ (UIImage *)weatherImageWithKey:(NSString *)key {
    
    UIImage *image = nil;
    if ([key isEqualToString:@"雷阵雨"]) {
        image = [UIImage imageNamed:@"thunder_mini"];
    }else if ([key isEqualToString:@"晴"]){
        image = [UIImage imageNamed:@"sun_mini"];
    }else if ([key isEqualToString:@"多云"]){
        image = [UIImage imageNamed:@"sun_and_cloud_mini"];
    }else if ([key isEqualToString:@"阴"]){
        image = [UIImage imageNamed:@"nosun_mini"];
    }else if ([key hasSuffix:@"雨"]){
        image = [UIImage imageNamed:@"rain_mini"];
    }else if ([key hasSuffix:@"雪"]){
        image = [UIImage imageNamed:@"snow_heavyx_mini"];
    }else{
        image = [UIImage imageNamed:@"sand_float_mini"];
    }
    return image;
}

@end
