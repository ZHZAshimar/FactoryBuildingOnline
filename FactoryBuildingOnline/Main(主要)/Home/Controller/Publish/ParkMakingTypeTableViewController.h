//
//  SelectIdentityTableViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SELECTDEPOSITBLOCK) (NSString *parkType, NSString *indexStr);

@interface ParkMakingTypeTableViewController : BaseViewController



/// 已选园区配套设备
@property (nonatomic, strong) NSString *parkTypeStr;

/// 适用园区配套设备的回调
@property (nonatomic, copy) SELECTDEPOSITBLOCK parkTypeBlock;

@end
