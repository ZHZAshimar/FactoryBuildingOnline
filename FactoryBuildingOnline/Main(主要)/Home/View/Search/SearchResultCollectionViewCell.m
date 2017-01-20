//
//  SearchResultCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SearchResultCollectionViewCell.h"

@implementation SearchResultCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
//        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Screen_Width, 43)];
//        self.label.textColor = BLACK_42;
//        self.label.font = [UIFont systemFontOfSize:14.0];
//        [self addSubview:self.label];
        
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 14, 20, 16)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, Screen_Width/2, 44)];
        self.typeLabel.textColor = GREEN_1ab8;
        self.typeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.typeLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-44, 53/4, 27, 17.5)];
        self.numLabel.backgroundColor = GRAY_d2;
        self.numLabel.textColor = GRAY_80;
        self.numLabel.font = [UIFont systemFontOfSize:13.0f];
        self.numLabel.layer.cornerRadius = 9;
        self.numLabel.layer.masksToBounds = YES;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numLabel];
        
        UIView *cutlineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, Screen_Width, 0.5)];
        cutlineView.backgroundColor = GRAY_db;
        [self addSubview:cutlineView];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    
    if ([dic[@"type"] intValue] == 1) {
        self.typeLabel.text = @"业主发布相关房源";
        self.imageView.image = [UIImage imageNamed:@"search_owner"];
    } else {
        self.typeLabel.text = @"专家发布相关房源";
        self.imageView.image = [UIImage imageNamed:@"search_broker"];
    }
    self.numLabel.text = [NSString stringWithFormat:@"%@",dic[@"count"]];
}

@end
