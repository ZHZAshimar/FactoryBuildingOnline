//
//  FivePathHeadCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/4.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "FivePathHeadCollectionReusableView.h"

@implementation FivePathHeadCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FivePathHeadCollectionReusableView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = arrayOfViews[0];
        
        self.label.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.label.font.pointSize]];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
