//
//  MapCollectionView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/26.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantedMessageModel.h"

typedef void(^MapTapBlock) (NSIndexPath *indexPath,WantedMessageModel*model);

@interface MapCollectionView : UIView

@property (nonatomic, strong) NSString *areaStr;    // 区域的名称

@property (nonatomic, assign) NSInteger num;        // 房源的数量

@property (nonatomic, strong) UIButton *packUpBtn;    // 收起按钮

@property (nonatomic, strong) NSMutableArray *mDataSource;  // 数据源

@property (nonatomic, strong) UIActivityIndicatorView *activity;    // 活动指示器

@property (nonatomic, copy) MapTapBlock tapBlock;    // 点击cell 回调

@end
