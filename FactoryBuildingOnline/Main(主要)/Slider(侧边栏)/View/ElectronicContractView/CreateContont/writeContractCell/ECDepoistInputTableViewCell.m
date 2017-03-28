//
//  ECDepoistInputTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/27.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECDepoistInputTableViewCell.h"

@implementation ECDepoistInputTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.unitLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.unitLabel.font.pointSize]];
    
    self.depoistTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.depoistTF.font.pointSize]];
    
    self.depoistTF.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.inputBlock(textField.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
