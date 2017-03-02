//
//  LogoViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//  登录VC 命名错了

#import "LogoViewController.h"
#import "User.h"
#import "HMSegmentedControl.h"
#import "LoginOfUserView.h"
#import "LoginOfPhoneView.h"
#import "NSString+Judge.h"
#import "SecurityUtil.h"
//#import "UserInfoModel+CoreDataClass.h"
#import "FOLUserInforModel.h"
#import "RegisterViewController.h"
#import "ForgetPsdViewController.h"

typedef enum{
    
    LOGIN_SMS,      // 1
    LOGIN_PWD,      // 2
    
}LOGIN_TYPE;

@interface LogoViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    NSTimer *timer;       // 计时器
    int count;            // 计数
}
@property (nonatomic, strong) LoginOfUserView *loginOfUserView;
@property (nonatomic, strong) LoginOfPhoneView *loginOfPhoneView;
@property (nonatomic, strong)HMSegmentedControl *mySegmentedControl;
@property (nonatomic, assign) LOGIN_TYPE login_type;

@end

@implementation LogoViewController

- (void)dealloc {
    
    self.loginOfPhoneView.phoneTF.delegate = nil;
    self.loginOfPhoneView.messageTF.delegate = nil;
    
    self.loginOfUserView.userTF.delegate = nil;
    self.loginOfUserView.pswTF.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 隐藏导航栏 和 工具栏
    self.navigationController.navigationBar.hidden = YES;
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
    self.thirdPathLoginView.hidden = YES;
    
    self.myScrollView.contentOffset = CGPointMake(0, 0);

    [self.mySegmentedControl setSelectedSegmentIndex:0];
    
    self.login_type = LOGIN_SMS;
    
    self.loginOfPhoneView.phoneTF.delegate = self;
    self.loginOfPhoneView.messageTF.delegate = self;
    self.loginOfUserView.userTF.delegate = self;
    self.loginOfUserView.pswTF.delegate = self;
    [self.loginOfPhoneView.phoneTF becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mySegmentedControl.selectedSegmentIndex = 0;
    
    self.login_type = LOGIN_SMS;
    
    [self loadLoginTypeView];
    
    [self userDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];  // 键盘弹出监听
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeyboardHidden:) name:UIKeyboardWillHideNotification object:nil];    // 键盘关闭监听
    
}

