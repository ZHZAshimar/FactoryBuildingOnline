//
//  SocialSecurityTabBarViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/14.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SocialSecurityTabBarViewController.h"
#import "SSConsultViewController.h"     // 社保资讯
#import "SSHomeViewController.h"        // 社保首页
#import "SSMyViewController.h"          // 社保我的

@interface SocialSecurityTabBarViewController ()

@end

@implementation SocialSecurityTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViewContoller];
}

- (void)setupViewContoller {
    
    //  视图数组
    NSArray *controllerArr = @[@"SSHomeViewController",@"SSConsultViewController",@"SSMyViewController"];
    // 标题数组
    NSArray *titleArray = @[@"服务",@"咨询",@"我的"];
    // 图片数组
    NSArray *picArr = @[@"sshome",@"ssConsult",@"ssMy"];
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < picArr.count; i++) {
        Class class = NSClassFromString(controllerArr[i]);
        
        UIViewController *controller = [class new];
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
        
        navi.tabBarItem.title = titleArray[i];  // 设置文字
//        UIEdgeInsets
        navi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
        navi.tabBarItem.image = [[UIImage imageNamed:picArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];  // 设置正常状态下的图标
        
        navi.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];    // 设置选中状态下的图标
        
        [navi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:GREEN_19b8} forState:UIControlStateSelected];     // 设置选中的文字的字体颜色
        
        [mArray addObject:navi];    // 将设置好的VC添加到数组中
        
    }
    [self setViewControllers:mArray];
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
