//
//  RecommendAndActionCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//  138  70  320 480  推荐 和 活动

#import "RecommendAndActionCollectionViewCell.h"

#define self_width self.frame.size.width
#define self_height self.frame.size.height

@implementation RecommendAndActionCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame ];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.borderColor = GRAY_e6.CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
    }
    return self;
}


- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, self_height*6/35, self_height*6/35)];
//        _imageView.backgroundColor = [UIColor orangeColor];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self_height*6/35 + 8+ 4, 8, self_width-20, self_height*6/35)];
        
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12.0f]];
        
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self_height*6/35 + 16, self_width-16, self_height - self_height*6/35 - 8*3)];
        
        _contentLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]];
        _contentLabel.numberOfLines = 2;
        
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;  // 尾部省略
    }
    return _contentLabel;
}

@end