- (void)loadLoginTypeView {
    
    
    [self.loginTypeView addSubview:self.mySegmentedControl];
    
    self.myScrollView.contentSize = CGSizeMake(Screen_Width*2, Screen_Height*25/58);
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.delegate = self;
    
    // 用户账号登录
    self.loginOfUserView = [[LoginOfUserView alloc] initWithFrame:CGRectMake(Screen_Width, 0, Screen_Width,Screen_Height*25/58)];
    [self.myScrollView addSubview:self.loginOfUserView];
    self.loginOfUserView.userTF.delegate = self;
    self.loginOfUserView.pswTF.delegate = self;
    
    [self.loginOfUserView.seePasswordBtn addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginOfUserView.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginOfUserView.registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginOfUserView.forgotPswButton addTarget:self action:@selector(forgetPassWordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 短信登录界面
    self.loginOfPhoneView = [[LoginOfPhoneView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height*25/58)];
    [self.myScrollView addSubview:self.loginOfPhoneView];
    [self.loginOfPhoneView.sendMsgBtn addTarget:self action:@selector(sendMsgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginOfPhoneView.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loginOfPhoneView.phoneTF.delegate = self;
    self.loginOfPhoneView.messageTF.delegate = self;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5;
    
}

- (void)loginKeyboardShow:(NSNotification *)sender {
    
    NSValue *rectValue = sender.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [rectValue CGRectValue].size.height;
    CGFloat result = Screen_Height - keyboardHeight;
    CGFloat textFieldY = self.myScrollView.frame.origin.y + Screen_Height*3/16 + 20;
    if (result < textFieldY) {
        self.view.frame = CGRectMake(0, result - textFieldY, Screen_Width, Screen_Height);
    }
}

- (void)loginKeyboardHidden: (NSNotification *)sender {
    self.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
}

// 用户偏好设置
- (void)userDefault {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RegisterPWDFlagKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableArray *mArray;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:UserPath]) {
        NSData *data = [NSData dataWithContentsOfFile:UserPath];
        NSKeyedUnarchiver *unArchinver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        mArray = [NSMutableArray arrayWithArray:[unArchinver decodeObjectForKey:UserKey]];
        NSLog(@"user = %@ \n%@",mArray,UserPath);
        User *user = [mArray lastObject];
        self.loginOfUserView.userTF.text = user.userName;
        self.loginOfUserView.pswTF.text = user.password;
        [self.rememderBtn setImage:[UIImage imageNamed:@"check"] forState:0];   // 设置为记住密码
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RegisterPWDFlagKey];  // 设置为YES
    }
}

- (void)goUserDefault {
    NSFileManager *manager = [NSFileManager defaultManager];
    // 用户名和密码归档
    if ([[NSUserDefaults standardUserDefaults] boolForKey:RegisterPWDFlagKey]) {
        User *user = [[User alloc] init];
        user.userName = self.loginOfUserView.userTF.text;
        user.password = self.loginOfUserView.pswTF.text;
        
        NSMutableArray *mArray;
        
        if ([manager fileExistsAtPath:UserPath]) {
            NSData *data = [NSData dataWithContentsOfFile:UserPath];
            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            mArray = [NSMutableArray arrayWithArray:[unArchiver decodeObjectForKey:UserKey]];
            [mArray addObject:user];
        } else {
            mArray = [NSMutableArray arrayWithObjects:user, nil];
        }
        NSLog(@"mArray = %@",mArray);
        
        NSMutableData *mData = [NSMutableData data];
        
        NSKeyedArchiver *keyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
        [keyedArchiver encodeObject:mArray forKey:UserKey];
        [keyedArchiver finishEncoding];
        [mData writeToFile:UserPath atomically:YES];
    } else {
        
        if ([manager fileExistsAtPath:UserPath]) {              // 判断是否存在该路径
            NSError *error;
            [manager removeItemAtPath:UserPath error:&error];   // 移除路径
            if (![manager fileExistsAtPath:UserPath]) {         // 判断移除是否成功
                NSLog(@"成功移除");
            } else {
                NSLog(@"移除失败 %@",error.description);
            }
            
        }
        
    }
}
#pragma mark -
- (IBAction)backAction:(UIButton *)sender {
    
    CATransition *animation = [CATransition animation]; // 创建动画
    //设置运动轨迹的速度
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"push";   // 设置动画类型
    animation.duration = .5f;   // 设置动画时间
    animation.subtype = kCATransitionFromBottom;    // 设置动画运动方向
    [self.view.layer addAnimation:animation forKey:nil];    // view.layer 添加动画效果
    
    [self.navigationController popViewControllerAnimated:NO];   // 使用自定义的动画，取消系统自带的动画
    
}

#pragma mark - 登录
- (void)loginAction:(UIButton *)sender {
    
    NSDictionary *dic;
    
    if (self.login_type == 1) {
        if (self.loginOfUserView.userTF.text.length <= 0) {
            
            [MBProgressHUD showAutoMessage:@"请输入账号哦！" ToView:nil];
            
            [self.loginOfUserView.userTF becomeFirstResponder];
            return;
        }
        if (self.loginOfUserView.pswTF.text.length <= 0) {
            
            [MBProgressHUD showAutoMessage:@"请输入密码哦！" ToView:nil];
            
            [self.loginOfUserView.pswTF becomeFirstResponder];
            return;
        }
        dic = @{@"user_name":self.loginOfUserView.userTF.text,@"pwd":self.loginOfUserView.pswTF.text,@"device_id": [[[UIDevice currentDevice] identifierForVendor] UUIDString],@"login_type":@(self.login_type +1)};
        
    } else {
        
        if (self.loginOfPhoneView.phoneTF.text.length < 1) {
            
            [MBProgressHUD showAutoMessage:@"输入手机号码哦！" ToView:nil];
            
            [self.loginOfPhoneView.phoneTF becomeFirstResponder];
            return;
        }
        
        if (![NSString validateMobile:self.loginOfPhoneView.phoneTF.text]) {
            
            [MBProgressHUD showAutoMessage:@"正确输入手机号码哦！" ToView:nil];
            
            [self.loginOfPhoneView.phoneTF becomeFirstResponder];
            return;
        }
        
        if (self.loginOfPhoneView.messageTF.text.length < 1) {
            
            [MBProgressHUD showAutoMessage: @"输入手机验证码哦！" ToView:nil];
            
            [self.loginOfPhoneView.messageTF becomeFirstResponder];
            return;
        }
        dic = @{@"user_name":self.loginOfPhoneView.phoneTF.text,@"pwd":self.loginOfPhoneView.messageTF.text,@"device_id": [[[UIDevice currentDevice] identifierForVendor] UUIDString],@"login_type":@(self.login_type +1)};
    }
    
    [self goUserDefault];
    
    
    
    [HTTPREQUEST_SINGLE postRequestWithService:URL_POST_LOGIN andParameters:dic andRequestType:1 success:^(RequestManager *manager, NSDictionary *response, NSString *time) {
        
        // 拿到token保存在本地，time 是 key ，time 时间戳反转 即为iv
        
        NSLog(@"%@--%@",response,response[@"erro_msg"]);
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showError:response[@"erro_msg"] ToView:nil];
            return ;
        }
        // 解密User
        NSString *userStr = response[@"user"];
        
        NSString *iv = [time stringByReversed];     // 由时间戳反转得到 iv
        
        userStr = [SecurityUtil AES128Decrypt:userStr andKey:time andIV:iv];      // 解密
        
        NSDictionary *userDic = [NSString dictionaryWithJsonString:userStr];    // string转字典
        
        NSLog(@"user %@",userDic);
        
        NSDictionary *responsedic = @{@"userID":userDic[@"id"],@"userName":userDic[@"username"],@"phoneNum":self.loginOfUserView.userTF.text,@"publish_count":userDic[@"publish_count"],@"regist_time":userDic[@"regist_time"],@"avatar":userDic[@"avatar"],@"type":userDic[@"type"],@"token_time":time,@"token":response[@"token"],@"password":self.loginOfUserView.pswTF.text};
        
        FOLUserInforModel *usermodel = [[FOLUserInforModel alloc] initWithDictionary:responsedic];
        [FOLUserInforModel insertUserInfoModel:usermodel];
        // 将数据保存到 user info model中
//        [UserInfoModel insertUserInfoModel:dic];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"error = %@",error.debugDescription);
        [MBProgressHUD showError:@"网络有点问题，请稍后再操作！" ToView:nil];
    }];
    
}

