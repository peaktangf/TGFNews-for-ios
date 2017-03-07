//
//  BaseViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
    UIBarButtonItem* leftBarItem;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置状态栏字体颜色(默认设置为白色)
    [self setStateBarTitleColor:UIStatusBarStyleLightContent];
    
    //设置导航栏的颜色
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NAVBAR], [UIColor colorWithHexString:NIGHT_NAVBAR]);
    
    //设置导航条的标题（字体大小和字体颜色）
    [RACObserve(UserDefaultEntity, isNight) subscribeNext:^(id x) {

        NSDictionary *textAttributes = nil;
        BOOL bNight = [x boolValue];
        if (bNight) {
            textAttributes = @{
                               NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT],
                               };
        }
        else {
            textAttributes = @{
                               NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                               NSForegroundColorAttributeName:[UIColor whiteColor],
                               };
        }
        
        self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    }];
    
    //设置返回按钮
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_public_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 35,35);
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    //设置导航条在向上滑的时候隐藏
    //self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)setIsBack:(BOOL)isDontBack {
    _isDontBack = isDontBack;
    if (_isDontBack) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)setStateBarTitleColor:(UIStatusBarStyle)style {
    //设置状态栏字体颜色
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:style];
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
