//
//  FlatButton.m
//  Popping
//
//  Created by André Schneider on 12.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "FlatButton.h"
#import <POP/POP.h>

@interface FlatButton()
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
- (void)setup;
- (void)scaleToSmall;
- (void)scaleAnimation;
- (void)scaleToDefault;
@end

@implementation FlatButton

//通过代码初始化
+ (instancetype)button
{
    return [self buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

//通过故事版或者Xib初始化
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)shakeButton
{
    [self.activityIndicatorView stopAnimating];
    self.enabled = YES;
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [self.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}
#pragma mark - Private instance methods

- (void)setup
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:self.activityIndicatorView];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(kScreen_Width/4);
    }];
    
    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit];
}

- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    self.enabled = NO;
    [self.activityIndicatorView startAnimating];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

//重写父类的该方法，让button在可用和不可用的时候标题显示不同的颜色
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled == YES) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        [self setTitleColor:[UIColor colorWithWhite:0.800 alpha:1.000] forState:UIControlStateNormal];
    }
}

@end
