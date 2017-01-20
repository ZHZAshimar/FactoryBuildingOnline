//
//  DetailFactoryIntroduceCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailFactoryIntroduceCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *intruduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraintHeight;

@end
