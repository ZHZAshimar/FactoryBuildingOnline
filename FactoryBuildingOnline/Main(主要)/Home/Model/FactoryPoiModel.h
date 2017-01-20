//
//  FactoryPoiModel.h
//  BaiduMapTest
//
//  Created by myios on 2016/10/19.
//  Copyright © 2016年 ZHZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface FactoryPoiModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*address;  // 附加信息

@property (nonatomic, strong) NSString <Optional>*province; // 省

@property (nonatomic, assign) NSInteger province_id;        // 省id

@property (nonatomic, strong) NSString <Optional>*city;     // 城市

@property (nonatomic, assign) NSInteger city_id;            // 城市id

@property (nonatomic, strong) NSString <Optional>*district; // 区/ 镇

@property (nonatomic, assign) NSInteger district_id;        // 区/镇id

@property (nonatomic, strong) NSString <Optional>*street;   // 街道

@property (nonatomic, assign) NSInteger street_id;          // 街道id

@property (nonatomic, assign) NSInteger factory_id;         // 厂房id

@property (nonatomic, strong) NSArray *location;

@end

