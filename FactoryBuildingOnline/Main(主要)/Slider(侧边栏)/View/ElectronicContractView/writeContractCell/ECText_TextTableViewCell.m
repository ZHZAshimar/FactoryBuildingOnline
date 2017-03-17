//
//  ECText_TextTableViewCell.m
//  
//
//  Created by myios on 2017/3/17.
//
//  文字和文字

#import "ECText_TextTableViewCell.h"

@implementation ECText_TextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.contentLabel.font.pointSize]];
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.titleLabel.font.pointSize]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
