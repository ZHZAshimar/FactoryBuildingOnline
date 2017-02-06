//
//  AddRootView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TAPBUTTONBLOCK) (NSInteger index);

@interface AddRootView : UIView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) TAPBUTTONBLOCK tapButtonBlock;  // 点击图标按钮回调

- (id)initWithFrame:(CGRect)frame andType:(int)type;

- (void)removeView;

@end
