//
//  PublisherCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/17.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublisherCollectionViewCellDelegate <NSObject>
// 发送短信
- (void)sendMessage;
// 打电话
- (void)callPhone;
// 跳转发布人界面
- (void)pushPublisherVC;
// 跳转举报界面
- (void)pushResportVC;

@end

@interface PublisherCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *imageBGView;

@property (weak, nonatomic) IBOutlet UIImageView *publisherHeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *publishName;

@property (weak, nonatomic) IBOutlet UIButton *reportBtn;

@property (nonatomic, assign) id<PublisherCollectionViewCellDelegate> publishDelegate;

@property (nonatomic, strong) NSDictionary *dataDic;

@end
