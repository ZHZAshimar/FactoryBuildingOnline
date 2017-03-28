//
//  FactoryDetailViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/17.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"
#import "WantedMessageModel.h"

#import "FootCollectionReusableView.h"
#import "PublisherCollectionViewCell.h"
#import "DetailPictureCollectionViewCell.h"
#import "DetailMapCollectionViewCell.h"
#import "DetailFactoryIntroduceCollectionViewCell.h"
#import "DetailHeadCollectionReusableView.h"
#import "DetailOfFactoryInfoCollectionViewCell.h"
#import "RewardCollectionViewCell.h"

#import "PublishManViewController.h"
#import "ReportViewController.h"
#import "NSString+Judge.h"
#import "RequestMessage.h"
#import "FOLUserInforModel.h"
#import "GeoCodeOfBaiduMap.h"
#import "SecurityUtil.h"
#import "ZHZShareView.h"    // 分享界面

@interface FactoryDetailViewController : BaseViewController

@property (nonatomic, strong) WantedMessageModel *model;


@end
