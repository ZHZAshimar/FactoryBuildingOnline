//
//  AddRootView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "AddRootView.h"

@interface AddRootView()<CAAnimationDelegate>
{
    UIButton *closeButton;
    UIView *closeView;
}

@end

@implementation AddRootView

- (id)initWithFrame:(CGRect)frame andType:(int)type{
    
    if (self = [super initWithFrame:frame]) {
        
        // 毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = frame;
        effectView.alpha = 0.93;
        [self addSubview:effectView];
        
        closeView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width/2-15, Screen_Height-45, 30, 30)];
        closeView.backgroundColor = GREEN_19b8;
        closeView.layer.borderWidth = 1;
        closeView.layer.borderColor = [UIColor whiteColor].CGColor;
        closeView.layer.cornerRadius = 8;
        [self addSubview:closeView];
        
        // 关闭的按钮
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = closeView.bounds;
        [closeButton setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
        
        [closeButton addTarget:self action:@selector(removeView:) forControlEvents:UIControlEventTouchUpInside];
        
        [closeView addSubview:closeButton];
        // 关闭按钮的动画
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.rotation";  // 中心旋转45度
        animation.duration = 0.5;
        animation.byValue = @(M_PI_4);
        [closeButton.layer addAnimation:animation forKey:@"rotateAnimation"];
        
        // 按钮
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.button.backgroundColor = [UIColor redColor];
        self.button.frame = CGRectMake(Screen_Width/2-Screen_Height*17/142/2, Screen_Height-150-Screen_Height*17/142, Screen_Height*17/142, Screen_Height*17/142+30);
        
        if (type == 2) {   // 身份为专家时，可发布厂房
            [self.button setImage:[UIImage imageNamed:@"add_publish"] forState:UIControlStateNormal];
            [self.button setTitle:@"发布" forState:UIControlStateNormal];
            self.button.tag = 1;
        } else {           // 身份为普通用户时，可发布需求
            [self.button setImage:[UIImage imageNamed:@"add_reserve"] forState:UIControlStateNormal];
            [self.button setTitle:@"预定" forState:UIControlStateNormal];
            self.button.tag = 0;
        }

        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.button.titleEdgeInsets = UIEdgeInsetsMake(0, -Screen_Height*17/142, -Screen_Height*11/71, 0);
//        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:self.button];
        
        [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
//        scaleAnimation.duration = 0.5;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:closeView.layer.position];
        positionAnimation.toValue = [NSValue valueWithCGPoint:self.button.layer.position];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = 0.3;
        [animationGroup setAnimations:@[scaleAnimation,positionAnimation]];
        
        [self.button.layer addAnimation:animationGroup forKey:@"animationGroup"];
    }
    return self;
}
// 按钮点击回调
- (void)buttonAction: (UIButton *)sender {
    
    self.tapButtonBlock(sender.tag);
    
}
// 触碰到View
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.tapViewBlock();
    
    [self removeView];
}



- (void)removeView:(UIButton *)sender {
    
    [self removeView];
}


- (void)removeView {
    
    // 关闭按钮的动画
    CABasicAnimation *closeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    closeAnimation.duration = 0.3;
    closeAnimation.byValue = @(-M_PI_4);
    [closeButton.layer addAnimation:closeAnimation forKey:@"closeAnimation"];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.button.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:closeView.layer.position];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.3;
    animationGroup.delegate = self;
    [animationGroup setAnimations:@[scaleAnimation,positionAnimation]];
    
    [self.button.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
