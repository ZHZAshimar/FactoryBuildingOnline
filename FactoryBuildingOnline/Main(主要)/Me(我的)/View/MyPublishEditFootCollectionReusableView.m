//
//  MyPublishEditFootCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/25.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "MyPublishEditFootCollectionReusableView.h"

@implementation MyPublishEditFootCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createTwoButton ];
        [self drawGrayView];
    }
    return self;
}

- (void)drawGrayView {
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-5, Screen_Width, 5)];
    grayView.backgroundColor = GRAY_ee;
    
    [self addSubview:grayView];
}

- (void)createTwoButton {
    
    CGFloat buttonWidth = Screen_Width*5/32;
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(Screen_Width-12-buttonWidth*2-10 + i*(buttonWidth+10), 8, buttonWidth, self.frame.size.height-5-16);
        
        button.tag = i+100;
        [button addTarget:self action:@selector(editButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [button setTitle:@"编辑" forState:0];
        } else {
            [button setTitle:@"删除" forState:0];
        }
        
        [button setTitleColor:RED_df3d forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12]];
        button.layer.borderColor = RED_df3d.CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        
        [self addSubview:button];
    }
}

- (void)editButtonDidTouch:(UIButton  *)sender {
    self.footerBlock(sender.tag);
}

@end
