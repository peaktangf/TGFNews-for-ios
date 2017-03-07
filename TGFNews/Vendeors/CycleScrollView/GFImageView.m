//
//  GFImageView.m
//  TGFNews
//
//  Created by 谭高丰 on 16/2/25.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "GFImageView.h"
#import "GFImageLoadingView.h"

@interface GFImageView () {
    BOOL _zoomByDoubleTap;
    GFImageLoadingView *_photoLoadingView;
}
@end

@implementation GFImageView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        //设置图片模式
        self.contentMode= UIViewContentModeScaleAspectFit;
        // 进度条
        _photoLoadingView = [[GFImageLoadingView alloc] initWithFrame:self.bounds];
    }
    return self;
}

#pragma mark 开始加载图片
- (void)setUrl:(NSURL *)url {
    
    _url = url;
    
    // 直接显示进度条
    [_photoLoadingView showLoading];
    [self addSubview:_photoLoadingView];
    
    ESWeakSelf
    ESWeak_(_photoLoadingView);
    
    [SDWebImageManager.sharedManager downloadImageWithURL:url options:SDWebImageRetryFailed| SDWebImageLowPriority| SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ESStrong_(_photoLoadingView);
        if (receivedSize > kMinProgress) {
            __photoLoadingView.progress = (float)receivedSize/expectedSize;
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        ESStrongSelf;
        _self.image = image;
        [_self photoDidFinishLoadWithImage:image];
    }];
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.image = image;
        [_photoLoadingView removeFromSuperview];
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
}

@end
