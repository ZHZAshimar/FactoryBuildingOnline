//
//  NMCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/10.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *scanNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;

@end
