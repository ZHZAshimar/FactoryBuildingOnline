//
//  BrokerIntroCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/2/27.
//  Copyright © 2017年 XFZY. All rights reserved.
//  专家的 cell

#import "BrokerIntroCollectionViewCell.h"
#import "SecurityUtil.h"

@implementation BrokerIntroCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BrokerIntroCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count <= 0) {
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
    // 文字适配
    self.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.titleLabel.font.pointSize] weight:0.5]; // 加粗
    self.adressLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.adressLabel.font.pointSize]];
    self.areaLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.areaLabel.font.pointSize]];
    self.moneyLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.moneyLabel.font.pointSize]];
    
    self.fImageView.layer.borderColor = GRAY_e6.CGColor;
    self.fImageView.layer.borderWidth = 0.5;
    self.fImageView.layer.masksToBounds = YES;
    self.fImageView.layer.cornerRadius = 2;
}

- (void)setBrokerModel:(BrokerFactoryInfoModel *)brokerModel {
    
    _brokerModel = brokerModel;
    
    ProMediumFactoryModel *proFactoryModel = brokerModel.factoryModel;
    
    NSString *imageURL = [SecurityUtil decodeBase64String:proFactoryModel.thumbnail_url];
    
    [self.fImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:PLACEHOLDER_IMAGE];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",proFactoryModel.title];
    
    self.adressLabel.text = [NSString stringWithFormat:@"%@%@",proFactoryModel.area,proFactoryModel.address];
    
    NSString *price = [NSString stringWithFormat:@"%@元/m²",proFactoryModel.price];
    
    self.moneyLabel.text = price;  // 每月一平方的租金
    
    self.areaLabel.text = [NSString stringWithFormat:@"%@ m²",proFactoryModel.range];
}


@end
