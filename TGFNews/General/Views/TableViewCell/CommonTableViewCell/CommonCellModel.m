//
//  CommonCellModel.m
//  EwitMobileOffice
//
//  Created by 谭高丰 on 16/4/26.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "CommonCellModel.h"

@implementation CommonCellModel

- (id)initWithType:(ECellType)type withTitle:(NSString *)title withContent:(id)content {
    if (self == [super init]) {
        _type = type;
        _title = title;
        if ([content isKindOfClass:[NSString class]]) {
            _content = (NSString *)content;
        }
        else if ([content isKindOfClass:[UIImage class]]) {
            _image = (UIImage *)content;
        }
    }
    return self;
}
@end
