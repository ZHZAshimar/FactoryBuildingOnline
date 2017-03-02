//
//  BaseViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import <AliHotFix/AliHotFix.h>
#import "HomeViewController.h"
#import "LogoViewController.h"
#import "MeViewController.h"
#import "MessageViewController.h"
#import "RecommendViewController.h"
#import "SearchViewController.h"
#import "FactoryDetailViewController.h"
#import "PublishManViewController.h"
#import "FOLUserInforModel.h"
#import "LogoViewController.h"

@interface BaseViewController ()<UISearchBarDelegate>
{
    
}
@end

@implementation BaseViewController

- (void)dealloc {
    NSLog(@"already kill me %@", [[self class] description]);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UnauthorizedRequest" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBarOfNavi removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear %@",[[self class] description]);
    
    // 隐藏 tabbar
    [self.rdv_tabBarController setTabBarHidden:NO];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
//     设置 导航栏的背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    
    if (self.navigationController.navigationBarHidden) {
        // 此处判断对应类的导航栏需要隐藏的
        if ([self isKindOfClass:[SearchViewController class]]) {
            self.navigationController.navigationBarHidden = NO;
        }
    }
    
    //scroll view 置顶
    if ([self isKindOfClass:[MeViewController class]] || [self isKindOfClass:[LogoViewController class]] || [self isKindOfClass:[FactoryDetailViewController class]] || [self isKindOfClass:[PublishManViewController class]]) {
        // 防止界面 由于隐藏导航栏而 下滑 20个像素点  //自动调整滚动视图插入
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }else{
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
        
    }
    
    self.navigationController.navigationBar.barTintColor = NaviBackColor;
    self.navigationController.navigationBar.tintColor = BLACK_42;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, 0.5)];
    if ([self isKindOfClass:[HomeViewController class]]) {
        line.backgroundColor = [UIColor whiteColor];
    } else {
        line.backgroundColor = GRAY_cc;    // 1.0.1  版本是 GRAY_cc
    }
    [self.navigationController.navigationBar addSubview:line];
    [self.navigationController.navigationBar bringSubviewToFront:line];
}

#pragma mark -- 导航栏 上的按钮
#pragma mark - 左边的按钮
- (void)addLeftItem:(NSString *)itemName {
    self.leftItem = [[UIBarButtonItem alloc] initWithTitle:itemName style:UIBarButtonItemStylePlain target:self action:@selector(leftItemButtonAction)];
    self.leftItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
}

- (void)leftItemButtonAction {
    NSLog(@"导航栏左边的按钮");
}

/**
 *  navigation 添加 单个 右边图片按钮
 *
 *  @param itemName   文字
 *  @param tintColor  前景色
 */
- (void)addRightItemWithString:(NSString *)itemName andItemTintColor:(UIColor *)tintColor{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:itemName style:UIBarButtonItemStylePlain target:self action:@selector(rightItemButtonAction)];
    item.tintColor = tintColor;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:[UIFont adjustFontSize:14]],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark - 右边 单个 logo 按钮
/**
 *  navigation 添加 单个 右边图片按钮
 *
 *  @param image  图片
 *  @param color  前景色
 */
- (void)addRightItemWithLogo:(UIImage *)image andItemTintColor:(UIColor *)color{
    self.rightImageItemButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightItemButtonAction)];
    
    self.rightImageItemButton.tintColor = color;
    self.navigationItem.rightBarButtonItem = self.rightImageItemButton;
}
/**
 *  navigation 添加 单个 右边 图片+文字 按钮
 *
 *  @param image    图片
 *  @param itemName 文字
 */
