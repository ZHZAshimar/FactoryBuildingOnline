//
//  NDynamicHeaderCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NDynamicHeaderCollectionReusableView.h"

@implementation NDynamicHeaderCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NDynamicHeaderCollectionReusableView" owner:self options:nil];
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
    
    self.userNameLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.userNameLabel.font.pointSize]];
    self.tagLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.tagLabel.font.pointSize]];
    self.distanceLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.distanceLabel.font.pointSize]];
    self.timeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.timeLabel.font.pointSize]];
    self.contentLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.contentLabel.font.pointSize]];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    UIImage *image;
    int type = [dataDic[@"user_type"] intValue];
    
    if (type == 0) {
        self.tagLabel.text = @"用户";
        
        image = [UIImage imageNamed:@"my_normal"];

    } else if (type == 1) {
        image = [UIImage imageNamed:@"my_normal"];
        self.tagLabel.text = @"业主";
    } else {
        image = [UIImage imageNamed:@"my_broker"];
        self.tagLabel.text = @"经济";
    }
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar_url"]] placeholderImage:image];
    self.userNameLabel.text = dataDic[@"username"];
    self.contentLabel.text = dataDic[@"dynamic_explain"];
    self.timeLabel.text = dataDic[@"last_login"];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",dataDic[@"range"]];
    
}

@end
