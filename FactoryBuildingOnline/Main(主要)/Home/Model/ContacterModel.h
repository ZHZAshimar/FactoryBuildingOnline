//
//  ContacterModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//
/*
 "contacter": {
 "phone_num": "string,联系人号码",
 "name": "string,联系人姓名"
 },
 */

#import <Foundation/Foundation.h>

@interface ContacterModel : NSObject

/// int 联系人ID
@property (nonatomic, assign) NSInteger id;

/// string,联系人号码
@property (nonatomic, strong) NSString *phone_num;

/// string,联系人姓名
@property (nonatomic, strong) NSString *name;

/**
 *  初始化
 *
 *  @param dictionary 字典
 *  @return self
 */
- (id)initWithDictionary :(NSDictionary *)dictionary;

/*
 *  插入数据库
 *
 *  @param model FactoryModel
 *
 *  @return BOOL
 */
+ (BOOL)insertContactorModel:(ContacterModel *)model;


@end
