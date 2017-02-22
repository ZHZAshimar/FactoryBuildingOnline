//
//  LoginOfUserView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "LoginOfUserView.h"

#define width self.frame.size.width
#define height self.frame.size.height

@implementation LoginOfUserView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.userTF];
        [self addSubview:self.pswTF];
        [self addSubview:self.seePasswordBtn];
        [self addSubview:self.loginButton];
        [self addSubview:self.registerButton];
        [self addSubview:self.forgotPswButton];
        
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.userTF resignFirstResponder];
    [self.pswTF resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}

- (UITextField *)userTF {
    
    if (!_userTF) {
        _userTF = [[UITextField alloc] initWithFrame:CGRectMake(40, height*5/31, width-80, height*8/45)];
        // 设置边框和圆角
        _userTF.layer.borderWidth = 0.5;
        _userTF.layer.borderColor = GRAY_cc.CGColor;
        _userTF.layer.cornerRadius = height*4/45;
        _userTF.borderStyle = UITextBorderStyleNone;
        _userTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
        
        // 设置提示文字的大小
        NSString *holderText = @"请输入手机号码";
        NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:holderText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]]}];
        _userTF.attributedPlaceholder = placeHolder;
        
        // 设置 左边的logo
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, height*8/45)];
        UIImageView *pHimageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height*2/45, 11, height*4/45)];
        pHimageView.contentMode = UIViewContentModeScaleAspectFit;
        pHimageView.image = [UIImage imageNamed:@"phone"];
        [leftView addSubview:pHimageView];
        _userTF.leftView = leftView;
        _userTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _userTF;
}

- (UITextField *)pswTF {
    
    if (!_pswTF) {
        _pswTF = [[UITextField alloc] initWithFrame:CGRectMake(40, height*5/31+height*8/45+height/13, width-80, height*8/45)];
        // 设置边框和圆角
        _pswTF.layer.borderWidth = 0.5;
        _pswTF.layer.borderColor = GRAY_cc.CGColor;
        _pswTF.layer.cornerRadius = height*4/45;
        _pswTF.borderStyle = UITextBorderStyleNone;
        _pswTF.secureTextEntry = YES;
        _pswTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
//        _pswTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        // 设置提示文字的大小
        NSString *holderText = @"请输入登录密码";
        NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:holderText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]]}];
        _pswTF.attributedPlaceholder = placeHolder;
        
        // 设置 左边的logo
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, height*8/45)];
        UIImageView *pHimageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height*2/45, 11, height*4/45)];
        pHimageView.contentMode = UIViewContentModeScaleAspectFit;
        pHimageView.image = [UIImage imageNamed:@"clock"];
        [leftView addSubview:pHimageView];
        _pswTF.leftView = leftView;
        _pswTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _pswTF;
}

- (UIButton *)seePasswordBtn {
    
    if (!_seePasswordBtn) {
        _seePasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _seePasswordBtn.frame = CGRectMake(width-84, height*5/31+height*8/45+height/13, 44, height*8/45);
        
        [_seePasswordBtn setImage:[UIImage imageNamed:@"closeEye"] forState:0];
        [_seePasswordBtn setTintColor:[UIColor blackColor]];
        
    }
    return _seePasswordBtn;
}

- (UIButton *)loginButton {
    
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(40, height*5/31+height*16/45+height*2/13, width-80, height*8/45);
        _loginButton.backgroundColor = GREEN_19b8;
        [_loginButton setTitle:@"登 录" forState:0];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:16.0]];
        _loginButton.layer.cornerRadius = height*4/45;
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(40, height*5/31+height*24/45+height*2/13, 80, height-(height*5/31+height*24/45+height*2/13));
        [_registerButton setTitleColor:GREEN_19b8 forState:UIControlStateNormal];
        [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12.0]];
        _registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _registerButton;
}

- (UIButton *)forgotPswButton {
    
    if (!_forgotPswButton) {
        _forgotPswButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgotPswButton.frame = CGRectMake(width-40-80, height*5/31+height*24/45+height*2/13, 80, height-(height*5/31+height*24/45+height*2/13));
        [_forgotPswButton setTitleColor:GREEN_19b8 forState:UIControlStateNormal];
        [_forgotPswButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgotPswButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12.0]];
        _forgotPswButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _forgotPswButton;
}

@end
