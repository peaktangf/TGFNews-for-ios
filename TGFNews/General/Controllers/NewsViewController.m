//
//  NewsViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/19.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailsViewController.h"
#import "PhotoNewsViewController.h"
#import "CycleScrollView.h"
#import "NewsCell.h"
#import <MJExtension.h>
#import "NewsEntity.h"
#import "AdsEntity.h"

/**
 刷新类型
 */
typedef enum : NSUInteger {
    EPullDown = 0,
    EPullUp,
} ERefreshType;

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIViewControllerPreviewingDelegate> {
    CycleScrollView *cycScrollView;
    NSIndexPath *selectedPath;
    CGRect sourceRect;
}

@property (nonatomic, strong) NSMutableArray *newsArray;

@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UILabel *lbAdTitle;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册3D Touch,先判断是否可用
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
         NSLog(@"3D Touch  可用!");
        //注册
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }else{
        NSLog(@"3D Touch 无效");
    }
    
    self.newsTableView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_TABLESECTION_BG], [UIColor colorWithHexString:NIGHT_BACKGROUND]);
    self.lbAdTitle.dk_textColorPicker =  DKColorWithColors([UIColor whiteColor], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    //第一次加载的时候隐藏adView
    self.adView.hidden = YES;
    //添加广告栏视图
    cycScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 180)];
    [self.adView insertSubview:cycScrollView atIndex:0];
    //下拉刷新集成
    self.newsTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestNewsDataForType:EPullDown];
    }];
    //集成上拉加载更多
    self.newsTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestNewsDataForType:EPullUp];
    }];
    
    //隐藏上拉控件
    self.newsTableView.footer.hidden = YES;
    //第一次进入时请求数据
    [self.newsTableView.header beginRefreshing];
}

//数据请求
- (void)requestNewsDataForType:(ERefreshType)type {
    
    NSRange range = [self.url rangeOfString:@"/"];
    NSString *key = [self.url substringFromIndex:range.location + 1];
    
    if (type == EPullDown) {
        NSString *urlStr = [NSString stringWithFormat:@"%@nc/article/%@/0-20.html",NEWS_URL,self.url];
        [NETWORKINGMANAGER requestDataMethod:Get withUrl:urlStr withParmeter:nil requestSuccess:^(NSDictionary *dataDic) {
            
            //结束下拉
            [self.newsTableView.header endRefreshing];
            //加载成功后显示adView
            self.adView.hidden = NO;
            _newsArray = [NewsEntity mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:key]];
            
            //判断是否隐藏上拉控件
            self.newsTableView.footer.hidden = _newsArray.count > 10 ? NO : YES;
            
            [self configureAdView:[_newsArray firstObject]];
            [self.newsTableView reloadData];
        } requestFailure:^(NSString *errorMessage) {
            [self.newsTableView.header endRefreshing];
        }];
    }
    else {
        NSString *urlStr = [NSString stringWithFormat:@"%@nc/article/%@/%lu-20.html",NEWS_URL,self.url,(_newsArray.count - _newsArray.count % 10)];
        [NETWORKINGMANAGER requestDataMethod:Get withUrl:urlStr withParmeter:nil requestSuccess:^(NSDictionary *dataDic) {
            //结束上拉
            [self.newsTableView.footer endRefreshing];
            NSMutableArray *array = [NewsEntity mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:key]];
            [_newsArray addObjectsFromArray:array];
            [self.newsTableView reloadData];
        } requestFailure:^(NSString *errorMessage) {
            [self.newsTableView.footer endRefreshing];
        }];
    }
}

