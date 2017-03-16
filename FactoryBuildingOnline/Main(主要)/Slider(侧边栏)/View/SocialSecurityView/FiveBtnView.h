//
//  FiveBtnView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BUTTONTAGBLOCK) (NSInteger tagindex);

@interface FiveBtnView : UIView

@property (nonatomic, copy) BUTTONTAGBLOCK tagBlock;

@end
