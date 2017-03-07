//
//  SettingTextViewController.m
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/12.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "SettingTextViewController.h"

@interface SettingTextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *settingTextField;
@property (nonatomic, copy) NSString *textValue;
@property (copy, nonatomic) void(^doneBlock)(NSString *textValue);
@property (nonatomic, assign) NSInteger boardType;
@end

@implementation SettingTextViewController

+ (instancetype)settingTextVCWithTitle:(NSString *)title textValue:(NSString *)textValue keyBoardType:(UIKeyboardType)boardType doneBlock:(void(^)(NSString *textValue))block {
    SettingTextViewController *Vc = [[[NSBundle mainBundle] loadNibNamed:@"SettingTextViewController" owner:nil options:nil] firstObject];
    Vc.title = title;
    Vc.textValue = textValue != nil ? textValue : @"";
    Vc.doneBlock = block;
    
    Vc.settingTextField.text = Vc.textValue;
    Vc.settingTextField.keyboardType = boardType;
    //监听用户输入来设置完成按钮是否可点击
    [Vc.settingTextField.rac_textSignal subscribeNext:^(NSString *value) {
        if (![value isEqualToString:textValue]) {
            Vc.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else {
            Vc.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }];
    return Vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClicked)];
    doneBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneBtn;
    [self performSelector:@selector(becomeFirstRes) withObject:self afterDelay:0.6];
}

- (void)becomeFirstRes {
    [_settingTextField becomeFirstResponder];
}

- (void)doneBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.doneBlock) {
        self.doneBlock(_settingTextField.text);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
