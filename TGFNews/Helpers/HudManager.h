//
//  HudManager.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/22.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HUDMANAGER [HudManager shareManager]

/**
 状态栏消息类型枚举
 */
typedef enum : NSUInteger {
    Error = 0,
    Success,
    Warning,
} EMessageType;


@interface HudManager : NSObject

+ (HudManager *)shareManager;

/**
 *  状态栏提示视图
 *
 *  @param type    消息类型
 *  @param content 消息内容
 */
- (void)showStateMessageType:(EMessageType)type withContent:(NSString *)content;

/**
 *  状态栏加载视图（网络请求之类的，上传，下载等）
 *
 *  @param content 消息内容
 */
- (void)showStateQueryMessageContent:(NSString *)content;

/**
 *  取消状态栏加载视图
 */
- (void)dismissStateQueryMessage;

/**
 *  弹出提示视图
 *
 *  @param content 消息内容
 */
- (void)showAlertMessageContent:(NSString *)content;

/**
 *  页面加载指示视图
 */
- (void)showLoadingMessageToView:(UIView *)view;

/**
 *  取消页面加载指示视图
 */
- (void)dismissLoadingMessage;

@end
