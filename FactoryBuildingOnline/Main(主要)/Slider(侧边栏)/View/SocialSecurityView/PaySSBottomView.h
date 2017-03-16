//
//  PaySSBottomView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    PAYSS       = 0,    // 缴费
    TRANSFERSS          // 转移
} BOTTOMTYPE;

typedef void(^ButtonTagBlock) (NSInteger tagIndex);

@interface PaySSBottomView : UIView

@property (nonatomic, copy) ButtonTagBlock tagBlock;

@property (nonatomic, assign) BOTTOMTYPE bottomType;

@end
