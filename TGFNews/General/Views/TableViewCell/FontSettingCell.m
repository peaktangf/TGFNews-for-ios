//
//  FontSettingCell.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/31.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "FontSettingCell.h"

@implementation FontSettingCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.lbTitle.dk_textColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NEWS_BODYTEXT], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    self.imgMark.dk_imagePicker = DKImageWithImages([UIImage imageNamed:@"img_draw_normal"], [UIImage imageNamed:@"img_draw_night"]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
