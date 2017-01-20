//
//  ImagePlayerCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/14.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
@interface ImagePlayerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet ImagePlayerView *imagePlayerView;

@property (nonatomic, strong)NSArray *imageDataSource;

@end
