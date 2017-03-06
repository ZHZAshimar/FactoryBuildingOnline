//
//  MainCoverView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/4.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "MainCoverView.h"

@implementation MainCoverView
- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tapBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
