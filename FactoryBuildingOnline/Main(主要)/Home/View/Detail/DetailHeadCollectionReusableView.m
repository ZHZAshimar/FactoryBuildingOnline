//
//  DetailHeadCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "DetailHeadCollectionReusableView.h"

@implementation DetailHeadCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"DetailHeadCollectionReusableView" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            return nil;
        }
        if (![arrayOfView[0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = arrayOfView[0];
        // 自适应文字大小
        self.headLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.headLabel.font.pointSize]];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
