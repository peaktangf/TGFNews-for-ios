//
//  HotCityCell.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/22.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "HotCityCell.h"

@interface HotCityCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@end

@implementation HotCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 15.0;
    self.layer.borderWidth = 1.0;
}

- (void)setCityname:(NSString *)cityname {
    _cityname = cityname;
    _cityLabel.text = cityname;
    if ([UserDefaultEntity.cityArray containsObject:[cityname stringByReplacingOccurrencesOfString:@"市" withString:@""]] || [cityname isEqualToString:@"定位"]) {
        self.layer.borderColor = [UIColor colorWithHexString:NORMAL_NAVBAR].CGColor;
        _cityLabel.textColor = [UIColor colorWithHexString:NORMAL_NAVBAR];
    }
    else {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        _cityLabel.textColor = [UIColor grayColor];
    }
}

@end
