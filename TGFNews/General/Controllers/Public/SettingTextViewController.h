//
//  SettingTextViewController.h
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/12.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingTextViewController : BaseViewController

+ (instancetype)settingTextVCWithTitle:(NSString *)title textValue:(NSString *)textValue keyBoardType:(UIKeyboardType)boardType doneBlock:(void(^)(NSString *textValue))block;
@end
