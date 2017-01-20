//
//  LoginOfPhoneView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "LoginOfPhoneView.h"

#define width self.frame.size.width
#define height self.frame.size.height

@implementation LoginOfPhoneView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.phoneTF];
        [self addSubview:self.messageTF];
        [self addSubview:self.sendMsgBtn];
        [self addSubview:self.loginButton];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTF resignFirstResponder];
    [self.messageTF resignFirstResponder];
}
#pragma mark - lazyload
- (UITextField *)phoneTF {
    
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(40, height*5/31, width-80, height*8/45)];
        // 设置边框和圆角
        _phoneTF.layer.borderWidth = 0.5;
        _phoneTF.layer.borderColor = GRAY_cc.CGColor;
        _phoneTF.layer.cornerRadius = height*4/45;
        _phoneTF.borderStyle = UITextBorderStyleNone;
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTF.font = [UIFont systemFontOfSize:14.0f];
        
        // 设置提示文字的大小
        NSString *holderText = @"请输入手机号码";
        NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:holderText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        _phoneTF.attributedPlaceholder = placeHolder;
        
        // 设置 左边的logo
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, height*8/45)];
        UIImageView *pHimageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height*2/45, 11, height*4/45)];
        pHimageView.contentMode = UIViewContentModeScaleAspectFit;
        pHimageView.image = [UIImage imageNamed:@"phone"];
        [leftView addSubview:pHimageView];
        _phoneTF.leftView = leftView;
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _phoneTF;
}

- (UITextField *)messageTF {
    
    if (!_messageTF) {
        _messageTF = [[UITextField alloc] initWithFrame:CGRectMake(40, height*5/31+height*8/45+height/13, width-80, height*8/45)];
        // 设置边框和圆角
        _messageTF.layer.borderWidth = 0.5;
        _messageTF.layer.borderColor = GRAY_cc.CGColor;
        _messageTF.layer.cornerRadius = height*4/45;
        _messageTF.borderStyle = UITextBorderStyleNone;
        _messageTF.font = [UIFont systemFontOfSize:14.0f];
        
        // 设置提示文字的大小
        NSString *holderText = @"请输入登录密码";
        NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:holderText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        _messageTF.attributedPlaceholder = placeHolder;
        
        // 设置 左边的logo
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, height*8/45)];
        UIImageView *pHimageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, height*2/45, 13, height*4/45)];
        pHimageView.contentMode = UIViewContentModeScaleAspectFit;
        pHimageView.image = [UIImage imageNamed:@"login_safe"];
        [leftView addSubview:pHimageView];
        _messageTF.leftView = leftView;
        _messageTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _messageTF;
}

- (UIButton *)sendMsgBtn {
    
    if (!_sendMsgBtn) {
        _sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendMsgBtn.frame = CGRectMake(width-40-80, height*5/31+height*8/45+height/13+(height*8/45-height/9)/2, 70, height/9);
        _sendMsgBtn.backgroundColor = [UIColor clearColor];
        [_sendMsgBtn setTitle:@"获取验证码" forState:0];
        _sendMsgBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [_sendMsgBtn setTitleColor:GREEN_19b8 forState:0];
        _sendMsgBtn.layer.borderColor = GREEN_19b8.CGColor;
        _sendMsgBtn.layer.borderWidth = 0.5;
        _sendMsgBtn.layer.cornerRadius = height/18;
        
    }
    return _sendMsgBtn;
}

- (UIButton *)loginButton {
    
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(40, height*5/31+height*16/45+height*2/13, width-80, height*8/45);
        _loginButton.backgroundColor = GREEN_19b8;
        [_loginButton setTitle:@"登 录" forState:0];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _loginButton.layer.cornerRadius = height*4/45;
    }
    return _loginButton;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.phoneTF) {
        [self.messageTF becomeFirstResponder];
    } else {
        [self.messageTF resignFirstResponder];
        
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
