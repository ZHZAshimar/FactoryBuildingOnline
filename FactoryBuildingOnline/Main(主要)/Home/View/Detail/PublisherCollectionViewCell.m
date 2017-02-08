//
//  PublisherCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/17.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "PublisherCollectionViewCell.h"
#import "SecurityUtil.h"

@implementation PublisherCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PublisherCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        // 头像的背景
        self.imageBGView.layer.borderColor = GRAY_cc.CGColor;
        self.imageBGView.layer.borderWidth = 1;
        self.imageBGView.layer.cornerRadius = (Screen_Height*14/71)*67/112/2;
        self.imageBGView.layer.masksToBounds = YES;
        // 头像
        self.publisherHeadImageView.layer.cornerRadius = ((Screen_Height*14/71)*67/112-3)/2;
        self.publisherHeadImageView.layer.masksToBounds = YES;
        self.publisherHeadImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestured = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewAction:)];
        [self.publisherHeadImageView addGestureRecognizer:tapGestured];
        
        // 举报按钮
        self.reportBtn.layer.borderColor = RED_ec52.CGColor;
        self.reportBtn.layer.borderWidth = 0.5;
        self.reportBtn.layer.cornerRadius = 5;
        self.reportBtn.layer.masksToBounds = YES;
        self.reportBtn.titleLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.reportBtn.titleLabel.font.pointSize]];
        
        self.publishName.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.publishName.font.pointSize]];
        
    }
    return self;
}
- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    NSString *avatarStr = [SecurityUtil decodeBase64String:_dataDic[@"avatar"]];
    
    [self.publisherHeadImageView sd_setImageWithURL:[NSURL URLWithString:avatarStr] placeholderImage:[UIImage imageNamed:@"my_broker"]];
    
    NSString *userName = _dataDic[@"username"];
    
    if ([NSString validateMobile:userName]) {
        userName = [userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    self.publishName.text = [NSString stringWithFormat:@"发布人：%@",userName];
    
    
}

// 聊天
- (IBAction)chattingBtnAction:(UIButton *)sender {
    
    if ([self.publishDelegate respondsToSelector:@selector(sendMessage)]) {
        [self.publishDelegate sendMessage];
    }
    
}
// 电话
- (IBAction)callTelAction:(UIButton *)sender {
    
    if ([self.publishDelegate respondsToSelector:@selector(callPhone)]) {
        [self.publishDelegate callPhone];
    }
    
}
// 举报
- (IBAction)reportAction:(UIButton *)sender {
    
    if ([self.publishDelegate respondsToSelector:@selector(pushResportVC)]) {
        [self.publishDelegate pushResportVC];
    }
    
}
// 头像
- (void)tapImageViewAction:(UITapGestureRecognizer *)sender {
    
    if ([self.publishDelegate respondsToSelector:@selector(pushPublisherVC)]) {
        [self.publishDelegate pushPublisherVC];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
