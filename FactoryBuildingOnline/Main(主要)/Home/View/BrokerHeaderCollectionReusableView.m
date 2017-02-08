//
//  BrokerHeaderCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/6.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BrokerHeaderCollectionReusableView.h"
#import "SecurityUtil.h"

@implementation BrokerHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BrokerHeaderCollectionReusableView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndexCheck:0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndexCheck:0];
        self.brokerImageView.layer.masksToBounds = YES;
        self.brokerImageView.layer.cornerRadius = 30;
        
        // 文字自适应
        self.brokerName.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.brokerName.font.pointSize]];
        self.brokerPosition.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.brokerPosition.font.pointSize]];
        self.dateEmptyedLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.dateEmptyedLabel.font.pointSize]];
    }
    
    return self;
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    
    _infoDic = infoDic;
    
    NSString *avatar = [SecurityUtil decodeBase64String:infoDic[@"avatar"]];
    
    [self.brokerImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"my_default"]];
    
    self.brokerName.text = infoDic[@"real_name"];
    
    self.brokerPosition.text = infoDic[@"branch"];
    
    self.dateEmptyedLabel.text = [NSString stringWithFormat:@"入职%@年",infoDic[@"year_experience"]];
//    self.publishNumLabel.text = [NSString stringWithFormat:@"(%@)",infoDic[@""]]
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
