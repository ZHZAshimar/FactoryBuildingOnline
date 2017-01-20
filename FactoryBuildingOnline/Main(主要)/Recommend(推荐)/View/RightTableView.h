//
//  RightTableView.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightTableView : UITableView

@property (nonatomic, strong) NSArray *rightListArray;
// 选中的 index
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void(^rightTableViewSelectIndex) (NSIndexPath *indexPath);

@end
