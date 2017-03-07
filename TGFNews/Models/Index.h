//
//	Index.h
//
//	Create by 高丰 谭 on 19/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface Index : NSObject

@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * details;
@property (nonatomic, strong) NSString * index;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * otherName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end