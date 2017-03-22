//
//  NewsViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/9.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NewsViewController.h"
#import "HMSegmentedControl.h"
#import "SelectItemViewController.h"      // 选择频道
#import "Header.h"
#import "PGScView.h"
#import "SearchFile.h"

#import "NRemmandView.h"
#import "NMarketView.h"
#import "RankingListView.h"
#import "LittleVideoView.h"
#import "FMView.h"
#import "NearView.h"

@interface NewsViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    PGScView *_pgView;
    NSArray *labelArr;
    NSArray *allChannelArray;

}
@property (nonatomic, strong) HMSegmentedControl *mySegmentedControl;
@property (nonatomic, strong) NSMutableArray *mNaviTitleArray;
@property (nonatomic, strong) NSString *fileName;

//@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NRemmandView *nremmandView;
@property (nonatomic, strong) NMarketView *nmarketView;
@property (nonatomic, strong) RankingListView *rankListView;
@property (nonatomic, strong) LittleVideoView *littleVideoView;
@property (nonatomic, strong) FMView *FMView;
@property (nonatomic, strong) NearView *nearView;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self getAllChannelData];
//    [self.view addSubview: self.myScrollView];
    [self.view addSubview:self.myCollectionView];
    [self.navigationController.navigationBar addSubview:self.mySegmentedControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [self initNavi];
    [self getTitleData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mySegmentedControl.hidden = YES;
}
// 加载导航栏
- (void)initNavi {
    
    [self setVCName:@"" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@""];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];
    
    [self addRightItemWithString:@"+" andItemTintColor:BLACK_42];
}

- (void)getTitleData {
    self.fileName = @"MyChannel.txt";
    NSArray *myChannelArray = [SearchFile readFileArrayWithdocumentNamue:self.fileName];
    if (myChannelArray.count <= 0) {
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:@[@"推荐",@"行情",@"排行榜",@"小视频",@"附近",@"FM"]];
        if ([SearchFile writeSearchFileArray:mArray documentNamue:self.fileName]) {
            NSLog(@"写入我的频道成功");
            myChannelArray = [SearchFile readFileArrayWithdocumentNamue:self.fileName];
        } else {
            NSLog(@"写入我的频道失败");
        }
    }
    self.mNaviTitleArray = [NSMutableArray array];
    [self.mNaviTitleArray addObjectsFromArray:myChannelArray];
    // 重新设置 头部
    self.mySegmentedControl.sectionTitles = self.mNaviTitleArray;
    self.mySegmentedControl.hidden = NO;
    [self.myCollectionView reloadData];
    // 设置scrollView 的可滚动大小
//    self.myScrollView.contentSize = CGSizeMake(Screen_Width*self.mNaviTitleArray.count, Screen_Height);
    
}
// 加载频道的view，当第一次入资讯界面时，只加载推荐界面，当点击或滚到到其他界面时，将对应的界面添加到 scrollview 中
// 这里存在一个问题，当全部都加载的时候scrollView 则存在对应多个个数的View
//- (void)loadChannelView:(NSInteger)index {
//    
//    NSString *indexChannelStr = self.mNaviTitleArray[index]; // 拿到了点击到的index的title
//    NSString* viewStr;
//    
//    for (NSDictionary *contentDic in allChannelArray) {
//        
//        NSString *channelStr = contentDic[@"channel"];
//        
//        
//        if ([indexChannelStr isEqualToString:channelStr]) {
//            viewStr = contentDic[@"view"];
//        }
//    }
//    
//    if ([viewStr isEqualToString:@"NRemmandView"]) {    // 推荐
//        self.nremmandView.frame = CGRectMake(Screen_Width*index, 0, Screen_Width, Screen_Height-64);
//        
//    } else if ([viewStr isEqualToString:@"NMarketView"]) {  // 行情
//        self.nmarketView.frame = CGRectMake(Screen_Width*index, 0, Screen_Width, Screen_Height-64);
//    } else if ([viewStr isEqualToString:@"RankingListView"]) {
//        self.rankListView.frame = CGRectMake(Screen_Width*index, 0, Screen_Width, Screen_Height-64);
//    } else if ([viewStr isEqualToString:@"LittleVideoView"]) {
//        self.littleVideoView.frame = CGRectMake(Screen_Width*index, 0, Screen_Width, Screen_Height-64);
//    } else if ([viewStr isEqualToString:@"FMView"]) {
//        self.FMView.frame = CGRectMake(Screen_Width*index, 0, Screen_Width, Screen_Height-64);
//    } else if ([viewStr isEqualToString:@"NearView"]) {
//        self.nearView.frame = CGRectMake(Screen_Width*index, 0, Screen_Width, Screen_Height-64);
//    }
//    
//}

- (void)getAllChannelData {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NewsChannel" ofType:@"plist"];
    allChannelArray = [NSArray arrayWithContentsOfFile:filePath];
    
}
#pragma mark - 导航栏右边的按钮
- (void)rightItemButtonAction {
    SelectItemViewController *selectItemVC = [SelectItemViewController new];
    selectItemVC.myChannelArray = self.mNaviTitleArray;
    
    // 将返回按钮设置为空
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] init];
    [leftBtn setTitle:@""];
    self.navigationItem.backBarButtonItem = leftBtn;
    
    [self.navigationController pushViewController:selectItemVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollContentX = scrollView.contentOffset.x;
    
    int index = scrollContentX/Screen_Width;
    
    self.mySegmentedControl.selectedSegmentIndex = index;
//    [self loadChannelView:index];
}

