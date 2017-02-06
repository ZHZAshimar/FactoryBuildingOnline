//
//  PromediumsModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/6.
//  Copyright © 2017年 XFZY. All rights reserved.
//  前三名专家的

#import <Foundation/Foundation.h>

@interface PromediumsModel : NSObject

@property (nonatomic, assign) NSInteger promediumsID;   // ID
@property (nonatomic, strong) NSString *branch;     // 分店
@property (nonatomic, strong) NSString *realName;   // 名称
@property (nonatomic, strong) NSString *workYear;   // 工作时间
@property (nonatomic, strong) NSString *avatar;     // 头像   需要base64 解密
@property (nonatomic, strong) NSString *phoneNum;   // 手机号码

/**
 *  初始化
 *
 *  @prama dictionary 字典
 *  @return self
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  插入数据库
 *
 *  @prama PromediumsModel model
 *
 *  @return BOOL
 */
+ (BOOL)insertPromediumsModel:(PromediumsModel *)promediumsModel;

/**
 *  查找 表中的所有数据
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)findAll;

@end