// 记住密码
- (IBAction)rememberPasswordAction:(id)sender {
    NSLog(@"记住密码");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:RegisterPWDFlagKey]) {
        
        [sender setImage:[UIImage imageNamed:@"uncheck"] forState:0];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:RegisterPWDFlagKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        [sender setImage:[UIImage imageNamed:@"check"] forState:0];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RegisterPWDFlagKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 查看密码
- (void)seePassword:(UIButton *)sender {
    sender.selected = !sender.selected;
//    [sender setTintColor:[UIColor blackColor]];
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"openEye"] forState:UIControlStateNormal];
        sender.adjustsImageWhenHighlighted = NO;
        self.loginOfUserView.pswTF.secureTextEntry = NO;
    } else {
        [sender setImage:[UIImage imageNamed:@"closeEye"] forState:UIControlStateNormal];
        
        self.loginOfUserView.pswTF.secureTextEntry = YES;
    }
}

#pragma mark - 发送短信
- (void)sendMsgBtnAction:(UIButton *)sender {
    
    if (self.loginOfPhoneView.phoneTF.text.length < 1) {
        
        [MBProgressHUD showAutoMessage:@"输入手机号码哦！" ToView:nil];
        
        [self.loginOfPhoneView.phoneTF becomeFirstResponder];
        
        return;
    }
    
    if (![NSString validateMobile:self.loginOfPhoneView.phoneTF.text]) {
        
        [MBProgressHUD showAutoMessage:@"正确输入手机号码哦！" ToView:nil];
        
        [self.loginOfPhoneView.phoneTF becomeFirstResponder];
        
        return;
    }
    
    [HTTPREQUEST_SINGLE getRequestWithService:[NSString stringWithFormat:@"%@2",URL_GET_SMSES] andParameters:@{@"address":self.loginOfPhoneView.phoneTF.text} isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"登录发送短信验证码：%@",response);
        
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showAutoMessage:@"您刚发送过验证码，请留意短信！" ToView:nil];
            return;
        }
        [MBProgressHUD showAutoMessage:@"短信验证码已发送，请查看" ToView:nil];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        count = 120;
        
        [self.loginOfPhoneView.sendMsgBtn setTitleColor:GRAY_99 forState:0];
        self.loginOfPhoneView.sendMsgBtn.layer.borderColor = GRAY_db.CGColor;
        self.loginOfPhoneView.sendMsgBtn.enabled = NO;
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"登录发送短信验证码：error=%@",error);
        [MBProgressHUD showAutoMessage:@"网络有点问题，请稍后再操作！" ToView:nil];
    }];
    
}

