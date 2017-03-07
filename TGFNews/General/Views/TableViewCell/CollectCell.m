//
//  CollectCell.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/31.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "CollectCell.h"

@interface CollectCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

/**
 *  如果有就显示
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation CollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lbTitle.dk_textColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NEWS_BODYTEXT], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
}

- (void)setEntity:(NewsEntity *)entity {
    _entity = entity;
    _lbTitle.text = entity.title;
    
    // 图片cell
    if (entity.imgsrc) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:entity.imgsrc] placeholderImage:nil];
    }
}

+ (NSString *)idForRow:(NewsEntity *)entity {
    if ([entity.skipType isEqualToString:@"photoset"]) {
        return @"ImagesCell";
    }
    else {
        return @"NewsCell";
    }
}

+ (CGFloat)heightForRow:(NewsEntity *)entity {
    if ([entity.skipType isEqualToString:@"photoset"]){
        return 216;
    }else{
        return 56;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
