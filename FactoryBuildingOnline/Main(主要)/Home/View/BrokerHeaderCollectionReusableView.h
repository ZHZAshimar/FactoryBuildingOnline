//
//  BrokerHeaderCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/6.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrokerHeaderCollectionReusableView : UICollectionReusableView
/// 经纪人头像
@property (weak, nonatomic) IBOutlet UIImageView *brokerImageView;
/// 经纪人名称
@property (weak, nonatomic) IBOutlet UILabel *brokerName;
/// 职位
@property (weak, nonatomic) IBOutlet UILabel *brokerPosition;
/// 入职时间
@property (weak, nonatomic) IBOutlet UILabel *dateEmptyedLabel;
/// 发布厂房数 (num)
@property (weak, nonatomic) IBOutlet UILabel *publishNumLabel;

@property (nonatomic, strong) NSDictionary *infoDic;

@end
