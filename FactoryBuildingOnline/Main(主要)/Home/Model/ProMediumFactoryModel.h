//
//  ProMediumFactoryModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProMediumFactoryModel : NSObject

@property (nonatomic, assign) NSInteger id;     // integer,中介厂房id

@property (nonatomic, strong) NSString *thumbnail_url;  // string,缩略图路径

@property (nonatomic, strong) NSString *title;          // string,标题

@property (nonatomic, strong) NSString *price;          // "float,价格 x元/平方

@property (nonatomic, strong) NSString *range;          // float,面积   平方米;

@property (nonatomic, strong) NSString *area;           // string,所属镇区

@property (nonatomic, strong) NSString *address;        // string,地址

@property (nonatomic, strong) NSString *description_pro;    // string,厂房的描述

@property (nonatomic, strong) NSString *image_urls;     //

@property (nonatomic, strong) NSString *pre_pay;        // string,押金

@property (nonatomic, strong) NSString *rent_type;      // string,出租方式

- (id)initWithDictionary:(NSDictionary *)dic;

@end
