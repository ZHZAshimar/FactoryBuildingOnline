//
//  HomeViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeViewController.h"

#import "HMSegmentedControl.h"
#import "HomeCollectionViewCell.h"
#import "GetVersion.h"
#import "SearchViewController.h"
#import "SelectCityTableViewController.h"
#import "FactoryDetailViewController.h"
#import "PublishScrollViewViewController.h"
#import "NewsViewController.h"              // 资讯界面
#import "FirstShowViewController.h"
#import "FOLUserInforModel.h"

#import "UserLocation.h"

#define NAVBAR_CHANGE_POINT 64

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    NSArray *fourPathTextArr;
    NSArray *fourPathSubtextArr;
    SelectCityTableViewController *selectCityVC;
    CGFloat segmentedIndexView_width;
    BOOL isShowSlider;  // 是否展开侧边栏
}

@property (nonatomic, strong) HMSegmentedControl *naviSegmentedControl;  // 导航栏上面的 segmented
@property (nonatomic, strong) UITextField *searchTF;   // 在导航栏下面的 搜索框

@property (nonatomic, strong) UIView *greenView;    // 导航栏的绿色View（停用了此功能）
@property (nonatomic, strong) UIButton *naviSearchButton;   // 导航栏上的搜索（停用了此按钮）

@property (nonatomic,strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UIView *leftBarView;        // 搜索框左边的定位View
@property (nonatomic, strong) UILabel *leftBarAreaLabel;  // 搜索框左边的定位View 里面的label
@property (nonatomic, strong) UIButton *slideButton;    // 侧边栏的button
@property (nonatomic, assign) int segmentedIndex;

@end

@implementation HomeViewController

- (void)dealloc
{
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NAVIGATIONCHANGE" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _locService.delegate = nil;     // 不用时，置nil
    _locService.delegate = nil;     // 不用时，置nil
    self.navigationController.navigationBar.barTintColor = NaviBackColor;
    
    __weak HomeViewController *weakSelf = self;
    // 选择城市回调
    selectCityVC.area_city = ^(NSString *string)
    {
        if (string)
        {
            weakSelf.leftBarAreaLabel.text = string;
        }
        
    };
    self.slideButton.hidden = YES;          // 隐藏导航栏 左边的button
    self.naviSegmentedControl.hidden = YES; // 隐藏导航栏 segmentedControl
    [self.naviSearchButton removeFromSuperview];
    [self.greenView removeFromSuperview];
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_locService != nil) {
        _locService = nil;
    }
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, 0.5)];
    
    line.backgroundColor = [UIColor whiteColor];    // 1.0.1  版本是 GRAY_cc
    
    [self.navigationController.navigationBar addSubview:line];
    [self.navigationController.navigationBar bringSubviewToFront:line];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 显示 tabbar
    [self.rdv_tabBarController setTabBarHidden:NO];
    self.slideButton.hidden = NO;          // 隐藏导航栏 左边的button
    [self loadNavigation];
    _locService.delegate = self;    // 定位代理
    _geocodesearch.delegate = self;  // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 判断是否登录，没有登录的话就跳转到登录界面
    NSMutableArray *userArray = [FOLUserInforModel findAll];
    if (userArray.count < 1) {
        [self.navigationController pushViewController:[FirstShowViewController new] animated:YES];
    }
    
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.leftBarView];
    
    // 代理
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    [self locationSevice];  // 设置定位
//     NSLog(@"********%f",Screen_Width);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"NAVIGATIONCHANGE" object:nil];
    
    // 获取版本更新
    GetVersion *getVersion = [GetVersion new];
    [getVersion appStoreUpdateVersion];
    getVersion.block = ^(NSDictionary *dic){
        [self showVersionUpdate:dic];
    };
    
    isShowSlider = YES;
    // 初始化从屏幕边边扫动的手势
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(tapMoveLeftAction:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
  
}

