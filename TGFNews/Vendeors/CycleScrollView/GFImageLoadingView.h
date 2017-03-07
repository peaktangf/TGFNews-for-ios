//
//  GFImageLoadingView.h
//  TGFNews
//
//  Created by 谭高丰 on 16/2/26.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001

@interface GFImageLoadingView : UIView

@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure;
@end
