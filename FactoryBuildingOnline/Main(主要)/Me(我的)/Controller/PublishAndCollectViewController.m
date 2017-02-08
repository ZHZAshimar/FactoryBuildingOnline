//
//  PublishAndCollectViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/2.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "PublishAndCollectViewController.h"
#import "FivePathCollectionViewCell.h"
#import "RequestMessage.h"
#import "FactoryDetailViewController.h"
#import "BrokerDetailViewController.h"
#import "EmptyView.h"
#import <MJRefresh.h>
#import "WantedMessageModel.h"
#import "HomeRequest.h"
@interface PublishAndCollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RequestMessageDelegate>
{
    NSString *urlStr;
    EmptyView *emptyView;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;       // 集合视图
@property (nonatomic, strong) NSMutableArray *mDataSource;              // 数据
@property (nonatomic, strong) RequestMessage *request;                  // 数据请求类
@property (nonatomic, strong) UISegmentedControl *mySegmentedControl;    // 分段控件

@end

@implementation PublishAndCollectViewController

- (void)dealloc {
    
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
    if (self.datatype == MYPUBLISH_TYPE){} else {
        [self.mySegmentedControl removeFromSuperview];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.rdv_tabBarController.tabBarHidden = NO;
    
    if (self.datatype == MYPUBLISH_TYPE){
        
    }else {
        self.mySegmentedControl.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rdv_tabBarController.tabBarHidden = YES;
    
    if (self.datatype == MYPUBLISH_TYPE){
        
    }else {
        self.mySegmentedControl.hidden = NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mDataSource = [NSMutableArray array];
    
    if (self.datatype == MYPUBLISH_TYPE) {   // 我的发布
        
        [self setVCName:@"近期发布" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
        urlStr = URL_GET_PUBLICATIONS;
    } else {
        [self setVCName:@"" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
        [self.navigationController.navigationBar addSubview:self.mySegmentedControl];
        urlStr = URL_GET_COLLECTIONS;
    }
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.myCollectionView];

    self.request = [RequestMessage new];
    
    self.request.delegate = self;
    
    [self getData];

    emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds];
    emptyView.image = [UIImage imageNamed:@"error_1"];
    emptyView.hidden = YES;
    [self.view addSubview:emptyView];
}
#pragma mark - 获取数据
- (void)getData {
    
    [HTTPREQUEST_SINGLE requestWithServiceOfCollection:urlStr andParameters:nil requestType:0 isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
//        NSLog(@"%@",response);
        
        NSArray *array;
        NSMutableArray *mArr;

        if (self.datatype == MYCOLLECT_BROKER_TYPE) {
            array = response[@"proMediumMessage"];
            
            if (array.count <= 0) {
                emptyView.hidden = NO;
                emptyView.emptyStr = @"暂无专家类型房源的收藏";
                if (self.mDataSource.count > 0) {
                    [self.mDataSource removeAllObjects];
                    [self.myCollectionView reloadData];
                }
                return ;
            }
            mArr = [HomeRequest dealWithBrokerDatabase:response isWriteDB:NO];
        } else {
            
            array = response[@"wantedMessage"];
            if (array.count <= 0) {
                emptyView.hidden = NO;
                if (self.datatype == MYPUBLISH_TYPE) {
                    emptyView.emptyStr = @"暂无发布";
                } else {
                    emptyView.emptyStr = @"暂无收藏";
                    
                    if (self.mDataSource.count > 0) {
                        [self.mDataSource removeAllObjects];
                        [self.myCollectionView reloadData];
                    }
                }
                
                return ;
            }
            mArr = [RequestMessage dealWithDatabase:response andArray:response[@"wantedMessage"] andWriteSQL:NO];
        }
        self.mDataSource = mArr;
        
        emptyView.hidden = YES;
        
        [self.myCollectionView reloadData];
        
    } failure:^(RequestManager *manager, NSError *error) {
        
        emptyView.emptyStr = @"💔网络异常，请稍后请求";
        emptyView.hidden = NO;
    }];
}
#pragma mark - 显示空白显示界面
- (void)showEmptyView{
    
}

#pragma mark - segmented tap action 
- (void)segmentedValueChangeAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) { // 业主
        urlStr = URL_GET_COLLECTIONS;
        self.datatype = MYCOLLECT_NORMAL_TYPE;
    } else {    // 专家
        
        urlStr = URL_GET_BROKERS_COLLECTIONS;
        self.datatype = MYCOLLECT_BROKER_TYPE;
    }
    [self getData];
}

#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mDataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Width*17/32);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FivePathCollectionViewCell" forIndexPath:indexPath];
    if (self.datatype == MYCOLLECT_BROKER_TYPE) {
        cell.brokerModel = self.mDataSource[indexPath.item];
    } else {
        cell.model = self.mDataSource[indexPath.item];
    }
    return cell;
}
#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.datatype == MYCOLLECT_BROKER_TYPE) {
        BrokerDetailViewController *detailVC = [BrokerDetailViewController new];
        detailVC.model = self.mDataSource[indexPath.item];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else {
        
        FactoryDetailViewController *detailVC = [FactoryDetailViewController new];
        detailVC.model = self.mDataSource[indexPath.item];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - requestmessage delegate -
- (void)refreshView:(NSMutableArray *)mArray {
    
    if (mArray.count <= 0) {
        return;
    }
    for (WantedMessageModel *model in mArray) {
        [self.mDataSource addObject:model];
    }
    [self.myCollectionView reloadData];
}

#pragma mark - lazy load 
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-80) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[FivePathCollectionViewCell class] forCellWithReuseIdentifier:@"FivePathCollectionViewCell"];
        
        __weak typeof (self) weakSelf = self;
        
        _myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            // 判断数据类型
            if (weakSelf.datatype == MYCOLLECT_BROKER_TYPE) {
                
                BrokerFactoryInfoModel *model = [weakSelf.mDataSource lastObject];
                
                if (model.next.length > 0) {
//                    [HomeRequest getNextPromediumsWithURL:]
                }
                
            } else {
                
                WantedMessageModel*model = [weakSelf.mDataSource lastObject];
                if (model.nextURL.length > 0) {
                    
                    [weakSelf.request requestNestURL:model.nextURL];
                }
            }
            [weakSelf.myCollectionView.mj_footer endRefreshing];
        }];
        
    }
    return _myCollectionView;
}

- (UISegmentedControl *)mySegmentedControl {
    
    if (!_myCollectionView) {
        _mySegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"业主",@"专家"]];
        _mySegmentedControl.frame = CGRectMake(Screen_Width/2-60, 10, 120, 24);
        _mySegmentedControl.tintColor = GREEN_1ab8;
        _mySegmentedControl.selectedSegmentIndex = 0;
        [_mySegmentedControl addTarget:self action:@selector(segmentedValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _mySegmentedControl;
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
