//
//  MeFirstHeadCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/17.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "MeFirstHeadCollectionReusableView.h"

#import "SecurityUtil.h"

#define self_height self.frame.size.height

@implementation MeFirstHeadCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 头像
        self.userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width/2 - self.frame.size.height*19/55/2, self.frame.size.height*12/55, self.frame.size.height*19/55, self.frame.size.height*19/55)];
        
        self.userHeadImageView.layer.cornerRadius = self.frame.size.height*19/55/2;
        self.userHeadImageView.layer.masksToBounds = YES;
        
        self.userHeadImageView.userInteractionEnabled = YES;
        [self addSubview:self.userHeadImageView];
    
        UITapGestureRecognizer *tapUserHeadImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPesonalSetting:)];
        [self.userHeadImageView addGestureRecognizer:tapUserHeadImage];
        
        // 显示文字的按钮
        self.nameBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.nameBtn.frame = CGRectMake(0, self.frame.size.height*13/55+self.userHeadImageView.frame.size.height, self.frame.size.width, 30);
        self.nameBtn.backgroundColor = [UIColor clearColor];
        [self.nameBtn setTitleColor:BLACK_42 forState:UIControlStateNormal];
        [self.nameBtn setTitle:@"未登录，请登录" forState:0];
        self.nameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameBtn];
        
        [self.nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.integralLabel];
        
        [self addSubview:self.publishLabel];
        
        [self drawHexagon];
    }
    
    return self;
}


// 绘制六边形
- (void)drawHexagon {
    // 初始化一个view 作为绘制六边形的容器，因为cashapelayer 添加到button 之后，button的image 显示不出来。
    UIView *hexagonView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width/2-Screen_Width*3/40, self_height*83/110, Screen_Width*3/20, self_height*27/110)];
    [self addSubview:hexagonView];
    
    CGFloat btn_width = hexagonView.frame.size.width;
    CGFloat btn_height = hexagonView.frame.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath]; // 初始化 贝塞尔曲线
    [path moveToPoint:CGPointMake(btn_width/2, 0)]; // 设置起点
    [path addLineToPoint:CGPointMake(0, btn_height*13/54)];   // 添加绘制的点
    [path addLineToPoint:CGPointMake(0, btn_height*41/54)];
    [path addLineToPoint:CGPointMake(btn_width/2, btn_height)];
    [path addLineToPoint:CGPointMake(btn_width, btn_height*41/54)];
    [path addLineToPoint:CGPointMake(btn_width, btn_height*13/54)];
    [path closePath];   // 关闭路径，形成闭合路线
    
    self.hexagonShapeLayer = [CAShapeLayer layer];
    

    self.hexagonShapeLayer.fillColor = GREEN_19b8.CGColor;

    self.hexagonShapeLayer.path = path.CGPath;
    
    [hexagonView.layer addSublayer:self.hexagonShapeLayer];
    
    // 创建button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(Screen_Width/2-Screen_Width*3/40, self_height*83/110, Screen_Width*3/20, self_height*27/110);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"information"] forState:0];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

#pragma mark - 文字按钮 点击事件
- (void)nameBtnAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(tapNameButtonAction:)]) {
        [self.delegate tapNameButtonAction:sender];
    }
    
}
#pragma mark - 跳转到个人设置页面
- (void)gotoPesonalSetting:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(tapHeadPictureAction)]) {
        [self.delegate tapHeadPictureAction];
    }
}
#pragma mark - 跳转到个人发布界面
- (void)buttonAction:(UIButton *)sender {
    NSLog(@"tap hexagon ");
    if ([self.delegate respondsToSelector:@selector(tapHexagonButton)]) {
        [self.delegate tapHexagonButton];
    }
}

- (void)setUserModel:(FOLUserInforModel *)userModel {
    
    _userModel = userModel;
    
    
    NSString *userAvatar = [SecurityUtil decodeBase64String:userModel.avatar];
    
    
    [self.nameBtn setTitle:[NSString stringWithFormat:@"%@",userModel.userName] forState:0];
    
    if (userModel.type == 2) {  // 专家的图标
        [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:[UIImage imageNamed:@"my_broker"]];
        
        self.hexagonShapeLayer.fillColor = BLUE_FE.CGColor;
    } else {                // 普通用户的图标
        self.hexagonShapeLayer.fillColor = GREEN_19b8.CGColor;
        [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:[UIImage imageNamed:@"my_normal"]];
        
    }
    if (userModel.avatar.length > 0) {
            
        self.userHeadImageView.layer.borderColor = GRAY_94.CGColor;
        self.userHeadImageView.layer.borderWidth = 1;
        
    } else {
        self.userHeadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.userHeadImageView.layer.borderWidth = 0;
            
    }
    self.publishLabel.text = [NSString stringWithFormat:@"发布\n%d",userModel.publish_count];
}

//- (void)setIsLogin:(BOOL)isLogin {
//    _isLogin = isLogin;
//
//    [self setNeedsDisplay];    // 调用 [self setNeedsDisplay]; 系统将重写 drawRect:(CGRect)rect 方法
//}

//- (void)drawRect:(CGRect)rect {
//    
//    if (self.isLogin) {
//        
//        self.gotoLoginBtn.hidden = YES;
//        
//        self.userHeadImageView.hidden = NO;
//        self.useNameLabel.hidden = NO;
//        
//    } else {
//    
//        self.gotoLoginBtn.hidden = NO;
//        
//        self.userHeadImageView.hidden = YES;
//        self.useNameLabel.hidden = YES;
//    }
//    
//}
#pragma mark - lazy load
- (UILabel *)integralLabel {
    
    if (!_integralLabel) {
        _integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height*12/55, self.frame.size.height*19/55, self.frame.size.height*19/55)];
        
        _integralLabel.numberOfLines = 2;
        
        _integralLabel.text = @"积分\n0";
        
        _integralLabel.textAlignment = NSTextAlignmentCenter;
        
        _integralLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:15]];
        
        _integralLabel.textColor = BLACK_42;
    }
    return _integralLabel;
    
}

- (UILabel *)publishLabel {
    
    if (!_publishLabel) {
        _publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width - 20 - self.frame.size.height*19/55, self.frame.size.height*12/55, self.frame.size.height*19/55, self.frame.size.height*19/55)];
        
        _publishLabel.numberOfLines = 2;
        
        _publishLabel.text = @"发布\n0";
        
        _publishLabel.textAlignment = NSTextAlignmentCenter;
        
        _publishLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:15]];
        
        _publishLabel.textColor = BLACK_42;
    }
    return _publishLabel;
    
}

@end