- (void)tapMoveLeftAction:(UIScreenEdgePanGestureRecognizer *)gesture {
//    self.showSlider(YES);
    NSLog(@"左边");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWSLIDER" object:self userInfo:@{@"showSlider":@(YES)}];
}

#pragma mark - 接收 NAVIGATIONCHANGE 通知
- (void)receiveNotification:(NSNotification *)sender {
    
    CGFloat contentY = [sender.userInfo[@"contentOffsetY"] floatValue];  // 拿到偏移的Y值
    
    if (contentY >= -20) {
        
        [self changeWithFloat:contentY];
    }
}

- (void)changeWithFloat:(CGFloat)contentY {

    // 将搜索框和collectionView向上移动
    self.searchTF.frame = CGRectMake(26, -contentY, Screen_Width-52, Screen_Height*15/284);
    
    self.myCollectionView.frame = CGRectMake(0, Screen_Height*15/284-contentY, Screen_Width, Screen_Height-Screen_Height*15/284);
    
    if (contentY >= Screen_Height*15/284) {  // 当偏移量到达 Screen_Height*15/284 时，让 UICollectionView 固定在（0，0）点
        
        self.myCollectionView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-Screen_Height*15/284);
    }
    
    CGFloat alpha = MIN(1, contentY/100);
    
    self.greenView.alpha = alpha;       // 设置greenView 的透明度
    
    NSLog(@"%f--%f",contentY,alpha);
    
    // 定位的View 透明度变化
    self.leftBarView.alpha = 1 - alpha;
    
    // 计算 segmentedControl 的偏移及宽度的变化
    CGFloat segmentedControl_X = Screen_Width/2-contentY;
    if (segmentedControl_X <= Screen_Width/6) {
        self.naviSegmentedControl.frame = CGRectMake(Screen_Width/6, 5, Screen_Width*2/3, 30);
        
    }else if (contentY == 0){
        // 当 偏移为0时，恢复之前的位置
        self.naviSegmentedControl.frame = CGRectMake(Screen_Width/2, 5, Screen_Width/2-13, 30);
        self.naviSearchButton.frame = CGRectMake(Screen_Width, 0, 50, 44);
        // set font's style on normal
        _naviSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:GRAY_80,NSFontAttributeName:[UIFont adjustFont:[UIFont systemFontOfSize:15.0]]};
        
        // set font's style on selected
        _naviSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:GREEN_1ab8,NSFontAttributeName:[UIFont adjustFont:[UIFont systemFontOfSize:15.0]]};
        
    } else {
        // 让 naviSegmentedControl 根据 偏移Y改变 x轴上的位置 和 宽度
        self.naviSegmentedControl.frame = CGRectMake(segmentedControl_X, 5, Screen_Width/2+contentY/2, 30);
        
        
        CGFloat color = MIN(1, (128+contentY)/225.0);
        
        // 颜色变化
        // set font's style on normal
        self.naviSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:color green:color blue:color alpha:1.0],NSFontAttributeName:[UIFont adjustFont:[UIFont systemFontOfSize:15.0]]};
        
        CGFloat chooseRed = MIN(1, (26+contentY*2)/255.0);
        CGFloat chooseGreen = MIN(1, (184+contentY*2)/255.0);
        CGFloat chooseBlue = MIN(1, (15+contentY*2)/255.0);
        NSLog(@"%f-%f-%f",chooseRed,chooseBlue,chooseGreen);
        // set font's style on selected
        self.naviSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:chooseRed green:chooseGreen blue:chooseBlue alpha:1.0],NSFontAttributeName:[UIFont adjustFont:[UIFont systemFontOfSize:15.0]]};
        
        
        // 搜索按钮的 位置变化
        CGFloat searchButton_X = Screen_Width - contentY/2;
        if (contentY/2 >= 50) {
            // 当偏移大于 50 时，让搜索的图标固定在导航栏右端
            self.naviSearchButton.frame = CGRectMake(Screen_Width-50, 0, 50, 44);
        } else {
            // 让 naviSearchButton 的X轴变化
            self.naviSearchButton.frame = CGRectMake(searchButton_X, 0, 50, 44);
        }
        
    }
    
}
#pragma mark - 加载 导航栏
- (void)loadNavigation {
    // 显示 导航栏
    self.navigationController.navigationBar.hidden = NO;
    // 添加一个展开侧边栏的按钮
    [self.navigationController.navigationBar addSubview:self.slideButton];
    
    [self.navigationController.navigationBar addSubview:self.naviSegmentedControl];
    
    self.leftBarView.hidden = NO;
    self.naviSegmentedControl.hidden = NO;
    
    [self.navigationController.navigationBar addSubview:self.naviSearchButton];
    
    // 将greenView 添加到 navigationBar 的 0 位置，
    [self.navigationController.navigationBar insertSubview:self.greenView atIndex:0];
}
#pragma mark - 初始化定位服务
- (void)locationSevice {        // 定位设置
    
    _locService = [[BMKLocationService alloc] init];    // 初始化定位 服务
//    _locService.distanceFilter = 100;
    [_locService startUserLocationService];     // 开启定位
    
    _locService.headingFilter = 4;
    _locService.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locService.pausesLocationUpdatesAutomatically = YES;
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
}
#pragma mark - 跳转到选择城市界面
- (void)jumpSelectCityAction: (UITapGestureRecognizer *)sender {
    
    selectCityVC = [SelectCityTableViewController new];
    
    selectCityVC.cityStr = self.cityNameStr;
    
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

#pragma mark - 出现侧边栏
- (void)showSlideVC: (UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWSLIDER" object:self userInfo:@{@"showSlider":@(YES)}];
    
}

#pragma mark - location sevice delegate -
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    NSString *str = [GeoCodeOfBaiduMap getGeohash:userLocation.location.coordinate.latitude andLon:userLocation.location.coordinate.longitude andLength:12];
    [UserLocation shareInstance].geohashStr = str;
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];    ///反geo检索信息类
    reverseGeocodeSearchOption.reverseGeoPoint = pt;    ///经纬度
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];

    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    } else
    {
        NSLog(@"反geo检索发送失败");
        self.leftBarAreaLabel.text = @"定位失败";
    }

    [_locService stopUserLocationService];
}
/**
 *返回反地理编码搜索结果
 */
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"定位结果：%u",error);
    
    NSString *street;
    
    if (error == 9) {
        self.leftBarAreaLabel.text = @"无法定位";
        street = @"哎呦，定位不到您的位置哦";
        
    } else {
    
        self.cityNameStr = result.addressDetail.city; // 拿到当前城市
        self.leftBarAreaLabel.text = self.cityNameStr;
        street = [NSString stringWithFormat:@"%@%@",result.addressDetail.district, result.addressDetail.streetName];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FRESHADDRESS" object:self userInfo:@{@"street":street}];
}

