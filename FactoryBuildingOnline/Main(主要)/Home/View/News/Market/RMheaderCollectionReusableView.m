//
//  RMheaderCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/10.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "RMheaderCollectionReusableView.h"

@implementation RMheaderCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RMheaderCollectionReusableView" owner:self options:nil];
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
    self.titleLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.titleLabel.font.pointSize  weight:0.2]];
    self.contentLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.contentLabel.font.pointSize]];
    
    self.scanLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.scanLabel.font.pointSize]];
}

@end
