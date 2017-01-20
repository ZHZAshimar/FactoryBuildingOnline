//
//  FootCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/4.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "FootCollectionReusableView.h"

@implementation FootCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FootCollectionReusableView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            
            return nil;
            
        }
        
        if (![[arrayOfViews objectAtIndexCheck:0] isKindOfClass:[UICollectionReusableView class]]) {
            
            return nil;
            
        }
        
        self = [arrayOfViews objectAtIndexCheck:0];
        
    }
    
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