#pragma mark - scroll delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    self.segmentedIndex = 0;
//    CGFloat contentOffSetX = self.myCollectionView.contentOffset.x;
//    
////    NSLog(@"%d",isShowSlider);
////    
////    if (!isShowSlider) {
//    
//        if (contentOffSetX >= Screen_Width/2 && contentOffSetX < Screen_Width*1.5) {
//            self.segmentedIndex = 1;
//            
//        } else if (contentOffSetX >= Screen_Width*1.5 ) {
//            self.segmentedIndex = 2;
//            
//        } else {
//            self.segmentedIndex = 0;
//        }
//        
//        [self.naviSegmentedControl setSelectedSegmentIndex: self.segmentedIndex];
//    
////    }else {
////        
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWSLIDER" object:self userInfo:@{@"showSlider":@(NO)}];
////        isShowSlider = YES;
////    }
////    
////    if (contentOffSetX < 0) {
////        isShowSlider = !isShowSlider;
////        if (isShowSlider) {
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWSLIDER" object:self userInfo:@{@"showSlider":@(isShowSlider)}];
////            
////        }
////        return;
////    }
//    
////    [self changeWithFloat:self.myCollectionView.contentOffset.x];
//}

#pragma mark - collectionView delegate -
#pragma mark -- section 中的 item 数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
#pragma mark - collectionView 中的 section 数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - item 的 宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Screen_Width, Screen_Height-Screen_Height*15/284);
}

