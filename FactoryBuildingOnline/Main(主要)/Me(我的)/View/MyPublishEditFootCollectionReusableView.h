//
//  MyPublishEditFootCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/25.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PUBLISHFOOTERBLOCK) (NSInteger tagIndex);

@interface MyPublishEditFootCollectionReusableView : UICollectionReusableView

@property (nonatomic, copy) PUBLISHFOOTERBLOCK footerBlock;

@end
