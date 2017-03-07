//
//  DrawerViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/4/6.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "DrawerViewController.h"

@interface DrawerViewController ()

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMaximumLeftDrawerWidth:kScreen_Width * 4 / 5];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