#pragma mark - UICollectionViewCell
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.item == 0) {
        // 首页
        [self addChildViewController:cell.homeOfHomeVC];
    } else if (indexPath.item == 1) {
        // 列表
        [self addChildViewController:cell.recommendOfHomeVC];
    } else if (indexPath.item == 2) {
        // 专家
        [self addChildViewController:cell.expertOfHomeVC];
    }
    return cell;
}

#pragma mark - textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self gotoSearchVC];
    return NO;
}
#pragma mark - 跳转搜索界面
- (void)gotoSearchVC {
    
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.hidesBottomBarWhenPushed = YES;    // 隐藏 tabbar
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (void)showVersionUpdate:(NSDictionary*)dic {
    
    NSString *string =[NSString stringWithFormat:@"检测到新版本:%@",dic[@"version"]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:string message:dic[@"releaseNotes"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"下次再提醒" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 推送到AppStore  “id” 字符不能缺少
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPID]]];
    }];
    
    [alertController addAction:ignoreAction];
    [alertController addAction:updateAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - lazy load
// the segmentedControl in navigatorBar
- (HMSegmentedControl *)naviSegmentedControl {

    if (!_naviSegmentedControl) {
        
        // init the HMSegmentedControl
        _naviSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"首页",@"资讯",@"列表",@"专家"]];
        
        // set frame
        _naviSegmentedControl.frame = CGRectMake(Screen_Width/2, 5, Screen_Width/2-13, 30);
        _naviSegmentedControl.backgroundColor = [UIColor clearColor];
        
        // set font's style on normal
        _naviSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:GRAY_80,NSFontAttributeName:[UIFont adjustFont:[UIFont systemFontOfSize:15.0]]};
        
        _naviSegmentedControl.shouldCutWidth = 10;
        
        // set font's style on selected
        _naviSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:GREEN_1ab8,NSFontAttributeName:[UIFont adjustFont:[UIFont systemFontOfSize:15.0]]};

        // set Color for the selection indicator stripe/box
        _naviSegmentedControl.selectionIndicatorColor = GREEN_1ab8;
        
        _naviSegmentedControl.selectionIndicatorHeight = 2;
        _naviSegmentedControl.selectionIndicatorStripLayer.cornerRadius = 1;
        _naviSegmentedControl.selectionIndicatorStripLayer.masksToBounds = YES;
        // set selectStyle for selectionStyle
        _naviSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        
        // set location for the indicatorLocation
        _naviSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        __weak typeof (self) weakSelf = self;
        
        [_naviSegmentedControl setIndexChangeBlock:^(NSInteger index) {
            
            weakSelf.segmentedIndex = (int)index;
            
//            if (index == 1) {
//               
//                
//                return ;
//            }
            switch (index) {
                case 0:
                    [weakSelf.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                    break;
                case 1:
                { // 跳转到咨询界面
                    NewsViewController *newsVC = [NewsViewController new];
                    [weakSelf.navigationController pushViewController:newsVC animated:YES];
                    weakSelf.naviSegmentedControl.selectedSegmentIndex = 0;
                    return;
                }
                    break;
                case 2:
                {
                    [weakSelf.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                    
                }
                    break;
                case 3:
                    [weakSelf.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                    break;
                default:
                    break;
            }
            
            
            
        }];
    }
    return _naviSegmentedControl;
}
- (UITextField *)searchTF {
    if (!_searchTF) {
        NSString *string = @"请输入街道/路段/园区";
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(Screen_Width/3, 0, Screen_Width*2/3-26, Screen_Height*15/284)];
        
        _searchTF.backgroundColor = GRAY_F0;
        _searchTF.text = string;
        _searchTF.textAlignment = NSTextAlignmentCenter;
        _searchTF.textColor = GRAY_cc;
//        _searchTF.enabled = NO;
        _searchTF.delegate = self;
        _searchTF.layer.cornerRadius = Screen_Height*15/284/2;
        _searchTF.layer.masksToBounds = YES;
        
        _searchTF.font = [UIFont adjustFont:[UIFont systemFontOfSize:12]];
        
        CGFloat width = [NSString widthForString:string fontSize:[UIFont adjustFontSize:12.0f] andHeight:Screen_Height/16];
       // 根据搜索控件的宽度计算出搜索图标需要偏移的位置
        CGFloat marginOfLeft = (Screen_Width*2/3-26)/2-width/2-Screen_Height*15/284/2;
        // 设置 左边的logo
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height*15/284/4, Screen_Height*15/284/2, Screen_Height*15/284/2)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginOfLeft, 0, Screen_Height*15/284/2, Screen_Height*15/284/2)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"search"];
        [leftView addSubview:imageView];
        _searchTF.leftView = leftView;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTF;
}


