//
//  SelectAreaTableViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SELECTAREABLOCK) (NSString *town,NSString *townID ,NSString *city, NSString *cityID);

@interface SelectAreaTableViewController : UIViewController

@property (nonatomic ,copy) SELECTAREABLOCK selectAreaBlock;

@property (nonatomic, strong) NSString *selectedStr;

@end
