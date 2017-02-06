//
//  RecommendViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//
#import "RecommendViewController.h"
#import "HMSegmentedControl.h"
#import "FivePathCollectionViewCell.h"
#import "SelectBgView.h"
#import "FactoryDetailViewController.h"
#import "SearchViewController.h"
#import "MapViewController.h"
#import "WantedMessageModel.h"
#import "RequestMessage.h"
#import "EmptyView.h"

@interface RecommendViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UISearchBarDelegate,RequestMessageDelegate>
{
    RequestMessage *requestMessage;
    int freshIndex;
    BOOL isFirstArea;
    BOOL isFirstPrice;
    NSMutableDictionary *requestMaxDic; // 请求的最大值
    NSMutableDictionary *requestMinDic; // 请求的
    EmptyView *emptyView;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *mDataSource;
@property (nonatomic, strong) NSArray *segmentedTitleArray; // segmented 的 title Array
@property (nonatomic, strong) NSArray *leftTableViewArray;  // 区域左边的数组
@property (nonatomic, strong) NSArray *rightTableViewAllArray;  // 区域右边的总数组
@property (nonatomic, assign) NSInteger leftSelectIndex;    // 区域左边 tableView 选中的 index
@property (nonatomic, assign) NSInteger rightSelectIndex;   // 区域右边 tableView 选中你的 index
@property (nonatomic, assign) NSInteger areaSelectIndex;    // 面积选中的 index
@property (nonatomic, assign) NSInteger priceSelectIndex;   // 价格选中的 index
@property (nonatomic, strong) NSString *segmentedZoneStr; // 区域
@property (nonatomic, strong) NSString *segmentedPriceStr;    // 价格
@property (nonatomic, strong) NSString *segmentedAreaStr;     // 面积
@property (nonatomic, strong) NSString *segmentedClassify;    // 分类
@property (nonatomic, strong) SelectBgView *selectBgView;
@property (nonatomic, strong) NSMutableDictionary *requestDic;    // 数据请求的字典
@property (nonatomic, strong) NSMutableArray *requestTypeArr; // 赛选类型的数组
@property (nonatomic, strong) NSDictionary *cityDic;
@end

@implementation RecommendViewController

- (void)dealloc {
//    
//    self.collectionView.delegate = nil;
//    self.collectionView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SELECTSURE" object:nil];   // 移除 监听
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];  // 移除键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self loadNaviControl]; // 设置导航栏
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createView];
    [self segmentedControl:-1];
    
    [self selectBgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectingAction:) name:@"SELECTSURE" object:nil];

    self.leftSelectIndex = 0;
    self.rightSelectIndex = 0;
    // 键盘 显示监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];

}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    NSLog(@"%f--%f",scrollView.contentOffset.y,Screen_Height);
//    if (scrollView.contentOffset.y >= Screen_Height) {
//        // 重新设置搜索框的位置
//        self.searchBarOfNavi.frame = CGRectMake(19, 0, Screen_Width-100, 44);
//        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
//    } else {
//        // 重新设置搜索框的位置
//        self.searchBarOfNavi.frame = CGRectMake(19, 0, Screen_Width-38, 44);
//        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
//    }
//    
//}

