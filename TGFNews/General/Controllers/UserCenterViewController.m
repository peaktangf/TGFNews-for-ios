//
//  UserCenterViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/5/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "UserCenterViewController.h"
#import "SettingPwdViewController.h"
#import "CommonTableViewCell.h"
#import "CommonCellModel.h"
#import "Helper.h"
#import "DateFormatter.h"
#import "SettingTextViewController.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "DateFormatter.h"

#define USER_SEX_TYPE_ARR @[@"男",@"女"]

@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray *userInfoArray;
}
@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;
@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    //设置tableview的底部视图
    self.userInfoTableView.tableFooterView = [self tableFooterView];
    [self initData];
}

- (void)initData {
    
    CommonCellModel *spaceOneModel = [[CommonCellModel alloc] initWithType:ESpace withTitle:nil withContent:nil];
    CommonCellModel *headModel = [[CommonCellModel alloc] initWithType:ESettingImage withTitle:@"头像" withContent:UserDefaultEntity.userInfo.head];
    CommonCellModel *spaceTwoModel = [[CommonCellModel alloc] initWithType:ESpace withTitle:nil withContent:nil];
    
    CommonCellModel *nameModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"昵称" withContent:UserDefaultEntity.userInfo.user];
    CommonCellModel *sexModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"性别" withContent:UserDefaultEntity.userInfo.sexname];
    NSLog(@"%@",UserDefaultEntity.userInfo.birthday);
    CommonCellModel *birthdayModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"生日" withContent:UserDefaultEntity.userInfo.birthday];
    CommonCellModel *phoneModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"手机号" withContent:UserDefaultEntity.userInfo.phone];
    
    CommonCellModel *spaceThreeModel = [[CommonCellModel alloc] initWithType:ESpace withTitle:nil withContent:nil];
    CommonCellModel *updatePwdModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"修改密码" withContent:nil];
    
    userInfoArray = [[NSMutableArray alloc] initWithObjects:spaceOneModel,headModel,spaceTwoModel,nameModel,sexModel,birthdayModel,phoneModel,spaceThreeModel,updatePwdModel, nil];
    [self.userInfoTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return userInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommonCellModel *model = userInfoArray[indexPath.row];
    NSString *Id = [CommonTableViewCell idForRow:model];
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:Id owner:nil options:nil] firstObject];
    }
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCellModel *model = userInfoArray[indexPath.row];
    CGFloat rowHeight = [CommonTableViewCell heightForRow:model];
    return rowHeight;
}

