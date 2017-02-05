//
//  RegisterViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+Judge.h"                  // nsstring 类目
#import "SecurityUtil.h"                    // 加密解密类
#import "FOLUserInforModel.h"     // userinfo model

@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)dealloc {
    
    self.pswTF.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
    
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setVCName:@"注册账号" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:nil];
    // 
    [self.leftNaviButton setImage:[UIImage imageNamed:@"closeBack"] forState:UIControlStateNormal];
    
    [self setTextFieldStyle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerKeyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)returnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTextFieldStyle {
    
    self.phoneNumTF.layer.cornerRadius = 22;
    //    self.phoneNumTF.layer.masksToBounds = YES;
    self.phoneNumTF.layer.borderColor = GRAY_cc.CGColor;
    self.phoneNumTF.layer.borderWidth = 0.5;
    
    
    self.msgNumTF.layer.cornerRadius = 22;
    //    self.msgNumTF.layer.masksToBounds = YES;
    self.msgNumTF.layer.borderColor = GRAY_cc.CGColor;
    self.msgNumTF.layer.borderWidth = 0.5;
    
    
    self.pswTF.layer.cornerRadius = 22;
    //    self.pswTF.layer.masksToBounds = YES;
    self.pswTF.layer.borderColor = GRAY_cc.CGColor;
    self.pswTF.layer.borderWidth = 0.5;
    NSArray *imageArr = @[[UIImage imageNamed:@"phone"],[UIImage imageNamed:@"login_safe"],[UIImage imageNamed:@"clock"]];
    NSArray *textArr = @[@"请输入手机号",@"输入短信验证码",@"请输入登录密码"];
    for (int i = 0; i < 3; i ++) {
        // 添加左边的logo
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
        UIImageView *pHimageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 11, 11, 22)];
        pHimageView.contentMode = UIViewContentModeScaleAspectFit;
        pHimageView.image = imageArr[i];
        [leftView addSubview:pHimageView];
        
        // 设置 提示文字的大小
        NSString *holderText = textArr[i];
        NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeHolder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0,holderText.length)];
        if (i == 0) {
            self.phoneNumTF.leftView = leftView;
            self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
            self.phoneNumTF.attributedPlaceholder = placeHolder;
        } else if (i == 1) {
            self.msgNumTF.leftView = leftView;
            self.msgNumTF.leftViewMode = UITextFieldViewModeAlways;
            self.msgNumTF.attributedPlaceholder = placeHolder;
        } else {
            self.pswTF.leftView = leftView;
            self.pswTF.leftViewMode = UITextFieldViewModeAlways;
            self.pswTF.attributedPlaceholder = placeHolder;
        }
    }
    
    self.sendMsgBtn.layer.masksToBounds = YES;
    self.sendMsgBtn.layer.cornerRadius = 13;
    self.sendMsgBtn.layer.borderColor = GREEN_19b8.CGColor;
    self.sendMsgBtn.layer.borderWidth = 0.5;
    
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 22;
    
    self.phoneNumTF.delegate = self;
    self.msgNumTF.delegate = self;
    self.pswTF.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 键盘将要弹起
- (void)registerKeyBoardWillShow:(NSNotification *)sender {
    
    NSValue *rectValue = sender.userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGFloat keyboardHeight = [rectValue CGRectValue].size.height;
    
    CGFloat result = Screen_Height - keyboardHeight;
    
    CGFloat textFieldY = self.pswTF.frame.origin.y + 44;
    
    if (result < textFieldY) {
        self.view.frame = CGRectMake(0, result - textFieldY, Screen_Width, Screen_Height);
    }
    
}
#pragma mark - 键盘将要收起
- (void)registerKeyBoardWillHidden:(NSNotification *)sender {
    self.view.frame = CGRectMake(0, 64, Screen_Width, Screen_Height-64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 发送验证码
- (IBAction)sendMsgBtnAction:(UIButton *)sender {
    
    if (self.phoneNumTF.text.length < 1) {
        
        [MBProgressHUD showAutoMessage:@"请输入手机号哦~" ToView:nil];
        
        return;
    }
    
    if (![NSString validateMobile:self.phoneNumTF.text]) {
        
        [MBProgressHUD showAutoMessage:@"请正确输入手机号哦~" ToView:nil];
        
        return;
    }
    
    [HTTPREQUEST_SINGLE getRequestWithService:[NSString stringWithFormat:@"%@1",URL_GET_SMSES] andParameters:@{@"address":self.phoneNumTF.text} isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog(@"登录发送短信验证码：%@",response);
        
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showAutoMessage:@"操作过于频繁" ToView:nil];
            return;
        }
        [MBProgressHUD showAutoMessage:@"短信验证码已发送，请查看" ToView:nil];
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"登录发送短信验证码：error=%@",error);
        [MBProgressHUD showAutoMessage:@"网络有点问题，请稍后再操作！" ToView:nil];
    }];
