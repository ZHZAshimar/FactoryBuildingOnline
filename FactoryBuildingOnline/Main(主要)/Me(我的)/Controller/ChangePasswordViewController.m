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
    UILabel *errorLabel;
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
    
    // 显示错误的label
    errorLabel = [[UILabel alloc] init];
    errorLabel.textColor = RED_df3d;
    errorLabel.font = [UIFont systemFontOfSize:9.0];
    errorLabel.hidden = YES;
    errorLabel.textAlignment = NSTextAlignmentRight;
//    errorLabel.backgroundColor = YELLOW_bg;
    [self.view addSubview:errorLabel];
    
    // 手机号码 TF
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 20, Screen_Width-80, 44)];
    phoneTF.placeholder = @"请输入手机号";
    phoneTF.textColor = BLACK_42;
    phoneTF.font = [UIFont systemFontOfSize:14.0];
    phoneTF.delegate = self;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTF];
    
    // 第一条华丽的分割线
    UIView *cutinglineView1 = [[UIView alloc] initWithFrame:CGRectMake(40, 20+44, Screen_Width-80, 0.5)];
    cutinglineView1.backgroundColor = GRAY_cc;
    [self.view addSubview:cutinglineView1];
    
    // 验证码
    msgTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 20+44+1, Screen_Width-80-75, 44)];
    msgTF.placeholder = @"输入短信验证码";
    msgTF.textColor = BLACK_42;
    msgTF.font = [UIFont systemFontOfSize:14.0];
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
    
    // 第二条华丽的分割线
    UIView *cutinglineView2 = [[UIView alloc] initWithFrame:CGRectMake(40, 20+44*2+1, Screen_Width-80-75, 0.5)];
    cutinglineView2.backgroundColor = GRAY_cc;
    [self.view addSubview:cutinglineView2];
    
//    // 旧密码
//    oldPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 20+44*2+2, Screen_Width-80, 44)];
//    oldPwdTF.placeholder = @"输入旧密码";
//    oldPwdTF.textColor = BLACK_42;
//    oldPwdTF.font = [UIFont systemFontOfSize:14.0];
//    oldPwdTF.delegate = self;
//    oldPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.view addSubview:oldPwdTF];
    
    // 第三条华丽的分割线
    UIView *cutinglineView3 = [[UIView alloc] initWithFrame:CGRectMake(40, 20+44*3+2, Screen_Width-80, 0.5)];
    cutinglineView3.backgroundColor = GRAY_cc;
    [self.view addSubview:cutinglineView3];

    // 新密码
//    newPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 20+44*3+3, Screen_Width-80-34, 44)];
    newPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 20+44*2+2, Screen_Width-80-25, 44)];
    newPwdTF.placeholder = @"输入新密码";
    newPwdTF.textColor = BLACK_42;
    newPwdTF.font = [UIFont systemFontOfSize:14.0];
    newPwdTF.delegate = self;
    newPwdTF.secureTextEntry = YES;
    newPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:newPwdTF];
    
    UIButton *seePwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seePwdBtn.frame = CGRectMake(Screen_Width-40-35, 20+44*2+2, 34, 44);
    [seePwdBtn setImage:[UIImage imageNamed:@"closeEye"] forState:UIControlStateNormal];
    [seePwdBtn setImage:[UIImage imageNamed:@"openEye"] forState:UIControlStateSelected];
    [seePwdBtn addTarget:self action:@selector(seePwdBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:seePwdBtn];
    
    // 第四条华丽的分割线
//    UIView *cutinglineView4 = [[UIView alloc] initWithFrame:CGRectMake(40, 20+44*4+3, Screen_Width-80, 1)];
//    cutinglineView4.backgroundColor = GRAY_cc;
//    [self.view addSubview:cutinglineView4];
    
    NSArray *imageArray = @[[UIImage imageNamed:@"phone"],[UIImage imageNamed:@"login_safe"]/*,[UIImage imageNamed:@"unclock"]*/,[UIImage imageNamed:@"key"]];
    
    for (int i = 0; i < 3; i++) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 44)];

        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 12, 24)];
        logoImageView.image = imageArray[i];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftView addSubview:logoImageView];
        
        switch (i) {
            case 0:
            {
                phoneTF.leftView = leftView;
                phoneTF.leftViewMode = UITextFieldViewModeAlways;
            }
                break;
            case 1:
            {
                msgTF.leftView = leftView;
                msgTF.leftViewMode = UITextFieldViewModeAlways;
            }
                break;
//            case 2:
//            {
//                oldPwdTF.leftView = leftView;
//                oldPwdTF.leftViewMode = UITextFieldViewModeAlways;
//            }
//                break;
            case 2:
            {
                newPwdTF.leftView = leftView;
                newPwdTF.leftViewMode = UITextFieldViewModeAlways;
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
    
    errorLabel.hidden = YES;
    
    if (phoneTF.text.length <= 0) {
        [self shakeAnimationForView:phoneTF];
        errorLabel.frame = CGRectMake(Screen_Width-140, 20, 75, 44);
        errorLabel.text = @"输入11位手机号码";
        errorLabel.hidden = NO;
        return;
    }
    
    if (msgTF.text.length <= 0) {
        [self shakeAnimationForView:msgTF];
        return;
    }
    
    if (newPwdTF.text.length < 6) {
        [self shakeAnimationForView:newPwdTF];
        errorLabel.frame = CGRectMake(Screen_Width-180, 20+44*2+2, 80, 44);
        errorLabel.text = @"密码长度 ≥ 六位数";
        errorLabel.hidden = NO;
        return;
    }
//    if (oldPwdTF.text.length <= 0) {
//        
//        [self shakeAnimationForView:oldPwdTF];
//        errorLabel.frame = CGRectMake(Screen_Width-120, 20+44*2+2, 50, 44);
//        errorLabel.text = @"请输入旧密码";
//        errorLabel.hidden = NO;
//        return;
//    }
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
        
        [self shakeAnimationForView:phoneTF];
        errorLabel.frame = CGRectMake(Screen_Width-120, 20, 50, 44);
        errorLabel.text = @"手机号有误";
        errorLabel.hidden = NO;
        [phoneTF becomeFirstResponder];
        return;
    }
    errorLabel.hidden = YES;
    
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
            
            [self shakeAnimationForView:phoneTF];
            errorLabel.frame = CGRectMake(Screen_Width-120, 20, 50, 44);
            errorLabel.text = @"手机号有误";
            errorLabel.hidden = NO;
            [phoneTF becomeFirstResponder];
            
            return YES;
        }
        errorLabel.hidden = YES;
        
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