//设置广告栏视图
- (void)configureAdView:(NewsEntity *)newsEntnty {
    
    NSMutableArray *adArray = [AdsEntity mj_objectArrayWithKeyValuesArray:newsEntnty.ads context:nil]?:[NSMutableArray array];//如果数组为空就array
    
    //将AdsEntity模型数组转换成NewsEntity模型数组
    for (int i = 0; i < adArray.count; i ++) {
        
        AdsEntity *adEntity = adArray[i];
        NewsEntity *neEntity = [[NewsEntity alloc] init];
        
        neEntity.title = adEntity.title;
        neEntity.imgsrc = adEntity.imgsrc;
        neEntity.skipType = adEntity.tag;
        neEntity.photosetID = adEntity.url;
        neEntity.docid = adEntity.url;
        [adArray replaceObjectAtIndex:i withObject:neEntity];
    }
    [adArray insertObject:newsEntnty atIndex:0];
    
    __weak typeof(self) weakSelf = self;
    //下面两个block需放在totalPagesCount之前执行，才能加载出首次数据
    cycScrollView.fetchContentViewAtIndex = ^UIView*(NSInteger pageIndex) {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, kScreen_Width, 180);
        
        NewsEntity *entity = adArray[pageIndex];
        [imageView sd_setImageWithURL:[NSURL URLWithString:entity.imgsrc] placeholderImage:nil];
        return imageView;
    };
    
    cycScrollView.CurPageIndexBolck = ^(NSInteger curPageIndex) {
        NewsEntity *entity = adArray[curPageIndex];
        weakSelf.lbAdTitle.text = entity.title;
    };
    
    cycScrollView.totalPagesCount = ^NSInteger(void) {
        return adArray.count;
    };
    
    cycScrollView.TapActionBlock = ^(NSInteger pageIndex) {
        
        UIViewController *vc = nil;
        //NewsEntity * = [[NewsEntity alloc] init];
        
        NewsEntity *entity = adArray[pageIndex];
        
        if ([entity.skipType isEqualToString:@"photoset"]) {
            PhotoNewsViewController *photoNewsVc = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"PhotoNewsViewController"];
            photoNewsVc.entity = entity;
            vc = photoNewsVc;
        }
        else {
            NewsDetailsViewController *newsDetailsVc = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailsViewController"];
            newsDetailsVc.entity = entity;
            vc = newsDetailsVc;
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsArray.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsEntity *entity = _newsArray[indexPath.row + 1];
    NSString *Id = [NewsCell idForRow:entity];
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    [cell configurNewsEntity:entity];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsEntity *entity = _newsArray[indexPath.row + 1];
    CGFloat rowHeight = [NewsCell heightForRow:entity];
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsEntity *entity = _newsArray[indexPath.row + 1];
    UIViewController *vc;
    if ([entity.skipType isEqualToString:@"photoset"]){
        PhotoNewsViewController *photoNewsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoNewsViewController"];
        photoNewsVc.entity = entity;
        vc = photoNewsVc;
    }else{
        NewsDetailsViewController *newsDetailsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailsViewController"];
        newsDetailsVc.entity = entity;
        vc = newsDetailsVc;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIViewControllerPreviewingDelegate
/**
 *  peek手势（预览）
 */
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    
    //获取用户手势点所在cell的下标。同时判断手势点是否超出tableView响应范围。
    if (![self getShouldShowRectAndIndexPathWithLocation:location]) return nil;
    //弹出视图的初始位置，sourceRect是peek触发时的高亮区域。这个区域内的View会高亮显示，其余的会模糊掉
    previewingContext.sourceRect = sourceRect;
    
    //获取数据进行传值
    UIViewController *childVc = nil;
    NewsEntity *entity = _newsArray[selectedPath.row + 1];
    if ([entity.skipType isEqualToString:@"photoset"]){
        PhotoNewsViewController *photoNewsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoNewsViewController"];
        photoNewsVc.entity = entity;
        childVc = photoNewsVc;
    }else{
        NewsDetailsViewController *newsDetailsVc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailsViewController"];
        newsDetailsVc.entity = entity;
        childVc = newsDetailsVc;
    }
    return childVc;
}

/**
 *  pop手势（跳转）
 */
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    [self tableView:self.newsTableView didSelectRowAtIndexPath:selectedPath];
}


/**
 *  获取用户手势点所在cell的下标，同时判断手势点是否超出tableview的范围
 */
- (BOOL)getShouldShowRectAndIndexPathWithLocation:(CGPoint)location {
    //坐标点的转换(将当前点击的位置坐标从self.view上转换到newsTableView上)
    CGPoint tableLocation = [self.view convertPoint:location toView:self.newsTableView];
    selectedPath = [self.newsTableView indexPathForRowAtPoint:tableLocation];
    //位置转换(将cell在newsTableView上的位置转换到self.view上)
    CGRect rectInTableView = [self.newsTableView rectForRowAtIndexPath:selectedPath];
    CGRect rect = [self.newsTableView convertRect:rectInTableView toView:self.view];
    //将该区域设置为sourceRect
    sourceRect = rect;
    //如果row越界了，返回NO 不处理peek手势
    NSLog(@"当前所在的行---%zd",selectedPath.row);
    return (selectedPath.row >= (_newsArray.count) || !selectedPath) ? NO : YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
