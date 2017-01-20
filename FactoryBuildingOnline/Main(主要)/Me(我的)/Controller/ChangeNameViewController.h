//
//  ChangeNameViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/3.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^REFRESHNAMEBLOCK) (NSString *userName);

@interface ChangeNameViewController : BaseViewController

@property (nonatomic, strong) NSString *userName;

@end
