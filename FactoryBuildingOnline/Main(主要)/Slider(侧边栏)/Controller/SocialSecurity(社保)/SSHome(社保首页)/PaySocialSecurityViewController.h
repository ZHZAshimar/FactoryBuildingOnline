//
//  PaySocialSecurityViewController.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
//  缴社保 与 补缴社保

#import <UIKit/UIKit.h>

typedef enum {
    PAYSOCIALSECURITY = 0,      // 缴社保
    PAYCHANGESOCIALSECURITY,    // 补缴社保
}VCTYPE;                        // viewcontroller 的类型

@interface PaySocialSecurityViewController : UIViewController

@property (nonatomic, assign) VCTYPE vctype;

@end