- (UICollectionView *)myCollectionView
{
    
    if (!_myCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;     // 设置滚动方向为 水平滚动
        
        layout.minimumLineSpacing = 0;
        
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.frame = CGRectMake(0, Screen_Height*15/284, Screen_Width, Screen_Height-Screen_Height*15/284);
        
        _myCollectionView.pagingEnabled = YES;      // 设置分页
        
         // 关闭了滚动的功能，因为此处与侧滑显示侧边栏手势冲突
        _myCollectionView.scrollEnabled = NO;
        
        [self.view addSubview:_myCollectionView];
        
        [_myCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
        
    }
    return _myCollectionView;
}
// 左上角的 定位 barView
- (UIView *)leftBarView {
    
    if (!_leftBarView) {
        
        _leftBarView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, Screen_Width/3, 44)]; // 初始化
        
        UITapGestureRecognizer *tapLeftBarView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpSelectCityAction:)];  // 初始化单击事件
        [_leftBarView addGestureRecognizer:tapLeftBarView]; // 添加单击事件
        
        self.leftBarAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, Screen_Width/4-8-10, 44)];
        self.leftBarAreaLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:15.0]];
        self.leftBarAreaLabel.text = @"正在定位";
        self.leftBarAreaLabel.textColor = BLACK_42;
        self.leftBarAreaLabel.textAlignment = NSTextAlignmentCenter;
        [_leftBarView addSubview:self.leftBarAreaLabel];
        
        // 向下的图标
        UIImageView *turnDownImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"turnDown"]];
        turnDownImageView.frame = CGRectMake(self.leftBarAreaLabel.frame.size.width+6, 17, 10, 10);
        [_leftBarView addSubview:turnDownImageView];
    
    }
    return _leftBarView;
}

- (UIButton *)naviSearchButton {
    
    if (!_naviSearchButton) {
        _naviSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _naviSearchButton.frame = CGRectMake(Screen_Width, 0, 50, 44);
        [_naviSearchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_naviSearchButton setTintColor:[UIColor whiteColor]];
        [_naviSearchButton addTarget:self action:@selector(gotoSearchVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviSearchButton;
}

- (UIView *)greenView {
    
    if (!_greenView) {
        self.greenView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, Screen_Width, 64)];
        self.greenView.backgroundColor = GREEN_19b8;
        self.greenView.hidden = NO;
        self.greenView.alpha = 0;
    }
    return _greenView;
}

- (UIButton *)slideButton {
    if (!_slideButton) {
        
        _slideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _slideButton.frame = CGRectMake(0, 0, 44, 44);
        [_slideButton setImage:[UIImage imageNamed:@"home_slider"] forState:0];
        [_slideButton addTarget:self action:@selector(showSlideVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slideButton;
}

- (void)didReceiveMemoryWarning
{
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
