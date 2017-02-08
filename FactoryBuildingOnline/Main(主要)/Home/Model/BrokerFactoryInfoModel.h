//
//  BrokerFactoryInfoModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProMediumFactoryModel.h"

@interface BrokerFactoryInfoModel : NSObject

@property (nonatomic, strong) NSString *next;            //

@property (nonatomic, assign) NSInteger view_count;

@property (nonatomic, assign) NSInteger collected_count;    // 被收藏数

@property (nonatomic, strong) ProMediumFactoryModel *factoryModel;  // 厂房详情

@property (nonatomic, assign) NSInteger owner_id;                   // 发布人ID

@property (nonatomic, strong) NSString *created_time;               // 信息的发布时间

- (id)initWithDictionary:(NSDictionary *)dic;

@end
