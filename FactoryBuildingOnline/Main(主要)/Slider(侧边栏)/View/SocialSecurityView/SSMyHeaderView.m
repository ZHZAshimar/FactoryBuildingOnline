//
//  SSMyHeaderView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/14.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SSMyHeaderView.h"
@implementation SSMyHeaderView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
        
    }
    return self;
}

- (void)initView {
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.frame.size.height*2/3)];
    [self addSubview:upView];
    // 背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:upView.bounds];
    bgImageView.image = [UIImage imageNamed:@"ssmy_bg"];
    [upView addSubview:bgImageView];
    // 头像设置
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, upView.frame.size.height/2, upView.frame.size.height/2)];
    self.avatarImageView.center = upView.center;
    self.avatarImageView.image = [UIImage imageNamed:@"ss_myAvatar"];
    self.avatarImageView.layer.cornerRadius = upView.frame.size.height/4;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 3;
    [upView addSubview:self.avatarImageView];
    // 添加名称label
    [upView addSubview:self.nameLabel];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height*2/3, Screen_Width, self.frame.size.height/3)];
    
    [self addSubview:downView];
    
    NSArray *array = @[
  @{@"name":@"待付款",@"logo":@"ss_waitPay"},
  @{@"name":@"补差额",@"logo":@"ss_payDifference"},
  @{@"name":@"待办事项",@"logo":@"ss_waitdo"},
  @{@"name":@"我的订单",@"logo":@"ss_myOrder"}];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(Screen_Width/4), 0, Screen_Width/4, downView.frame.size.height);
        // 设置图片和文字
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height*2/3-8, button.frame.size.width, button.frame.size.height/3)];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = array[i][@"name"];
        title.textColor = BLACK_66;
        title.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
        [button addSubview:title];
        [button setImage:[UIImage imageNamed:array[i][@"logo"]] forState:0];
        button.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        button.tag = i;
        [downView addSubview:button];
    }
}

#pragma mark - lazyload
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.avatarImageView.frame.origin.y + self.avatarImageView.frame.size.height/2+10, Screen_Width, 30)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0]];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
