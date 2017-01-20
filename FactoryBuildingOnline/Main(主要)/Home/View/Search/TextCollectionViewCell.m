//
//  TextCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/16.
//  Copyright © 2016年 XFZY. All rights reserved.
//  Developer :Ashimar_ZHZ

#import "TextCollectionViewCell.h"

@implementation TextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        
        self.label.backgroundColor = [UIColor clearColor];
        
        self.label.textAlignment = NSTextAlignmentCenter;
        
        self.label.textColor = BLACK_42;
        
        self.label.font = [UIFont systemFontOfSize:12.0f];
        
        [self addSubview:self.label];
        
        // 绘制边框， 圆角为4
        self.layer.borderColor = GRAY_db.CGColor;
        
        self.layer.borderWidth = 0.5;
        
        self.layer.cornerRadius = 4;
        
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

@end
