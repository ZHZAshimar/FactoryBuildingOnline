//
//  SearchResultCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UIImageView *imageView;   // logo

@property (nonatomic, strong) UILabel *numLabel;        // 个数label

@property (nonatomic, strong) NSDictionary *dic;

@end
