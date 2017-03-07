//
//  UILabel+Rich.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/25.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Rich)

/**
 *  设置UILabel上某段文字的字体与颜色
 *
 *  @param range 设置内容的区间
 *  @param font  字体大小
 *  @param color 字体颜色
 */
- (void)richTextRange:(NSRange)range withFont:(id)font wtihColor:(UIColor *)color;

/**
 *  获取一个label
 */
+ (UILabel *)lineLabel;
@end
