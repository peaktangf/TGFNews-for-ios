//
//  AppDelegate.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocial.h>
#import "PublicTabelViewController.h"
#import "AboutViewController.h"
#import "MainNewsViewController.h"
#import <MMDrawerController.h>
#import <IQKeyboardManager.h>

#import "LoginViewController.h"
#import "LoginNavigationViewController.h"
#import "DrawerViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置键盘不会挡住输入框
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //开启键盘自动收缩功能
    manager.enable = YES;
    //控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    //控制键盘上的工具条文字颜色是否用户自定义
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    //控制是否显示键盘上的工具条
    manager.enableAutoToolbar = YES;
    
    //初始化友盟appkey
    [UMSocialData setAppKey:UMAPPKEY];
    //启动3D Touch标签功能
    [self init3DTouchActionShow:YES];
    //设置启动页的停留时间
//    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    return YES;
}

/**
 *  手动添加3D touch功能
 */
- (void)init3DTouchActionShow:(BOOL)isShow {
    //设置3d touch的菜单
    UIApplicationShortcutItem *itemone = [[UIApplicationShortcutItem alloc] initWithType:@"one" localizedTitle:@"头条新闻" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_news"] userInfo:nil];
    UIApplicationShortcutItem *itemtwo = [[UIApplicationShortcutItem alloc] initWithType:@"two" localizedTitle:@"查看天气" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_weather"] userInfo:nil];
    UIApplicationShortcutItem *itemthree = [[UIApplicationShortcutItem alloc] initWithType:@"three" localizedTitle:@"本地收藏" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_star"] userInfo:nil];
    UIApplicationShortcutItem *itemfour = [[UIApplicationShortcutItem alloc] initWithType:@"four" localizedTitle:@"关于看呀" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_about"] userInfo:nil];
    //添加
    [UIApplication sharedApplication].shortcutItems = @[itemfour,itemthree,itemtwo,itemone];
}

/**
 *  处理3d Touch的点击事件
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    UIStoryboard *mainStroryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //获取MMDrawerController 的中心控制器
    MMDrawerController *drawerC = (MMDrawerController *)self.window.rootViewController;
    UINavigationController *centerNaviationC = (UINavigationController *)(drawerC.centerViewController);
    
    if ([shortcutItem.type isEqualToString:@"one"]) {
    }
    else if ([shortcutItem.type isEqualToString:@"two"]) {
        MainNewsViewController *mainNewsVc = [mainStroryBoard instantiateViewControllerWithIdentifier:@"MainNewsViewController"];
        mainNewsVc.isShortcutShowWeather = YES;
        [centerNaviationC pushViewController:mainNewsVc animated:NO];
    }
    else if ([shortcutItem.type isEqualToString:@"three"]) {
        PublicTabelViewController *publicVc = [mainStroryBoard instantiateViewControllerWithIdentifier:@"PublicTabelViewController"];
        publicVc.markStr = @"collect";
        publicVc.navTitle = @"本地收藏";
        [centerNaviationC pushViewController:publicVc animated:NO];
    }
    else {
        AboutViewController *aboutVc = [mainStroryBoard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [centerNaviationC pushViewController:aboutVc animated:NO];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//显示main控制器
- (void)showMainViewController {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DrawerViewController *drawerVc = (DrawerViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"DrawerViewController"];
    self.window.rootViewController = drawerVc;
}

//显示登录控制器
- (void)showLoginViewController {
    UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginNavigationViewController *loginNavVc = (LoginNavigationViewController *)[loginStoryBoard instantiateViewControllerWithIdentifier:@"LoginNavigationViewController"];
    self.window.rootViewController = loginNavVc;
}

//#pragma mark XGPush
//- (void)registerPush{
//    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if(sysVer < 8){
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//    }else{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
//                                                                                     categories:[NSSet setWithObject:categorys]];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:userSettings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//#endif
//    }
//}
//
//#pragma mark - Methods Private
//- (void)setupTabViewController {
//
//}
//- (void)setupLoginViewController {
//
//}
//- (void)setupIntroductionViewController {
//
//}

@end
