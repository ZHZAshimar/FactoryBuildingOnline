//
//  RewardCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/22.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "RewardCollectionViewCell.h"

@implementation RewardCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, self.frame.size.height)];
        
        _contentLabel.textColor = RED_df3d;
        
        _contentLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:16.0]];
        
        _contentLabel.text = [NSString stringWithFormat:@"悬赏:50万元"];
    }
    return _contentLabel;
}
@end