#pragma mark - 加载导航栏
- (void)loadNaviControl {
    
//    [self setVCName:@"" andShowSearchBar:YES andTintColor:nil andBackBtnStr:nil];
    
//    [self addRightItemCustomWithLogo:nil andItemName:@"返回顶部"];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES; // 隐藏右边的按钮
    // 重新设置搜索框的位置
//    self.searchBarOfNavi.frame = CGRectMake(19, 0, Screen_Width-38, 44);
    
    // 右边的图片+文字按钮
//    [self addRightItemCustomWithLogo:[UIImage imageNamed:@"rec_map"] andItemName:@"地图"];
    
}
#pragma mark - 加载collectView
- (void)createView {
    
    self.segmentedZoneStr = @"区域";
    self.segmentedPriceStr = @"价格";
    self.segmentedAreaStr = @"面积";
//    self.segmentedClassify = @"分类";
    self.requestDic = [NSMutableDictionary dictionary];
    self.requestTypeArr = [NSMutableArray array];
    requestMaxDic = [NSMutableDictionary dictionary];
    requestMinDic = [NSMutableDictionary dictionary];
    
    _segmentedTitleArray = @[self.segmentedZoneStr,self.segmentedPriceStr,self.segmentedAreaStr];
    
    self.mDataSource = [NSMutableArray array];
    
    emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];  // 当数据为空的时显示的
    emptyView.hidden = YES;
    [self.view addSubview:emptyView];
    
    requestMessage = [RequestMessage new];  // 数据请求 初始化
    requestMessage.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[FivePathCollectionViewCell class] forCellWithReuseIdentifier:@"FivePathCollectionViewCell"];
    
    freshIndex = 0;
    if (self.mDataSource.count > 0) {
        
        [requestMessage firstGetDataState:YES];     // 首次进入该界面，传入view是否有值
    } else {
        
        [requestMessage firstGetDataState:NO];      // 首次进入该界面，传入view是否有值
    }
    __weak RecommendViewController *weakSelf = self;
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    self.request_type = REQUEST_NORMAL;     // 初始化
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        freshIndex = 1;
        
        [weakSelf requestData];
        
    }];
    // 上拉加载更多
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        freshIndex = 2;
        
        [weakSelf requestData];
       
    }];
    
}
#pragma mark - 加载数据 上下拉
- (void)requestData{
    
    if (freshIndex == 1) {  // 下拉
        
        if (self.request_type == REQUEST_NORMAL) {  // 筛选请求没有下拉
            
            [requestMessage requestNetWithPage:1];
        }
        [self.collectionView.mj_header endRefreshing];
        
    } else if (freshIndex == 2){                // 上拉
        
        if (self.request_type == REQUEST_FILTER) {
            
            WantedMessageModel *model = [self.mDataSource lastObject];
            
            if (model.nextURL != nil) {
                [requestMessage requestNestURL:model.nextURL];
            }
        } else {
            [requestMessage requestSQLTogetModeData:(int)self.mDataSource.count];
        }
        [self.collectionView.mj_footer endRefreshing];
    }
}
// 筛选的请求
- (void)requestDataWithDic{
    [requestMessage requestNetWithDic:self.requestDic isShowActivity:YES];
    [self.mDataSource removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - 数据筛选请求
- (void)selectingAction:(NSNotification *)sender {
    NSLog(@"%@",sender.userInfo);
    int type = [sender.userInfo[@"segmentType"] intValue]+2;
    // 将选择的 view 从视图中移除
    [self.selectBgView removeFromSuperview];
    
    if (sender.userInfo[@"isCellTag"] == 0){
        
        if ([sender.userInfo[@"segmentType"] intValue] == 0) {  // 价格
            
            self.segmentedPriceStr = [NSString stringWithFormat:@"%@-%@",sender.userInfo[@"low"],sender.userInfo[@"hight"]];
            
            self.priceSelectIndex = 0;
            self.leftSelectIndex = 0;
            self.rightSelectIndex = 0;
            [self segmentedControl:1];
        } else {    // 面积
            self.segmentedAreaStr = [NSString stringWithFormat:@"%@-%@",sender.userInfo[@"low"],sender.userInfo[@"hight"]];
            self.areaSelectIndex = 0;
            self.leftSelectIndex = 0;
            self.rightSelectIndex = 0;
            [self segmentedControl:2];
        }
        
        self.segmentedTitleArray = @[self.segmentedZoneStr,self.segmentedPriceStr,self.segmentedAreaStr];
    }
    if (![self.requestTypeArr containsObject:@(type)]) {
        [self.requestTypeArr addObject:@(type)];
    }
    
    [requestMaxDic setValue:@([sender.userInfo[@"hight"] intValue]) forKey:[NSString stringWithFormat:@"%d",type]];   // 最大值的字典
    [requestMinDic setValue:@([sender.userInfo[@"low"] intValue]) forKey:[NSString stringWithFormat:@"%d",type]]; // 最小值的字典
//    获取到筛选输入框输入的 范围，进行数据请求。
    [self.requestDic setValue:[NSString arrayToJson:self.requestTypeArr] forKey:@"filtertype"];
    
    [self.requestDic setValue:[NSString dictionaryToJson:requestMaxDic] forKey:@"maxranges"];
    [self.requestDic setValue:[NSString dictionaryToJson:requestMinDic] forKey:@"minranges"];
    
    [self requestDataWithDic];
}

#pragma mark - 跳转地图按钮 -
- (void)rightItemButtonAction {
//    MapViewController *mapVC = [[MapViewController alloc] init];
//    [self.navigationController pushViewController:mapVC animated:YES];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];   // 滚动到顶部
//    self.collectionView.scrollsToTop = YES;
}

#pragma mark - 键盘监听响应 通知的方法- 
#pragma mark - 当键盘将要出现的时候，计算键盘时候挡道 textFeild，是，则将self.View 的frame 上移
- (void)keyBoardShow: (NSNotification *)sender {
    
    NSValue *rectValue = sender.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [rectValue CGRectValue].size.height;
    CGFloat result = Screen_Height - keyboardHeight;
    NSLog(@"---- %f",self.selectBgView.frame.origin.y);
    CGFloat textFieldY = self.selectBgView.frame.origin.y+self.selectBgView.priceView.frame.size.height+ Screen_Height*15/284+64;
    if (result < textFieldY+40) {
        self.view.frame = CGRectMake(0, result - textFieldY, Screen_Width, Screen_Height);
    }
}
#pragma mark - 当键盘将要隐藏的时候，self.view 的 frame 恢复原来
- (void)keyBoardHidden:(NSNotification *)sender {
    self.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height+64);
}

#pragma mark - 点击屏幕移除 键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.selectBgView.priceView.lowPriceTF resignFirstResponder];
    [self.selectBgView.priceView.hightPriceTF resignFirstResponder];
}

