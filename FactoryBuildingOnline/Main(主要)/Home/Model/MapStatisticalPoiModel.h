//
//  MapStatisticalPoiModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/1.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MapStatisticalPoiModel : JSONModel

@property (nonatomic, assign) NSInteger area_id;    // id

@property (nonatomic, assign) NSInteger count;      // 数量

@property (nonatomic, strong) NSString *geohash;    // 经纬度的 geohash 值， 再转成经纬度

@property (nonatomic, strong) NSString *area_description;    // 名称

@end
