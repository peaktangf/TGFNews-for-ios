//
//  NewsCell.m
//  TGFNews
//
//  Created by 谭高丰 on 16/1/20.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubTitle;
/**
 *  第二张图片（如果有的话）
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgOtherOne;
/**
 *  第三张图片（如果有的话）
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgOtherTwo;

@end

@implementation NewsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)configurNewsEntity:(NewsEntity *)entity {
    
    //设置夜间模式和日间模式的颜色
    self.lbTitle.dk_textColorPicker = DKColorWithColors([UIColor colorWithHexString:NORMAL_NEWS_BODYTEXT], [UIColor colorWithHexString:NIGHT_NEWS_BODYTEXT]);
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:entity.imgsrc] placeholderImage:nil];
    
    self.lbTitle.text = entity.title;
    self.lbSubTitle.text = entity.digest;
    
    // 多图cell
    if (entity.imgextra.count == 2) {
        [self.imgOtherOne sd_setImageWithURL:[NSURL URLWithString:entity.imgextra[0][@"imgsrc"]] placeholderImage:nil];
        [self.imgOtherTwo sd_setImageWithURL:[NSURL URLWithString:entity.imgextra[1][@"imgsrc"]] placeholderImage:nil];
    }
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(NewsEntity *)entity
{
    if (entity.imgType){
        return @"BigImageCell";
    }else if (entity.imgextra){
        return @"ImagesCell";
    }else{
        return @"NewsCell";
    }
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(NewsEntity *)entity
{
    if(entity.imgType) {
        return 182;
    }else if (entity.imgextra){
        return 129;
    }else{
        return 86;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
