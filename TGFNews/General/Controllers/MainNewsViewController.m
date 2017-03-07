//
//  MainNewsViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "LocationManage.h"
#import "MainNewsViewController.h"
#import "NewsViewController.h"
#import "PublicTabelViewController.h"
#import "WMMenuView.h"
#import "WeatherView.h"
#import <UIAlertView+BlocksKit.h>
#import <UIViewController+MMDrawerController.h>
#import "SlideScrollView.h"

@interface MainNewsViewController () <UIScrollViewDelegate, WMMenuViewDelegate> {
    WMMenuView* menuView;
    WeatherView* weatherView;
}
@property (weak, nonatomic) IBOutlet SlideScrollView *bigScrollView;
@property (weak, nonatomic) IBOutlet UIView* customNavBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)leftAction:(id)sender;
- (IBAction)weatherAction:(id)sender;

@end

@implementation MainNewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    //解决scrollview向下偏移的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //判断是否是夜间模式
    if (UserDefaultEntity.isNight) {
        [DKNightVersionManager nightFalling];//启动夜间模式
    }
    else {
        [DKNightVersionManager dawnComing];//关闭夜间模式
    }
    
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_BACKGROUND], [UIColor colorWithHexString:NIGHT_BACKGROUND]);
    self.customNavBar.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NAVBAR],[UIColor colorWithHexString:NIGHT_NAVBAR]);
    self.titleLabel.dk_textColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    
    //初始化天气视图
    weatherView = [WeatherView view];

    //第一次进入应用时进行定位
    if (!UserDefaultEntity.isFirst) {
        UserDefaultEntity.isFirst = YES;
        //设置默认城市为北京
        UserDefaultEntity.locationCity = @"北京";
        [UserDefaultEntity saveUserDefault];
        
        [LOCATIONMANAGER starLocationSuccess:^(CLPlacemark *locationInfo) {
            [UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"定位到当前城市为 %@,是否切换", locationInfo.name] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView* alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    UserDefaultEntity.locationCity = locationInfo.name;
                    [UserDefaultEntity saveUserDefault];
                }
            }];
        } Failure:^(NSString *failureMessage) {
            [HUDMANAGER showAlertMessageContent:@"定位失败"];
        }];
    }

    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCity) name:@"SwitchCity" object:nil];

    //添加子控制器
    [self addController];
    CGFloat contentX = self.childViewControllers.count * kScreen_Width;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.bounces = NO;
    self.bigScrollView.delegate = self;
    //添加滚动菜单视图
    [self addMenuView];
    // 添加默认控制器
    UIViewController* vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    
    if (_isShortcutShowWeather) {
        [self weatherAction:nil];
    }
//    //注册通知(用来监听是否是从3d touch 的查看天气 进入控制器的)
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWeatherMethod) name:@"show_weather" object:nil];
}

//添加滚动菜单视图
- (void)addMenuView
{
    CGRect frame = CGRectMake(0, 64, kScreen_Width, 35);
    menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:NEWS_TITLE_ARRAY backgroundColor:[UIColor whiteColor] norSize:13 selSize:16 norColor:[UIColor blackColor] selColor:[UIColor colorWithHexString:NORMAL_NAVBAR]];
    menuView.delegate = self;
    [self.view addSubview:menuView];
}

/** 添加子控制器 */
- (void)addController
{
    for (int i = 0; i < NEWS_TITLE_ARRAY.count; i++) {
        NewsViewController* vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"];
        vc1.url = NEWS_URL_ARRAY[i];
        [self addChildViewController:vc1];
    }
}

#pragma mark - UIScrollViewDelegate
/** 滚动动画结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    [menuView slideMenuAtProgress:index];
    // 添加控制器
    NewsViewController* newsVc = self.childViewControllers[index];
    newsVc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark -WMMenuViewDelegate
- (void)menuView:(WMMenuView*)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex
{

    CGFloat offsetX = index * kScreen_Width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);

    [self.bigScrollView setContentOffset:offset animated:YES];
}

- (IBAction)leftAction:(id)sender
{
    //显示左侧视图
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)weatherAction:(id)sender
{
    [self showWeatherMethod];
}

- (void)showWeatherMethod {
    //显示天气
    if (weatherView.isShow) {
        [weatherView hiddenView];
        return;
    }
    [weatherView showViewWithCityName:UserDefaultEntity.locationCity toView:self.view];
}

//切换城市
- (void)switchCity
{
    PublicTabelViewController* publicTableViewVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PublicTabelViewController"];
    publicTableViewVc.navTitle = @"天气城市";
    publicTableViewVc.markStr = @"weather";
    publicTableViewVc.clickBlock = ^(NSString *cityname){
        [weatherView showViewWithCityName:cityname toView:self.view];
    };
    [self.navigationController pushViewController:publicTableViewVc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    //移除所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
