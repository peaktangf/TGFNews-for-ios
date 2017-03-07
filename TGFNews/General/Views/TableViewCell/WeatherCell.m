//
//  WeatherCell.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/8.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "WeatherCell.h"

@interface WeatherCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityLb;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@end

@implementation WeatherCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.cityLb.dk_textColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NEWS_BODYTEXT], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
}

- (void)setCity:(NSString *)city {
    _city = city;
    _cityLb.text = [NSString stringWithFormat:@"%@市",city];
    if (![city isEqualToString:UserDefaultEntity.locationCity]) {
        _locationImageView.hidden = YES;
    }
    else {
        _locationImageView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
