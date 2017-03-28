//
//  NDynamicFactoryCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/13.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDynamicFactoryCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
