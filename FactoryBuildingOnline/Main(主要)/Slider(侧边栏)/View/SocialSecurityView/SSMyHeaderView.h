//
//  SSMyHeaderView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/14.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSMyHeaderView : UIView

@property (nonatomic, strong) UIImageView *avatarImageView; // 头像的imageView

@property (nonatomic, strong) NSDictionary *logoTextDic;    // logo and text dictionary

@property (nonatomic, strong) UILabel *nameLabel ;  // 名称

@end
