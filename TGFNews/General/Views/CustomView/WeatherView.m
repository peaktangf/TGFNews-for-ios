//
//  WeatherView.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/15.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "WeatherView.h"
#import "WeatherEntity.h"
#import "ForecastWeatherCell.h"
#import "NetWorkingManager.h"
#import "NSString+CutWeather.h"
#import "LocationManage.h"

#define COLLECTIONWITH self.forecastWeatherCollectionView.bounds.size.width
#define COLLECTIONHITH self.forecastWeatherCollectionView.bounds.size.height

@interface WeatherView ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    WeatherEntity *weatherEntity;
    NSString *curCity;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *wenduLb;
@property (weak, nonatomic) IBOutlet UILabel *wenduUnitLb;

@property (weak, nonatomic) IBOutlet UILabel *cityLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *highAndLowLb;
@property (weak, nonatomic) IBOutlet UILabel *typeAndFengliLb;
@property (weak, nonatomic) IBOutlet UILabel *pmLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherSignImg;
@property (weak, nonatomic) IBOutlet UICollectionView *forecastWeatherCollectionView;

//push到天气管理页面
- (IBAction)switchCityAction:(id)sender;
@end

@implementation WeatherView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    //设置夜间模式和白天模式的颜色
    _wenduLb.dk_textColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NAVBAR],[UIColor colorWithHexString:NIGHT_NAVBAR]);
    _wenduUnitLb.dk_textColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NAVBAR],[UIColor colorWithHexString:NIGHT_NAVBAR]);
    //集成下拉刷新
    self.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSString *address = [NSString stringWithFormat:@"%@cityinfo",WEATHER_URL];
        [NETWORKINGMANAGER requestDataMethod:Get withUrl:address withParmeter:@{@"cityname":curCity} requestSuccess:^(NSDictionary *dataDic) {
            
            if ([[dataDic objectForKey:@"errNum"] integerValue] == -1) {
                [self.scrollView.header endRefreshing];
                [HUDMANAGER showAlertMessageContent:@"天气查询失败！"];
            }
            else {
                NSString *idStr = [[dataDic objectForKey:@"retData"] objectForKey:@"cityCode"];
                //刷新天气数据
                [NETWORKINGMANAGER requestWeatherWithCityName:idStr requestSuccess:^(NSDictionary *dataDic) {
                    [self.scrollView.header endRefreshing];
                    WeatherEntity *entity = [[WeatherEntity alloc] initWithDictionary:[dataDic objectForKey:@"retData"]];
                    //刷新数据
                    [self reloadDataWithEntity:entity];
                } requestFailure:^(NSString *errorMessage) {
                    [self.scrollView.header endRefreshing];
                }];
            }
        } requestFailure:^(NSString *errorMessage) {
            
        }];
    }];
    
    //监听 UserDefaultEntity 的 locationCity 属性，有变化了就刷新数据
    [RACObserve(UserDefaultEntity, locationCity) subscribeNext:^(NSString *cityname) {
        curCity = cityname;
        [self.scrollView.header beginRefreshing];
    }];
    
    //注册collcetionView
    [self.forecastWeatherCollectionView registerNib:[UINib nibWithNibName:@"ForecastWeatherCell" bundle:nil] forCellWithReuseIdentifier:@"cellid"];
    self.forecastWeatherCollectionView.layer.masksToBounds = YES;
    self.forecastWeatherCollectionView.layer.borderWidth = 0.2;
    self.forecastWeatherCollectionView.layer.borderColor = [UIColor grayColor].CGColor;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return weatherEntity.forecast.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ForecastWeatherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    Forecast *entity = (Forecast *)weatherEntity.forecast[indexPath.row];
    cell.entity = entity;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(COLLECTIONWITH / weatherEntity.forecast.count, COLLECTIONHITH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//设置页面数据
- (void)configureContent {
    _wenduLb.text = [weatherEntity.today.curTemp stringByReplacingOccurrencesOfString:@"℃" withString:@""];
    _cityLb.text = weatherEntity.city;
    _dateLb.text = [NSString stringWithFormat:@"%@ %@",weatherEntity.today.week,weatherEntity.today.date];
    _highAndLowLb.text = [NSString stringWithFormat:@"%@/%@",weatherEntity.today.hightemp,weatherEntity.today.lowtemp];
    _typeAndFengliLb.text = [NSString stringWithFormat:@"%@ %@",weatherEntity.today.type,weatherEntity.today.fengli];
    _pmLabel.text = [NSString stringWithFormat:@"PM %@",weatherEntity.today.aqi];
    _weatherSignImg.image = [UIImage weatherImageWithKey:weatherEntity.today.type];
}

//刷新数据
- (void)reloadDataWithEntity:(WeatherEntity *)entity {
    weatherEntity = entity;
    //设置数据
    [self configureContent];
    //刷新CollectionView
    [self.forecastWeatherCollectionView reloadData];
}

#pragma makr 共有方法
+ (instancetype)view {
    WeatherView *weatherView = [[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:nil options:nil] firstObject];
    weatherView.frame = [UIScreen mainScreen].bounds;
    weatherView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithWhite:1.000 alpha:0.900], [UIColor colorWithWhite:0.800 alpha:0.900]);
    weatherView.y = 64;
    weatherView.height -= 64;
    return weatherView;
}

- (void)showViewWithCityName:(NSString *)cityname toView:(UIView *)view{
    
    curCity = cityname;
    
    self.isShow = YES;
    [view addSubview:self];
    
    [self.scrollView.header beginRefreshing];
}

- (void)hiddenView {
    self.isShow = NO;
    [self removeFromSuperview];
}

- (IBAction)switchCityAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchCity" object:nil];
}

@end



