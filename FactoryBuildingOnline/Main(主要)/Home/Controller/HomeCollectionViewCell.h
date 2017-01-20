//
//  HomeCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeOfHomeViewController.h"
#import "RecommendViewController.h"
#import "BoutiqueViewController.h"

#import "ExpertOfHomeViewController.h"

@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HomeOfHomeViewController *homeOfHomeVC;   // 首页中的首页
@property (nonatomic, strong) RecommendViewController *recommendOfHomeVC;   // 首页中的列表
@property (nonatomic, strong) ExpertOfHomeViewController *expertOfHomeVC;   // 首页中的专家
@property (nonatomic, strong) BoutiqueViewController *boutiqueVC;       // 精品厂房 的

@end
