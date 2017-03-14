//
//  FMHeaderView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *FMNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *FMContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upLoadImageView;
@property (weak, nonatomic) IBOutlet UILabel *allTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *curTimeLabel;

@end
