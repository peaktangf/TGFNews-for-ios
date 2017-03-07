//
//  SearchViewController.h
//  TGFNews
//
//  Created by 谭高丰 on 16/2/21.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DismissReturn)(void);

@interface SearchViewController : BaseViewController

@property (nonatomic, strong) DismissReturn dismissBlock;
@end
