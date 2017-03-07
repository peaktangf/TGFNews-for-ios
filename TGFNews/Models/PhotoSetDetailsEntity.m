//
//  PhotoSetDetailsEntity.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "PhotoSetDetailsEntity.h"

@implementation PhotoSetDetailsEntity

+ (instancetype)photoDetailWithDict:(NSDictionary *)dict
{
    PhotoSetDetailsEntity *photoDetail = [[PhotoSetDetailsEntity alloc]init];
    [photoDetail setValuesForKeysWithDictionary:dict];
    return photoDetail;
}
@end
