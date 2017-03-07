//
//  HudManager.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/22.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "HudManager.h"
#import <JDStatusBarNotification.h> //状态栏提示控件
#import "EaseLoadingView.h"         //页面加载等待控件
#import <MBProgressHUD.h>           //文字提示


@interface HudManager () {
    EaseLoadingView *loadView;
}

@end
@implementation HudManager

+ (HudManager *)shareManager {
    static HudManager *hudManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hudManager = [[HudManager alloc] init];
    });
    return hudManager;
}

- (void)showStateMessageType:(EMessageType)type withContent:(NSString *)content {
    
    NSString *style;
    switch (type) {
        case Error:
            style = JDStatusBarStyleError;
            break;
        case Success:
            style = JDStatusBarStyleSuccess;
            break;
        case Warning:
            style = JDStatusBarStyleWarning;
            break;
        default:
            break;
    }
    //如果当前正在显示消息，那么久延迟需要显示的消息
    if ([JDStatusBarNotification isVisible]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
            [JDStatusBarNotification showWithStatus:content dismissAfter:1.5 styleName:style];
        });
    }else{
        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [JDStatusBarNotification showWithStatus:content dismissAfter:1.0 styleName:style];
    }
}

- (void)showStateQueryMessageContent:(NSString *)content {
    [JDStatusBarNotification showWithStatus:content styleName:JDStatusBarStyleSuccess];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)dismissStateQueryMessage {
    [JDStatusBarNotification dismissAnimated:YES];
}

- (void)showAlertMessageContent:(NSString *)content {
    if ([JDStatusBarNotification isVisible]) {//如果statusBar上面正在显示信息，则不再用hud显示error
        DebugLog(@"如果statusBar上面正在显示信息，则不再用hud显示error");
    }
    else {
        if (content && content.length > 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
            hud.detailsLabelText = content;
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.0];
        }
    }
}


- (void)showLoadingMessageToView:(UIView *)view {
    
    if (loadView) {
        [loadView stopAnimating];
        loadView = nil;
    }
    loadView = [[EaseLoadingView alloc] initWithFrame:view.bounds];
    [view addSubview:loadView];
    [loadView startAnimating];
}

- (void)dismissLoadingMessage {
    if (loadView) {
        [loadView stopAnimating];
    }
}

@end
