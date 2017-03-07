//
//  AboutViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/7.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation AboutViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于看呀";
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_TABLESECTION_BG], [UIColor colorWithHexString:NIGHT_BACKGROUND]);
    _logoLabel.dk_textColorPicker = DKColorWithColors([UIColor blackColor], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    _versionLabel.dk_textColorPicker = DKColorWithColors([UIColor blackColor], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    _infoLabel.dk_textColorPicker = DKColorWithColors([UIColor blackColor], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = 10;
    
    _infoLabel.text = [NSString stringWithFormat:@"官网：https://看呀.net \nE-mail:link@看呀.net \n微博：看呀 \n微信：妞TGFNews"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
