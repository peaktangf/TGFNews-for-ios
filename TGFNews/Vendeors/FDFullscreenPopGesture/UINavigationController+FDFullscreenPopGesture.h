// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <UIKit/UIKit.h>

/*
 “UINavigation + FDFullscreenPopGesture”是UINavigationController的分类，运行于iOS 7 +支持全屏平移手势。而不是屏幕边缘,你现在可以从屏幕上的任何地方实现交互式无缝过渡工作
 
 在你的工程中导入这个分类，你的导航控制器将会自动继承这个特性
 */
@interface UINavigationController (FDFullscreenPopGesture)

//处理pop交互的手势属性
/// The gesture recognizer that actually handles interactive pop.

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *fd_fullscreenPopGestureRecognizer;

/*
 决定视图控制器是否能够控制导航栏的外观本身的属性
 返回一个全局方法,检查“fd_prefersNavigationBarHidden”属性
 默认YES开启状态,如果你不想让视图控制器控制导航栏的外观就设为NO
 */
@property (nonatomic, assign) BOOL fd_viewControllerBasedNavigationBarAppearanceEnabled;

@end

//当视图控制器本身在某些情况下处理平移手势时允许其禁用交互手势,这是必须的
@interface UIViewController (FDFullscreenPopGesture)

//用来禁用pop交互手势的属性
@property (nonatomic, assign) BOOL fd_interactivePopDisabled;

//是否隐藏导航栏，默认是显示，可以设置为隐藏
@property (nonatomic, assign) BOOL fd_prefersNavigationBarHidden;

//当开始执行pop交互手势的时候手指允许离左边缘的最大初始距离，超过了这个距离将不执行手势交互。默认是0，意味着忽略这个限制
@property (nonatomic, assign) CGFloat fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end
