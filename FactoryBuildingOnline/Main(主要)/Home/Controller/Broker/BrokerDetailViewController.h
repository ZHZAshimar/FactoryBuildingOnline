//
//  BrokerDetailViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"
#import "BrokerFactoryInfoModel.h"
@interface BrokerDetailViewController : BaseViewController

@property (nonatomic, strong) BrokerFactoryInfoModel *model;

@property (nonatomic, strong) NSDictionary *brokerInfoDic;

@end
