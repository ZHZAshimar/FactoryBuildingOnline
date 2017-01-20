//
//  BaseNavigationController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UISearchBarDelegate>

@end

@implementation BaseNavigationController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 
//- (void)setHomeImage {
//    NSLog(@"create home image");
//    // 创建 首页导航栏 logoImage
//    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo"]];
//    // 通过中心点确定logoImageView 在 navigationBar 中的位置
//    CGRect rect = self.logoImageView.frame;
//    
//    rect.origin.x = Screen_Width/2 - self.logoImageView.frame.size.width/2;
//    
//    rect.origin.y = self.navigationBar.frame.size.height/2 - self.logoImageView.frame.size.height/2;
//    rect.size.width = self.logoImageView.frame.size.width/2;
//    rect.size.height = self.logoImageView.frame.size.height/2;
//    self.logoImageView.frame = rect;
//    self.logoImageView.center = self.navigationBar.center;
//    self.logoImageView.backgroundColor = [UIColor clearColor];
//    [self.navigationBar addSubview:self.logoImageView];
//    
//}



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
