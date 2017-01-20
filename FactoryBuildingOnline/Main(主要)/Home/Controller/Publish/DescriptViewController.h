//
//  DescriptViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DescriptBlock) (NSString *descriptStr);

@interface DescriptViewController : BaseViewController

@property (nonatomic, copy) DescriptBlock descriptBlock;

@property (nonatomic, strong) NSString *descriptStr;

@end
