//
//  DetailOfFactoryInfoCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TAGBLOCK) (BOOL isTag);

@interface DetailOfFactoryInfoCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) TAGBLOCK tagBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn; // 更多按钮

@property (nonatomic, strong) NSDictionary *dataDic;

@end
