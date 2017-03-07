//
//  UILabel+Rich.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/25.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "UILabel+Rich.h"

@implementation UILabel (Rich)

//设置不同字体颜色
-(void)richTextRange:(NSRange)range withFont:(id)font wtihColor:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = str;
}

+ (UILabel *)lineLabel {
    UILabel *lineLabel = [[UILabel alloc] init];
    //设置label夜间模式和正常模式的颜色
    lineLabel.dk_backgroundColorPicker = DKColorWithColors([UIColor groupTableViewBackgroundColor], [UIColor colorWithWhite:1.000 alpha:0.066]);
    return lineLabel;
}
@end
