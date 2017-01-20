//
//  DetailPictureCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
#import "FactoryModel.h"
#import "ProMediumFactoryModel.h"

@interface DetailPictureCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet ImagePlayerView *imagePlayerView;

@property (weak, nonatomic) IBOutlet UILabel *headLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthlyLabel;

@property (weak, nonatomic) IBOutlet UILabel *daythlyLabel;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UIView *backBtnView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
// 收藏
@property (weak, nonatomic) IBOutlet UIView *likeBtnView;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
// 图片指示
@property (weak, nonatomic) IBOutlet UIView *indexView;

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
// 分享
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UILabel *mLabel;
@property (weak, nonatomic) IBOutlet UILabel *dLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;


@property (nonatomic, strong) NSArray *imageData;

@property (nonatomic, strong) NSDictionary *dataDic;

///  厂房详情的
@property (nonatomic, strong) FactoryModel *ftModel;

@property (nonatomic, strong) ProMediumFactoryModel *brokerFactoryModel;  // 厂房详情 经纪人

@end
