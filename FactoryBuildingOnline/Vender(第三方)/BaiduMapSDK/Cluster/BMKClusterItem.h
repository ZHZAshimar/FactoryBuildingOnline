//
//  BMKClusterItem.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 15/9/15.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#ifndef BMKClusterItem_h
#define BMKClusterItem_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FactoryPoiModel.h" // 详细的model
#import "MapStatisticalPoiModel.h"  // 简单的model

/**
 * 表示一个标注
 */
@interface BMKClusterItem : NSObject

///经纬度，初始化后，不可修改
@property (nonatomic, assign) CLLocationCoordinate2D coor;

//@property (nonatomic, strong) FactoryPoiModel *factoryPoiModel;

@property (nonatomic, strong) MapStatisticalPoiModel *mapPoiModel;

@end

/**
 * 聚合后的标注
 */
@interface BMKCluster : NSObject

///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//@property (nonatomic, strong) FactoryPoiModel *clusterFactoryPoiModel;
@property (nonatomic, strong) MapStatisticalPoiModel *clusterMapPoiModel;
///所包含BMKClusterItem
@property (nonatomic, strong) NSMutableArray *clusterItems;
///包含BMKClusterItem个数
@property (nonatomic, readonly) NSUInteger size;



@end

#endif /* BMKClusterItem_h */
