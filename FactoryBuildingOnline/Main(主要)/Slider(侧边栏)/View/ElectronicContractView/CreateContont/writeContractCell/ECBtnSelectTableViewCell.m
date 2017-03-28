//
//  ECBtnSelectTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//  文字和选择button

#import "ECBtnSelectTableViewCell.h"

@implementation ECBtnSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
