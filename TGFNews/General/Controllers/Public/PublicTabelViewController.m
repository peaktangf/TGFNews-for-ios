//
//  PublicTabelViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/27.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "CollectCell.h"
#import "FontSettingCell.h"
#import "NewsDetailsViewController.h"
#import "PhotoNewsViewController.h"
#import "PublicTabelViewController.h"
#import "SearchViewController.h"
#import "WMMenuView.h"
#import "WeatherCell.h"
#import "HintView.h"

@interface PublicTabelViewController () <UITableViewDelegate, UITableViewDataSource, WMMenuViewDelegate> {
    HintView *hintView;
}

@property (weak, nonatomic) IBOutlet UITableView* publicTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* topConstraint;
- (IBAction)addCityAction:(id)sender;
@end

@implementation PublicTabelViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _navTitle;
    self.publicTableView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_TABLESECTION_BG], [UIColor colorWithHexString:NIGHT_BACKGROUND]);
    //初始化提示View
    hintView = [[HintView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - 35)];
    
    if ([_markStr isEqualToString:@"weather"]) {

        NSMutableArray* array = [NSMutableArray arrayWithArray:UserDefaultEntity.cityArray];
        [array insertObject:UserDefaultEntity.locationCity atIndex:0];

        _objArray = [NSArray arrayWithArray:array];

        NSLog(@"%@,%@,%@", UserDefaultEntity.cityArray, UserDefaultEntity.locationCity, _objArray);
    }
    if ([_markStr isEqualToString:@"collect"]) {

        self.navigationItem.rightBarButtonItem = nil;
        self.topConstraint.constant = 35;
        //添加滚动菜单视图
        [self addMenuView];
        
        [self collectSetObjDataWith:NO];
    }
    if ([_markStr isEqualToString:@"setting"]) {
        self.navigationItem.rightBarButtonItem = nil;
        _objArray = NEWS_BODY_FONT_MARK;
    }
}

//设置收藏列表的数据
- (void)collectSetObjDataWith:(BOOL)isPhoto {
    
    //对数组进行过滤 skipType 属性为 photoset
    NSString *skipTypePath = @"skipType";
    NSPredicate* prediate;
    
    if (isPhoto) {
        prediate = [NSPredicate predicateWithFormat:@"%K == 'photoset'", skipTypePath];
    }
    else {
        prediate = [NSPredicate predicateWithFormat:@"%K != 'photoset'", skipTypePath];
    }
    _objArray = [UserDefaultEntity.collectArray filteredArrayUsingPredicate:prediate];
}

//添加滚动菜单视图
- (void)addMenuView
{
    CGRect frame = CGRectMake(0, 0, kScreen_Width, 35);
    WMMenuView* menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:@[@"文章", @"图片" ] backgroundColor:[UIColor whiteColor] norSize:13 selSize:16 norColor:[UIColor blackColor] selColor:[UIColor colorWithHexString:NORMAL_NAVBAR]];
    menuView.delegate = self;
    [self.view addSubview:menuView];
}

