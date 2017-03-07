//
//  BaseTableViewCell.m
//  TGFNews
//
//  Created by 谭高丰 on 16/3/2.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置cell选中时的颜色
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithWhite:0.902 alpha:1.000], [UIColor colorWithWhite:0.098 alpha:1.000]);
    //设置cell夜间模式和正常模式的颜色
    self.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor colorWithHexString:NIGHT_CELL_BACKGROUND]);
    UILabel *labeBottom = [[UILabel alloc] init];
    //设置下面线条夜间模式和正常模式的颜色
    labeBottom.dk_backgroundColorPicker = DKColorWithColors([UIColor groupTableViewBackgroundColor], [UIColor colorWithWhite:1.000 alpha:0.066]);
    [self addSubview:labeBottom];
    [labeBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
