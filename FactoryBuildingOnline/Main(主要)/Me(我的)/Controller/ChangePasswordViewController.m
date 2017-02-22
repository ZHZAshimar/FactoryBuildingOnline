//
//  ChangePasswordViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/3.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ChangePasswordViewController.h"
//#import "UserInfoModel+CoreDataClass.h"
#import "MeNetRequest.h"
#import "SecurityUtil.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
{
    UITextField *phoneTF;
    UITextField *msgTF;
    UITextField *oldPwdTF;
    UITextField *newPwdTF;
    UIButton *getMsgBtn;
    NSTimer *timer; // 计时器
    int count;      // 计数
    
}
@end

@implementation ChangePasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setVCName:@"修改密码" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:nil];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"closeBack"] forState:0];
    
    [self addRightItemWithString:@"提交" andItemTintColor:GREEN_19b8];
    
    [self drawView];    // 绘制界面
}

- (void)drawView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 手机号码 TF
    phoneTF = [UITextField new];
    phoneTF.placeholder = @"请输入手机号";
    phoneTF.textColor = BLACK_42;
    phoneTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
    phoneTF.delegate = self;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTF];
    
    // 验证码
    msgTF = [UITextField new];
    msgTF.placeholder = @"输入短信验证码";
    msgTF.textColor = BLACK_42;
    msgTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
    msgTF.delegate = self;
    msgTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:msgTF];
    
    getMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getMsgBtn.frame = CGRectMake(Screen_Width-40-70, 20+44+1+9, 70, 25);
    getMsgBtn.layer.borderColor = GREEN_1ab8.CGColor;
    getMsgBtn.layer.borderWidth = 0.5;
    getMsgBtn.layer.cornerRadius = 10;
    getMsgBtn.layer.masksToBounds = YES;
    getMsgBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [getMsgBtn setTitle:@"获取验证码" forState:0];
    [getMsgBtn setTitleColor:GREEN_1ab8 forState:0];
    [getMsgBtn addTarget:self action:@selector(getMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getMsgBtn];

    // 新密码
    newPwdTF = [UITextField new];
    newPwdTF.placeholder = @"输入新密码";
    newPwdTF.textColor = BLACK_42;
    newPwdTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
    newPwdTF.delegate = self;
    newPwdTF.secureTextEntry = YES;
    newPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:newPwdTF];

    UIButton *seePwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seePwdBtn.frame = CGRectMake(Screen_Width-75, Screen_Height*22/142+20, 34, Screen_Height*11/142);
    [seePwdBtn setImage:[UIImage imageNamed:@"closeEye"] forState:UIControlStateNormal];
    [seePwdBtn setImage:[UIImage imageNamed:@"openEye"] forState:UIControlStateSelected];
    [seePwdBtn addTarget:self action:@selector(seePwdBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seePwdBtn];

    phoneTF.translatesAutoresizingMaskIntoConstraints = NO;
    msgTF.translatesAutoresizingMaskIntoConstraints = NO;
    newPwdTF.translatesAutoresizingMaskIntoConstraints = NO;
    getMsgBtn.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat height = Screen_Height*11/142;
    CGFloat btnWidth = Screen_Width*7/32;
    CGFloat btnHeight = height*25/44;
    // 添加约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[phoneTF]-(40)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,phoneTF)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[msgTF]-(5)-[getMsgBtn(btnWidth)]-(40)-|" options:0 metrics:@{@"btnWidth":@(btnWidth)} views:NSDictionaryOfVariableBindings(self.view,msgTF,getMsgBtn)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[newPwdTF]-(75)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,newPwdTF)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[phoneTF(height)]-(0)-[msgTF(height)]-(0)-[newPwdTF(height)]" options:0 metrics:@{@"height":@(height)} views:NSDictionaryOfVariableBindings(self.view,phoneTF,msgTF,newPwdTF)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[phoneTF(height)]-(margin_top)-[getMsgBtn(btnHeight)]" options:0 metrics:@{@"height":@(height),@"btnHeight":@(btnHeight),@"margin_top":@(height*5/22)} views:NSDictionaryOfVariableBindings(self.view,getMsgBtn,phoneTF)]];
    
    
    NSArray *imageArray = @[[UIImage imageNamed:@"phone"],[UIImage imageNamed:@"login_safe"]/*,[UIImage imageNamed:@"unclock"]*/,[UIImage imageNamed:@"key"]];
    
    for (int i = 0; i < 3; i++) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 44)];
        // 图片
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 12, 24)];
        logoImageView.image = imageArray[i];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftView addSubview:logoImageView];
        // 分割线
        // 华丽的分割线
        UIView *cutinglineView = [UIView new];
        cutinglineView.backgroundColor = GRAY_cc;

        switch (i) {
            case 0:
            {
                phoneTF.leftView = leftView;
                phoneTF.leftViewMode = UITextFieldViewModeAlways;
                [phoneTF addSubview:cutinglineView];
                cutinglineView.frame = CGRectMake(0, Screen_Height*11/142-0.5, Screen_Width-80,0.5);
            }
                break;
            case 1:
            {
                msgTF.leftView = leftView;
                msgTF.leftViewMode = UITextFieldViewModeAlways;
                [msgTF addSubview:cutinglineView];
                cutinglineView.frame = CGRectMake(0, Screen_Height*11/142-0.5, Screen_Width-80-75, 0.5);
                
            }
                break;
            case 2:
            {
                newPwdTF.leftView = leftView;
                newPwdTF.leftViewMode = UITextFieldViewModeAlways;
                
                [newPwdTF addSubview:cutinglineView];
                cutinglineView.frame = CGRectMake(0, Screen_Height*11/142-0.5, Screen_Width-80, 0.5);
                
            }
                break;
            default:
                break;
        }
    }


    // 底部logo
    UIImage *bottomImage = [UIImage imageNamed:@"login_logo"];
    
    CGFloat width = Screen_Height*2/9 *bottomImage.size.width / bottomImage.size.height;
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width/2-width/2, Screen_Height-Screen_Height*2/9-64, width, Screen_Height*2/9)];
    bottomImageView.image = bottomImage;
    [self.view addSubview:bottomImageView];
}


