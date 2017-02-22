//
//  ForgetPsdViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/5.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ForgetPsdViewController.h"
#import "MeNetRequest.h"
#import "SecurityUtil.h"

@interface ForgetPsdViewController ()<UITextFieldDelegate>
{
    UITextField *phoneTF;
    UITextField *msgTF;
    UITextField *newPwdTF;
    UITextField *againNewPwdTF;
//    UILabel *errorLabel;
    UIButton *getMsgBtn;
    int time;
    NSTimer *timer;
}
@end

@implementation ForgetPsdViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setVCName:@"忘记密码" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:nil];
    
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
    phoneTF.font = [UIFont systemFontOfSize:14.0];
    phoneTF.delegate = self;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTF];
    
    // 验证码
    msgTF = [UITextField new];
    msgTF.placeholder = @"输入短信验证码";
    msgTF.textColor = BLACK_42;
    msgTF.font = [UIFont systemFontOfSize:14.0];
    msgTF.delegate = self;
    msgTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:msgTF];
    
    getMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getMsgBtn.frame = CGRectMake(Screen_Width-40-70, 44+1+9, 70, 25);
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
    newPwdTF.placeholder = @"请输入新密码";
    newPwdTF.textColor = BLACK_42;
    newPwdTF.font = [UIFont systemFontOfSize:14.0];
    newPwdTF.delegate = self;
    newPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPwdTF.secureTextEntry = YES;
    [self.view addSubview:newPwdTF];
    
    // 新新密码
    againNewPwdTF = [UITextField new];
    againNewPwdTF.placeholder = @"请确定新密码";
    againNewPwdTF.textColor = BLACK_42;
    againNewPwdTF.font = [UIFont systemFontOfSize:14.0];
    againNewPwdTF.delegate = self;
    againNewPwdTF.secureTextEntry = YES;
    againNewPwdTF.selected = NO;
    againNewPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:againNewPwdTF];
    
    UIButton *seePwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seePwdBtn.frame = CGRectMake(Screen_Width-40-40, 44*3+3, 34, 44);
    [seePwdBtn setImage:[UIImage imageNamed:@"closeEye"] forState:UIControlStateNormal];
    [seePwdBtn setImage:[UIImage imageNamed:@"openEye"] forState:UIControlStateSelected];
    [seePwdBtn addTarget:self action:@selector(seePwdBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seePwdBtn];
    
    phoneTF.translatesAutoresizingMaskIntoConstraints = NO;
    msgTF.translatesAutoresizingMaskIntoConstraints = NO;
    newPwdTF.translatesAutoresizingMaskIntoConstraints = NO;
    againNewPwdTF.translatesAutoresizingMaskIntoConstraints = NO;
    getMsgBtn.translatesAutoresizingMaskIntoConstraints = NO;
    seePwdBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat cellHeight = Screen_Height*11/142;
    // 添加约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[phoneTF(cellHeight)]-(0)-[msgTF(cellHeight)]-(0)-[newPwdTF(cellHeight)]-(0)-[againNewPwdTF(cellHeight)]" options:0 metrics:@{@"cellHeight":@(cellHeight)} views:NSDictionaryOfVariableBindings(phoneTF,self.view,msgTF,newPwdTF,againNewPwdTF)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(msgBtnHeight)-[getMsgBtn]" options:0 metrics:@{@"msgBtnHeight":@(cellHeight+cellHeight*5/22)} views:NSDictionaryOfVariableBindings(self.view,getMsgBtn)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topHeight)-[seePwdBtn(cellHeight)]" options:0 metrics:@{@"topHeight":@(3*cellHeight),@"cellHeight":@(cellHeight)} views:NSDictionaryOfVariableBindings(self.view,seePwdBtn)]];
     
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[phoneTF]-(40)-|" options:1 metrics:nil views:NSDictionaryOfVariableBindings(self.view,phoneTF)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[msgTF]-(5)-[getMsgBtn(getMsgBtnWidth)]-(40)-|" options:0 metrics:@{@"getMsgBtnWidth":@(Screen_Width*7/32)} views:NSDictionaryOfVariableBindings(self.view,msgTF,getMsgBtn)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[newPwdTF]-(40)-|" options:1 metrics:nil views:NSDictionaryOfVariableBindings(self.view,newPwdTF)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(40)-[againNewPwdTF]-(5)-[seePwdBtn(34)]-(40)-|" options:1 metrics:nil views:NSDictionaryOfVariableBindings(self.view,againNewPwdTF,seePwdBtn)]];
    
    
    
    NSArray *imageArray = @[[UIImage imageNamed:@"phone"],[UIImage imageNamed:@"login_safe"],[UIImage imageNamed:@"unclock"],[UIImage imageNamed:@"key"]];
    
    for (int i = 0; i < 4; i++) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 44)];
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 12, 24)];
        logoImageView.image = imageArray[i];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftView addSubview:logoImageView];
        
        
        
        // 第一条华丽的分割线
        UIView *cutinglineView = [UIView new];
        cutinglineView.backgroundColor = GRAY_cc;
        
        switch (i) {
            case 0:
            {
                phoneTF.leftView = leftView;
                phoneTF.leftViewMode = UITextFieldViewModeAlways;
                
                cutinglineView.frame = CGRectMake(0, cellHeight-0.5, Screen_Width-80, 0.5);
                [phoneTF addSubview:cutinglineView];
            }
                break;
            case 1:
            {
                msgTF.leftView = leftView;
                msgTF.leftViewMode = UITextFieldViewModeAlways;
                
                cutinglineView.frame = CGRectMake(0, cellHeight-0.5, Screen_Width-80-75, 0.5);
                [msgTF addSubview:cutinglineView];
            }
                break;
            case 2:
            {
                newPwdTF.leftView = leftView;
                newPwdTF.leftViewMode = UITextFieldViewModeAlways;
                
                cutinglineView.frame = CGRectMake(0, cellHeight-0.5, Screen_Width-80, 0.5);
                [newPwdTF addSubview:cutinglineView];
            }
                break;
            case 3:
            {
                againNewPwdTF.leftView = leftView;
                againNewPwdTF.leftViewMode = UITextFieldViewModeAlways;
                
                cutinglineView.frame = CGRectMake(0, cellHeight-0.5, Screen_Width-80, 0.5);
                [againNewPwdTF addSubview:cutinglineView];
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
- (void)seePwdBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        againNewPwdTF.secureTextEntry = YES;
    } else {
        againNewPwdTF.secureTextEntry = NO;
    }
}
#pragma mark - 提交
- (void)rightItemButtonAction {
    [self judgePhoneNum];   // 判断手机号
    
    if (msgTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码" ToView:nil];
        return;
    }
    
    if (newPwdTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入长度≥6位密码" ToView:nil];
        return;
    }
    
    if (![againNewPwdTF.text isEqualToString:newPwdTF.text]) {
        [MBProgressHUD showError:@"前后密码不一致" ToView:nil];
        return;
    }
    
    NSDictionary *dic = @{@"pwd":newPwdTF.text,@"verify_code":msgTF.text};  // 请求的字典
    NSString *update_value = [NSString dictionaryToJson:dic];               // 转成字符串
    
    update_value = [SecurityUtil encodeBase64String:update_value];
    
    NSDictionary *requestDic = @{@"update_type":@(5),@"update_value":update_value};
    [HTTPREQUEST_SINGLE putRequestToForgetPWD:URL_POST_LOGIN andParameters:requestDic andPhoneNum: phoneTF.text isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"忘记密码请求失败：%@",response);
        [MBProgressHUD showSuccess:@"成功修改" ToView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(RequestManager *manager, NSError *error) {
//        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"忘记密码请求失败：%@",error);
    }];
    
    
}
/// 判断手机号的输入是否正确
- (BOOL)judgePhoneNum {
    
    if (phoneTF.text.length <= 0) {
        [MBProgressHUD showError:@"输入11位手机号码" ToView:nil];
        return NO;
    }
    
    if (![NSString validateMobile:phoneTF.text]) {
        [MBProgressHUD showError:@"手机号有误" ToView:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 获取验证码
- (void)getMessageAction:(UIButton *)sender {
    
    if (![self judgePhoneNum]) {
        return;
    }
    
    [HTTPREQUEST_SINGLE getRequestWithService:[NSString stringWithFormat:@"%@4",URL_GET_SMSES] andParameters:@{@"address":phoneTF.text} isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog(@"忘记密码发送短信验证码：%@",response);
        
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showAutoMessage:@"您刚发送过验证码，请留意短信！" ToView:nil];
            return;
        }
        [MBProgressHUD showAutoMessage:@"短信验证码已发送，请查看" ToView:nil];
        
        // 初始化计时器
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
        time = 120;
        // 设置发送验证码按钮的
        getMsgBtn.enabled = NO;
        [getMsgBtn setTitleColor:GRAY_99 forState:0];
        getMsgBtn.layer.borderColor = GRAY_db.CGColor;
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"忘记密码发送短信验证码：error=%@",error);
        [MBProgressHUD showAutoMessage:@"网络有点问题，请稍后再操作！" ToView:nil];
    }];
}

- (void)timeAdd{
    
    if (time == 0) {
        [getMsgBtn setTitleColor:GREEN_1ab8 forState:0];
        getMsgBtn.layer.borderColor = GREEN_1ab8.CGColor;
        getMsgBtn.enabled = YES;
        [getMsgBtn setTitle:@"获取验证码" forState:0];
        [timer invalidate];
        return;
    }
    [getMsgBtn setTitle:[NSString stringWithFormat:@"%ds",time] forState:0];
    time--;
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == newPwdTF) {    // 判断旧密码输入时候正确
        
        if (textField.text.length < 6) {
            
            [MBProgressHUD showError:@"请输入长度≥6位密码" ToView:nil];
            [newPwdTF becomeFirstResponder];
        }
        
    } else if (textField == phoneTF) {  // 判断手机号输入是否正确
        
        if (![self judgePhoneNum]) {
            [phoneTF becomeFirstResponder];
        }
        
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [phoneTF resignFirstResponder];
    [msgTF resignFirstResponder];
    [newPwdTF resignFirstResponder];
    [againNewPwdTF resignFirstResponder];
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
