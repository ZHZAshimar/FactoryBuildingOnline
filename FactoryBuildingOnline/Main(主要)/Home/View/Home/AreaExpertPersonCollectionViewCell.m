//
//  AreaExpertPersonCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/20.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "AreaExpertPersonCollectionViewCell.h"

@implementation AreaExpertPersonCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AreaExpertPersonCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self =  arrayOfViews[0];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.nameLabel.font.pointSize]];
    
    self.jobLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.jobLabel.font.pointSize]];
    
    self.fatoryNumLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.jobLabel.font.pointSize]];
    
    self.avatarImageView.layer.cornerRadius = Screen_Height * 45/284/3;
    self.avatarImageView.layer.masksToBounds = YES;
    
}

@end
