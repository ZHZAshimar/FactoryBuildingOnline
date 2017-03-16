//
//  SSPayHeaderCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"

@interface SSPayHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet ImagePlayerView *imagePlayerView;  // 轮播图片
@property (weak, nonatomic) IBOutlet UIButton *selectCityBtn;   // 所在城市

@property (weak, nonatomic) IBOutlet UIButton *accountsNatureBtn;   // 户籍性质
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *reminder_1;
@property (weak, nonatomic) IBOutlet UILabel *reminder_2;



@end
