//
//  MyPublishViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/27.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "MyPublishViewController.h"

#import "FivePathCollectionViewCell.h"          // 业主
#import "BrokerIntroCollectionViewCell.h"       // 专家
#import "RequestMessage.h"
#import "FactoryDetailViewController.h"
#import "BrokerDetailViewController.h"
#import "EmptyView.h"
#import <MJRefresh.h>
#import "WantedMessageModel.h"
#import "HomeRequest.h"

#import "MyPublishEditFootCollectionReusableView.h"
@interface MyPublishViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RequestMessageDelegate>
{
    NSString *urlStr;
    EmptyView *emptyView;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;       // 集合视图
@property (nonatomic, strong) NSMutableArray *mDataSource;              // 数据
@property (nonatomic, strong) RequestMessage *request;                  // 数据请求类
@property (nonatomic, strong) UISegmentedControl *mySegmentedControl;    // 分段控件

@end

@implementation MyPublishViewController

- (void)dealloc {
    
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.rdv_tabBarController.tabBarHidden = NO;
    
//    if (self.datatype == MYPUBLISH_TYPE){
//        
//    }else {
//        self.mySegmentedControl.hidden = YES;
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rdv_tabBarController.tabBarHidden = YES;
    
//    if (self.datatype == MYPUBLISH_TYPE){
//        
//    }else {
//        self.mySegmentedControl.hidden = NO;
//    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mDataSource = [NSMutableArray array];
    
    [self setVCName:@"近期发布" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    urlStr = URL_GET_PUBLICATIONS;

    
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
        
            array = response[@"wantedMessage"];
            if (array.count <= 0) {
                emptyView.hidden = NO;
                
                    emptyView.emptyStr = @"暂无发布";
                    
                return ;
            }
            mArr = [RequestMessage dealWithDatabase:response andArray:response[@"wantedMessage"] andWriteSQL:NO];
        
        self.mDataSource = mArr;
     
        emptyView.hidden = YES;
        
        [self.myCollectionView reloadData];
        
    } failure:^(RequestManager *manager, NSError *error) {
        
        emptyView.emptyStr = @"网络异常，请稍后请求";
        emptyView.hidden = NO;
    }];
}
#pragma mark - 显示空白显示界面
- (void)showEmptyView{
    
}


#pragma mark - collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(Screen_Width, Screen_Height*39/568);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView ;
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        MyPublishEditFootCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"publishFooter" forIndexPath:indexPath];
        
        reusableView = footerView;
        
        footerView.footerBlock = ^(NSInteger tagIndex){
            
            if (tagIndex == 100) {
                NSLog(@"编辑");
            } else {
                NSLog(@"删除");
            }
            
        };
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(Screen_Width, Screen_Width/2);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FivePathCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.mDataSource[indexPath.section];
    
    return cell;
}
#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FactoryDetailViewController *detailVC = [FactoryDetailViewController new];
    detailVC.model = self.mDataSource[indexPath.section];
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
        
        [_myCollectionView registerClass:[MyPublishEditFootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"publishFooter"];
        
        __weak typeof (self) weakSelf = self;
        
        _myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            // 判断数据类型
            WantedMessageModel*model = [weakSelf.mDataSource lastObject];
            if (model.nextURL.length > 0) {
                
                [weakSelf.request requestNestURL:model.nextURL];
            }
            
            [weakSelf.myCollectionView.mj_footer endRefreshing];
        }];
        
    }
    return _myCollectionView;
}

//- (UISegmentedControl *)mySegmentedControl {
//    
//    if (!_myCollectionView) {
//        _mySegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"业主",@"专家"]];
//        _mySegmentedControl.frame = CGRectMake(Screen_Width/2-60, 10, 120, 26);
//        //        _mySegmentedControl.
//        _mySegmentedControl.tintColor = GREEN_1ab8;
//        _mySegmentedControl.selectedSegmentIndex = 0;
//        // 设置字体大小
//        NSDictionary *fontDic = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:14]]};
//        [_mySegmentedControl setTitleTextAttributes:fontDic forState:UIControlStateSelected];
//        [_mySegmentedControl setTitleTextAttributes:fontDic forState:UIControlStateNormal];
//        
//        [_mySegmentedControl addTarget:self action:@selector(segmentedValueChangeAction:) forControlEvents:UIControlEventValueChanged];
//    }
//    return _mySegmentedControl;
//}

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
