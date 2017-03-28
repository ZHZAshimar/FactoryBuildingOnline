//
//  NDynamicHeaderCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDynamicHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
