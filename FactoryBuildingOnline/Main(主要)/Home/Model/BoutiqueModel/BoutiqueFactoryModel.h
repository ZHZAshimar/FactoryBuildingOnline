//
//  BoutiqueFactoryModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/7.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoutiqueFactoryModel : NSObject
/// integer,厂房id
@property (nonatomic, assign) NSInteger id;
/// 标签数组
@property (nonatomic, strong) NSString *tags;
/// string,缩略图路径
@property (nonatomic, strong) NSString *thumbnail_url;
/// string,厂房标题
@property (nonatomic, strong) NSString *title;
/// float,价格  x元/平方
@property (nonatomic, strong) NSString *price;
/// float,面积 平方米
@property (nonatomic, strong) NSString *range;
/// string,详细描述
@property (nonatomic, strong) NSString *description_factory;
/// string,地址总览
@property (nonatomic, strong) NSString *address_overview;
/// string,押金
@property (nonatomic, strong) NSString *pre_pay;
/// 图片数组
@property (nonatomic, strong) NSString *image_urls;
/// string,地理位置的hash编码
@property (nonatomic, strong) NSString *geohash;
/// string,出租方式
@property (nonatomic, strong) NSString *rent_type;

/**
 *  初始化
 *
 *  @prama dictionary 字典
 *  @return self
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/*
 *  插入数据库
 *
 *  @param model FactoryModel
 *
 *  @return BOOL
 */
+ (BOOL)insertFactoryModel:(BoutiqueFactoryModel *)model;
@end
