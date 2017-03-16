//
//  SSPayHeaderCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SSPayHeaderCollectionReusableView.h"

@implementation SSPayHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SSPayHeaderCollectionReusableView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = arrayOfViews[0];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
