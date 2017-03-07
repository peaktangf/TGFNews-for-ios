//
//  DesigbableImageView.m
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/16.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "DesigbableImageView.h"

@implementation DesigbableImageView

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0?true:false;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

@end
