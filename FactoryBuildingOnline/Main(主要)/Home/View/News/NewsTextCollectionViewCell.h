//
//  NewsTextCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/21.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTextCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;   // 关闭的图标
@property (weak, nonatomic) IBOutlet UILabel *label;
@end
