//
//  ExpertPersonCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ExpertPersonCollectionViewCell.h"
#import "SecurityUtil.h"

@implementation ExpertPersonCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ExpertPersonCollectionViewCell" owner:self options:nil];
        
        if (array.count < 1) {
            return nil;
        }
        
        if (![array[0] isKindOfClass:[ExpertPersonCollectionViewCell class]]) {
            return nil;
        }
        self = array[0];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = (Screen_Height * 10/71-30)/2;    // 要通过 screen_height 来计算，用 avatarImageView 的高度 拿到的一直是 58
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.nameLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.nameLabel.font.pointSize]];
    
    self.jobLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.jobLabel.font.pointSize]];
    
    self.areaLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.areaLabel.font.pointSize]];

}

- (void)setModel:(PromediumsModel *)model {
    
    self.nameLabel.text = model.realName;
    self.areaLabel.text = model.branch;
    
    NSString *avatarStr = [SecurityUtil decodeBase64String:model.avatar];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarStr] placeholderImage:[UIImage imageNamed:@"my_default"]];
    self.jobLabel.text = [NSString stringWithFormat:@"%@年经验",model.workYear];
}

@end
