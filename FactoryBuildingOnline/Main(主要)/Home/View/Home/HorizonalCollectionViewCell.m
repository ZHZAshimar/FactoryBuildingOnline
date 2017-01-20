//
//  HorizonalCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HorizonalCollectionViewCell.h"
#import "SecurityUtil.h"

@implementation HorizonalCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
    
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    NSString *avatarURL = [SecurityUtil decodeBase64String:dic[@"avatar"]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"my_default"]];
    
    self.name.text = dic[@"real_name"];
    
    [self.jobButton setTitle:dic[@"branch"] forState:0];
    [self.jobButton setImage:nil forState:0];
    self.jobButton.selected = NO;
    [self.jobButton setTitleColor:BLACK_57 forState:0];
    
    self.imageView.layer.cornerRadius = 41/2;
    self.imageView.layer.masksToBounds = YES;
    
}

@end
