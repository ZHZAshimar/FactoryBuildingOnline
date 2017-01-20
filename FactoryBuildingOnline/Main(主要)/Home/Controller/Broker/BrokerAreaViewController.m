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

@interface BrokerAreaViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) HomeRequest *homeRequest;

@property (nonatomic, strong) NSDictionary *promediusDic;                  // 经纪人的字典

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
    [self setVCName:[NSString stringWithFormat:@"%@区域",self.titleStr] andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:self.myCollectionView];
    
    self.homeRequest = [HomeRequest new];
    // 获取经纪人
    [self.homeRequest getPromeDiums];
    
    __weak typeof (self) weakSelf = self;
    
    self.homeRequest.promediusBlock = ^(NSDictionary *response){
        
        weakSelf.promediusDic = response;
        [weakSelf.myCollectionView reloadData];
    };
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Height*45/284);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    AreaExpertPersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AreaExpertPersonCollectionViewCell" forIndexPath:indexPath];
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
            
            
            
        }];
        
        [_myCollectionView.mj_footer endRefreshing];
        
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
