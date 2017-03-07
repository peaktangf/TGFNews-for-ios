//
//  CollectCell.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/31.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "NewsEntity.h"

@interface CollectCell : BaseTableViewCell

@property (nonatomic, strong) NewsEntity *entity;

/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(NewsEntity *)entity;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(NewsEntity *)entity;

@end
