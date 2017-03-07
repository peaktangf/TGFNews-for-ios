//
//  AdsEntity.h
//  TGFNews
//
//  Created by 谭高丰 on 16/1/21.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsEntity : NSObject
/*
 imgsrc = "http://img6.cache.netease.com/3g/2016/1/21/201601211759181db3c.jpg";
 subtitle = "";
 tag = photoset;
 title = "\U6cb3\U5317\U90af\U90f8\U591a\U540d\U94a2\U7ba1\U821e\U8005\U5bd2\U98ce\U4e2d\U8d77\U821e";
 url = "00AP0001|108889";
 */
@property (nonatomic, copy) NSString *imgsrc;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@end
