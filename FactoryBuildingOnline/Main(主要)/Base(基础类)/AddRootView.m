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
    int userType;
}

@end

@implementation AddRootView

- (id)initWithFrame:(CGRect)frame andType:(int)type{
    
    if (self = [super initWithFrame:frame]) {
        userType = type;
        
        // 毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = frame;
        effectView.alpha = 0.93;
        [self addSubview:effectView];
        
        closeView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width/2-58/2, Screen_Height-65, 58, 58)];

        [self addSubview:closeView];
        
        // 关闭的按钮
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = closeView.bounds;
        [closeButton setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
        
        [closeButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        
        [closeView addSubview:closeButton];
        // 关闭按钮的动画
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.rotation";  // 中心旋转45度
        animation.duration = 0.5;
        animation.byValue = @(M_PI_4/2);
        [closeButton.layer addAnimation:animation forKey:@"rotateAnimation"];
        
        NSArray *logoView = @[@"add_publish",@"add_new",@"add_need",@"add_video"];
        
        for (int i = 0; i < 4; i++) {
            
            CGFloat buttonWidth = Screen_Width*29/160; // 按钮的宽度
            // 按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.tag = i+100;     // 给四个按钮添加 tag
            
            switch (i) {    // 给四个按钮设置位置
                case 0:
                {
                    button.frame = CGRectMake(Screen_Width/2-buttonWidth*2, Screen_Height-Screen_Height*206/1136, buttonWidth, buttonWidth);
                }
                    break;
                case 1:
                {
                    button.frame = CGRectMake(Screen_Width/2-buttonWidth-6, Screen_Height-Screen_Height*36/142, buttonWidth, buttonWidth);
                }
                    break;
                case 2:
                {
                    button.frame = CGRectMake(Screen_Width/2+6, Screen_Height-Screen_Height*36/142, buttonWidth, buttonWidth);
                }
                    break;
                case 3:
                {
                    button.frame = CGRectMake(Screen_Width/2+buttonWidth, Screen_Height-Screen_Height*206/1136, buttonWidth, buttonWidth);
                }
                    break;
                    
                default:
                    break;
            }
            
            [button setImage:[UIImage imageNamed:logoView[i]] forState:0];
//            if (type == 2) {   // 身份为专家时，可发布厂房
//                [button setImage:[UIImage imageNamed:@"add_publish"] forState:UIControlStateNormal];
//                [button setTitle:@"发布" forState:UIControlStateNormal];
//                button.tag = 1;
//            } else {           // 身份为普通用户时，可发布需求
//                [button setImage:[UIImage imageNamed:@"add_reserve"] forState:UIControlStateNormal];
//                [button setTitle:@"预定" forState:UIControlStateNormal];
//                button.tag = 0;
//            }
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
            [self addSubview:button];
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self beginAnimation:button];
        }
    }
    return self;
}

#pragma mark - 按钮点击回调
- (void)buttonAction: (UIButton *)sender {
    
    if (sender.tag == 100 && userType== 1) {
        [MBProgressHUD showError:@"请切换身份为专家" ToView:nil];
        return;
    }
    if (sender.tag == 102 && userType == 2) {
        [MBProgressHUD showError:@"请切换身份为用户" ToView:nil];
        return;
    }
    
    self.tapButtonBlock(sender.tag);
    
}
#pragma mark - 触碰到View
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeView];
}
#pragma mark - 移除视图
- (void)removeView {
    
    for (id ele in self.subviews) {
        
        if ([ele isKindOfClass:[UIButton class]]) {
            // 给按钮添加收缩动画
            [self closeButtonAnimation:(UIButton *)ele];
        }
    }
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    for (id ele in self.subviews) {
        // 将button移除
        if ([ele isKindOfClass:[UIButton class]]) {
            [ele removeFromSuperview];
        }
        // 将 view 从父视图 移除
        [self removeFromSuperview];
    }
}

#pragma mark - 按钮展开的动画
- (void)beginAnimation:(UIButton *)button{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    //        scaleAnimation.duration = 0.5;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:closeView.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:button.layer.position];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.3;
    [animationGroup setAnimations:@[scaleAnimation,positionAnimation]];
    
    [button.layer addAnimation:animationGroup forKey:@"animationGroup"];
}

#pragma mark - 按钮收缩动画
- (void)closeButtonAnimation:(UIButton *)button {

    // 关闭按钮的动画
    CABasicAnimation *closeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    closeAnimation.duration = 0.3;
    closeAnimation.byValue = @(-M_PI_4/2);
    [closeButton.layer addAnimation:closeAnimation forKey:@"closeAnimation"];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:button.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:closeView.layer.position];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.3;
    animationGroup.delegate = self;
    [animationGroup setAnimations:@[scaleAnimation,positionAnimation]];
    
    [button.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
    button.frame = closeView.frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
