//
//  AdjustTradeTableViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/22.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "AdjustTradeTableViewCell.h"

@implementation AdjustTradeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.selectImageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width - 30, 16, 16, 11)];
        
    }
    return _selectImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, self.frame.size.height)];
        
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
        
        _titleLabel.textColor = BLACK_42;
    }
    return _titleLabel;
}

@end
