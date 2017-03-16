//
//  ECCreateTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECCreateTableViewCell.h"

@implementation ECCreateTableViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
       
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bigLabel.layer.cornerRadius = 10;
    
    self.bigLabel.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
