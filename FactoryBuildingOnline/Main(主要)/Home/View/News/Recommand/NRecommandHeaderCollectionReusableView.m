//
//  NRecommandHeaderCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/9.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NRecommandHeaderCollectionReusableView.h"

@implementation NRecommandHeaderCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NRecommandHeaderCollectionReusableView" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = arrayOfViews[0];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.titleLabel.font.pointSize]  weight:0.2];
    self.scanNumLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.scanNumLabel.font.pointSize]];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.scanNumLabel.text = [NSString stringWithFormat:@"浏览人数:%@",dataDic[@""]];
    self.titleLabel.text = dataDic[@""];
    
}

@end
