//
//  NewsDetailsViewController.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "BaseViewController.h"
#import "NewsEntity.h"

typedef void(^CancelCollect)(void);

@interface NewsDetailsViewController : BaseViewController

@property (nonatomic ,strong) NewsEntity *entity;
//取消收藏时回调
@property (nonatomic, strong) CancelCollect cancelCollectBlock;
@end
