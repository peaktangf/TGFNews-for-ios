//
//  HintView.m
//  TGFNews
//
//  Created by 谭高丰 on 16/3/2.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "HintView.h"

@interface HintView () {
    UIImageView *hintImageView;
    UILabel *hintLabel;
}
@end

@implementation HintView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化子视图
        hintImageView = [[UIImageView alloc] init];
        hintLabel = [[UILabel alloc] init];
        
        //添加子视图
        [self addSubview:hintImageView];
        [self addSubview:hintLabel];
        
        //设置子视图
        hintLabel.numberOfLines = 0;
        hintLabel.textAlignment = NSTextAlignmentCenter;
        [hintLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        
        self.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_BACKGROUND], [UIColor colorWithHexString:NIGHT_BACKGROUND]);
        hintImageView.dk_imagePicker = DKImageWithImages([UIImage imageNamed:@"img_hint"], [UIImage imageNamed:@"img_hint_night"]);
        hintLabel.dk_textColorPicker = DKColorWithColors([UIColor darkGrayColor], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
        
        //防止block的循环引用
        __weak typeof (self) weakSelf = self;
        [hintImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(90, 90));
            make.top.mas_equalTo((kScreen_Height - 90) / 3);
        }];
        
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(hintImageView.mas_bottom).with.offset(13);
        }];
    }
    return self;
}

- (void)setHintStr:(NSString *)hintStr {
    _hintStr = hintStr;
    hintLabel.text = hintStr;
}

@end
