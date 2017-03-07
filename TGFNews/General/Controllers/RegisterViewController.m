//
//  RegisterViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/5/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)sendCodeAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
}

//发送验证码
- (IBAction)sendCodeAction:(id)sender {
    
}

//注册
- (IBAction)registerAction:(id)sender {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",USER_URL,REGISTER_CODE];
    NSDictionary *parmeter = @{@"user":self.userNameLabel.text,@"pwd":self.pwdLabel.text,@"phone":self.phoneLabel.text};
    [HUDMANAGER showLoadingMessageToView:self.view];
    [NETWORKINGMANAGER requestDataMethod:Post withUrl:urlStr withParmeter:parmeter requestSuccess:^(NSDictionary *dataDic) {
        [HUDMANAGER dismissLoadingMessage];
        //存储登录信息
        UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues:dataDic];
        //存储用户基本信息
        UserDefaultEntity.userInfo = userInfo;
        //存储用户登录信息
        UserDefaultEntity.isLogin = YES;
        //保存用户信息
        [UserDefaultEntity saveUserDefault];
        
        [TGFNewsAppDelegate showMainViewController];
    } requestFailure:^(NSString *errorMessage) {
        [HUDMANAGER dismissLoadingMessage];
        [HUDMANAGER showAlertMessageContent:errorMessage];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


