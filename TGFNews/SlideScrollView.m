//
//  SlideScrollView.m
//  TGFNews
//
//  Created by 谭高丰 on 16/4/7.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "SlideScrollView.h"

@implementation SlideScrollView

//重载该方法,拦截scrollview的手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //设置手势拦截的条件，满足条件就拦截(使手势失效)
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        //判定pan手势滑动的方向（point.x > 0：向右  point.x < 0：向左）
        CGPoint point = [pan translationInView:self];
        if (self.contentOffset.x <= 0 && point.x > 0) {
            return YES;
        }
    }
    return NO;
}

@end
