//
//  SSImagePlayerCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/14.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImagePlayerView.h"
@interface SSImagePlayerCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) ImagePlayerView *imagePlayerView;

@property (nonatomic, strong)NSArray *imageDataSource;
@end
