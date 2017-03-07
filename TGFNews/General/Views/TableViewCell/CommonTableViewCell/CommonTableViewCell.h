//
//  CommonTableViewCell.h
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/26.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonCellModel.h"
#import "UIPlaceHolderTextView.h"
#import "DesigbableImageView.h"

@interface CommonTableViewCell : UITableViewCell

//显示标题控件
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//显示内容控件
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//文字输入控件
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;
//文字修改控件
@property (weak, nonatomic) IBOutlet UITextField *textField;
//图片显示控件
@property (weak, nonatomic) IBOutlet DesigbableImageView *headImageView;
//开关控件
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;


//cell的模型
@property (nonatomic, strong) CommonCellModel *model;

//开关选择的回调
@property (nonatomic, copy) void(^switchValueChangeBlock)(BOOL);

//文字有修改时的回调
@property (nonatomic,copy) void(^textValueChangedBlock)(NSString*);
//设置textFiled & textView 的占位符和当前文字，还有是否启动安全键盘(在修改密码的时候一般都是启动安全键盘的)
- (void)configWithPlaceholder:(NSString *)phStr valueStr:(NSString *)valueStr secureTextEntry:(BOOL)isSecure;


//类方法返回可重用的id
+ (NSString *)idForRow:(CommonCellModel *)model;

//类方法返回行高
+ (CGFloat)heightForRow:(CommonCellModel *)model;
@end
