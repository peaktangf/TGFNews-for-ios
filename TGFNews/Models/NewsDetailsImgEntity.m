//
//  NewsDetailsImgEntity.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "NewsDetailsImgEntity.h"

@implementation NewsDetailsImgEntity

/** 便利构造器方法 */
+ (instancetype)detailImgWithDict:(NSDictionary *)dict
{
    NewsDetailsImgEntity *imgModel = [[self alloc]init];
    imgModel.ref = dict[@"ref"];
    imgModel.pixel = dict[@"pixel"];
    imgModel.src = dict[@"src"];
    return imgModel;
}
@end
