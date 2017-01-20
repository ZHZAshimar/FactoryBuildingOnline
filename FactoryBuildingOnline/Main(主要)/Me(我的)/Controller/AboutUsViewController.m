//
//  AboutUsViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/2.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVCName:@"关于我们" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createImageView]; // 厂房在线的图片
    
    [self createVersionNum];    // 版本号的label
}

- (void)createImageView {
    
    UIImage *image = [UIImage imageNamed:@"about_us"];
    
    CGFloat width = Screen_Height/5 * image.size.width /image.size.height;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width/2-width/2, 40, width, Screen_Height/5)];
    
    imageView.image = image;
    
    [self.view addSubview:imageView];
}

- (void)createVersionNum {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appCurVersion = infoDic[@"CFBundleShortVersionString"];
    
    NSString *version = [NSString stringWithFormat:@"版本：%@",appCurVersion];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width/2-50, Screen_Height-100, 100, 30)];
    
    versionLabel.text = version;
    
    versionLabel.textColor = BLACK_42;
    
    versionLabel.textAlignment = NSTextAlignmentCenter;
    
    versionLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [self.view addSubview:versionLabel];
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
