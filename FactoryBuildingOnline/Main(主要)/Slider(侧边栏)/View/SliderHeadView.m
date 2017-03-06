//
//  SliderHeadView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/3.
//  Copyright © 2017年 XFZY. All rights reserved.
//  侧滑的头部

#import "SliderHeadView.h"
#define view_width self.frame.size.width
#define view_height self.frame.size.height

@implementation SliderHeadView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FRESHADDRESS" object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.userAvatarImageView];
        [self addSubview:self.userNameLabel];
        [self addSubview:self.addressLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddress:) name:@"FRESHADDRESS" object:nil];
    }
    return self;
}

- (void)refreshAddress: (NSNotification *)sender {
    self.addressLabel.text = sender.userInfo[@"street"];
}

#pragma mark- lazy load
- (UIImageView *)userAvatarImageView {
    if (!_userAvatarImageView) {
        _userAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, view_height*63/208, view_height*155/416, view_height*155/416)];
        _userAvatarImageView.image = [UIImage imageNamed:@"my_normal"];
//        _userAvatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _userAvatarImageView.layer.cornerRadius = view_height*155/416/2;
        _userAvatarImageView.layer.masksToBounds = YES;
        
    }
    return _userAvatarImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.userAvatarImageView.frame.size.height+self.userAvatarImageView.frame.origin.y+10, view_width/2, 30)];
        _userNameLabel.textColor = BLACK_42;
        _userNameLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13]];
        _userNameLabel.text = @"未登录";
    }
    return _userNameLabel;
}
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat y = self.userAvatarImageView.frame.size.height+self.userAvatarImageView.frame.origin.y+10+30;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"s_location"]];
        imageView.frame = CGRectMake(16, y+7.5, 15, 15);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+16+8, y, view_width-30, 30)];
        _addressLabel.text = @"正在定位";
        _addressLabel.textColor = GRAY_80;
        _addressLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
    }
    return _addressLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
