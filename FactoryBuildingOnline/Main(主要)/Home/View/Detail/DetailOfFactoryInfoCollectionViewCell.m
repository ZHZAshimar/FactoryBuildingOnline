//
//  DetailOfFactoryInfoCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "DetailOfFactoryInfoCollectionViewCell.h"

@implementation DetailOfFactoryInfoCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"DetailOfFactoryInfoCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            return nil;
        }
        
        if (![arrayOfView[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfView[0];
        
        [self setFontAdjust];
    }
    
    return self;
}

- (void)setFontAdjust {
    self.pLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.pLabel.font.pointSize]];
    self.sLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.sLabel.font.pointSize]];
    self.rLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.rLabel.font.pointSize]];
    self.cLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.cLabel.font.pointSize]];
    self.nLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.nLabel.font.pointSize]];
    
    self.publishTimeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.publishTimeLabel.font.pointSize]];
    self.scanCountLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.scanCountLabel.font.pointSize]];
    self.rentTypeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.rentTypeLabel.font.pointSize]];
    self.cashpledgeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.cashpledgeLabel.font.pointSize]];
    self.numberLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.numberLabel.font.pointSize]];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    NSString *time = [NSString getTimeFormatter:dataDic[@"created_time"]];
    self.publishTimeLabel.text = time;
    self.scanCountLabel.text = [NSString stringWithFormat:@"%d",[dataDic[@"view_count"] integerValue]];
    self.rentTypeLabel.text = dataDic[@"rent_type"];
    self.cashpledgeLabel.text = dataDic[@"pre_pay"];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"factory_id"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
