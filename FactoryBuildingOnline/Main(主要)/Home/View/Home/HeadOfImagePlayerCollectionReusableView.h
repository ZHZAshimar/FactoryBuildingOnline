//
//  HeadOfImagePlayerCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImagePlayerView.h"

@interface HeadOfImagePlayerCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) ImagePlayerView *imagePlayerView;

@property (nonatomic, strong) NSArray *imageDataSource;

@end
