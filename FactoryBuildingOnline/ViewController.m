//
//  ViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/29.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ViewController.h"

#import "SliderViewController.h"    // 侧边栏
#import "BaseTabBarViewController.h"
#import "MainCoverView.h"
#import "FOLUserInforModel.h"

@interface ViewController ()

@property (nonatomic, strong) BaseTabBarViewController *tabBarVC;
@property (nonatomic, strong) SliderViewController *sliderVC;
@property (nonatomic, strong) MainCoverView *coverView;    // 遮盖的View;
@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SHOWSLIDER" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addSubView];
    
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderStateChange:) name:@"SHOWSLIDER" object:nil];
}

// 添加子View
- (void)addSubView {
    __weak typeof(self) weakSelf = self;
    // 添加侧边栏界面
    self.sliderVC = [SliderViewController new];
    [self.sliderVC.view setFrame:CGRectMake(-Screen_Width/3, 0, Screen_Width*2/3, Screen_Height)];
    [self.view addSubview:self.sliderVC.view];
    self.sliderVC.sliderBlock = ^(BOOL isShow) {
        [weakSelf hiddenSlider];
    };
    
    // 添加主界面
    self.tabBarVC = [[BaseTabBarViewController alloc] init];
    [self.tabBarVC.view setFrame:self.view.bounds];
    self.tabBarVC.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabBarVC.view];
    
    // 主界面的回调方法
    
    self.tabBarVC.showSlider = ^(BOOL showSlider) {
        if (showSlider) {
            
            [weakSelf showSlider];
        } else {
            [weakSelf hiddenSlider];
        }
        
    };

    // 将主界面置于最顶层
    [self.view bringSubviewToFront:self.tabBarVC.view];
    
    [self.tabBarVC.view addSubview:self.coverView];// 添加一个遮盖的View
    [self.tabBarVC.view bringSubviewToFront:self.coverView];
    self.coverView.hidden = YES;
    self.coverView.tapBlock = ^(){
        [weakSelf hiddenSlider];
    };
}

- (void)sliderStateChange:(NSNotification *)sender {
    
    BOOL isShowSlider = [sender.userInfo[@"showSlider"] boolValue];
 
    if (isShowSlider) {
        [self showSlider];
    } else {
        [self hiddenSlider];
    }
    
}
#pragma mark - 展开侧边栏
- (void)showSlider {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sliderVC.view.hidden = NO;
        [self.tabBarVC.view setFrame:CGRectMake(Screen_Width*2/3, 0, Screen_Width, Screen_Height)];
        
        [self.sliderVC.view setFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        self.coverView.alpha = 0.5;
        self.coverView.hidden = NO;
    }];
    [self sendUserInfo];
}
#pragma mark - 隐藏侧边栏
- (void)hiddenSlider {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.tabBarVC.view setFrame:self.view.bounds]; // 将 tabBarVC 设置为原来的位置
        [self.sliderVC.view setFrame:CGRectMake(-Screen_Width/3, 0, Screen_Width, Screen_Height)];    // 侧边栏回收
        
        self.coverView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        self.sliderVC.view.hidden = YES;
        self.coverView.hidden = YES;
    }];
}

#pragma mark - 获取用户信息
- (void)sendUserInfo {
    
    NSMutableArray *usersArray = [FOLUserInforModel findAll];
    self.sliderVC.usersArray = usersArray;
}

#pragma mark - lazy load
- (MainCoverView *)coverView {
    if (!_coverView) {
        _coverView = [[MainCoverView alloc] initWithFrame:self.tabBarVC.view.bounds];
    }
    return _coverView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
