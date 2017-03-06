//
//  BaseTabBarViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <RDVTabBarController/RDVTabBarController.h>

typedef void (^SLIDERSHOWBLOCK)(BOOL showSlider);

@interface BaseTabBarViewController : RDVTabBarController


@property (nonatomic,strong) RDVTabBarController *viewController;
@property (nonatomic, strong) SLIDERSHOWBLOCK showSlider;
@end
