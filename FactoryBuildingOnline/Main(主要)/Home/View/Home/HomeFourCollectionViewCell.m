//
//  HomeFourCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/4.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeFourCollectionViewCell.h"

@implementation HomeFourCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HomeFourCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndexCheck:0] isKindOfClass:[UICollectionViewCell class]]) {
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
