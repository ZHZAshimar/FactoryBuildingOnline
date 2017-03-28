//
//  SelectDepositTableViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SELECTDEPOSITBLOCK) (NSString *adjustType, NSString *indexStr);

@interface AdjustTradeTableViewController : BaseViewController

/// 已选使用行业
@property (nonatomic, strong) NSString *adjustStr;

/// 适用行业方式的回调
@property (nonatomic, copy) SELECTDEPOSITBLOCK adjustTypeBlock;

@end
