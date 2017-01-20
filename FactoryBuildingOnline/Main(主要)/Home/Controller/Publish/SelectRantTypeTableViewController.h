//
//  SelectIdentityTableViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SELECTRANTTYPEBLOCK) (NSString *rantType);

@interface SelectRantTypeTableViewController : BaseViewController

/// 出租方式的回调
@property (nonatomic, copy) SELECTRANTTYPEBLOCK rantBlock;

/// 已选的出租方式
@property (nonatomic, strong) NSString *rantStr;

@end
