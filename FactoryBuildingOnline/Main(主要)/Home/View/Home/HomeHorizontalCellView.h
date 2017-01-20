//
//  HomeHorizontalCellView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/29.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHorizontalCellView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;    // 大图片

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *goldmedalImageView;

@property (weak, nonatomic) IBOutlet UILabel *honourLabel;

@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@end
