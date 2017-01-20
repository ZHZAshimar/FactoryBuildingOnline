//
//  ExpertImageCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//  冠军销售

#import "ExpertImageCollectionReusableView.h"

@implementation ExpertImageCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height*9/20, Screen_Width, self.frame.size.height-self.frame.size.height*9/20)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imageView.image = [UIImage imageNamed:@"shellOne"];
        
        [self addSubview:imageView];
        
    }
    return self;
}

@end
