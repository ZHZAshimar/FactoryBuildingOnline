//
//  ScanHistoryViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/7.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ScanHistoryViewController.h"
#import "FivePathCollectionViewCell.h"
#import "RequestMessage.h"
#import "FactoryDetailViewController.h"

@interface ScanHistoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RequestMessageDelegate>
{
    RequestMessage *request;
    EmptyView *emptyView;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *mArrayData;

@end

@implementation ScanHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setVCName:@"浏览历史" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];
    
    self.mArrayData = [NSMutableArray array];
    
    [self.view addSubview:self.myCollectionView];
    
    [self getHistoryData];
}
#pragma mark - 获取历史记录的数据
- (void)getHistoryData {
    
    request = [RequestMessage new];
    
    [request getHistoryData];
    
    request.delegate = self;
    
    
}

#pragma mark - collection dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mArrayData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Width*166/320);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FivePathCollectionViewCell" forIndexPath:indexPath];
    
    cell.model = self.mArrayData[indexPath.item];
    
    return cell;
}
#pragma mark - collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FactoryDetailViewController *factoryDetailVC = [FactoryDetailViewController new];
    
    factoryDetailVC.model = self.mArrayData[indexPath.item];
    
    [self.navigationController pushViewController:factoryDetailVC animated:YES];
}

#pragma mark - RequestMessageDelegate
- (void)refreshView:(NSMutableArray *)mArray {
    
    if (mArray.count <= 0 && self.mArrayData.count <= 0) {
        // 当两个数组都为空时，显示暂无浏览历史
        emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds];
        emptyView.hidden = NO;
        emptyView.image = [UIImage imageNamed:@"erro_1"];
        emptyView.emptyStr = @"暂无浏览历史";
        [self.view addSubview:emptyView];
        return;
    }
    
    if (mArray.count > 0) {
        emptyView.hidden = YES;
        for (WantedMessageModel *model in mArray) {
            
            [self.mArrayData addObject:model];
            [self.myCollectionView reloadData];
        }
        
    }
    
    [_myCollectionView.mj_footer endRefreshing];
}

- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[FivePathCollectionViewCell class] forCellWithReuseIdentifier:@"FivePathCollectionViewCell"];
        
        _myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            WantedMessageModel *model = [self.mArrayData lastObject];
            
            if (model.nextURL.length < 1) {
                [_myCollectionView.mj_footer endRefreshing];
                
                return ;
            }
            
            [request requestNestURL:model.nextURL];
        }];
    }
    return _myCollectionView;
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
