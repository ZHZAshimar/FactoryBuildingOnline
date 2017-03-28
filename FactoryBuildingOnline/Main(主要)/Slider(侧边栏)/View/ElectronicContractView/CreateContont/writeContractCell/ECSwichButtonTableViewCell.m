//
//  ECSwichButtonTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/27.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECSwichButtonTableViewCell.h"

@implementation ECSwichButtonTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.titleLabel.font.pointSize]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
