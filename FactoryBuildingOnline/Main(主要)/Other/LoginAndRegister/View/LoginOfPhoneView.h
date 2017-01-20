//
//  LoginOfPhoneView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginOfPhoneView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UITextField *messageTF;

@property (nonatomic, strong) UIButton *sendMsgBtn;

@property (strong, nonatomic) UIButton *loginButton;

@end
