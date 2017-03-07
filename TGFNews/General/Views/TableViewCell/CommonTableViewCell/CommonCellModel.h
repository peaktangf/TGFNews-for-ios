//
//  CommonCellModel.h
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/26.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>

//常用的cell模型
typedef enum : NSUInteger {
    ESettingText= 0,//设置文字内容cell
    ESettingImage,//设置图片cell
    EChangeText,//修改文字内容cell
    EFillText,//填写文字cell
    EContent,//显示内容cell
    EMultiContent,//换行显示内容cell（一般cell内容比较多）
    ESwitch,//显示开关cell
    ESpace
} ECellType;

@interface CommonCellModel : NSObject
//属性   cell类型  cell标题  内容(图片，文字)
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) ECellType type;

//初始化
- (id)initWithType:(ECellType)type withTitle:(NSString *)title withContent:(id)content;
@end