- (void)timeChange {
    
    if (count == 0) {   // 当时间到之后 恢复
        [self.loginOfPhoneView.sendMsgBtn setTitleColor:GREEN_1ab8 forState:0];
        self.loginOfPhoneView.sendMsgBtn.layer.borderColor = GREEN_1ab8.CGColor;
        [self.loginOfPhoneView.sendMsgBtn setTitle:@"获取验证码" forState:0];
        self.loginOfPhoneView.sendMsgBtn.enabled = YES;
        [timer invalidate];
        return;
    }
    [self.loginOfPhoneView.sendMsgBtn setTitle:[NSString stringWithFormat:@"%ds",count] forState:0];
    count--;
}

#pragma mark - 注册
- (void)registerAction:(UIButton *)sender {
    NSLog(@"注册");
    RegisterViewController *registerVC = [RegisterViewController new];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark - 忘记密码
- (void)forgetPassWordAction:(UIButton *)sender {
    NSLog(@"忘记密码");
    ForgetPsdViewController *forgetVC = [ForgetPsdViewController new];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - thirdPath login
- (IBAction)loginOfQQ:(id)sender {
}

- (IBAction)loginOfWeibo:(id)sender {
}

- (IBAction)loginOfWeChar:(id)sender {
}

#pragma mark - uitextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.loginOfUserView.userTF) {
        
        [self.loginOfUserView.pswTF becomeFirstResponder];
        
    } else {
        
        [self.loginOfUserView.pswTF resignFirstResponder];
    }
    
    
    return YES;
}

#pragma mark - textField -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > Screen_Width/2) {
        self.mySegmentedControl.selectedSegmentIndex = 1;
        self.login_type = LOGIN_PWD;
    } else {
        self.login_type = LOGIN_SMS;
        self.mySegmentedControl.selectedSegmentIndex = 0;
    }
    
}


#pragma mark - lazyload
- (HMSegmentedControl *)mySegmentedControl {
    
    if (!_mySegmentedControl) {
        _mySegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"短信登录",@"账号登录"]];
        _mySegmentedControl.frame = CGRectMake(0, 0, Screen_Width-88, 44);
        _mySegmentedControl.backgroundColor = [UIColor clearColor];
        _mySegmentedControl.selectionIndicatorColor = GREEN_19b8;
        _mySegmentedControl.selectionIndicatorStripLayer.cornerRadius = 1.5f;
        _mySegmentedControl.selectionIndicatorStripLayer.masksToBounds = YES;
        _mySegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _mySegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _mySegmentedControl.selectionIndicatorHeight = 3.0f;
        _mySegmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]],NSForegroundColorAttributeName:BLACK_42};
        _mySegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]],NSForegroundColorAttributeName:GREEN_19b8};
        __weak typeof (self) weakSelf = self;
        
        [_mySegmentedControl setIndexChangeBlock:^(NSInteger index) {
            
            if (index == 0) {
                [weakSelf.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                weakSelf.login_type = LOGIN_SMS;
            }else {
                [weakSelf.myScrollView setContentOffset:CGPointMake(Screen_Width, 0) animated:YES];
                weakSelf.login_type = LOGIN_PWD;
            }
            
        }];
        NSLog(@"%@",_mySegmentedControl);
        NSLog(@"%@",self.loginTypeView);
        
    }
    return _mySegmentedControl;
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
