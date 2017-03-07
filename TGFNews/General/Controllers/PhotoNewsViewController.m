//
//  PhotoNewsViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "CycleScrollView.h"
#import "PhotoNewsViewController.h"
#import "PhotoSetDetailsEntity.h"
#import "UILabel+Rich.h"
#import <MJExtension.h>
#import <UMSocial.h>
#import <MMDrawerController.h>
#import "AppDelegate.h"

#import "GFImageView.h"

@interface PhotoNewsViewController ()<UMSocialUIDelegate> {
    PhotoSetDetailsEntity* photoSetEntiy;
    NSMutableArray* photoSetArray;
    CycleScrollView* cycScrollView;
    BOOL isHideAnnexView;
}

@property (weak, nonatomic) IBOutlet UIView* topView;
@property (weak, nonatomic) IBOutlet UIView* bottonView;
@property (weak, nonatomic) IBOutlet UIView* adView;
@property (weak, nonatomic) IBOutlet UIView* descibeView;

@property (weak, nonatomic) IBOutlet UILabel* lbTitle;
@property (weak, nonatomic) IBOutlet UILabel* lbMark;
@property (weak, nonatomic) IBOutlet UILabel* lbContent;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

- (IBAction)backAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)collectAction:(id)sender;

@end

@implementation PhotoNewsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestPhotoSetData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descibeView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.682];
    
    if ([UserDefaultEntity.collectArray containsObject:_entity]) {
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn_yet_collect"] forState:UIControlStateNormal];
    }
    else {
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn_collect"] forState:UIControlStateNormal];
    }
    
    self.lbTitle.dk_textColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    self.lbContent.dk_textColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)requestPhotoSetData {
    //提前获得约束后的adview的bounds
    [self.adView setNeedsLayout];
    [self.adView layoutIfNeeded];

    cycScrollView = [[CycleScrollView alloc] initWithFrame:self.adView.bounds];
    cycScrollView.isHidePage = YES; //隐藏pageControl
    [self.adView insertSubview:cycScrollView atIndex:0];
    
    self.descibeView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.6];
    self.lbTitle.text = self.entity.title; //设置标题

    // 取出关键字
    NSString* one = self.entity.photosetID;
    NSString* two = [one substringFromIndex:4];
    NSArray* three = [two componentsSeparatedByString:@"|"];
    
    NSString* urlStr = [NSString stringWithFormat:@"%@photo/api/set/%@/%@.json", NEWS_URL, [three firstObject], [three lastObject]];
    [NETWORKINGMANAGER requestDataMethod:Get withUrl:urlStr withParmeter:nil requestSuccess:^(NSDictionary* dataDic) {
        photoSetArray = [PhotoSetDetailsEntity mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"photos"] context:nil];
        [self configureImageView];
    }
        requestFailure:^(NSString* errorMessage){
    }];
}

//设置页面的ImageView
- (void)configureImageView {
    NSMutableArray* adArray = (NSMutableArray*)photoSetArray;
    __weak typeof(self) weakSelf = self;
    //下面两个block需放在totalPagesCount之前执行，才能加载出首次数据
    cycScrollView.fetchContentViewAtIndex = ^UIView*(NSInteger pageIndex) {
        GFImageView* imageView = [[GFImageView alloc] initWithFrame:weakSelf.adView.bounds];
        PhotoSetDetailsEntity* entity = adArray[pageIndex];
        imageView.url = [NSURL URLWithString:entity.imgurl];
        return imageView;
    };

    cycScrollView.CurPageIndexBolck = ^(NSInteger curPageIndex) {
        PhotoSetDetailsEntity* entity = adArray[curPageIndex];
        weakSelf.lbContent.text = entity.note;
        weakSelf.lbMark.text = [NSString stringWithFormat:@"%ld/%lu", (long)curPageIndex + 1, (unsigned long)adArray.count];
        NSRange range = [weakSelf.lbMark.text rangeOfString:@"/"];
        [weakSelf.lbMark richTextRange:NSMakeRange(0, range.location) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16] wtihColor:[UIColor whiteColor]];
    };

    cycScrollView.totalPagesCount = ^NSInteger(void) {
        return adArray.count;
    };

    cycScrollView.TapActionBlock = ^(NSInteger pageIndex) {
        //延迟0.5秒执行
        [weakSelf performSelector:@selector(isHideAnnexView) withObject:nil afterDelay:0.5];
    };
}

//设置附件view的隐藏与显示
- (void)isHideAnnexView {
    isHideAnnexView = !isHideAnnexView;
    self.topView.hidden = isHideAnnexView;
    self.bottonView.hidden = isHideAnnexView;
    self.descibeView.hidden = isHideAnnexView;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    //分享
    [UMSocialSnsService presentSnsIconSheetView:self appKey:nil shareText:_entity.title shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToDouban,UMShareToEmail,UMShareToSms,nil] delegate:self];
}

- (IBAction)collectAction:(id)sender {
    //收藏
    if (![UserDefaultEntity.collectArray containsObject:_entity]) {
        //如果新闻没被收藏
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn_yet_collect"] forState:UIControlStateNormal];
        [UserDefaultEntity.collectArray addObject:_entity];
        [UserDefaultEntity saveUserDefault];
        [HUDMANAGER showAlertMessageContent:@"收藏成功"];
    }
    else {
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn_collect"] forState:UIControlStateNormal];
        [UserDefaultEntity.collectArray removeObject:_entity];
        [UserDefaultEntity saveUserDefault];
        [HUDMANAGER showAlertMessageContent:@"已取消收藏"];
    }
    if (_cancelCollectBlock) {
        //如果blcok不为空，且数据有变化，进行回调
        _cancelCollectBlock();
    }
}

/**
 *  3D Touch 上移显示的视图
 */
-(NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        //要进行分享，必须先进入到当前控制器来进行操作，所以先push到当前控制器
        MMDrawerController *drawerC = (MMDrawerController *)TGFNewsAppDelegate.window.rootViewController;
        UINavigationController *centerNaviationC = (UINavigationController *)(drawerC.centerViewController);
        [centerNaviationC pushViewController:self animated:YES];
        //分享
        [self shareAction:nil];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        //收藏
        [self collectAction:nil];
    }];
    
    //想要显示多个就定义多个 UIPreviewAction
    NSArray *actions = @[action1,action2];
    return actions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
