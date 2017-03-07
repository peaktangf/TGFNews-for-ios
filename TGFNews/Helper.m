//
//  Helper.m
//  Coding_iOS
//
//  Created by Elf Sundae on 14-12-22.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "Helper.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@import AVFoundation;

@implementation Helper

#pragma mark - 相机相关
+ (BOOL)checkPhotoLibraryAuthorizationStatus
{
    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (ALAuthorizationStatusDenied == authStatus ||
            ALAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        kTipAlert(@"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:tipStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        kTipAlert(@"%@", tipStr);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([app canOpenURL:settingsURL]) {
            [app openURL:settingsURL];
        }
    }
}

#pragma mark - 用户相关
+(void)getUserHeadReturnImage:(void(^)(UIImage *image))returnImage {
    
    //获取用户头像图片，先查找沙盒中是否有该图片，在去网络请求图片
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userHead.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    if (savedImage) {
        returnImage(savedImage);
    }else{
        [self asynchronousLoadImageWithUrl:PHOTO_URL(UserDefaultEntity.userInfo.head) complete:^(UIImage *image) {
            returnImage(image);
            //获取图片后再把图片存入沙盒
            [self setUserHead:image];
        }];
    }
}

//异步加载图片
+ (void)asynchronousLoadImageWithUrl:(NSURL *)url complete:(void(^)(UIImage *image))complete{
    //开启多线程
    NSOperationQueue * queue=[[NSOperationQueue alloc] init];
    NSBlockOperation * block=[NSBlockOperation blockOperationWithBlock:^{
        //下载图片
        NSData * data = [NSData dataWithContentsOfURL:url];
        UIImage * image=[UIImage imageWithData:data];
        //获取主线程，刷新UI
        NSOperationQueue * queue2=[NSOperationQueue mainQueue];
        [queue2 addOperationWithBlock:^{
            complete(image);
        }];
    }];
    [queue addOperation:block];
}

//保存图片到沙盒
+ (void)setUserHead:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    //超过一定大小图片压缩
    int maxlength=1024*100*6;
    if (imageData.length>maxlength) {
        imageData=UIImageJPEGRepresentation(image, 0.01);
    }
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userHead.png"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:fullPath]) {
        [fileMgr removeItemAtPath:fullPath error:nil];
    }
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

//从沙盒中删除用户头像
+ (void)removeSandBoxUserHead {
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"userHead.png"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //从沙盒中删除相应路径的文件
    if ([fileMgr fileExistsAtPath:fullPath]) {
        [fileMgr removeItemAtPath:fullPath error:nil];
    }
}

@end
