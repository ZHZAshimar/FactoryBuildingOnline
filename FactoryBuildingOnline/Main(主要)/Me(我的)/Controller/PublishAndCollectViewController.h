//
//  PublishAndCollectViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/2.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    MYPUBLISH_TYPE,   // 我的发布
    MYCOLLECT_NORMAL_TYPE,   // 我的收藏 普通收藏 业主
    MYCOLLECT_BROKER_TYPE,   // 收藏 经纪人
}DATATYPE;

@interface PublishAndCollectViewController : BaseViewController

@property (nonatomic, assign) DATATYPE datatype;    // 数据类型

@end
