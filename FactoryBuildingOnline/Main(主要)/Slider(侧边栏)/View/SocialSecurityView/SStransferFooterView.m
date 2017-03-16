//
//  SStransferFooterView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SStransferFooterView.h"

@implementation SStransferFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SStransferFooterView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UIView class]]) {
            return nil;
        }
        self = arrayOfViews[0];
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
