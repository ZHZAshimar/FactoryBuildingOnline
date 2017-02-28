//
//  MeViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "MeViewController.h"
#import "MeFirstHeadCollectionReusableView.h"
#import "MyCollectionViewCell.h"
#import "LogoViewController.h"
//#import "UserInfoModel+CoreDataClass.h"
#import "FOLUserInforModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PublishAndCollectViewController.h"
#import "SettingTableViewController.h"
#import "UserInfomationViewController.h"

#import "RoleSwitchingView.h"
#import "MeBackgroundView.h"
#import "AppFeedbackViewController.h"
#import "ScanHistoryViewController.h"
#import "ScanReserveViewController.h"

@interface MeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MeFirstHeadCollectionReusableViewDelegate>
{
    NSArray *titleArray;    // 标题的数组
    NSArray *imageArray;    // 图片的数组
    NSMutableArray *userInfoModelArr;   // 用户信息数组
    MeFirstHeadCollectionReusableView *firstHeadReusableView;
    BOOL isLogin;
    
    UIView *viewDown;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) RoleSwitchingView *roleSwitchView;
@end

@implementation MeViewController

- (void)dealloc {
    
    self.myCollectionView.delegate = nil;
    
    self.myCollectionView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
//    // 将状态栏变成白色 在 info文件 添加 View controller-based status bar appearance 设置为no
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    
    userInfoModelArr = [FOLUserInforModel findAll];
    
    if (userInfoModelArr.count > 0) {
        isLogin = YES;
    } else {
        isLogin = NO;
    }
    [self.myCollectionView reloadData];
}
//
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];  // status bar 设置成默认的
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    titleArray = @[@"我的收藏",@"",@"浏览历史",@"问题反馈",@"身份切换",@"设置"];

    imageArray= @[[UIImage imageNamed:@"my_collect"],[UIImage imageNamed:@"my_scan"],[UIImage imageNamed:@"my_publish"],[UIImage imageNamed:@"my_problem"],[UIImage imageNamed:@"my_change"],[UIImage imageNamed:@"my_setting"]];
    
    self.view.backgroundColor = GRAY_F5;
    
    [self drawBgView];
    
//    []
}

