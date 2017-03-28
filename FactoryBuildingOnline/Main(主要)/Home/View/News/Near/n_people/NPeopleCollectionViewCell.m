//
//  NPeopleCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/13.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NPeopleCollectionViewCell.h"

@implementation NPeopleCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NPeopleCollectionViewCell" owner:self options:nil];
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
/* 
 "avatar_url" = "http://img.oncom.cn/\U5934\U50cf14";
 "last_login" = "97\U59292\U5c0f\U65f647\U5206";
 range = "0.261";
 tag = "\U6c38\U5229\U8fbe";
 "user_type" = 1;
 username = a4;
 
 */
- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    self.userNameLabel.text = dataDic[@"username"];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",dataDic[@"range"]];
    self.timeLabel.text = dataDic[@"last_login"];
    self.companyLabel.text = dataDic[@"tag"];
    int type = [dataDic[@"user_type"] intValue];
    UIImage *image;
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
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userNameLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.userNameLabel.font.pointSize]];
    self.tagLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.tagLabel.font.pointSize]];
    self.distanceLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.distanceLabel.font.pointSize]];
    self.timeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.timeLabel.font.pointSize]];
    self.companyLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.companyLabel.font.pointSize]];
}

@end