#pragma mark -WMMenuViewDelegate
- (void)menuView:(WMMenuView*)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex
{
    if (index == 0) {
        [self collectSetObjDataWith:NO];
    }
    else {
        [self collectSetObjDataWith:YES];
    }
    [self.publicTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_objArray.count == 0) {
        return 1;
    }
    return _objArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = nil;

    if (_objArray.count == 0) {
        UITableViewCell *hintCell = [tableView dequeueReusableCellWithIdentifier:@"hintCell"];
        if (hintCell == nil) {
            hintCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hintCell"];
            hintView.hintStr = [NSString stringWithFormat:@"你还没收藏新闻\n赶快去收藏你喜欢的新闻吧！"];
            [hintCell addSubview:hintView];
            hintCell.userInteractionEnabled = NO;
        }
        cell = hintCell;
    }
    else {
        if ([_markStr isEqualToString:@"collect"]) {
            //收藏
            NewsEntity* entity = _objArray[indexPath.row];
            NSString* Id = [CollectCell idForRow:entity];
            CollectCell* collectCell = [tableView dequeueReusableCellWithIdentifier:Id];
            collectCell.entity = entity;
            cell = collectCell;
        }
        else if ([_markStr isEqualToString:@"weather"]) {
            //天气城市
            WeatherCell* weatherCell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCell"];
            weatherCell.city = _objArray[indexPath.row];
            cell = weatherCell;
        }
        else if ([_markStr isEqualToString:@"setting"]) {
            //字号设置
            FontSettingCell* fontCell = [tableView dequeueReusableCellWithIdentifier:@"FontSettingCell"];
            fontCell.lbTitle.text = _objArray[indexPath.row];
            
            if ([fontCell.lbTitle.text isEqualToString:UserDefaultEntity.newsFont]) {
                fontCell.imgMark.hidden = NO;
            }
            else {
                fontCell.imgMark.hidden = YES;
            }
            cell = fontCell;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (_objArray.count == 0) {
        return kScreen_Height - 64 - 35;
    }
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([_markStr isEqualToString:@"collect"]) {
        //收藏
        NewsEntity* entity = _objArray[indexPath.row];
        return [CollectCell heightForRow:entity];
    }
    return cell.frame.size.height;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_objArray.count != 0) {
        if ([_markStr isEqualToString:@"collect"]) {
            //收藏
            NewsEntity* entity = _objArray[indexPath.row];
            UIViewController* vc;
            if ([entity.skipType isEqualToString:@"photoset"]) {
                PhotoNewsViewController* photoNewsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoNewsViewController"];
                photoNewsVc.entity = entity;
                photoNewsVc.cancelCollectBlock = ^{
                    [self collectSetObjDataWith:YES];
                    [self.publicTableView reloadData];
                };
                vc = photoNewsVc;
            }
            else {
                NewsDetailsViewController* newsDetailsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailsViewController"];
                newsDetailsVc.entity = entity;
                newsDetailsVc.cancelCollectBlock = ^{
                    [self collectSetObjDataWith:NO];
                    [self.publicTableView reloadData];
                };
                vc = newsDetailsVc;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([_markStr isEqualToString:@"weather"]) {
            //天气
            if (_clickBlock) {
                _clickBlock(_objArray[indexPath.row]);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else if ([_markStr isEqualToString:@"setting"]) {
            //字号设置
            if (![_objArray[indexPath.row] isEqualToString:UserDefaultEntity.newsFont]) {
                UserDefaultEntity.newsFont = _objArray[indexPath.row];
                [UserDefaultEntity saveUserDefault];
                [self.publicTableView reloadData];
            }
        }
    }
}

//删除天气城市
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && [_markStr isEqualToString:@"weather"]) {

        NSString* cityName = _objArray[indexPath.row];

        if ([cityName isEqualToString:UserDefaultEntity.locationCity]) {
            [HUDMANAGER showAlertMessageContent:@"不能删除当前城市"];
        }
        else {
            [UserDefaultEntity.cityArray removeObject:cityName];
            [UserDefaultEntity saveUserDefault];
            NSMutableArray* array = [NSMutableArray arrayWithArray:UserDefaultEntity.cityArray];
            [array insertObject:UserDefaultEntity.locationCity atIndex:0];
            _objArray = [NSArray arrayWithArray:array];
            [self.publicTableView reloadData];
        }
    }
}

- (IBAction)addCityAction:(id)sender
{
    //添加天气城市
    SearchViewController* searchVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchVc.dismissBlock = ^{
        NSMutableArray* array = [NSMutableArray arrayWithArray:UserDefaultEntity.cityArray];
        [array insertObject:UserDefaultEntity.locationCity atIndex:0];
        _objArray = [NSArray arrayWithArray:array];
        [self.publicTableView reloadData];
    };
    [self presentViewController:searchVc animated:YES completion:nil];
    NSLog(@"添加天气城市");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