- (UICollectionViewCell *)loadChannelViewForItemAtIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView {
    
    CGFloat index = indexPath.item;
    
    NSString *indexChannelStr = self.mNaviTitleArray[indexPath.item]; // 拿到了点击到的index的title
    
    
    NSString* viewStr;
    
    for (NSDictionary *contentDic in allChannelArray) {
        
        NSString *channelStr = contentDic[@"channel"];
        
        
        if ([indexChannelStr isEqualToString:channelStr]) {
            viewStr = contentDic[@"view"];
        }
    }
    
    if ([viewStr isEqualToString:@"NRemmandView"]) {    // 推荐
        NRemmandView *nRemmandCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nRemmandCell" forIndexPath:indexPath];
        return nRemmandCell;
        
        
//        self.nremmandView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64);
        
        
    } else if ([viewStr isEqualToString:@"NMarketView"]) {  // 行情
        NMarketView *nmarketCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nmarketCell" forIndexPath:indexPath];
        return nmarketCell;
       
//        self.nmarketView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64);
        
    } else if ([viewStr isEqualToString:@"RankingListView"]) {
        RankingListView *rankingCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rankingCell" forIndexPath:indexPath];
        return rankingCell;
       
//        self.rankListView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64);
        
    } else if ([viewStr isEqualToString:@"LittleVideoView"]) {
        LittleVideoView *littleVideoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"littleVideoCell" forIndexPath:indexPath];
        return littleVideoCell;
//        self.littleVideoView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64);
    } else if ([viewStr isEqualToString:@"FMView"]) {
        FMView *FMViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fmCell" forIndexPath:indexPath];
        return FMViewCell;
        
//        self.FMView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64);
    } else {
        NearView *nearCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nearCell" forIndexPath:indexPath];
        return nearCell;
       
//        self.nearView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64);
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mNaviTitleArray.count;
}

- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Height);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell = [self loadChannelViewForItemAtIndexPath:indexPath collectionView:collectionView];
    
    return cell;
}


#pragma mark - lazyload
- (HMSegmentedControl *)mySegmentedControl {
    if (!_mySegmentedControl) {
        _mySegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.mNaviTitleArray];
        _mySegmentedControl.frame = CGRectMake(50, 0, Screen_Width-90, 44);
        _mySegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _mySegmentedControl.selectionIndicatorHeight = 0;   // 相当于去掉了指示器
        
        _mySegmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:15.0]],NSForegroundColorAttributeName:BLACK_42};
        _mySegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:15.0]],NSForegroundColorAttributeName:GREEN_19b8};
        
        __weak typeof(self) weakSelf = self;
        
        [_mySegmentedControl setIndexChangeBlock:^(NSInteger index) {
           
//            [weakSelf.myCollectionView setContentOffset:CGPointMake(Screen_Width*index, 0) animated:YES];
            [weakSelf.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }];
        
    }
    return _mySegmentedControl;
}

//- (UIScrollView *)myScrollView {
//    if (!_myScrollView) {
//        _myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//        _myScrollView.pagingEnabled = YES;
//
//        _myScrollView.delegate = self;
//        // 先将推荐页面添加到 scrollView 中
//        self.nremmandView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64);
//    }
//    return _myScrollView;
//}

- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        [_myCollectionView registerClass:[FMView class] forCellWithReuseIdentifier:@"fmCell"];
        
        [_myCollectionView registerClass:[NRemmandView class] forCellWithReuseIdentifier:@"nRemmandCell"];
        
        [_myCollectionView registerClass:[RankingListView class] forCellWithReuseIdentifier:@"rankingCell"];
        
        [_myCollectionView registerClass:[NMarketView class] forCellWithReuseIdentifier:@"nmarketCell"];
        
        [_myCollectionView registerClass:[LittleVideoView class] forCellWithReuseIdentifier:@"littleVideoCell"];
        
        [_myCollectionView registerClass:[NearView class] forCellWithReuseIdentifier:@"nearCell"];
    }
    return _myCollectionView;
}

- (NMarketView *)nmarketView {
    if (!_nmarketView) {
        _nmarketView = [[NMarketView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
        _nmarketView.backgroundColor = [UIColor whiteColor];
//        [self.myScrollView addSubview:_nmarketView];
    }
    return _nmarketView;
}

- (NRemmandView *)nremmandView {
    if (!_nremmandView) {
        _nremmandView = [[NRemmandView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
//        [self.myScrollView addSubview:_nremmandView];
        _nremmandView.backgroundColor = [UIColor whiteColor];
    }
    return _nremmandView;
}

- (RankingListView *)rankListView {
    if (!_rankListView) {
        _rankListView = [[RankingListView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
        _rankListView.backgroundColor = [UIColor whiteColor];
//        [self.myScrollView addSubview:_rankListView];
    }
    return _rankListView;
}
- (LittleVideoView *)littleVideoView {
    if (!_littleVideoView) {
        _littleVideoView = [[LittleVideoView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
        _littleVideoView.backgroundColor = [UIColor whiteColor];
//        [self.myScrollView addSubview:_littleVideoView];
    }
    return _littleVideoView;
}

- (FMView *)FMView {
    if (!_FMView) {
        _FMView = [[FMView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
        _FMView.backgroundColor = [UIColor whiteColor];
//        [self.myScrollView addSubview:_FMView];
    }
    return _FMView;
}
- (NearView *)nearView {
    if (!_nearView) {
        _nearView = [[NearView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
        _nearView.backgroundColor = [UIColor whiteColor];
//        [self.myScrollView addSubview:_nearView];
    }
    return _nearView;
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
