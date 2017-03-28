//
//  ElectronicContractTabbarViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ElectronicContractTabbarViewController.h"
#import "ECCreateViewController.h"
#import "ECVisitViewController.h"
#import "ECExportViewController.h"

@interface ElectronicContractTabbarViewController ()

@end

@implementation ElectronicContractTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViewController];

}

- (void)setupViewController {
    
    NSArray *controlsArray = @[@"ECCreateViewController", @"ECVisitViewController", @"ECExportViewController"]; // 视图数组
    
    NSArray *titleArray = @[@"创建合同",@"查看合同",@"导出合同"];   // title 数组
    
    NSArray *picArray = @[@"ec_create",@"ec_export",@"ec_visit"];   // 图标数组
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        
        Class class = NSClassFromString(controlsArray[i]);
        
        UIViewController *controller  = [class new];
        controller.title = titleArray[i];   // 设置viewcontroller 的title
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
        
        navi.navigationBar.barTintColor = [UIColor colorWithHex:0x1d202f];      // 设置导航栏的背景色
        [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];    // 设置标题文字颜色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // 设置状态栏的状态为高亮
        
        navi.tabBarItem.title = titleArray[i];
        
//        navi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);  // 设置文字偏移
        
        navi.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",picArray[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];  // 选中时的图片
        
        navi.tabBarItem.image = [[UIImage imageNamed:picArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];   // 图标
        
        [navi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:GREEN_19b8,NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:10]]} forState:UIControlStateSelected];      // 设置选中时的文字大小及颜色
        
        [navi.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666],NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:10]]}  forState:0];    // 设置未选中时的文字大小及颜色
        
        [mArray addObject:navi];        // 将设置好的VC添加到数组中
        
    }
    
    self.viewControllers = mArray;
    
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
