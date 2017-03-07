//
//  CityListEntity.h
//  TGFNews
//
//  Created by 谭高丰 on 16/2/24.
//  Copyright © 2016年 谭高丰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityListEntity : NSObject

//"area_id" = 101010100;
//"district_cn" = "\U5317\U4eac";
//"name_cn" = "\U5317\U4eac";
//"name_en" = beijing;
//"province_cn" = "\U5317\U4eac";

//城市代码
@property (nonatomic, assign) long area_id;
//省
@property (nonatomic, copy) NSString *province_cn;
//市
@property (nonatomic, copy) NSString *district_cn;
//区、县
@property (nonatomic, copy) NSString *name_cn;
//城市拼音
@property (nonatomic, copy) NSString *name_en;

@end
