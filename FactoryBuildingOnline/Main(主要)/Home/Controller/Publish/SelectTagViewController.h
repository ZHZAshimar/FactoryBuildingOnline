//
//  SelectTagViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/19.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SELECTTAGBLOCK) (NSArray *tagArr, NSArray* tag);

@interface SelectTagViewController : BaseViewController

@property (nonatomic, copy)SELECTTAGBLOCK tagBlock;

@property (nonatomic, strong) NSArray *seletedStringArr;

@property (nonatomic, strong) NSArray *selectedTagArr;

@end
