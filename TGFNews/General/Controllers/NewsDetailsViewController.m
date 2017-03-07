//
//  NewsDetailsViewController.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "NewsDetailsEntity.h"
#import "ActionSheetStringPicker.h"
#import "UILabel+Rich.h"
#import "NSString+CutWeather.h"
#import <UMSocial.h>
#import <MMDrawerController.h>
#import "AppDelegate.h"


@interface NewsDetailsViewController ()<UIWebViewDelegate,UMSocialUIDelegate> {
    NewsDetailsEntity *detailsEntity;
    BOOL isNight;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *bottonView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

- (IBAction)backAction:(id)sender;
- (IBAction)fontAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)collectAction:(id)sender;

@end

@implementation NewsDetailsViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!UserDefaultEntity.isNight) {
        //设置状态栏文字为黑色
        [self setStateBarTitleColor:UIStatusBarStyleDefault];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //设置状态栏字体颜色(默认设置为白色)
    [self setStateBarTitleColor:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.hidden = YES;
    self.webView.delegate = self;
    
    if ([UserDefaultEntity.collectArray containsObject:_entity]) {
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn_yet_collect"] forState:UIControlStateNormal];
    }
    else {
        [self.collectBtn setBackgroundImage:[UIImage imageNamed:@"btn_collect"] forState:UIControlStateNormal];
    }
    
    self.webView.opaque = NO; //不设置这个值 页面背景始终是白色
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor colorWithHexString:NIGHT_BACKGROUND]);
    self.bottonView.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NEWS_BOTTON], [UIColor colorWithHexString:NIGHT_BACKGROUND]);
    
    UILabel *topViewLine = [UILabel lineLabel];
    [self.topView addSubview:topViewLine];
    [topViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *bottomViewLine = [UILabel lineLabel];
    [self.bottonView addSubview:bottomViewLine];
    [bottomViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    self.fd_prefersNavigationBarHidden = YES;
    [self requestNewsDetailsData];
}

- (void)requestNewsDetailsData {
    [HUDMANAGER showLoadingMessageToView:self.view];
    NSString *urlStr = [NSString stringWithFormat:@"%@nc/article/%@/full.html",NEWS_URL,self.entity.docid];
    [NETWORKINGMANAGER requestDataMethod:Get withUrl:urlStr withParmeter:nil requestSuccess:^(NSDictionary *dataDic) {
        [HUDMANAGER dismissLoadingMessage];
        self.webView.hidden = NO;
        detailsEntity = [NewsDetailsEntity detailWithDict:dataDic[self.entity.docid]];
        [self showInWebView];
    } requestFailure:^(NSString *errorMessage) {
        
    }];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        if([[UIApplication sharedApplication]canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
        }
        return NO;
    }
    return YES;
}


#pragma mark - ******************** 拼接html语言
- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    
    //外部样式表
//    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"NewsDetails_normal.css" withExtension:nil]];
    
    NSString *textColor = nil;
    NSString *backColor = nil;
    
    if (UserDefaultEntity.isNight) {
        textColor = NIGHT_NEWS_BODYTEXT;
        backColor = NIGHT_BACKGROUND;
    }
    else {
        textColor = NORMAL_NEWS_BODYTEXT;
        backColor = NORMAL_BACKGROUND;
    }
    
    //内部样式表
    [html appendFormat:@"<style>"];
    [html appendFormat:@".title{text-align:left;font-size:24px;font-weight:bold;color:%@;} .time{text-align:left;font-size:15px;color:gray;margin-top:7px;margin-bottom:7px;} body{font-size:%@px;color:%@;background-color:%@;} .img-parent{text-align:center;margin-bottom:10px;}",textColor,[NSString fontSizeTofontMark:UserDefaultEntity.newsFont],textColor,backColor];
    [html appendFormat:@"</style>"];
    
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",detailsEntity.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",detailsEntity.ptime];
    if (detailsEntity.body != nil) {
        [body appendFormat:@"<div class=\"body\">%@</div>",detailsEntity.body];
    }
    // 遍历img
    for (NewsDetailsImgEntity *detailImgModel in detailsEntity.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
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

//设置字体大小
- (IBAction)fontAction:(id)sender {
    
    NSNumber *curFont = nil;
    for (NSString *font in NEWS_BODY_FONT_MARK) {
        if ([font isEqualToString:UserDefaultEntity.newsFont]) {
            curFont = [NSNumber numberWithUnsignedInteger:[NEWS_BODY_FONT_MARK indexOfObject:font]];
            break;
        }
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:@[NEWS_BODY_FONT_MARK] initialSelection:@[curFont] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
        [self setWebViewFont:[[selectedIndex firstObject] integerValue]];
    } cancelBlock:nil origin:self.view];
}

- (void)setWebViewFont:(NSInteger)fontIndex {
    
    if (![UserDefaultEntity.newsFont isEqualToString:NEWS_BODY_FONT_MARK[fontIndex]]) {
        UserDefaultEntity.newsFont = NEWS_BODY_FONT_MARK[fontIndex];
        [UserDefaultEntity saveUserDefault];
        
        //用js改变body的字体大小
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize = '%@px'",[NSString fontSizeTofontMark:UserDefaultEntity.newsFont]]];
    }
}

//WebView夜间模式转换
- (void)nightSwith:(BOOL)night {
    //页面背景色
    if (night) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background ='#222222'"];
    }
    else {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background ='withe'"];
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
