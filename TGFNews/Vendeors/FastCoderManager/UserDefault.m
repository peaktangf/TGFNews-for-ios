//
//  UserDefault.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/5.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "UserDefault.h"
#import "FastCoderManager.h"

@implementation UserDefault

+ (UserDefault *)currentUserDefault {
    static UserDefault *userDefault = nil;
    if (userDefault == nil) {
        userDefault = [NSObject valueByKey:NSStringFromClass(self)];
        if (userDefault == nil) {
            userDefault = [[UserDefault alloc] init];
            userDefault.userHeads = [NSMutableDictionary dictionary];
            userDefault.collectArray = [NSMutableArray array];
            userDefault.cityArray = [NSMutableArray array];
        }
    }
    return userDefault;
}

- (void)saveUserDefault {
    [self setValueWithKey:@"UserDefault"];
}

//修改密码
- (NSString *)updatePwdTipsWithUserModel:(UserDefault *)userModel {
    NSString *tipStr = nil;
    if (!userModel.userPwd || userModel.userPwd.length <= 0){
        tipStr = @"请输入当前密码";
    }else if (!userModel.userNewPwd || userModel.userNewPwd.length <= 0){
        tipStr = @"请输入新密码";
    }else if (!userModel.userNewPwdConfirm || userModel.userNewPwdConfirm.length <= 0) {
        tipStr = @"请确认新密码";
    }else if (![userModel.userNewPwd isEqualToString:userModel.userNewPwdConfirm]){
        tipStr = @"两次输入的密码不一致";
    }else if (userModel.userNewPwd.length < 6){
        NSLog(@"%@-%ld",userModel.userNewPwd,userModel.userNewPwd.length);
        tipStr = @"新密码不能少于6位";
    }else if (userModel.userNewPwd.length > 64){
        tipStr = @"新密码不得长于64位";
    }
    else if (![userModel.userPwd isEqualToString:self.userPwd]){
        tipStr = @"用户的原始密码有误";
    }
    return tipStr;
}

//根据用户名来获取用户头像的url
- (NSURL *)userHeadWithUserAccount:(NSString *)userAccount {
    if (userAccount) {
        NSArray *key = [self.userHeads allKeys];
        for (NSString *str in key) {
            NSString *urlStr = nil;
            if ([str isEqualToString:userAccount]) {
                urlStr = [self.userHeads objectForKey:userAccount];
                return PHOTO_URL(urlStr);
            }
        }
    }
    return nil;
}

@end
