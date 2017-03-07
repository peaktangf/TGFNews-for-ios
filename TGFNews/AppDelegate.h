//
//  AppDelegate.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//- (void)setupTabViewController;
//- (void)setupLoginViewController;
//- (void)setupIntroductionViewController;
//
///**
// *  注册推送
// */
//- (void)registerPush;

- (void)showMainViewController;
- (void)showLoginViewController;

@end