- (UIView*)tableFooterView{
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 90)];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, 0, kScreen_Width - 18 * 2, 40)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_loginout"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"退出" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn addTarget:self action:@selector(loginOutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setCenter:footerV.center];
    [footerV addSubview:loginBtn];
    return footerV;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommonCellModel *model = userInfoArray[indexPath.row];
    switch (indexPath.row) {
        case 1:{
            //修改头像
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
            actionSheet.tag = 22;
            [actionSheet showInView:self.view];
        }
            break;
        case 3:{
            //修改昵称
            SettingTextViewController *settingTextVc = [SettingTextViewController settingTextVCWithTitle:@"修改昵称" textValue:model.content keyBoardType:UIKeyboardTypeDefault doneBlock:^(NSString *textValue) {
                
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",USER_URL,REVISE_NAME_CODE];
                NSDictionary *parmeter = @{@"user":UserDefaultEntity.userInfo.user,@"newName":textValue};
                [HUDMANAGER showStateQueryMessageContent:@"正在修改个人信息..."];
                [NETWORKINGMANAGER requestDataMethod:Post withUrl:urlStr withParmeter:parmeter requestSuccess:^(NSDictionary *dataDic) {
                    [HUDMANAGER showStateMessageType:Success withContent:@"个人信息修改成功"];
                    model.content = textValue;
                    [UserDefaultEntity.userHeads removeObjectForKey:UserDefaultEntity.userInfo.user];
                    [UserDefaultEntity saveUserDefault];
                    UserDefaultEntity.userInfo.user = textValue;
                    [UserDefaultEntity.userHeads setObject:UserDefaultEntity.userInfo.head forKey:textValue];
                    [UserDefaultEntity saveUserDefault];
                    [self.userInfoTableView reloadData];
                    
                } requestFailure:^(NSString *errorMessage) {
                    [HUDMANAGER showStateMessageType:Error withContent:errorMessage];
                }];
                
            }];
            [self.navigationController pushViewController:settingTextVc animated:YES];
        }
            break;
        case 4:{
            //修改性别
            NSInteger index = [USER_SEX_TYPE_ARR indexOfObject:model.content];
            NSNumber *curType = [NSNumber numberWithUnsignedInteger:index];
            [ActionSheetStringPicker showPickerWithTitle:nil rows:@[USER_SEX_TYPE_ARR] initialSelection:@[curType] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                
                NSInteger index = [[selectedIndex firstObject] integerValue];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",USER_URL,REVISE_SEX_CODE];
                
                int newSex = (int)index;
                NSDictionary *parmeter = @{@"user":UserDefaultEntity.userInfo.user,@"newSex":@(newSex)};
                [HUDMANAGER showStateQueryMessageContent:@"正在修改个人信息..."];
                [NETWORKINGMANAGER requestDataMethod:Post withUrl:urlStr withParmeter:parmeter requestSuccess:^(NSDictionary *dataDic) {
                    [HUDMANAGER showStateMessageType:Success withContent:@"个人信息修改成功"];
                    model.content = USER_SEX_TYPE_ARR[index];
                    UserDefaultEntity.userInfo.sex = (int)index;
                    [UserDefaultEntity saveUserDefault];
                    
                    [self.userInfoTableView reloadData];
                } requestFailure:^(NSString *errorMessage) {
                    [HUDMANAGER showStateMessageType:Error withContent:errorMessage];
                }];
            
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }
            break;
        case 5:{
            //修改生日
            NSDate *date = [DateFormatter stringToDateCustom:model.content formatString:kNSDateHelperFormatSQLDate];
            [ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:date doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                
                NSString *newBirthday = [DateFormatter dateToStringCustom:selectedDate formatString:kNSDateHelperFormatSQLDate];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",USER_URL,REVISE_BIRTHDAY_CODE];
                NSDictionary *parmeter = @{@"user":UserDefaultEntity.userInfo.user,@"newBirthday":newBirthday};
                
                [HUDMANAGER showStateQueryMessageContent:@"正在修改个人信息..."];
                [NETWORKINGMANAGER requestDataMethod:Post withUrl:urlStr withParmeter:parmeter requestSuccess:^(NSDictionary *dataDic) {
                    [HUDMANAGER showStateMessageType:Success withContent:@"个人信息修改成功"];
                    model.content = newBirthday;
                    UserDefaultEntity.userInfo.birthday = newBirthday;
                    [UserDefaultEntity saveUserDefault];
                    
                    [self.userInfoTableView reloadData];
                } requestFailure:^(NSString *errorMessage) {
                    [HUDMANAGER showStateMessageType:Error withContent:errorMessage];
                }];
                
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                
            } origin:self.view];
        }
            break;
        case 6:{
            //修改手机号
        }
            break;
        case 8:{
            //修改密码
            SettingPwdViewController *settingPwdVc = [[SettingPwdViewController alloc] init];
            [self.navigationController pushViewController:settingPwdVc animated:YES];
        }
            break;
        default:
            break;
    }
}

//退出登录
- (void)loginOutBtnClicked{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要退出当前账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定退出" otherButtonTitles: nil];
    actionSheet.tag = 11;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 11) {
        if (buttonIndex == 0) {
            //清除登录信息
            UserDefaultEntity.isLogin = NO;
            [UserDefaultEntity saveUserDefault];
            [TGFNewsAppDelegate showLoginViewController];
        }
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        if (buttonIndex == 0) {
            //拍照
            if ([Helper checkCameraAuthorizationStatus]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];//进入照相界面
            }
        }
        else if (buttonIndex == 1) {
            //从相册中选取
            if ([Helper checkPhotoLibraryAuthorizationStatus]) {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];//进入相册界面
            }
        }
    }
}

//修改头像
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //上传图片
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",USER_URL,UPLOAD_HEAD_CODE];
    NSDictionary *parmeter = @{@"user":UserDefaultEntity.userInfo.user,@"file":image};
    [HUDMANAGER showStateQueryMessageContent:@"上传图片中..."];
    [NETWORKINGMANAGER uploadImageWithUrl:urlStr parameters:parmeter image:image RequestSuccess:^(NSDictionary *dataDic) {
        [HUDMANAGER showStateMessageType:Success withContent:@"修改头像成功"];
        //存储新的图片路径
        UserDefaultEntity.userInfo.head = [dataDic objectForKey:@"head"];
        //将用户的图像地址和用户名对应存入本地
        [UserDefaultEntity.userHeads setObject:UserDefaultEntity.userInfo.head forKey:UserDefaultEntity.userInfo.user];
        [UserDefaultEntity saveUserDefault];
        //刷新数据
        CommonCellModel *headModel = [[CommonCellModel alloc] initWithType:ESettingImage withTitle:@"头像" withContent:image];
        [userInfoArray replaceObjectAtIndex:1 withObject:headModel];
        [self.userInfoTableView reloadData];
        
    } RequestFailure:^(NSString *errorMessage) {
        [HUDMANAGER showStateMessageType:Error withContent:errorMessage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