- (void)drawBgView {
    MeBackgroundView *backgroundView = [[MeBackgroundView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = GRAY_F5;
    [self.view addSubview:backgroundView];
    
    [self.view addSubview:self.myCollectionView];
    // 积分兑换按钮
    UIButton *integralButton = [UIButton buttonWithType:UIButtonTypeCustom];
    integralButton.frame = CGRectMake(Screen_Width - Screen_Width/5, Screen_Height*37/142, Screen_Width/5-10, Screen_Height*114/568);
//    [integralButton setImage:[UIImage imageNamed:@"god"] forState:0];
    [integralButton setBackgroundImage:[UIImage imageNamed:@"god"] forState:0];
    integralButton.imageEdgeInsets = UIEdgeInsetsMake(-Screen_Height*80/667, 0, 0, 0);
    [self.view addSubview:integralButton];
    
}

- (void)jumpAction: (UIButton *)sender {
    
//    AAViewController *aaVC = [AAViewController new];
//    [self.navigationController pushViewController:aaVC animated:YES];
}
#pragma mark - MeFirstHeadCollectionReusableViewDelegate
#pragma mark - 首页的名字点击效果
- (void)tapNameButtonAction:(UIButton *)sender {
    
    [self tapHeadPictureAction];
}
#pragma mark - 跳转到个人设置页面
- (void)tapHeadPictureAction{
    NSLog(@"个人设置");
    if (isLogin) {
        // 跳转到个人设置界面
        
        NSLog(@"个人设置");
        UserInfomationViewController *userInfoVC = [UserInfomationViewController new];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    } else {
        // 跳转到登录界面
        [self goLoginVC];

    }
}
#pragma mark - 跳转到个人发布界面
- (void)tapHexagonButton {
    if (!isLogin) {
        // 跳转到登录界面
        [self goLoginVC];
        return;
    }
    FOLUserInforModel *userModel = userInfoModelArr[0];
    
    // 身份为专家的时，跳转到我发布的厂房页面；当身份为用户时，跳转到我发布的需求页面
    if (userModel.type == 2) {
        // 跳转到我发布的厂房页面
        PublishAndCollectViewController *publishVC = [PublishAndCollectViewController new];
        
        publishVC.datatype = MYPUBLISH_TYPE;
        
        [self.navigationController pushViewController:publishVC animated:YES];

    } else {
        // 跳转到我发布的需求页面
        ScanReserveViewController *reserveVC = [ScanReserveViewController new];
        [self.navigationController pushViewController:reserveVC animated:YES];
    }
}

#pragma mark - 登录
- (void)goLoginVC {
    // 跳转到登录界面
    LogoViewController *logoVC = [LogoViewController new];
    
    CATransition *animation = [CATransition animation]; //创建动画
    //设置运动轨迹的速度
    //                animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = @"push";   //设置动画类型
    
    animation.duration =0.2f;   //设置动画时长
    
    animation.subtype =kCATransitionFromTop;    //设置运动的方向
    //控制器间跳转动画
    //                [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    [logoVC.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController pushViewController:logoVC animated:NO];
}

#pragma mark - collectionView datasource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return titleArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(Screen_Width, Screen_Height*110/284);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headView =  [UICollectionReusableView new];
    
    if (kind == UICollectionElementKindSectionHeader) {
        firstHeadReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MeFirstHeadCollectionReusableView" forIndexPath:indexPath];
        firstHeadReusableView.delegate = self;
        
        
        if (isLogin) {    // 登录状态
            
            userInfoModelArr = [FOLUserInforModel findAll];
            
            FOLUserInforModel *userModel = userInfoModelArr[0];
            
            firstHeadReusableView.userModel = userModel;
            
        } else {    // 未登录状态
            firstHeadReusableView.userHeadImageView.image = [UIImage imageNamed:@"my_normal"];
            [firstHeadReusableView.nameBtn setTitle:@"未登录，请登录 >" forState:0];
            [firstHeadReusableView.hexagonButton setImage:[UIImage imageNamed:@"my_reserve"] forState:0];
            firstHeadReusableView.hexagonShapeLayer.fillColor = GREEN_19b8.CGColor;
            firstHeadReusableView.publishLabel.text = @"发布\n0";
        }
        
        return firstHeadReusableView;
    }
    return headView;
}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.5f;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.5f;
//}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (Screen_Width-1)/2;
    return CGSizeMake(width, Screen_Height*50/284                                                                                                                                                  );
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.item == 1) {
        cell.imageView.hidden = YES;
        cell.label.hidden = YES;
    } else {
        cell.imageView.hidden = NO;
        cell.label.hidden = NO;
    
        cell.imageView.image = imageArray[indexPath.item];
        cell.label.text = titleArray[indexPath.item];
    }
    return  cell;
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case 0:
        {
            if (!isLogin) {
                
                // 跳转到登录界面
                [self goLoginVC];
                
            } else {
                
                PublishAndCollectViewController *publishAndCollectVC = [PublishAndCollectViewController new];
//                if (indexPath.item == 0) {
//                    // 跳转到 我的发布
//                    publishAndCollectVC.datatype = MYPUBLISH_TYPE;
//                    
//                } else {
                    // 跳转到我的收藏
                    publishAndCollectVC.datatype = MYCOLLECT_NORMAL_TYPE;
//                }
                [self.navigationController pushViewController:publishAndCollectVC animated:YES];
            }
        }
            break;
        case 2:     // 浏览记录
        {
            if (!isLogin) {
                
                // 跳转到登录界面
//                [self goLoginVC];
                [MBProgressHUD showError:@"请登录后查看！" ToView:nil];
                return;
            }
            ScanHistoryViewController *scanHistoryVC = [ScanHistoryViewController new];
            
            [self.navigationController pushViewController:scanHistoryVC animated:YES];
        }
            break;
        case 3:     // 问题反馈
        {
            AppFeedbackViewController *feedbackVC = [AppFeedbackViewController new];
            
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 4:     // 身份切换
        {
            if (!isLogin) {
                
                // 跳转到登录界面
//                [self goLoginVC];
                [MBProgressHUD showError:@"请登录后查看！" ToView:nil];
            } else {
                
                AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

                
                 self.roleSwitchView = [[RoleSwitchingView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
                __weak typeof(self) weakSelf = self;
                // 选择回调
                self.roleSwitchView.selectSwitchingBlock = ^(NSInteger index) {
                    NSLog(@"点中了%ld",index);
                    int tag = 0;
                    if (index == 100) {
                        tag = 2;
                    } else {
                        tag = 1;
                    }
                    
                    NSDictionary *requestDic = @{@"update_type":@(4),@"update_value":[NSString stringWithFormat:@"%d",tag]};
                    
                    [HTTPREQUEST_SINGLE putRequestWithService:URL_POST_LOGIN andParameters:requestDic isShowActivity:YES isEncode:YES success:^(RequestManager *manager, NSDictionary *response) {
                        NSLog(@"身份切换：%@",response[@"erro_msg"]);
                        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"身份切换%@",response[@"erro_msg"]] ToView:nil];
                        // 修改成功的时候
                        if ([response[@"erro_code"] intValue] == 200) {
                            
                            FOLUserInforModel *userModel = [FOLUserInforModel findAll][0];
                            // 修改数据库中 userInfo 表中的type 的值
                            [FOLUserInforModel updateUserInfo:@"type" andupdateValue:[NSString stringWithFormat:@"%d",tag] andUserID:userModel.userID];
                            [weakSelf.myCollectionView reloadData];
                        }
                        
                    } failure:^(RequestManager *manager, NSError *error) {
                        NSLog(@"身份切换：%@",error);
                    }];
                    
                    [weakSelf.roleSwitchView removeFromSuperview];
                };
                // 触碰回调
                self.roleSwitchView.tapViewBlock = ^(){
                    [weakSelf.roleSwitchView removeFromSuperview];
                };
                [appdelegate.window addSubview:self.roleSwitchView];
            }
        }
            break;
        case 5:     // 设置
        {
            SettingTableViewController *settingVC = [SettingTableViewController new];
            
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        default:
            break;
    }
    NSLog(@"");
}

#pragma mark - lazyload
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = [UIColor clearColor];
        
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        // 注册头部
        [_myCollectionView registerClass:[MeFirstHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MeFirstHeadCollectionReusableView"];
        
        // 注册cell
        [_myCollectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    }
    
    return _myCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
