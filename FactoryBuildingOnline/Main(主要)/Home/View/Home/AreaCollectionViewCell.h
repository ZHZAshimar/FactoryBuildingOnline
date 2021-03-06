//
//  AreaCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrancheModel.h"

@interface AreaCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *areaImageView;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (nonatomic, strong) BrancheModel *model;

@end
