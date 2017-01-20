//
//  AreaCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "AreaCollectionViewCell.h"

@implementation AreaCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AreaCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[AreaCollectionViewCell class]]) {
            return nil;
        }
        
        self = arrayOfViews[0];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAreaLabel:(UILabel *)areaLabel {
    
    _areaLabel = areaLabel;
    
    _areaLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:_areaLabel.font.pointSize]];
}

@end