#pragma mark - requestMessageDelegate
- (void)refreshView:(NSMutableArray *)mArray {
    
    if (mArray.count <= 0) {

        if (self.request_type == REQUEST_FILTER) {
            emptyView.image = [UIImage imageNamed:@"error_1"];
            emptyView.emptyStr = @"暂无相关内容";
            emptyView.hidden = NO;
        }else {
            
            if (self.mDataSource.count <= 0) {
                
                emptyView.image = [UIImage imageNamed:@"error_1"];
                emptyView.emptyStr = @"暂内容";
                emptyView.hidden = NO;
            }
        }
        
        return ;
    }
     emptyView.hidden = YES;
    for (WantedMessageModel*model in mArray) {
        
        if (freshIndex == 1) {
            
            [self.mDataSource insertObject:model atIndex:0];
            
        } else {
        
            [self.mDataSource addObject:model];
        }
    }
    NSLog(@"%@",self.mDataSource);
    [self.collectionView reloadData];
}

#pragma mark - searchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    SearchViewController *serchVC = [SearchViewController new];
    [self.navigationController pushViewController:serchVC animated:YES];
    
    return NO;
}

#pragma mark - collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.mDataSource.count;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, (Screen_Width)*17/32);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FivePathCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.mDataSource[indexPath.item];
    
    return cell;
}
#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"indexPath %ld -%@",indexPath.item,self.mDataSource[indexPath.item]);
    FactoryDetailViewController *factoryDetailVC = [FactoryDetailViewController new];
    factoryDetailVC.model = self.mDataSource[indexPath.item];
   
    [self.navigationController pushViewController:factoryDetailVC animated:YES];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)createSelectBGView:(NSInteger)index {
    // 获取东莞市各个镇
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CityInfo" ofType:@"plist"];
    self.cityDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    NSLog(@"城市列表：%@",cityDic);
    self.leftTableViewArray = @[@"区域"];
    
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *townDic in self.cityDic[@"child"]) {
        [tmpArr addObject:townDic[@"name"]];
    }
    self.rightTableViewAllArray = @[tmpArr];
    
    [_selectBgView removeFromSuperview];        // 移除背景view
    
    self.selectBgView = [[SelectBgView alloc] initWithFrame:CGRectMake(0, 40, Screen_Width, Screen_Height-80) withIndex:index];    // 初始化背景view
    
    [self.view addSubview:self.selectBgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBgViewTapAction)]; // 添加 单击事件
    [self.selectBgView.alphaView addGestureRecognizer:tap];
    
    switch (index) {    // 价格和区域 选中的 index
        case 1:
        {
            self.selectBgView.priceView.selectIndex = self.priceSelectIndex;
        }
            break;
        case 2:
        {
            NSLog(@"%d",self.areaSelectIndex);
            self.selectBgView.priceView.selectIndex = self.areaSelectIndex;
        }
            break;
        default:
        {
            // 区域左右两边的tableView 的 数据 和选中的 index
            self.selectBgView.leftTableView.leftListArray = self.leftTableViewArray;
            self.selectBgView.rightTableView.rightListArray = self.rightTableViewAllArray[self.leftSelectIndex];
            
            self.selectBgView.leftTableView.selectIndex = self.leftSelectIndex;
            self.selectBgView.rightTableView.selectIndex = self.rightSelectIndex;
        }
            break;
    }
    
    //------------------- block 回调 -----------------------
    __weak RecommendViewController *weakSelf = self;
    
    [self.selectBgView.leftTableView setLeftTableViewSelectIndex:^(NSIndexPath *indexPath) {
        
        weakSelf.selectBgView.rightTableView.rightListArray = weakSelf.rightTableViewAllArray[indexPath.row];
        weakSelf.selectBgView.rightTableView.selectIndex = 0;
        weakSelf.leftSelectIndex = indexPath.row;
    }];
    
    __block NSString *selectStr;
    // 区域
    [self.selectBgView.rightTableView setRightTableViewSelectIndex:^(NSIndexPath *indexPath) {
        
        weakSelf.request_type = REQUEST_FILTER; // 将请求类型改为筛选类型
        
//        if (indexPath.row == 0) {
//            
//            selectStr = [NSString stringWithFormat:@"%@",weakSelf.leftTableViewArray[weakSelf.leftSelectIndex]];
//            
//            // 判断文字长度，超过显示 ...
//            if (selectStr.length > 4) {
//                selectStr = [selectStr substringWithRange:NSMakeRange(0, 4)];
//                selectStr = [NSString stringWithFormat:@"%@...",selectStr];
//            }
//            
//            weakSelf.segmentedZoneStr = selectStr;
//            weakSelf.segmentedTitleArray = @[weakSelf.segmentedZoneStr,weakSelf.segmentedPriceStr,weakSelf.segmentedAreaStr];
////            weakSelf.rightSelectIndex = 0;
//        } else {
            selectStr = [NSString stringWithFormat:@"%@",weakSelf.rightTableViewAllArray[weakSelf.leftSelectIndex][indexPath.row]];
            
            // 判断文字长度，超过显示 ...
            if (selectStr.length > 4) {
                selectStr = [selectStr substringWithRange:NSMakeRange(0, 4)];
                selectStr = [NSString stringWithFormat:@"%@...",selectStr];
            }
            
            weakSelf.segmentedZoneStr = selectStr;
            if (selectStr.length <= 2) {
                weakSelf.segmentedZoneStr = [NSString stringWithFormat:@"  %@  ",selectStr];
            }
            weakSelf.rightSelectIndex = indexPath.row;
            weakSelf.segmentedTitleArray = @[weakSelf.segmentedZoneStr,weakSelf.segmentedPriceStr,weakSelf.segmentedAreaStr];
//        }
        [weakSelf segmentedControl:index];
        NSLog(@"%@",weakSelf.segmentedZoneStr);
        [weakSelf.selectBgView.alphaView removeFromSuperview];
        [weakSelf.selectBgView removeFromSuperview];
        
        // 另外两个 selectindex 赋值为0;
        weakSelf.areaSelectIndex = 0;
        weakSelf.priceSelectIndex = 0;
        
        int townID = [weakSelf.cityDic[@"child"][indexPath.row][@"id"]  intValue];
        if (![weakSelf.requestTypeArr containsObject:@(1)]) {   // 判断数组中是否包含此 元素
            
            [weakSelf.requestTypeArr addObject:@(1)];
        }
        [weakSelf.requestDic setValue:[NSString arrayToJson:weakSelf.requestTypeArr] forKey:@"filtertype"];
        [weakSelf.requestDic setValue:@(townID) forKey:@"area_id"];
        
        [weakSelf requestDataWithDic];
    }];
    
    // 价格 and 面积 block
    self.selectBgView.priceView.priceBlock = ^(NSString *price,NSInteger index,NSIndexPath *indexPath){
        
        weakSelf.request_type = REQUEST_FILTER; // 将请求类型改为筛选类型
        
        [weakSelf.selectBgView.alphaView removeFromSuperview];
        [weakSelf.selectBgView removeFromSuperview];
        
        if (price.length>5) {
            price = [price substringWithRange:NSMakeRange(0, 5)];
            price = [NSString stringWithFormat:@"%@...",price];
        }
        
        if (index > 1) {    // 面积
            weakSelf.segmentedAreaStr = price;
            weakSelf.segmentedTitleArray = @[weakSelf.segmentedZoneStr,weakSelf.segmentedPriceStr,weakSelf.segmentedAreaStr];

            weakSelf.areaSelectIndex = indexPath.row;
            // 另外两个 selectIndex 为o
            weakSelf.priceSelectIndex = weakSelf.priceSelectIndex;
            weakSelf.leftSelectIndex = weakSelf.leftSelectIndex;
            weakSelf.rightSelectIndex = weakSelf.rightSelectIndex;
            
        } else {            // 价格
            weakSelf.segmentedPriceStr = price;
            weakSelf.segmentedTitleArray = @[weakSelf.segmentedZoneStr,weakSelf.segmentedPriceStr,weakSelf.segmentedAreaStr];
            weakSelf.priceSelectIndex = indexPath.row;
            // 另外两个 selectIndex 为o
            weakSelf.areaSelectIndex = weakSelf.areaSelectIndex;
            weakSelf.leftSelectIndex = weakSelf.leftSelectIndex;
            weakSelf.rightSelectIndex = weakSelf.rightSelectIndex;
        }
        
        [weakSelf segmentedControl:index];
    
    };
}

