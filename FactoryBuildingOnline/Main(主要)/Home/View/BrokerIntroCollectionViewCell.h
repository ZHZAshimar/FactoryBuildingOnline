//
//  BrokerIntroCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/2/27.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrokerFactoryInfoModel.h"

@interface BrokerIntroCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@property (strong, nonatomic) BrokerFactoryInfoModel *brokerModel;    // 经纪人model

@end
