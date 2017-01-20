//
//  HomeHorizontalCellView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/29.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeHorizontalCellView.h"

@implementation HomeHorizontalCellView

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView.layer.cornerRadius = 41/2;
        self.imageView.layer.masksToBounds = YES;
        self.goldmedalImageView.hidden = YES;
        self.honourLabel.hidden = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
