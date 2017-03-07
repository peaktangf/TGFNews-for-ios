//
//  BaseViewController.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkingManager.h"

@interface BaseViewController : UIViewController

//是否取消返回按钮
@property(nonatomic,assign)BOOL isDontBack;

/**
 *  设置状态栏的文字颜色
 *
 *  @param style 风格
 */
- (void)setStateBarTitleColor:(UIStatusBarStyle)style;

@end
