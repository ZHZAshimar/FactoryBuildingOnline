//
//  HeadOfImagePlayerCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImagePlayerView.h"

typedef void(^REMOVEVIEWBLOCK) (BOOL isMove);

@interface HeadOfImagePlayerCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) ImagePlayerView *imagePlayerView;

@property (nonatomic, strong) NSArray *imageDataSource;

@property (nonatomic, strong) NSDictionary *numDic;

@property (nonatomic, copy)REMOVEVIEWBLOCK removeBlock; // 是否移除了refresh 的View
// 显示刷新之后的view
//- (void)showOnlineNum;

/// 去除掉 在线人数的 view;
- (void)removeRefreshView;

@end
