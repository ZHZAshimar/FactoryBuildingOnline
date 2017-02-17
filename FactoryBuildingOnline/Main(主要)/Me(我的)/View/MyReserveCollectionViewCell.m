//
//  MyReserveCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by Ashimar ZHENG on 2017/2/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "MyReserveCollectionViewCell.h"

@implementation MyReserveCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MyReserveCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count <=0 ) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfViews[0];
        self.publishTimeLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13]];
        self.matchTimeLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
        self.contentLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14]];
        
        self.matchTimeLabel.layer.cornerRadius = 5;
        self.matchTimeLabel.layer.masksToBounds = YES;
        
    }
    return self;
}


- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    NSString *contentStr = dataDic[@"content"];
    NSLog(@"%ld",contentStr.length);
    
    NSString * matchStr;
    int type = [dataDic[@"type"] intValue];
    if (type != 1) {
        // 匹配中
        matchStr = [NSString stringWithFormat:@"匹配中:%@",@"99天" ];
        self.matchTimeLabel.backgroundColor = [UIColor redColor];
    } else {
        
        matchStr = [NSString stringWithFormat:@"匹配结束:%@",@"99天" ];
        self.matchTimeLabel.backgroundColor = GREEN_19b8;
    }
    
    CGFloat matchStrLength = [NSString widthForString:matchStr fontSize:[UIFont adjustFontSize:self.matchTimeLabel.font.pointSize] andHeight:30];
    self.matchTimeLabel.text = matchStr;
    self.matchLength.constant = matchStrLength+5;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
