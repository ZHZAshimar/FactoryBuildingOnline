//
//  BaseTabBarViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "RecommendViewController.h"
#import "MeViewController.h"
#import "FOLUserInforModel.h"
#import "LogoViewController.h"

#import "AddRootView.h"
#import "ReserveViewController.h"
#import "PublishScrollViewViewController.h"

@interface BaseTabBarViewController ()<RDVTabBarControllerDelegate>
{
    NSInteger selectedTabBarIiemTag;
}

@property (nonatomic, strong) AddRootView *addView;
@end

@implementation BaseTabBarViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnauthorizedRequest" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setupViewControllers];
    
//    // 添加一条分割线
//    UIView *linecutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
//    linecutView.backgroundColor = GRAY_cc;
//    [self.tabBar addSubview:linecutView];
    
    self.tabBar.backgroundView.backgroundColor = [UIColor whiteColor];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(showLoginView)
//                                                 name:@"UnauthorizedRequest"
//                                               object:nil];
}

#pragma mark - 显示网络状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSString *state = change[@"new"];
    [MBProgressHUD showAutoMessage:state ToView:nil];
}

- (void)setupViewControllers {
    
    // 首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    BaseNavigationController *homeNavi = [[BaseNavigationController alloc] initWithRootViewController:homeVC];
    
    UIViewController *addVC = [[UIViewController alloc] init];
    BaseNavigationController *addNavi = [[BaseNavigationController alloc] initWithRootViewController:addVC];
    
//    // 推荐
//    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
//    BaseNavigationController *recommendNavi = [[BaseNavigationController alloc] initWithRootViewController:recommendVC];
    
    // 消息
//    MessageViewController *messageVC = [[MessageViewController alloc] init];
//    BaseNavigationController *messageNavi = [[BaseNavigationController alloc] initWithRootViewController:messageVC];
    
    // 我的
    MeViewController *meVC = [[MeViewController alloc] init];
    BaseNavigationController *meNavi = [[BaseNavigationController alloc] initWithRootViewController:meVC];
    
    self.delegate = self;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self setViewControllers:@[homeNavi,addNavi,/*messageNavi,*/meNavi]];
    
    [self customizeTabBarForController:self];
    
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    NSArray *tabBarItemImages = @[@"nav_home",@"nav_add"/*,@"nav_icon3"*/,@"nav_my"];
    
    NSArray *nameArray = @[@"首页",@""/*,@"消息"*/,@"我的"];
    
    NSInteger index = 0;
    
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
      
        
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed.png",[tabBarItemImages objectAtIndex:index]]];
        
        UIImage *unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png",[tabBarItemImages objectAtIndex:index]]];
//        if (index == 0) {
//            selectedImage = [UIImage imageNamed:@"1.png"];
//            unselectedImage = [UIImage imageNamed:@"1.png"];
//        }
//        if (index == 1) {
//            selectedImage = [UIImage imageNamed:@"24x24_2.png"];
//            unselectedImage = [UIImage imageNamed:@"24x24_2.png"];
//        }
        // 设置选中图片和未选中图片
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        // 设置名称
        [item setTitle:[nameArray objectAtIndex:index]];
        // 设置背景颜色
        [item setBackgroundColor:[UIColor clearColor]];
        // 设置item的高度
        item.itemHeight = NaviHeight;
        
        item.unselectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:9.0f],NSForegroundColorAttributeName:[UIColor colorWithWhite:0.549 alpha:1.000]};
        
        item.selectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:GREEN_1ab8};
        
        item.titlePositionAdjustment = UIOffsetMake(0, 8);
        
        item.imagePositionAdjustment = UIOffsetMake(0, 4);
        
        item.tag = 100 + index;
        
//        item.itemHeight =Screen_Width*1.0f*(192*1.0f/180)/5;
        item.badgePositionAdjustment = UIOffsetMake(0, 15);
        
        NSLog(@"------%f",item.itemHeight);
        
        index++;
    }
    
}

/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
//    // 防止双击
//    if (selectedTabBarIiemTag == viewController.rdv_tabBarItem.tag) {
//        return NO;
//    } else {
//        selectedTabBarIiemTag = viewController.rdv_tabBarItem.tag;
//        return YES;
//    }
    
    BaseNavigationController *bos = (BaseNavigationController *)viewController;
    
    if (![[bos.viewControllers objectAtIndex:0] isKindOfClass:[BaseViewController class]]) {
        
        NSMutableArray *userArr = [FOLUserInforModel findAll];
        
        if (userArr.count <= 0) {
            [MBProgressHUD showAutoMessage:@"您还没有登录😯" ToView:nil];
            return NO;
        }
        
        FOLUserInforModel *userModel = userArr[0];
        // ➕ 按钮
        self.addView = [[AddRootView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) andType:userModel.type];
        
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appdelegate.window addSubview:self.addView];
        
        __weak typeof(self) weakSelf = self;
        
        self.addView.tapButtonBlock = ^(NSInteger index) {
            
            switch (index) {
                case 0:
                {   // 预定
                    ReserveViewController *reserveVC = [ReserveViewController new];
                    
                    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:reserveVC];

                    [weakSelf presentViewController:navi animated:YES completion:nil];

                    [weakSelf.addView removeView];

                }
                    break;
                case 1:
                {   // 发布
                    PublishScrollViewViewController *publishVC = [PublishScrollViewViewController new];
                    
                    publishVC.publish_type = RENT_TYPE; // 发布类型为出租
                    
                    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:publishVC];
                    
                    [weakSelf presentViewController:navi animated:YES completion:nil];
                    
                    [weakSelf.addView removeView];
                    
                }
                    break;
                default:
                    break;
            }
        
        };
        
        return NO;
    }
    
    return YES;
}

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
    
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
