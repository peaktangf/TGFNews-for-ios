//
//  UserDefault.h
//  TGFNews
//
//  Created by 谭高丰 on 16/2/5.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherEntity.h"
#import "UserInfoModel.h"

#define UserDefaultEntity [UserDefault currentUserDefault]

@interface UserDefault : NSObject

@property (nonatomic, retain) UserInfoModel *userInfo;
@property (nonatomic, copy) NSString *userPwd,*userNewPwd,*userNewPwdConfirm;

@property (nonatomic, assign) BOOL isLogin;//是否已登录

//登录过用户的头像数组(用来在登录界面用户输入账号时显示用户的对应头像，没有登录过得用户不会有头像)
@property (nonatomic, retain) NSMutableDictionary *userHeads;
@property (nonatomic, strong) NSMutableArray *collectArray;//新闻收藏数组
@property (nonatomic, strong) NSMutableArray *cityArray;//城市管理数组
@property (nonatomic, copy) NSString *locationCity;//当前城市
@property (nonatomic, assign) BOOL isFirst;//是否是第一次进入应用
@property (nonatomic, assign) BOOL isNight;//夜间模式
@property (nonatomic, copy) NSString *newsFont;//字体大小

+ (UserDefault *)currentUserDefault;

/**
 *  保存用户数据
 */
- (void)saveUserDefault;

//修改密码
- (NSString *)updatePwdTipsWithUserModel:(UserDefault *)userModel;
//根据用户名获取用户头像的url
- (NSURL *)userHeadWithUserAccount:(NSString *)useraccount;
@end
