//
//  FivePathCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/4.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WantedMessageModel.h"
#import "BrokerFactoryInfoModel.h"

@interface FivePathCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *eyeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;    // 图片

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;    // 名称

@property (weak, nonatomic) IBOutlet UILabel *addressLabel; // 位置

@property (weak, nonatomic) IBOutlet UILabel *moneyOfMonthLabel;   // 💰

@property (weak, nonatomic) IBOutlet UILabel *moneyOfdayLabel;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel; // 面积

@property (weak, nonatomic) IBOutlet UILabel *scanLabel;    // 浏览

@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (strong, nonatomic) WantedMessageModel *model;    // 数据model

@property (strong, nonatomic) BrokerFactoryInfoModel *brokerModel;    // 经纪人model

@end
