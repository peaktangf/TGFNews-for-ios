//
//  SearchViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/21.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "SearchViewController.h"
#import "HotCityCell.h"
#import "LocationManage.h"
#import "CityListEntity.h"
#import <MJExtension.h>
#import "UILabel+Rich.h"

@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *hotCityArray;
    NSArray *hotCityIdArray;
    NSMutableArray *searchArray;
    NSString *curSearchText;
}

@property (weak, nonatomic) IBOutlet UIButton *beginSearchButton;
@property (weak, nonatomic) IBOutlet UICollectionView *hotCityCollectionView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

- (IBAction)beginSearchAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //让tableview空得cell不显示线条出来（绝招）
    self.searchTableView.tableFooterView = [UIView new];
    
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor colorWithHexString:@"#c3c3c1"]);
    self.bottomView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor colorWithHexString:@"#c3c3c1"]);
    
    [self.bottomTitleLabel richTextRange:NSMakeRange(5, 2) withFont:[UIFont fontWithName:@"HelveticaNeue" size:12] wtihColor:[UIColor colorWithHexString:NORMAL_NAVBAR]];
    
    //隐藏背景
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self.searchBar setTranslucent:YES];
    
    hotCityArray = @[@"定位",@"北京市",@"天津市",@"上海市",@"重庆市",@"沈阳市",@"大连市",@"长春市",@"哈尔滨市",@"郑州市",@"武汉市",@"长沙市",@"广州市",@"深圳市",@"南京市"];
    hotCityIdArray = @[];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return hotCityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotCityCell" forIndexPath:indexPath];
    cell.cityname = hotCityArray[indexPath.row];
    return cell;
}

#pragma makr - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //定位
        [HUDMANAGER showLoadingMessageToView:self.view];
        [LOCATIONMANAGER starLocationSuccess:^(CLPlacemark *locationInfo) {
            //定位成功后
            
            _dismissBlock();
            [self dismissViewControllerAnimated:YES completion:nil];
        } Failure:^(NSString *failureMessage) {
            [HUDMANAGER dismissLoadingMessage];
            [HUDMANAGER showAlertMessageContent:@"定位失败！"];
        }];
    }
    else {
        NSString *cityName = hotCityArray[indexPath.row];
        [hotCityArray[indexPath.row] stringByReplacingOccurrencesOfString:@"市" withString:@""];
        if (![UserDefaultEntity.cityArray containsObject:cityName]) {
            [UserDefaultEntity.cityArray addObject:cityName];
            [UserDefaultEntity saveUserDefault];
            _dismissBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityListEntity *entity = searchArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    NSString *city = [NSString stringWithFormat:@"%@,%@,%@",entity.name_cn,entity.district_cn,entity.province_cn];
    NSRange range = [city rangeOfString:curSearchText];
    cell.textLabel.text = city;
    [cell.textLabel richTextRange:range withFont:[UIFont fontWithName:@"HelveticaNeue" size:17] wtihColor:[UIColor colorWithHexString:NORMAL_NAVBAR]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CityListEntity *entity = searchArray[indexPath.row];
    
    if (![UserDefaultEntity.cityArray containsObject:entity.name_cn] && ![UserDefaultEntity.locationCity isEqualToString:entity.name_cn]) {
        [UserDefaultEntity.cityArray addObject:entity.name_cn];
        [UserDefaultEntity saveUserDefault];
        _dismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);
    curSearchText = searchText;
    //查询可用天气城市
    [HUDMANAGER showLoadingMessageToView:self.view];
    NSString *address = [NSString stringWithFormat:@"%@citylist",WEATHER_URL];
    [NETWORKINGMANAGER requestDataMethod:Get withUrl:address withParmeter:@{@"cityname":searchText} requestSuccess:^(NSDictionary *dataDic) {
        NSLog(@"%@",dataDic);
        [HUDMANAGER dismissLoadingMessage];
        searchArray = [CityListEntity mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"retData"]];
        [self.searchTableView reloadData];
    } requestFailure:^(NSString *errorMessage) {
        [HUDMANAGER dismissLoadingMessage];
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.beginSearchButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.scrollView setContentOffset:CGPointMake(0, self.topImageView.frame.size.height - 64 - 20) animated:YES];
    self.scrollView.scrollEnabled = NO;
    [self performSelector:@selector(showSearchTableView) withObject:nil afterDelay:0.1];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    [self.beginSearchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchBar.text = @"";
    self.scrollView.scrollEnabled = YES;
    self.scrollView.scrollsToTop = YES;
    [self performSelector:@selector(hidenSearchTableView) withObject:nil afterDelay:0.1];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

//点击searchTableView时结束编辑
- (void)tResignFirstResponder {
    if (searchArray.count == 0) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)showSearchTableView {
    self.searchTableView.hidden = NO;
}

- (void)hidenSearchTableView {
    self.searchTableView.hidden = YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 11) {
        
        //获取偏移量
        CGFloat offsetY = scrollView.contentOffset.y;
//        NSLog(@"===  %f",offsetY);
        
        //向上滚动时隐藏返回按钮
        self.backButton.alpha = offsetY > 5 ? 0 : 1;
        
        //label文字透明度逐渐变化
        self.topTitleLabel.alpha = offsetY > 0 ? 1- offsetY/150 : 1;
        self.bottomTitleLabel.alpha = offsetY > 0 ? 1- offsetY/150 : 1;
        
        //topImageView等比例的伸缩
        CGFloat scale= 1-(offsetY/100);
        scale = (scale>=1)?scale :1;
        self.topImageView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (IBAction)beginSearchAction:(id)sender {
    
    NSString *titleStr = self.beginSearchButton.titleLabel.text;
    if ([titleStr isEqualToString:@"搜索"]) {
        [self.searchBar becomeFirstResponder];
    }
    else {
        [self.searchBar resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
