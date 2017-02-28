//
//  AreaExpertPersonCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/20.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "AreaExpertPersonCollectionViewCell.h"
#import "SecurityUtil.h"

@implementation AreaExpertPersonCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AreaExpertPersonCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self =  arrayOfViews[0];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.nameLabel.font.pointSize]];
    
    self.jobLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.jobLabel.font.pointSize]];
    
    self.fatoryNumLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.jobLabel.font.pointSize]];
    
    self.avatarImageView.layer.cornerRadius = (Screen_Height * 10/71-30)/2;
    self.avatarImageView.layer.masksToBounds = YES ;
    
}

- (void)setDic:(NSDictionary *)dic {
    
    self.nameLabel.text = dic[@"real_name"];
    self.jobLabel.text = [NSString stringWithFormat:@"%@年经验",dic[@"year_experience"]];
    
    NSString *avatarStr = [SecurityUtil decodeBase64String:dic[@"avatar"]];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarStr] placeholderImage:[UIImage imageNamed:@"my_broker"]];
    
    self.fatoryNumLabel.text = @"";
}

@end
