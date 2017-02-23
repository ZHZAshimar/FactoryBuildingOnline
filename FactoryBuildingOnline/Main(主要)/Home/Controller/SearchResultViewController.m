//
//  SearchResultViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/12.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SearchResultViewController.h"
#import "FivePathCollectionViewCell.h"
#import "SearchRequest.h"
#import "BrokerDetailViewController.h"
#import "FactoryDetailViewController.h"

@interface SearchResultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    SearchRequest *searchRequest;
}

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *mDataSource;
@end

@implementation SearchResultViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNavi];
    
    self.mDataSource = [NSMutableArray array];
    
    [self.view addSubview:self.myCollectionView];
    
    [self getSearchData];
}

- (void)setNavi {
    
    if ([self.dic[@"type"] intValue] == 1) {
        
        [self setVCName:@"业主发布相关房源" andShowSearchBar:NO andTintColor:GREEN_1ab8 andBackBtnStr:@"返回"];
    } else {
        [self setVCName:@"专家发布相关房源" andShowSearchBar:NO andTintColor:GREEN_1ab8 andBackBtnStr:@"返回"];
        
    }
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
}

- (void)getSearchData {
    
    searchRequest = [SearchRequest new];
    
    [searchRequest getSearchContentsWithContentID:self.dic];
    
    __weak typeof (self) weakSelf = self;
    
    searchRequest.dataBlock = ^ (NSMutableArray *dataArray) {
      
        if ([weakSelf.dic[@"type"] intValue] == 1) {    // 业主
            for (WantedMessageModel *model in dataArray) {
                [weakSelf.mDataSource addObject:model];
            }
        } else {
            for (BrokerFactoryInfoModel *model in dataArray) {
                [weakSelf.mDataSource addObject:model];
            }
        }
        [weakSelf.myCollectionView.mj_footer endRefreshing];
        [weakSelf.myCollectionView reloadData];
    };
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mDataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dic[@"type"] intValue] == 1) {
        return CGSizeMake(Screen_Width, Screen_Width/2);    // 业主
    } else {
        return CGSizeMake(Screen_Width, Screen_Width/2-28);    // 专家
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"cell" forIndexPath:indexPath];
    
    if ([self.dic[@"type"] intValue] == 1) {            // 业主
        
        cell.model = self.mDataSource[indexPath.item];
        
    } else {                                            // 专家
        
        cell.brokerModel = self.mDataSource[indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dic[@"type"] intValue] == 1) {            // 业主
        
        FactoryDetailViewController *factoryDetailVC = [FactoryDetailViewController new];
        
        factoryDetailVC.model = self.mDataSource[indexPath.item];
        
        [self.navigationController pushViewController:factoryDetailVC animated:YES];
        
    } else {                                            // 专家
        BrokerFactoryInfoModel *model = self.mDataSource[indexPath.item];
        
        [searchRequest getBrokerInfoWithOWNID:model.owner_id];
        
        __weak typeof (self) weakSelf = self;
        
        searchRequest.infoBlock = ^(NSDictionary *dic) {
        
            
            BrokerDetailViewController *factoryDetailVC = [BrokerDetailViewController new];
            
            factoryDetailVC.model = model;
            
            factoryDetailVC.brokerInfoDic = dic;
            
            [weakSelf.navigationController pushViewController:factoryDetailVC animated:YES];
            
        };
        
    }
   
}

#pragma mark - lazy load 
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;

        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[FivePathCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        _myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([self.dic[@"type"] intValue] == 1) {            // 业主
                
                WantedMessageModel *model = [self.mDataSource lastObject];
                if (model.nextURL.length > 0) {
                    [searchRequest getSearchWithURL:model.nextURL andDataType:@"1"];
                } else {
                    [_myCollectionView.mj_footer endRefreshing];
                }
                
            } else {                                            // 专家
                
                BrokerFactoryInfoModel *brokerModel = [self.mDataSource lastObject];
                if (brokerModel.next.length > 0) {
                    [searchRequest getSearchWithURL:brokerModel.next andDataType:@"2"];
                } else {
                    [_myCollectionView.mj_footer endRefreshing];
                }
                
            }
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
