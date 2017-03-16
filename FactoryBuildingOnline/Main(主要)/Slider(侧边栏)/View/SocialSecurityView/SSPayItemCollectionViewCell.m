//
//  SSPayItemCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SSPayItemCollectionViewCell.h"

@implementation SSPayItemCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.moneyLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, self.frame.size.height-0.5, Screen_Width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHex:0xD6D6D6];
        [self addSubview:lineView];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, Screen_Width/2, self.frame.size.height)];
        _titleLabel.text = @"养老保险";
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
        
    }
    return _titleLabel;
}
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-Screen_Width/3-12, 0, Screen_Width/3, self.frame.size.height)];
        _moneyLabel.textColor = [UIColor colorWithHex:0x333333];
        _moneyLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:10]];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.text = @"￥639/月";
    }
    return _moneyLabel;
}
@end
