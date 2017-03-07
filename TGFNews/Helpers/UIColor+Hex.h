//
//  UIColor+Hex.h
//  color
//
//  Created by Andrew Sliwinski on 9/15/12.
//  Copyright (c) 2012 Andrew Sliwinski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
/**
 *  16进制转换颜色
 *
 *  @param hex   16进制 0x000000
 *  @param alpha 透明度 0-1.0
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
/**
 *  16进制颜色转换
 *
 *  @param hex 16进制 0x000000
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHex:(UInt32)hex;
/**
 *  字符串转换颜色
 */
+ (UIColor *)colorWithHexString:(id)input;
/**
 *  随机颜色
 */
+ (UIColor *)randomColor;
@end
