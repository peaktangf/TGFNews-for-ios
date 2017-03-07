//
//  PublicTabelViewController.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/27.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ClickReturn)(NSString *cityname);

@interface PublicTabelViewController : BaseViewController

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSArray *objArray;
@property (nonatomic, copy) NSString *markStr;//tableview显示数据的标示
@property (nonatomic, strong) ClickReturn clickBlock;//点击了cell时返回相应城市名

@end
