//
//  ForecastWeatherCell.h
//  TGFNews
//
//  Created by 谭高丰 on 16/2/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forecast.h"
#import "UIImage+WeatherImage.h"

@interface ForecastWeatherCell : UICollectionViewCell

@property (nonatomic, strong) Forecast *entity;

@end
