//
//  HomeThirdPathView.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/4.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HeadLineInformationViewDelegate <NSObject>

// 点击 timer text 跳转的页面
- (void)timerTextBeTouched:(UIButton*)sender;

@end

@interface HeadLineInformationView : UIView

@property (nonatomic,weak) id<HeadLineInformationViewDelegate>timerTextdelegate;

@property (nonatomic,strong)UILabel *timelabel;
@property (nonatomic,strong)NSArray *textArray;

// 每秒更新界面
- (void) updateLabelAction;
@end
