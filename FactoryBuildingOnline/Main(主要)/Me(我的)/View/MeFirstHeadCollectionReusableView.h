//
//  MeFirstHeadCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/17.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeFirstHeadCollectionReusableViewDelegate <NSObject>

- (void)tapNameButtonAction:(UIButton *)sender;     // 点击到文字

- (void)tapHeadPictureAction;   // 点击到头像

- (void)tapHexagonButton;   // 点击到六边形

@end

@interface MeFirstHeadCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) BOOL isLogin; // 判断时候登录

@property (nonatomic, strong) UIImageView *bgImageView; // 背景图片

@property (nonatomic, strong) UIImageView *userHeadImageView;   // 用户的头像

@property (nonatomic, strong) UIButton *nameBtn;   // 进行登录的按钮

@property (nonatomic, strong) UILabel *integralLabel;   // 积分

@property (nonatomic, strong) UILabel *publishLabel;    // 发布

@property (nonatomic, strong) CAShapeLayer *hexagonShapeLayer;

@property (nonatomic, weak) id<MeFirstHeadCollectionReusableViewDelegate> delegate;

@end
