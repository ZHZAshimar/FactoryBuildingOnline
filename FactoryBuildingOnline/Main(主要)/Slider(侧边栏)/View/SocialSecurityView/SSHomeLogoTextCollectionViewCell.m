//
//  SSHomeLogoTextCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/14.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SSHomeLogoTextCollectionViewCell.h"

@implementation SSHomeLogoTextCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SSHomeLogoTextCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfViews[0];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageBtn.enabled = NO;
    self.imageBtn.layer.cornerRadius = (Screen_Height * 72/568-34)/2;
    self.imageBtn.layer.masksToBounds = YES;
    
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.titleLabel.font.pointSize]];
}

@end
