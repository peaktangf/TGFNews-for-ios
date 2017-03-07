//
//  NewsDetailsEntity.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "NewsDetailsEntity.h"

@implementation NewsDetailsEntity

/** 便利构造器 */
+ (instancetype)detailWithDict:(NSDictionary *)dict
{
    NewsDetailsEntity *detail = [[self alloc]init];
    detail.title = dict[@"title"];
    detail.ptime = dict[@"ptime"];
    detail.body = dict[@"body"];
    
    NSArray *imgArray = dict[@"img"];
    NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:imgArray.count];
    
    for (NSDictionary *dict in imgArray) {
        NewsDetailsImgEntity *imgModel = [NewsDetailsImgEntity detailImgWithDict:dict];
        [temArray addObject:imgModel];
    }
    detail.img = temArray;
    
    
    return detail;
}
@end
