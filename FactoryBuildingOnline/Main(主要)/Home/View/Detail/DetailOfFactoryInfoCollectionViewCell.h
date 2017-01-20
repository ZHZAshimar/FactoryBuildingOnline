//
//  DetailOfFactoryInfoCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOfFactoryInfoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *pLabel;
@property (weak, nonatomic) IBOutlet UILabel *sLabel;
@property (weak, nonatomic) IBOutlet UILabel *rLabel;
@property (weak, nonatomic) IBOutlet UILabel *cLabel;
@property (weak, nonatomic) IBOutlet UILabel *nLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel; // 发布时间

@property (weak, nonatomic) IBOutlet UILabel *scanCountLabel;   // 浏览量
@property (weak, nonatomic) IBOutlet UILabel *rentTypeLabel;    // 出租方式
@property (weak, nonatomic) IBOutlet UILabel *cashpledgeLabel;  // 押金

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;  // 编号


@property (nonatomic, strong) NSDictionary *dataDic;

@end