// 将选择背景图层从视图中移除
- (void)selectBgViewTapAction{
    [self.selectBgView.alphaView removeFromSuperview];
    [self.selectBgView removeFromSuperview];
    self.segmentedControl.selectedSegmentIndex = -1;
}

#pragma mark - lazyload -

- (void)segmentedControl:(NSInteger)index{
    
    [_segmentedControl removeFromSuperview];
    
        // 初始化 segmentedControl
//    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.segmentedTitleArray];
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:
                         @[[UIImage imageNamed:@"turnDown"],[UIImage imageNamed:@"turnDown"],[UIImage imageNamed:@"turnDown"]]
                        sectionSelectedImages:@[[UIImage imageNamed:@"turnUp"],[UIImage imageNamed:@"turnUp"],[UIImage imageNamed:@"turnUp"]] titlesForSections:self.segmentedTitleArray showTextAndImage:YES];
    
    [self.view addSubview:_segmentedControl];
    // 设置分段控件的背景颜色
    _segmentedControl.backgroundColor = [UIColor whiteColor];

    _segmentedControl.selectionIndicatorHeight = 5;         // 设置指示器的高度 为了来控制中间分割线的高度
    _segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    // 两个按钮之间的分割线
    _segmentedControl.verticalDividerWidth = 1;
    _segmentedControl.verticalDividerColor = GRAY_eb;
    _segmentedControl.verticalDividerEnabled = YES;
    

    //设置分段控件的文字大小及颜色
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]]};
    // 设置分段控件选中时 的文字大小及颜色
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:GREEN_1ab8,NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]]};
    _segmentedControl.selectedSegmentIndex = index;
    __weak typeof(self) weakSelf = self;
    
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"%ld",index);
        
        [weakSelf createSelectBGView:index];
        
    }];

    [_segmentedControl setIndexSelectSameBlock:^(NSInteger index) {
        NSLog(@"点击了相同的 index :%ld",index);
        [weakSelf createSelectBGView:index];
    }];
    
    _segmentedControl.frame = CGRectMake(0, 10, Screen_Width, 35);
//    _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_segmentedControl]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_segmentedControl)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_segmentedControl(35)]-[_collectionView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_segmentedControl,_collectionView)]];
    
    // 分割线
    UIView *cuttingLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, Screen_Width, 0.5)];
    cuttingLineView.backgroundColor = GRAY_db;
    [_segmentedControl addSubview:cuttingLineView];
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
