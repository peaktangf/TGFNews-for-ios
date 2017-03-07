//
//  NewsEntity.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "NewsEntity.h"

@implementation NewsEntity

+ (instancetype)newsModelWithDict:(NSDictionary *)dict
{
    NewsEntity *entity = [[self alloc]init];
    
    [entity setValuesForKeysWithDictionary:dict];
    
    return entity;
}

//重载该类的- (BOOL)isEqual:(id)object方法，只要title相等就认为是相等得
- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:[NewsEntity class]]) {
        return NO;
    }
    NewsEntity *entity = (NewsEntity *)object;
    if ([entity.title isEqualToString:self.title]) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