#pragma mark - 提交
- (void)rightItemButtonAction {
    
    if (phoneTF.text.length <= 0) {
        [MBProgressHUD showError:@"输入11位手机号码" ToView:nil];
        return;
    }
    
    if (msgTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入短信验证码" ToView:nil];
        return;
    }
    
    if (newPwdTF.text.length < 6) {
        [MBProgressHUD showError:@"密码长度 ≥ 六位数" ToView:nil];
        return;
    }
    
    NSDictionary *dic = @{@"pwd":newPwdTF.text,@"verify_code":msgTF.text};  // 请求的字典
    NSString *update_value = [NSString dictionaryToJson:dic];               // 转成字符串
    
    update_value = [SecurityUtil encodeBase64String:update_value];
    
    MeNetRequest *meNetRequest = [MeNetRequest new];
    
    [meNetRequest updateUserAvater:update_value andUpdateType:3 getUserInfo:NO];
    
    meNetRequest.psdBlock = ^(BOOL flag) {
        [MBProgressHUD showSuccess:@"成功修改" ToView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
}

- (void)seePwdBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    newPwdTF.secureTextEntry = !newPwdTF.secureTextEntry;
  
}

#pragma mark - 获取验证码
- (void)getMessageAction:(UIButton *)sender {
    
    if (![NSString validateMobile:phoneTF.text]) {
        [MBProgressHUD showError:@"手机号有误" ToView:nil];
        [phoneTF becomeFirstResponder];
        return;
    }
    
    [HTTPREQUEST_SINGLE getRequestWithService:[NSString stringWithFormat:@"%@3",URL_GET_SMSES] andParameters:@{@"address":phoneTF.text} isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"登录发送短信验证码：%@",response);
        
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showAutoMessage:@"您刚发送过验证码，请留意短信！" ToView:nil];
            return;
        }
        [MBProgressHUD showAutoMessage:@"短信验证码已发送，请查看" ToView:nil];
        // 初始化计时器
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        count = 120;    // 初始化时间
        // 设置发送验证码的按钮状态
        [getMsgBtn setTitleColor:GRAY_99 forState:0];
        getMsgBtn.layer.borderColor = GRAY_db.CGColor;
        getMsgBtn.enabled = NO;
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"登录发送短信验证码：error=%@",error);
        [MBProgressHUD showAutoMessage:@"网络有点问题，请稍后再操作！" ToView:nil];
    }];
    
}

- (void)changeTime{
    
    if (count == 0) {
        [getMsgBtn setTitleColor:GREEN_1ab8 forState:0];
        getMsgBtn.layer.borderColor = GREEN_1ab8.CGColor;
        getMsgBtn.enabled = YES;
        [getMsgBtn setTitle:@"获取验证码" forState:0];
        [timer invalidate];
        return;
    }
    [getMsgBtn setTitle:[NSString stringWithFormat:@"%ds",count] forState:0];
    count--;
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
//    if (textField == oldPwdTF) {    // 判断旧密码输入时候正确
//        
//        UserInfoModel *model = [[UserInfoModel findAll] firstObject];
//        
//        
//        if (![textField.text isEqualToString: model.password]) {
//            
//            [self shakeAnimationForView:oldPwdTF];
//            errorLabel.frame = CGRectMake(Screen_Width-120, 20+44*2+2, 50, 44);
//            errorLabel.text = @"旧密码有误";
//            errorLabel.hidden = NO;
//            return NO;
//        }
//            errorLabel.hidden = YES;
//        
//    } else
    if (textField == phoneTF) {  // 判断手机号输入是否正确
        
        if (![NSString validateMobile:phoneTF.text]) {
            
            [MBProgressHUD showError:@"手机号有误" ToView:nil];
            [phoneTF becomeFirstResponder];
            
            return YES;
        }
        
    }
    return YES;
}

#pragma mark 抖动动画
- (void)shakeAnimationForView:(UITextField *) textField
{
    // 获取到当前的View
    CALayer *viewLayer = textField.layer;
    
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    [animation setAutoreverses:YES];
    
    // 设置时间
    [animation setDuration:.06];
    
    // 设置次数
    [animation setRepeatCount:3];
    
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
