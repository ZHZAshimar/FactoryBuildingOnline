//
//  SliderViewController.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/3.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SLIDERBLOCK) (BOOL isShowSlider);

@interface SliderViewController : UIViewController

@property (nonatomic, copy) SLIDERBLOCK sliderBlock;    // 侧边栏的收缩或展开回调

@property (nonatomic, strong) NSMutableArray *usersArray;

@end
