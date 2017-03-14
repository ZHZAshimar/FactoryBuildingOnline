//
//  SelectCityTableViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/15.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

// 声明
typedef void(^AREA_CITY) (NSString *areaStr);

@interface SelectCityTableViewController : BaseViewController

@property (nonatomic, copy) AREA_CITY area_city;

@property (nonatomic, strong) NSString *cityStr;

@end
