//
//  SliderHeadView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/3.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderHeadView : UIView
/// 用户头像
@property (nonatomic, strong) UIImageView *userAvatarImageView;
/// 用户名称
@property (nonatomic, strong) UILabel *userNameLabel;

/// 位置
@property (nonatomic, strong) UILabel *addressLabel;

@end
