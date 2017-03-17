//
//  ECTimerView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//  电子合同的头部计时器

#import "ECTimerView.h"

@interface ECTimerView ()
{
    
}
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation ECTimerView

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHex:0xFFF38F];
        
        [self addSubview:self.textLabel];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(Screen_Width*1.5, self.frame.size.height/2)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-Screen_Width/2, self.frame.size.height/2)];
        animation.duration = 8.0;
        animation.repeatCount = HUGE_VALF;
        
        [self.textLabel.layer addAnimation:animation forKey:nil];
    }
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.text = @"若对方要求您预先支付相关费用，请务必谨慎处理！";
        
        _textLabel.textColor = RED_df3d;
        _textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
   
    }
    return _textLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
