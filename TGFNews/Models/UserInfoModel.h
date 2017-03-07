//
//  UserInfoModel.h
//  TGFNews
//
//  Created by 谭高丰 on 16/5/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
//birthday = "1985-01-12";
//head = "1463638136.png";
//id = 1;
//phone = "<null>";
//pwd = 123456;
//sex = 0;
//user = gaofeng;

@property (nonatomic, assign) long id;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, assign) int sex;//0：男 1：女
@property (nonatomic, copy) NSString *sexname;
@end
