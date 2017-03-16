//
//  ECVisitTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECVisitTableViewCell.h"

@implementation ECVisitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.stateLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.stateLabel.font.pointSize]];
    self.nameLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.nameLabel.font.pointSize]];
    self.dateLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.dateLabel.font.pointSize]];
    self.timeLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.timeLabel.font.pointSize]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
