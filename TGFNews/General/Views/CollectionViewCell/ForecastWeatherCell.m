//
//  ForecastWeatherCell.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "ForecastWeatherCell.h"
#import "NSString+CutWeather.h"

@interface ForecastWeatherCell ()

@property (weak, nonatomic) IBOutlet UILabel *weakLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *fengliLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;
@end

@implementation ForecastWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _highLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NAVBAR],[UIColor colorWithHexString:NIGHT_NAVBAR]);
    _lowLabel.dk_textColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NAVBAR],[UIColor colorWithHexString:NIGHT_NAVBAR]);
}

- (void)setEntity:(Forecast *)entity {
    _entity = entity;
    _weakLabel.text = [NSString cutOutDate:entity.week];
    NSRange range = [entity.date rangeOfString:@"-"];
    _dateLabel.text = [entity.date substringFromIndex:range.location + 1];
    _typeLabel.text = entity.type;
    _highLabel.text = [entity.hightemp stringByReplacingOccurrencesOfString:@"℃" withString:@"°"];
    _lowLabel.text = [entity.lowtemp stringByReplacingOccurrencesOfString:@"℃" withString:@"°"];
    _fengliLabel.text = entity.fengli;
    _signImageView.image = [UIImage weatherImageWithKey:entity.type];
}

@end
