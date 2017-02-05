//
//  BoutiqueCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "BoutiqueCollectionViewCell.h"

@implementation BoutiqueCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BoutiqueCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfViews[0];
        
        
        self.titleLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.titleLabel.font.pointSize]];
        self.contentLable.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.contentLable.font.pointSize]];
        self.areaLable.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.areaLable.font.pointSize]];
        self.moneryLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.moneryLabel.font.pointSize]];
        self.adressLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.adressLabel.font.pointSize]];
        
        self.scanLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.scanLabel.font.pointSize]];
        
        self.imageView.layer.borderColor = GRAY_e6.CGColor;
        self.imageView.layer.borderWidth = 0.5;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 2;
        
    }
    
    
    
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
