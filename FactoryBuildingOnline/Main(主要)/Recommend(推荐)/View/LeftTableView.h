//
//  LeftTableView.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightTableView.h"
@interface LeftTableView : UITableView

@property (nonatomic, strong) NSArray *leftListArray;
// 选中的 index
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void(^leftTableViewSelectIndex)(NSIndexPath *indexPath);


@end
