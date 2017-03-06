//
//  MainCoverView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/4.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TAPBLOCK) ();

@interface MainCoverView : UIView
@property (nonatomic, strong) TAPBLOCK tapBlock;
@end
