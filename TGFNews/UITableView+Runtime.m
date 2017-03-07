//
//  UITableView+Runtime.m
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/12.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "UITableView+Runtime.h"

@implementation UITableView (Runtime)

- (void)awakeFromNib {
    [super awakeFromNib];
    //让tableview空得cell不显示线条出来（绝招）
    self.tableFooterView = [UIView new];
}

@end