//
    
}
#pragma mark - 注册
- (IBAction)registerBtnAction:(UIButton *)sender {
    
    if (self.phoneNumTF.text.length < 1) {
        
        [MBProgressHUD showAutoMessage:@"输入手机号哦~" ToView:nil];
        
        return;
    }
    
    if (![NSString validateMobile:self.phoneNumTF.text]) {
        
        [MBProgressHUD showAutoMessage:@"请正确输入手机号哦~" ToView:nil];
        
        return;
    }
    
    if (self.msgNumTF.text.length < 1) {
        
        [MBProgressHUD showAutoMessage:@"输入验证码哦~" ToView:nil];
        
        return;
    }
    
    if (self.pswTF.text.length < 6) {
        
        [MBProgressHUD showAutoMessage:@"输入6位长度以上的密码哦~" ToView:nil];
        
        return;
    }
    
    NSDictionary *dic = @{@"device_id":@"869271025136174",@"phone_num":self.phoneNumTF.text,@"pwd":self.pswTF.text,@"verify_code":self.msgNumTF.text};
    
    // 请求
    [HTTPREQUEST_SINGLE postRequestWithService:URL_POST_REGISTER andParameters:dic andRequestType:0 success:^(RequestManager *manager, NSDictionary *response,NSString *time) {
        NSLog(@"success：%@",response);
        // 对拿到的数据进行判断 如果不是 200 则显示错误信息
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showAutoMessage:response[@"erro_msg"] ToView:nil];
            return;
        }
        // 解密token
//        NSString *tokenStr = response[@"token"];
//        tokenStr = [SecurityUtil AES128Decrypt:tokenStr andKey:time andIV:iv];
//        NSLog(@"token = %@",tokenStr);
        // 解密 user
        NSString *userStr = response[@"user"];
        
        NSMutableString *mString = [NSMutableString string];        // 初始化可变字符串
        for (NSUInteger i=time.length; i>0; i--) {               // 对时间戳的字符串进行反转
            [mString appendString:[time substringWithRange:NSMakeRange(i-1, 1)]];
        }
        
        userStr = [SecurityUtil AES128Decrypt:userStr andKey:time andIV:mString];
        NSDictionary *userDic = [NSString dictionaryWithJsonString:userStr];
        NSLog(@"userDic = %@",userDic);
        
        
        // token 和密码 保存到本地，无需解密
//        NSDictionary *dic = @{@"id":userDic[@"id"],@"userName":userDic[@"userName"],@"phoneNum":userDic[@"phoneNum"],@"publish_count":userDic[@"publish_count"],@"regist_time":userDic[@"regist_time"],@"avatar":userDic[@"avatar"],@"type":userDic[@"type"],@"token_time":time,@"token":response[@"token"],};
        NSDictionary *dic = @{@"userID":userDic[@"id"],@"userName":userDic[@"username"],@"phoneNum":self.phoneNumTF.text,@"publish_count":userDic[@"publish_count"],@"regist_time":time,@"avatar": userDic[@"avatar"],@"type":@1,@"token_time":time,@"token":response[@"token"],@"password":self.pswTF.text};
        
        FOLUserInforModel *model = [[FOLUserInforModel alloc] initWithDictionary:dic];
        
        // 将数据保存到 user info model中
        [FOLUserInforModel insertUserInfoModel:model];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"error：%@",error.debugDescription);
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneNumTF resignFirstResponder];
    [self.msgNumTF resignFirstResponder];
    [self.pswTF resignFirstResponder];
}

#pragma mark - 查看密码
- (IBAction)seePswBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [sender setImage:[UIImage imageNamed:@"openEye"] forState:UIControlStateNormal];
        self.pswTF.secureTextEntry = NO;
        
    } else {
        
        [sender setImage:[UIImage imageNamed:@"closeEye"] forState:UIControlStateNormal];
        
        self.pswTF.secureTextEntry = YES;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.phoneNumTF) {
        [self.msgNumTF becomeFirstResponder];
    } else if (textField == self.msgNumTF){
        [self.pswTF becomeFirstResponder];
    } else {
        [self.pswTF resignFirstResponder];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
