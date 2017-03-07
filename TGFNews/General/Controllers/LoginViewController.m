//
//  LoginViewController.m
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/11.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "LoginViewController.h"
#import "FlatButton.h"

@interface LoginViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIView *inputBgView;
@property (weak, nonatomic) IBOutlet UIView *userNameBgView;
@property (weak, nonatomic) IBOutlet UIView *passBgView;
@property (weak, nonatomic) IBOutlet FlatButton *loginButton;

- (IBAction)loginAction:(id)sender;
- (IBAction)forgetPwdAction:(id)sender;
- (IBAction)registerAction:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//
////    NSString *urlstring= [NSString stringWithFormat:@"h"];// 此处网址不对，只是示意可以生成一个动态的urlstring  
////    //抓取网页中 网释义内容  
////    NSString * encodedString1 = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlstring, NULL, NULL,kCFStringEncodingUTF8);  
////    NSURL *url1 = [NSURL URLWithString:encodedString1];  
////    NSString *retStr = [NSString stringWithContentsOfURL:url1 encoding:NSUTF8StringEncoding error:nil];//[[NSString alloc] initWithData:data encoding:];  
////    NSLog(@" html = %@",retStr); 
//    NSURL *url = [NSURL URLWithString:@"http://www.tangaofeng.com/test/index.html"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"%lu",(unsigned long)str.length);
//    NSRange prefix = [str rangeOfString:@"<body>"];
//    NSRange suffix = [str rangeOfString:@"</body>"];
//    
//    NSRange reqRnage = NSMakeRange(prefix.location + prefix.length, suffix.location);
//    NSLog(@"%@,%@,%@",NSStringFromRange(prefix),NSStringFromRange(suffix),NSStringFromRange(reqRnage));
//    
////    NSRange suffix = [str rangeOfString:@"</body>"];
//    //NSRange reqRnage = NSMakeRange(prefix.location + prefix.length, suffix.location);
//    
//    NSString *reqStr = [str substringWithRange:reqRnage];
//    NSLog(@"%@",reqStr);
    
    //隐藏导航条
    self.fd_prefersNavigationBarHidden = YES;
    [self.headImageView setNeedsLayout];
    [self.headImageView layoutIfNeeded];
    self.headImageView.layer.cornerRadius = self.headImageView.height / 2;
    ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //判断用户是否登录过,登录过就直接进入首页
    if (UserDefaultEntity.isLogin == YES) {
        [TGFNewsAppDelegate showMainViewController];
    }
    //初始化界面UI
    [self initViewUI];
    
    if (UserDefaultEntity.userInfo.user) {
       self.userNameTextField.text = UserDefaultEntity.userInfo.user;
    }
    
    //设置登录按钮是否可点击
    //创建用户名和密码有效性的信号
    RACSignal *validUsernameSignal =
    [self.userNameTextField.rac_textSignal
     map:^id(NSString *text) {
         return @(text.length > 0);
     }];
    RACSignal *validPasswordSignal =
    [self.passwordTextField.rac_textSignal
     map:^id(NSString *text) {
         return @(text.length > 0);
     }];
    //聚合用户名和密码有效性的信号为一个总信号,并设置登录按钮的可点击状态
    RAC(self,loginButton.enabled) = [RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal]
                                                      reduce:^id(NSNumber *usernameValid,NSNumber *passwordValid){
                                                          return @([usernameValid boolValue] && [passwordValid boolValue]);
                                                      }];
    
    //监听用户输入用户名，当用户在本地存在时，设置当前用户的头像
    [self.userNameTextField.rac_textSignal subscribeNext:^(NSString *useraccount) {
        NSURL *headUrl = [UserDefaultEntity userHeadWithUserAccount:useraccount];
        if (headUrl) {
            [self.headImageView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"head_default"]];
        }
        else {
            self.headImageView.image = [UIImage imageNamed:@"head_default"];
        }
    }];
}

- (void)initViewUI {
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.layer.borderWidth = 2.0f;
    
    //使用kvo方式修改textfield的占位符颜色
    [self.userNameTextField setValue:[UIColor colorWithWhite:0.750 alpha:1.000] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor colorWithWhite:0.750 alpha:1.000] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.userNameBgView.backgroundColor = [UIColor colorWithWhite:0.257 alpha:1.000];
    self.passBgView.backgroundColor = [UIColor colorWithWhite:0.257 alpha:1.000];
}

//登录
- (IBAction)loginAction:(id)sender {
    
    [self closeEdit];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",USER_URL,LOGIN_CODE];
    NSDictionary *parmeter = @{@"user":self.userNameTextField.text,@"pwd":self.passwordTextField.text};
    [NETWORKINGMANAGER requestDataMethod:Post withUrl:urlStr withParmeter:parmeter requestSuccess:^(NSDictionary *dataDic) {
        
        UserInfoModel *userInfo = [UserInfoModel mj_objectWithKeyValues:dataDic];
        //存储用户基本信息
        UserDefaultEntity.userInfo = userInfo;
        UserDefaultEntity.userPwd = userInfo.pwd;
        //存储用户登录信息
        UserDefaultEntity.isLogin = YES;
        //将用户的图像地址和用户名对应存入本地
        [UserDefaultEntity.userHeads setObject:userInfo.head forKey:UserDefaultEntity.userInfo.user];
        //保存用户信息
        [UserDefaultEntity saveUserDefault];
        
        [TGFNewsAppDelegate showMainViewController];
        [self openEdit];
    } requestFailure:^(NSString *errorMessage) {
        [self openEdit];
        //请求失败进行错误提示
        [HUDMANAGER showAlertMessageContent:errorMessage];
    }];    
}

//忘记密码
- (IBAction)forgetPwdAction:(id)sender {
    
}

//注册
- (IBAction)registerAction:(id)sender {
    
}

//关闭编辑
- (void)closeEdit {
    //结束整个View的编辑
    [self.view endEditing:YES];
    self.userNameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
}

//开启编辑
- (void)openEdit {
    [self.loginButton shakeButton];
    self.userNameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
