//
//  NetWorkingManager.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "NetWorkingManager.h"
#import <AFNetworking.h>
#import "HudManager.h"
#import "DateFormatter.h"

static int TIMEOUTSECONDS = 30; //超时时间

@interface NetWorkingManager (){
    AFHTTPRequestOperationManager* requestOperationManager;
    AFHTTPRequestOperation* currentRequest;
}

@end

@implementation NetWorkingManager

+ (NetWorkingManager *)shareManager {
    static NetWorkingManager *netWorkingManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkingManager = [[NetWorkingManager alloc] init];
    });
    return netWorkingManager;
}

//获取用户头像，以block的形式返回
+ (void)getUserHeadReturnImage:(void(^)(UIImage *image))returnImage {
    
//    //开启多线程
//    NSOperationQueue * queue=[[NSOperationQueue alloc] init];
//    NSBlockOperation * block=[NSBlockOperation blockOperationWithBlock:^{
//        //下载图片
//        NSURL * URL = [self photoUrlWithStr:USERDEFAULTMANAGER.userInfo.HeadPortrait];
//        NSData * data = [NSData dataWithContentsOfURL:URL];
//        UIImage * image=[UIImage imageWithData:data];
//        //获取主线程，刷新UI
//        NSOperationQueue * queue2=[NSOperationQueue mainQueue];
//        [queue2 addOperationWithBlock:^{
//            returnImage(image);
//        }];
//    }];
//    [queue addOperation:block];
}


- (void)requestDataMethod:(NetworkMethod)method
                  withUrl:(NSString *)url
             withParmeter:(NSDictionary *)parmeter
           requestSuccess:(RequestRuccess)success
           requestFailure:(RequestField)failure {
    if (!requestOperationManager) {
        requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
    }
    
    requestOperationManager.requestSerializer.timeoutInterval = TIMEOUTSECONDS;
    requestOperationManager.responseSerializer.acceptableContentTypes = [requestOperationManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[ @"text/html", @"text/plain", @"text/json", @"text/xml", @"image/jpeg", @"image/png", @"image/jpg", @"application/octet-stream" ]];
    
    if ([url hasPrefix:@"http://apis.baidu.com"]) {
        [requestOperationManager.requestSerializer setValue:@"6d814be9002444468b458046bf7bb5ce" forHTTPHeaderField:@"apikey"];
    }
    
    NSLog(@"%@",url);
    
    switch (method) {
        case Get:{
            currentRequest = [requestOperationManager GET:url parameters:parmeter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                success(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSString *errorMessage = [self tipFromError:error];
                failure(errorMessage);
                //请求失败进行错误提示
                [HUDMANAGER showAlertMessageContent:errorMessage];
            }];
        }
            break;
        case Post:{
            requestOperationManager.responseSerializer =  [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
            
            currentRequest = [requestOperationManager POST:url parameters:parmeter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *responseDictionary=responseObject;
                NSLog(@"%@",responseDictionary);
                NSString *message = [responseDictionary objectForKey:@"message"];
                NSDictionary *dataDic = [responseDictionary objectForKey:@"data"];
                if ([message isEqualToString:@"success"]) {
                    success(dataDic);
                }
                else {
                    failure(message);
                    [HUDMANAGER showAlertMessageContent:message];

                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //请求失败进行错误提示
                NSString *errorMessage = [self tipFromError:error];
                failure(errorMessage);
                [HUDMANAGER showAlertMessageContent:errorMessage];
            }];
        }
            break;
        case Put:
            break;
        case Delete:
            break;
        default:
            break;
    }
}

-(void)uploadImageWithUrl:(NSString *)url
               parameters:(NSDictionary *)parameter
                    image:(UIImage *)image
           RequestSuccess:(RequestRuccess)success
           RequestFailure:(RequestField)failure {
    if (!requestOperationManager) {
        requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
    }
    
    requestOperationManager.requestSerializer.timeoutInterval = TIMEOUTSECONDS;
    requestOperationManager.responseSerializer.acceptableContentTypes = [requestOperationManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[ @"text/html", @"text/plain", @"text/json", @"text/xml", @"image/jpeg", @"image/png", @"image/jpg", @"application/octet-stream",@"application/json"]];
    requestOperationManager.responseSerializer =  [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
    
    NSLog(@"%@",url);
    
    currentRequest = [requestOperationManager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
        NSLog(@"%lu",[imageData length]/1000);
        NSString *imageName=[NSString stringWithFormat:@"IMG_%@.png",[DateFormatter dateToStringCustom:[NSDate date] formatString:kNSDateHelperFormatSQLDateWithTimes]];
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary=responseObject;
        NSLog(@"%@",responseDictionary);
        NSString *message = [responseDictionary objectForKey:@"message"];
        NSDictionary *dataDic = [responseDictionary objectForKey:@"data"];
        if ([message isEqualToString:@"success"]) {
            success(dataDic);
        }
        else {
            failure(message);
            [HUDMANAGER showAlertMessageContent:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求失败进行错误提示
        NSString *errorMessage = [self tipFromError:error];
        failure(errorMessage);
        [HUDMANAGER showAlertMessageContent:errorMessage];
    }];
}

- (void)requestWeatherWithCityName:(NSString *)cityname
                    requestSuccess:(RequestRuccess)success
                    requestFailure:(RequestField)failure {
    
    NSString *utfCityName = [cityname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@recentweathers?cityid=%@",WEATHER_URL,utfCityName];
    
    //NSString *urlStr = [NSString stringWithFormat:@"%@recentweathers?cityid=%@",WEATHER_URL,cityid];
    [NETWORKINGMANAGER requestDataMethod:Get withUrl:urlStr withParmeter:nil requestSuccess:^(NSDictionary *dataDic) {
        success(dataDic);
    } requestFailure:^(NSString *errorMessage) {
        failure(errorMessage);
    }];
}

#pragma Private Method 根据error.code获取相应错误提示（系统提示）
- (NSString *)tipFromError:(NSError *)error {
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"msg"]) {
            NSArray *msgArray = [[error.userInfo objectForKey:@"msg"] allValues];
            NSUInteger num = [msgArray count];
            for (int i = 0; i < num; i++) {
                NSString *msgStr = [msgArray objectAtIndex:i];
                if (i+1 < num) {
                    [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
                }else{
                    [tipStr appendString:msgStr];
                }
            }
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}

#pragma Private Method 根据error.code获取相应错误提示（自定义提示）
- (NSString *)getErrorInfo:(NSInteger)code {
    NSString *message;
    switch (code) {
        case -999:
            message=@"已取消请求";
            break;
        case -1001:
            message=@"连接超时，请刷新！";
            break;
        case -1002:
            message=@"请求认证失败";
            break;
        case -1009:
            message=@"无网络连接,请设置您的网络！";
            break;
        default:
            message=@"网络未知错误";
            break;
    }
    return message;
}

@end
