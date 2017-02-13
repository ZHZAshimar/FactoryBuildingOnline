//
//  BrokerAreaViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/20.
//  Copyright © 2017年 XFZY. All rights reserved.
//  区域经纪人

#import "BrokerAreaViewController.h"
#import "HomeRequest.h"
#import "AreaExpertPersonCollectionViewCell.h"
#import "BrokerInfoViewController.h"
#import "ExpertHomeRequest.h"

@interface BrokerAreaViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString *nextUrl;
    ExpertHomeRequest *expertHomeRequest;
}
@property (nonatomic, strong) HomeRequest *homeRequest;

@property (nonatomic, strong) NSMutableArray *promediusmArr;            // 经纪人数组

@property (nonatomic,strong) UICollectionView *myCollectionView;

@end

@implementation BrokerAreaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.rdv_tabBarController.tabBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVCName:[NSString stringWithFormat:@"%@",self.model.name] andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
    self.promediusmArr = [NSMutableArray array];
    nextUrl = @"";
    
    [self.view addSubview:self.myCollectionView];
    
//    self.homeRequest = [HomeRequest new];
//    // 获取经纪人
//    [self.homeRequest getPromeDiums];
//    
//    __weak typeof (self) weakSelf = self;
//    
//    self.homeRequest.promediusBlock = ^(NSDictionary *response){
//        
//        weakSelf.promediusDic = response;
//        [weakSelf.myCollectionView reloadData];
//    };
    
    
    expertHomeRequest = [ExpertHomeRequest new];
    
    [self getBranchPromediumsData];
}

- (void)getBranchPromediumsData {
    
    [expertHomeRequest getBranchPromediums:self.model.branchID andNextUrl:nextUrl];
    
    __weak typeof(self) weakSelf = self;
    expertHomeRequest.bpBlock = ^(NSDictionary *dic){
        
        EmptyView *emptyView;
        
        if (dic.count <= 0 && weakSelf.promediusmArr.count <= 0) {
            
            emptyView = [[EmptyView alloc] initWithFrame:weakSelf.view.bounds];
            emptyView.image = [UIImage imageNamed:@"error_1"];
            emptyView.emptyStr = @"网速太慢了";
            [weakSelf.view addSubview:emptyView];
            emptyView.hidden = NO;
            return ;
        }
        emptyView.hidden = YES;
        NSArray *array = dic[@"proMedium"];
        
        if (array.count > 0) {
            
            if ([dic[@"next"] isEqual:[NSNull null]]) {
                
                nextUrl = @"";
            } else {
                nextUrl = dic[@"next"];
            }
        
            for (NSDictionary *brokerDic in array) {
                
                [weakSelf.promediusmArr addObject:brokerDic];
                
            }
            
            [weakSelf.myCollectionView reloadData];
            
            [weakSelf.myCollectionView.mj_footer endRefreshing];
        }
    };
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.promediusmArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Height * 10/71);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    AreaExpertPersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AreaExpertPersonCollectionViewCell" forIndexPath:indexPath];
    
    cell.dic = self.promediusmArr[indexPath.item];
    
    switch (indexPath.item) {
        case 0:
        {
            cell.globImageView.image = [UIImage imageNamed:@"red"];
            cell.globImageView.hidden = NO;
        }
            break;
        case 1:
        {
            cell.globImageView.image = [UIImage imageNamed:@"yellow"];
            cell.globImageView.hidden = NO;
        }
            break;
        case 2:
        {
            cell.globImageView.image = [UIImage imageNamed:@"blue"];
            cell.globImageView.hidden = NO;
        }
            break;
            
        default:
            cell.globImageView.hidden = YES;
            break;
    }
    
    return cell;
}

#pragma mark - 跳转到专家详情页
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrokerInfoViewController *brokerInfoVC = [BrokerInfoViewController new];
    
    brokerInfoVC.infoDic = self.promediusmArr[indexPath.item];
    
    [self.navigationController pushViewController:brokerInfoVC animated:YES];
    
}

#pragma mark - lazy loading 
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_myCollectionView registerClass:[AreaExpertPersonCollectionViewCell class] forCellWithReuseIdentifier:@"AreaExpertPersonCollectionViewCell"];
        
        _myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            if (nextUrl.length >= 1) {
                
                [self getBranchPromediumsData];
                
            } else {
                [_myCollectionView.mj_footer endRefreshing];
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
