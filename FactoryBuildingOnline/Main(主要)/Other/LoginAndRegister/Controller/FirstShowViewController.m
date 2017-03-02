//
//  FirstShowViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/2.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "FirstShowViewController.h"
#import "LogoViewController.h"  // 登录界面

@interface FirstShowViewController ()

@property (weak, nonatomic) IBOutlet UIButton *notLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation FirstShowViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewStyle];
}
- (void)setViewStyle {
    self.notLoginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.notLoginButton.layer.borderWidth = 1;
    self.notLoginButton.layer.cornerRadius = Screen_Height*25/568/2;
    
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = Screen_Height*25/568/2;
}

#pragma mark - 跳过 登录
- (IBAction)notLoginButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 跳转 登录
- (IBAction)loginButtonAction:(UIButton *)sender {
    LogoViewController *loginVC = [LogoViewController new];
    CATransition *animation = [CATransition animation]; // 创建动画
    animation.type = @"push";   // 设置动画类型
    animation.duration = 0.2f;  // time
    animation.subtype = kCATransitionFromTop;
    [loginVC.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:loginVC animated:NO];
}

#pragma mark - 微博登录
- (IBAction)weiBoLogin:(UIButton *)sender {
}
#pragma mark - qq 登录
- (IBAction)qqLogin:(UIButton *)sender {
}
#pragma mark - 微信 登录
- (IBAction)wechat:(UIButton *)sender {
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
