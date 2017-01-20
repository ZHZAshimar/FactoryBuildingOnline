//
//  RoleSwitchingView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SELECTSWITCHINGBLOCK) (NSInteger index);

typedef void(^TAPVIEWBLOCK)();

@interface RoleSwitchingView : UIView

@property (nonatomic, copy) SELECTSWITCHINGBLOCK selectSwitchingBlock;  // 选择角色的回调
@property (nonatomic, copy) TAPVIEWBLOCK tapViewBlock;  // 点击到view 的回调
@end
