//
//  CommonTableViewCell.m
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/26.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "NetWorkingManager.h"

#define FillTextCellID @"FillTextCell"//文字输入cell
#define ChangeTextCellID @"ChangeTextCell"//文字修改cell
#define SettingTextCellID @"SettingTextCell"//内容设置cell
#define SettingImageCellID @"SettingImageCell"//设置图片cell
#define ContentCellID @"ContentCell"//显示内容cell
#define MultiContentCellID @"MultiContentCell"//多内容cell
#define SwitchCellID @"SwitchCell"//开关cell
#define SpaceCellID @"SpaceCell"//间隔cell

@interface CommonTableViewCell ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation CommonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//设置数据
- (void)setModel:(CommonCellModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    
    if (model.type == ESettingImage) {
        if (model.image) {
            _headImageView.image = model.image;
        }
        else {
            [_headImageView sd_setImageWithURL:PHOTO_URL(model.content) placeholderImage:[UIImage imageNamed:@"head_default"]];
        }
    }
    else if (model.type == EFillText) {
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.cornerRadius = 5.0f;
        _textView.delegate = self;
    }
    else if (model.type == EChangeText) {
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    else if (model.type == ESwitch) {
        _switchControl.on = [model.content boolValue];
        [_switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    else {
        _contentLabel.text = model.content;
    }
}

- (void)configWithPlaceholder:(NSString *)phStr valueStr:(NSString *)valueStr secureTextEntry:(BOOL)isSecure {
    self.textField.placeholder = phStr;
    self.textField.text = valueStr;
    self.textField.secureTextEntry = isSecure;
    
    self.textView.placeholder = phStr;
    self.textView.text = valueStr;
}

//类方法返回可重用的id
+ (NSString *)idForRow:(CommonCellModel *)model{
    NSString *cellid;
    switch (model.type) {
        case ESettingText:
            cellid = SettingTextCellID;
            break;
        case ESettingImage:
            cellid = SettingImageCellID;
            break;
        case EChangeText:
            cellid = ChangeTextCellID;
            break;
        case EFillText:
            cellid = FillTextCellID;
            break;
        case EContent:
            cellid = ContentCellID;
            break;
        case EMultiContent:
            cellid = MultiContentCellID;
            break;
        case ESwitch:
            cellid = SwitchCellID;
            break;
        case ESpace:
            cellid = SpaceCellID;
            break;
        default:
            break;
    }
    return cellid;
}

//类方法返回行高
+ (CGFloat)heightForRow:(CommonCellModel *)model {
    CGFloat cellheight = 0;
    switch (model.type) {
        case ESettingImage:
            cellheight = 68;
            break;
        case EFillText:
            cellheight = 125;
            break;
        case ESpace:
            cellheight = 15;
            break;
        case EMultiContent:
            cellheight = 69;
            break;
        default:
            cellheight = 44;
            break;
    }
    return cellheight;
}

- (void)switchAction:(UISwitch *)sh {
    if (_switchValueChangeBlock) {
        _switchValueChangeBlock(sh.isOn);
    }
}

- (void)textFieldChange:(UITextField *)textField {
    if (_textValueChangedBlock) {
        _textValueChangedBlock(textField.text);
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (_textValueChangedBlock) {
        _textValueChangedBlock(textView.text);
    }
}

@end



