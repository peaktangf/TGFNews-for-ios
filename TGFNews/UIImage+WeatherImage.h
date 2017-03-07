//
//  UIImage+WeatherImage.h
//  TGFNews
//
//  Created by 谭高丰 on 16/2/17.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WeatherImage)

//根据天气情况返回相应的图片
+ (UIImage *)weatherImageWithKey:(NSString *)key;
@end
