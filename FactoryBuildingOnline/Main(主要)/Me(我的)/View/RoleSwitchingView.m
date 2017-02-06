//
//  RoleSwitchingView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "RoleSwitchingView.h"

@implementation RoleSwitchingView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = frame;
        effectView.alpha = 0.93;
        [self addSubview:effectView];
        
        NSArray *titleArr = @[@"用户",@"专家"];
        NSArray *imgArray = @[@"userType",@"broker"];
        
        for (int i = 0; i < 2; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*Screen_Width/2, Screen_Height/2-Screen_Width/4, Screen_Width/2, Screen_Width/2);
            button.tag = 100+i;
            [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
//            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*Screen_Width/2, Screen_Height/2+Screen_Width/4, Screen_Width/2, 30)];
            label.text = titleArr[i];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:16.0f]];
            [self addSubview:label];
            
        }
        
        UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Screen_Height/2+Screen_Width/2, Screen_Width, 30)];
        selectLabel.textColor = [UIColor whiteColor];
        selectLabel.textAlignment = NSTextAlignmentCenter;
        selectLabel.text = @"选择身份";
        [self addSubview:selectLabel];
    }
    
    return self;
}
// 按钮点击回调
- (void)buttonAction: (UIButton *)sender {
    
    self.selectSwitchingBlock(sender.tag);
    
}
// 触碰到View 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tapViewBlock();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
