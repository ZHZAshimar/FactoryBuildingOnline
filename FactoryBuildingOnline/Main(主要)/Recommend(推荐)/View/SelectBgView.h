//
//  SelectBgView.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LeftTableView.h"
#import "RightTableView.h"
#import "PriceView.h"

@interface SelectBgView : UIView
@property (nonatomic, strong) UIView *alphaView;
@property (nonatomic, strong) RightTableView *rightTableView;
@property (nonatomic, strong) LeftTableView *leftTableView;
@property (nonatomic, strong) PriceView *priceView;

- (id)initWithFrame:(CGRect)frame withIndex:(NSInteger)index;

@end
