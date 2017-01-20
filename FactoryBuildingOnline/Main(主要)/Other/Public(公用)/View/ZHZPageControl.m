//
//  ZHZPageControl.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ZHZPageControl.h"

@implementation ZHZPageControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    
    }
    return self;
}
// 重写父类的 currentPage
- (void)setCurrentPage:(NSInteger)currentPage {
    
    [super setCurrentPage:currentPage];
    
    int index = 0;
    for (UIImageView *dot in self.subviews) {
        
        if (index == self.currentPage) {
            
            dot.layer.borderColor = GREEN_1ab8.CGColor;
            dot.layer.borderWidth = 1;
        } else {
            
            dot.layer.borderWidth = 0;
        }
        
        index++;
    }

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
