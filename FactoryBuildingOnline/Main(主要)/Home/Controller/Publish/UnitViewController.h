//
//  UnitViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^UnitBlock) (NSInteger index);

@interface UnitViewController : BaseViewController

@property (nonatomic, copy) UnitBlock unitBlock;

@end
