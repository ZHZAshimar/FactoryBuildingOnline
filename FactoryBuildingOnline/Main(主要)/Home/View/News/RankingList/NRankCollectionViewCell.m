//
//  NRankCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/10.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NRankCollectionViewCell.h"

@implementation NRankCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NRankCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfViews[0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.channelLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.channelLabel.font.pointSize weight:0.2]];
    self.titleLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.titleLabel.font.pointSize]];
    
    self.imageView.layer.cornerRadius = (self.frame.size.height-20)/2;
    self.imageView.layer.masksToBounds = YES;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(12, 0)];
    [path addLineToPoint:CGPointMake(36, 0)];
    [path addLineToPoint:CGPointMake(12, self.frame.size.height/2)];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = GRAY_cc.CGColor;
    
    
    self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 24, self.frame.size.height/2-4)];
    self.rankLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12.0]];
    
    [self.layer addSublayer:layer];
    [self addSubview:self.rankLabel];
    self.rankLabel.textColor = [UIColor whiteColor];
//    self.rankLabel.text = @"1";
}

@end
