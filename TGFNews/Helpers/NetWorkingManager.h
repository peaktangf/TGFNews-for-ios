//
//  NetWorkingManager.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NETWORKINGMANAGER [NetWorkingManager shareManager]

typedef void(^RequestRuccess)(NSDictionary *dataDic);
typedef void(^RequestField)(NSString *errorMessage);

/**
 网络请求类型枚举
 */
typedef enum {
    Get = 0,
    Post,
    Put,
    Delete,
}NetworkMethod;

@interface NetWorkingManager : NSObject

+ (NetWorkingManager *)shareManager;


/**
 *  请求新闻数据
 *
 *  @param method   请求类型
 *  @param url      请求url
 *  @param parmeter 请求参数
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)requestDataMethod:(NetworkMethod)method
                  withUrl:(NSString *)url
             withParmeter:(NSDictionary *)parmeter
           requestSuccess:(RequestRuccess)success
           requestFailure:(RequestField)failure;

/**
 *  上传有图片的Post请求
 *
 *  @param url       请求url
 *  @param parameter 请求参数
 *  @param image     图片
 *  @param success   成功回调
 *  @param failure   失败回调
 */
-(void)uploadImageWithUrl:(NSString *)url
               parameters:(NSDictionary *)parameter
                    image:(UIImage *)image
           RequestSuccess:(RequestRuccess)success
           RequestFailure:(RequestField)failure;


/**
 *  请求天气数据
 *
 *  @param cityname 城市名称
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)requestWeatherWithCityName:(NSString *)cityname
                  requestSuccess:(RequestRuccess)success
                  requestFailure:(RequestField)failure;

@end
