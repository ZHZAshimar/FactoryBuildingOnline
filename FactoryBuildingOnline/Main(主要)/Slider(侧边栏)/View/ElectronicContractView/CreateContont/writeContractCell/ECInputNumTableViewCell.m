//
//  ECInputNumTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECInputNumTableViewCell.h"

@implementation ECInputNumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.titleLabel.font.pointSize]];
    
    self.unitLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.unitLabel.font.pointSize]];
    
    self.inputTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.inputTF.font.pointSize]];
    
    self.inputTF.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.inputBlock(textField.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
