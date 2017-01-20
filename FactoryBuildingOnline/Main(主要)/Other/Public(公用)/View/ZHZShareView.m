//
//  ZHZShareView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/19.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ZHZShareView.h"
#import <ShareSDK/ShareSDK.h>

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import <ShareSDKUI/ShareSDKUI.h>

#define self_width self.frame.size.width
#define self_height self.frame.size.height

#define shareArray @[@{@"icon":@"sns_icon_22",@"name":@"微信"},@{@"icon":@"sns_icon_23",@"name":@"朋友圈"},@{@"icon":@"sns_icon_1",@"name":@"微博"},@{@"icon":@"sns_icon_24",@"name":@"QQ"},@{@"icon":@"sns_icon_6",@"name":@"QQ空间"}]

@interface ZHZShareView()
{
    UIView *bottomView;
    UIView *lineView;   // 分割线
}
@end

@implementation ZHZShareView

- (id)init {
    
    if (self = [super init]) {
        
        [self setAlphaView];
        
        [self setBottomView];
    }
    return self;
}

- (void)setAlphaView {
    
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.bounds];
    
    alphaView.backgroundColor = [UIColor blackColor];
    
    alphaView.alpha = 0.4;
    
    [self addSubview:alphaView];
    // 给阴影层添加 点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    alphaView.userInteractionEnabled = YES;
    [alphaView addGestureRecognizer:tap];
}

- (void)setBottomView {
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,Screen_Height-Screen_Height * 75/284, Screen_Width, Screen_Height * 75/284)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:bottomView];
    //// 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, bottomView.frame.size.height*54/75, Screen_Width, bottomView.frame.size.height*21/75);
    
    [closeBtn setTitleColor:GREEN_19b8 forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:0];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeBtn];
    
    // 分割线
    lineView = [[UIView alloc] initWithFrame:CGRectMake(17, closeBtn.frame.origin.y-0.5, Screen_Width-34, 0.5)];
    lineView.backgroundColor = GRAY_cc;
    [bottomView addSubview:lineView];
    
    UIButton *btnWX = [self makeupButton:0];
    UIButton *btnWXF = [self makeupButton:1];
    UIButton *btnWB = [self makeupButton:2];
    UIButton *btnQQ = [self makeupButton:3];
    UIButton *btnQQF = [self makeupButton:4];
    
    float width = (Screen_Width-24)/5.0f;
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[btnWX(witdh)]-(0)-[btnWXF(witdh)]-(0)-[btnWB(witdh)]-(0)-[btnQQ(witdh)]-(0)-[btnQQF(witdh)]-(0)-|" options:0 metrics:@{@"witdh":@(width)}  views:NSDictionaryOfVariableBindings(bottomView,btnWX,btnWXF,btnWB,btnQQ,btnQQF)]];
    
}

- (UIButton *)makeupButton:(NSInteger)index {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.tag = 100+index;
    NSString *img = shareArray[index][@"icon"];
    [button setTitle:shareArray[index][@"name"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button setTitleColor:BLACK_42 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
    [button addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(15)-[button]-(15)-[lineView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomView,button,lineView)]];
    
    return button;
}

/*
 * 显示
 */
- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    [self layoutIfNeeded];
    
    
}
/*
 *  清除
 */
-(void)dismiss{
    
    [self layoutIfNeeded];
    self.alpha = 1.0f;
    
    self.transform = CGAffineTransformMakeScale(1.0,1.0);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
