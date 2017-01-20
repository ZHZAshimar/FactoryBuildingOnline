//
//  SelectDepositTableViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SELECTDEPOSITBLOCK) (NSString *depositType);

@interface SelectDepositTableViewController : BaseViewController

/// 已选的押金方式
@property (nonatomic, strong) NSString *depositStr;

/// 押金方式的回调
@property (nonatomic, copy) SELECTDEPOSITBLOCK depositTypeBlock;

@end
