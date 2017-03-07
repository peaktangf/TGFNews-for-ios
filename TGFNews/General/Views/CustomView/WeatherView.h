//
//  WeatherView.h
//  TGFNews
//
//  Created by 谭高丰 on 16/2/15.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherEntity.h"

@interface WeatherView : UIView

@property (nonatomic, assign) BOOL isShow;

+ (instancetype)view;

- (void)showViewWithCityName:(NSString *)cityname toView:(UIView *)view;
- (void)hiddenView;

@end
