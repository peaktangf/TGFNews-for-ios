//
//  LeftViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/26.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "LeftViewController.h"
#import <MJExtension.h>
#import <BlocksKit+UIKit.h>
#import "PublicTabelViewController.h"
#import "AboutViewController.h"
#import "UserCenterViewController.h"
#import "MainNewsViewController.h"
#import <MMDrawerController.h>

#import "CommonCellModel.h"
#import "CommonTableViewCell.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *leftDataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation LeftViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDataChaceShow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImageView.dk_imagePicker = DKImageWithImages([UIImage imageNamed:@"img_left_bg"], [UIImage imageNamed:@"img_left_night_bg"]);
    [self initData];
}

- (void)initData {
    
    //获取缓存
    NSString *chaceSize = [NSString stringWithFormat:@"%.1f MB",[[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0];
    
    CommonCellModel *userCenterModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"个人资料" withContent:nil];
    CommonCellModel *collectionModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"我的收藏" withContent:nil];
    CommonCellModel *weatherModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"天气城市" withContent:nil];
    CommonCellModel *nightModel = [[CommonCellModel alloc] initWithType:ESwitch withTitle:@"夜间模式" withContent:[NSString stringWithFormat:@"%d",UserDefaultEntity.isNight]];
    CommonCellModel *dumpModel = [[CommonCellModel alloc] initWithType:EContent withTitle:@"清除缓存" withContent:chaceSize];
    CommonCellModel *aboutModel = [[CommonCellModel alloc] initWithType:ESettingText withTitle:@"关于看呀" withContent:nil];
    
    leftDataArray = [[NSMutableArray alloc] initWithObjects:userCenterModel,collectionModel,weatherModel,nightModel,dumpModel,aboutModel, nil];
    [self.leftTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return leftDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCellModel *model = leftDataArray[indexPath.row];
    NSString *Id = [CommonTableViewCell idForRow:model];
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:Id owner:nil options:nil] firstObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.contentLabel.textColor = [UIColor whiteColor];
    }
    if (indexPath.row == 3) {
        cell.switchValueChangeBlock = ^(BOOL isOn){
            model.content = [NSString stringWithFormat:@"%d",isOn];
            if (isOn) {
                [DKNightVersionManager nightFalling];
            }
            else {
                [DKNightVersionManager dawnComing];
            }
            UserDefaultEntity.isNight = isOn;
            [UserDefaultEntity saveUserDefault];
        };
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *Vc = nil;
    
    switch (indexPath.row) {
        case 0:{
            //个人中心
            UserCenterViewController *userCenterVc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserCenterViewController"];
            Vc = userCenterVc;
        }
            break;
        case 1:{
            //本地收藏
            PublicTabelViewController *publicTableVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PublicTabelViewController"];
            publicTableVc.navTitle = @"我的收藏";
            publicTableVc.markStr = @"collect";
            Vc = publicTableVc;
        }
            break;
        case 2:{
            //天气城市
            PublicTabelViewController *publicTableVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PublicTabelViewController"];
            publicTableVc.navTitle = @"天气城市";
            publicTableVc.markStr = @"weather";
            Vc = publicTableVc;
        }
            break;
        case 3:
            break;
        case 4:{
            //清除缓存
            [UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:@"您确定要清除缓存吗！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[SDImageCache sharedImageCache] clearDisk];
                    [self reloadDataChaceShow];
                    [HUDMANAGER showAlertMessageContent:@"清除缓存成功"];
                }
            }];
        }
            break;
        default:{
            //关于
            AboutViewController *aboutVc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
            Vc = aboutVc;
        }
            break;
    }
        if (Vc) {
            //从中心视图的导航控制器推出
            MMDrawerController *drawerC = (MMDrawerController *)TGFNewsAppDelegate.window.rootViewController;
            UINavigationController *centerNaviationC = (UINavigationController *)(drawerC.centerViewController);
            //关闭侧栏
            [drawerC closeDrawerAnimated:YES completion:nil];
            //推出控制器
            [centerNaviationC pushViewController:Vc animated:NO];
        }
        
}

- (void)reloadDataChaceShow {
    CommonCellModel *model = leftDataArray[4];
    model.content = [NSString stringWithFormat:@"%.1f MB",[[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0];
    [self.leftTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
