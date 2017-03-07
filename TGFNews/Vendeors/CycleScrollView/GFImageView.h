//
//  GFImageView.h
//  TGFNews
//
//  Created by 谭高丰 on 16/2/25.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFImageView : UIImageView

@property (nonatomic, copy) NSURL *url;
// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;

@end
