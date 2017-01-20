//
//  DetailFactoryIntroduceCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "DetailFactoryIntroduceCollectionViewCell.h"

@implementation DetailFactoryIntroduceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"DetailFactoryIntroduceCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            return nil;
        }
        
        if (![arrayOfView[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfView[0];
        
        self.seeAllButton.layer.cornerRadius = 5;
        self.seeAllButton.layer.masksToBounds = YES;
        self.seeAllButton.layer.borderColor = GREEN_1ab8.CGColor;
        self.seeAllButton.layer.borderWidth = 1;
        
        self.seeAllButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
        self.intruduceLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
