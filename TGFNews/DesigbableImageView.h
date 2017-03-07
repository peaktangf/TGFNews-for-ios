//
//  DesigbableImageView.h
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/16.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface DesigbableImageView : UIImageView
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@end
