//
//  SettingPwdViewController.m
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/18.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "SettingPwdViewController.h"
#import "CommonTableViewCell.h"
#import <UIAlertView+BlocksKit.h>


@interface SettingPwdViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *oldPwd,*newPwd,*surePwd;
    UserDefault *userDefault;
    NSMutableArray *settingInfoArray;
    UITableView *settingPwdTableView;
}

@end

@implementation SettingPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    settingPwdTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    settingPwdTableView.tableFooterView = [UIView new];
    settingPwdTableView.delegate = self;
    settingPwdTableView.dataSource = self;
    settingPwdTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingPwdTableView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClicked)];
    doneBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    [self initData];
}

- (void)initData {
    
    CommonCellModel *spaceModel = [[CommonCellModel alloc] initWithType:ESpace withTitle:nil withContent:nil];
    CommonCellModel *oldPwdModel = [[CommonCellModel alloc] initWithType:EChangeText withTitle:nil withContent:nil];
    CommonCellModel *newPwdModel = [[CommonCellModel alloc] initWithType:EChangeText withTitle:nil withContent:nil];
    CommonCellModel *conPwdModel = [[CommonCellModel alloc] initWithType:EChangeText withTitle:nil withContent:nil];
    settingInfoArray = [[NSMutableArray alloc] initWithObjects:spaceModel,oldPwdModel,newPwdModel,conPwdModel, nil];
    userDefault = [[UserDefault alloc] init];
    [settingPwdTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return settingInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommonCellModel *model = settingInfoArray[indexPath.row];
    NSString *Id = [CommonTableViewCell idForRow:model];
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:Id owner:nil options:nil] firstObject];
    }
    cell.model = model;
    
    switch (indexPath.row) {
        case 1:{
            [cell configWithPlaceholder:@"请输入旧密码" valueStr:@"" secureTextEntry:YES];
            cell.textValueChangedBlock = ^(NSString *valueStr) {
                userDefault.userPwd = valueStr;
                NSLog(@"%@",valueStr);
            };
        }
            break;
        case 2:{
            [cell configWithPlaceholder:@"请输入新密码" valueStr:@"" secureTextEntry:YES];
            cell.textValueChangedBlock = ^(NSString *valueStr) {
                userDefault.userNewPwd = valueStr;
                NSLog(@"%@",valueStr);
            };
        }
            break;
        case 3:{
            [cell configWithPlaceholder:@"请确认新密码" valueStr:@"" secureTextEntry:YES];
            cell.textValueChangedBlock = ^(NSString *valueStr) {
                userDefault.userNewPwdConfirm = valueStr;
                NSLog(@"%@",valueStr);
            };
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCellModel *model = settingInfoArray[indexPath.row];
    CGFloat rowHeight = [CommonTableViewCell heightForRow:model];
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//完成
- (void)doneBtnClicked {
    [self.view endEditing:YES];
    
    NSString *tipStr = [UserDefaultEntity updatePwdTipsWithUserModel:userDefault];
    if (tipStr) {
        [HUDMANAGER showAlertMessageContent:tipStr];
        return;
    }
    //发送请求修改密码
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",USER_URL,RESET_PWD_CODE];
    NSDictionary *parmeter = @{@"user":UserDefaultEntity.userInfo.user,@"pwd":userDefault.userPwd,@"newPwd":userDefault.userNewPwd};
    
    [HUDMANAGER showStateQueryMessageContent:@"正在修改个人信息..."];
    [NETWORKINGMANAGER requestDataMethod:Post withUrl:urlStr withParmeter:parmeter requestSuccess:^(NSDictionary *dataDic) {
        [HUDMANAGER dismissStateQueryMessage];
        
        UserDefaultEntity.isLogin = NO;
        [UserDefaultEntity saveUserDefault];
        
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"修改密码成功，你需要重新登陆哦~" cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                //修改密码成功之后提示用户重新登录
                [TGFNewsAppDelegate showLoginViewController];
            }
        }];
    } requestFailure:^(NSString *errorMessage) {
        [HUDMANAGER showStateMessageType:Error withContent:errorMessage];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
