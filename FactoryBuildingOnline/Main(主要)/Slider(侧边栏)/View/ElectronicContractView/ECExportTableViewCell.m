//
//  ECExportTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECExportTableViewCell.h"

@implementation ECExportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.selectButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [self.selectButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    
    self.stateLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.stateLabel.font.pointSize]];
    
    self.bigTextLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.bigTextLabel.font.pointSize]];
    
    self.contractNameLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.contractNameLabel.font.pointSize]];
    
    self.nLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.nLabel.font.pointSize]];
    
    self.contractNumLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.contractNumLabel.font.pointSize]];
    
    self.sLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.sLabel.font.pointSize]];
    
    self.sponsorLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.sponsorLabel.font.pointSize]];
    
    self.iLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.iLabel.font.pointSize]];
    
    self.invitedPeopleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.invitedPeopleLabel.font.pointSize]];
    
    self.dateLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.dateLabel.font.pointSize]];
    
    self.timeLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.timeLabel.font.pointSize]];
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    
    
//    [self.selectButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
//    [self.selectButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"choose"] forState:0];
    } else {
        [sender setImage:[UIImage imageNamed:@"uncheck"] forState:0];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
