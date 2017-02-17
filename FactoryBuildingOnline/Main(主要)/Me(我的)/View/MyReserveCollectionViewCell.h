//
//  MyReserveCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by Ashimar ZHENG on 2017/2/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReserveCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *matchTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelBttom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matchLength;
@property (nonatomic, strong) NSDictionary *dataDic;    // 数据
@property (nonatomic, assign) BOOL hiddenImage;
@end
