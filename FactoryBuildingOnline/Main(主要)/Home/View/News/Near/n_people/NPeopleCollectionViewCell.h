//
//  NPeopleCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/13.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPeopleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@end