- (void)addRightItemCustomWithLogo:(UIImage *)image andItemName:(NSString *)itemName {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = view.bounds;
    [button setTitle:itemName forState:UIControlStateNormal];
    [button setTitleColor:GREEN_1ab8 forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;   // 向右对齐
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [button addTarget:self action:@selector(rightItemButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    if (image != nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 14, 16, 16);
        [view addSubview:imageView];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
}
/**
 *  navigation 添加 单个 右边按钮的点击回调事件
 */
- (void)rightItemButtonAction {
    
}

#pragma mark -- 右边 n个 图片 按钮
- (void)addRightImageItem:(NSArray *)imageArray buttonCount:(int)count {
    
    if (count > 1) {
        CGFloat width = 76;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        
        for (int i = 0; i < count; i++) {
            self.barButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            self.barButton.frame = CGRectMake(0+i*width/2, 0, width/2, 44);
            
            [self.barButton setImage:[UIImage imageNamed:imageArray[i]] forState:0];
            
            [self.barButton setTintColor:BLACK_1a];
            
            self.barButton.tag = i;
            // 调整按钮向右偏移
            self.barButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
            
            [view addSubview:self.barButton];
            
            [self.barButton addTarget:self action:@selector(rightActionSecond:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIBarButtonItem *barButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:view];
        
        self.navigationItem.rightBarButtonItem = barButtonTwo;
        
        return;
    }
    
    UIBarButtonItem *barButtonOne = [[UIBarButtonItem alloc] initWithImage:imageArray[0] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem)];
    self.navigationItem.rightBarButtonItem = barButtonOne;
    
}

- (void)rightActionSecond:(UIButton *)sender {
    
}

- (void)setVCName:(NSString *)vcName andShowSearchBar:(BOOL)showSearchBar andTintColor:(UIColor*)tintColor andBackBtnStr:(NSString *)backStr{
    
    self.navigationItem.title = vcName; // 设置标题
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:BLACK_42}];    // 设置标题文字颜色

    if (showSearchBar) {
        
        self.searchBarOfNavi.hidden = NO;
        self.searchBarOfNavi = [[UISearchBar alloc] initWithFrame:CGRectMake(Screen_Width/4+10, 0, Screen_Width*3/4-30, 44)];
        self.searchBarOfNavi.placeholder = @"请输入搜索关键字";
        self.searchBarOfNavi.delegate = self;
        self.searchBarOfNavi.returnKeyType = UIReturnKeyDone;   // 键盘的return 按钮的设置
        // 设置 searchBar 的 内部背景颜色
        UIColor *innerColor = GRAY_f4;
        
        for (UIView* subview in [[self.searchBarOfNavi.subviews lastObject] subviews]) {
            
            if ([subview isKindOfClass:[UITextField class]]) {
                
                UITextField *textField = (UITextField*)subview;
                
                textField.backgroundColor = innerColor;
            }
        }
        [self.navigationController.navigationBar addSubview:self.searchBarOfNavi];
        // 设置 searchBar 的 搜索图片
        UIImage *searchImage = [UIImage imageNamed:@"search"];
        [self.searchBarOfNavi setImage:searchImage forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
    } else {
        
        self.searchBarOfNavi.hidden = YES;
        
        self.leftNaviButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        [self.leftNaviButton setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
        
        self.leftNaviButton.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
        
        [self.leftNaviButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.leftNaviButton];
        
        item.tintColor = tintColor;
        
        if (backStr.length > 0) {
            self.leftNaviButton.frame = CGRectMake(0, 0, 60, 40);
            self.leftNaviButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
            self.leftNaviButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [self.leftNaviButton setTitle:backStr forState:UIControlStateNormal];
            [self.leftNaviButton setTitleColor:tintColor forState:UIControlStateNormal];
            self.leftNaviButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14]];
        }
        
        self.navigationItem.leftBarButtonItem = item;
        
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - navigationbar 添加 双击手势
- (void)navigationAddTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    // 设置点击次数为两次
    tapGesture.numberOfTapsRequired = 2;
    
    [self.navigationController.navigationBar addGestureRecognizer:tapGesture];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = GRAY_F5;    // 设置所有视图的背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoginView)
                                                 name:@"UnauthorizedRequest"
                                               object:nil];
    
    //应用进入前台就同步一次补丁
    [AliHotFix sync];
}
#pragma mark - 跳转登录
- (void)showLoginView {
    [MBProgressHUD hideHUD];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号登录过期，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitLoginAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [FOLUserInforModel deleteAll];
//        self.rdv_tabBarController.selectedIndex = 2; // 跳转到我的界面
    }];
    [alertControl addAction:exitLoginAction];
    
    UIAlertAction *againLoginAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [FOLUserInforModel deleteAll];
        LogoViewController *loginVC = [LogoViewController new];
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
    [alertControl addAction:againLoginAction];
    [self presentViewController:alertControl animated:YES completion:nil];
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
