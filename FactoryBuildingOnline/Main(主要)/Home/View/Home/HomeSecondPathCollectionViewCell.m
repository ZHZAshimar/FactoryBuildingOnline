//
//  HomeSecondPathCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeSecondPathCollectionViewCell.h"

@implementation HomeSecondPathCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HomeSecondPathCollectionViewCell" owner:self options:nil];
        
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
