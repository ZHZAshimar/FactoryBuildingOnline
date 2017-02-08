//
//  ExpertOfHomeViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//  首页的专家

#import "ExpertOfHomeViewController.h"
#import "BrokerInfoViewController.h"

#import "ExpertAearHeadCollectionReusableView.h"    // 地方区域名
#import "ExpertImageCollectionReusableView.h"   // 销售冠军
#import "ExpertPersonCollectionViewCell.h"  //   cell

#import "BrokerAreaViewController.h"

#import "ExpertHomeRequest.h"
#import "PromediumsModel.h"
#import "BrancheModel.h"

@interface ExpertOfHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSArray *promediumsTOPArray;
@end

@implementation ExpertOfHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.promediumsTOPArray = [NSArray array];
    
    [self.view addSubview:self.myCollectionView];
    
    [self getData];
}

- (void)getData {
    
    ExpertHomeRequest *expertRequest = [ExpertHomeRequest new];
    
    [expertRequest getPromediumsTOP];
    
    __weak typeof(self) weakSelf = self;
    
    expertRequest.promediumsBlock = ^(BOOL flag) {
        if (flag) {
            
            NSMutableArray *array = [PromediumsModel findAll];
            
            if (array.count <= 0) {
                
                EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds];
                emptyView.image = [UIImage imageNamed:@"error_1"];
                emptyView.emptyStr = @"网络连接有问题";
                return ;
            }
            
            weakSelf.promediumsTOPArray = array;
            [weakSelf.myCollectionView reloadData];
        }
    };
    
    // 请求分店资源
    [expertRequest getPromediumsArea];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return self.promediumsTOPArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Height * 10/71);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(Screen_Width, Screen_Height*15/142);
    }
    
    return CGSizeMake(Screen_Width, Screen_Height*5/71);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
////    return UIEdgeInsetsMake(18, 0, 0 , 0 );
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0) { // 地方
            
            ExpertAearHeadCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ExpertAearHeadCollectionReusableView" forIndexPath:indexPath];
            
            headerView.mDataArray = [BrancheModel findAll];
//            __weak typeof(self) weakSelf = self;
            
            headerView.areaBlock = ^(NSInteger index, BrancheModel *model) {
                // 跳转到区域经纪人
                BrokerAreaViewController *brokerAreaVC = [BrokerAreaViewController new];
                brokerAreaVC.model = model;
                [self.navigationController pushViewController:brokerAreaVC animated:YES];
            };
            
            reusableView = headerView;
            
        } else {    // 销售冠军
            ExpertImageCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ExpertImageCollectionReusableView" forIndexPath:indexPath];
            reusableView = headerView;
        }
    }
    return reusableView;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __kindof UICollectionViewCell *cell;
    
    ExpertPersonCollectionViewCell *personCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExpertPersonCollectionViewCell" forIndexPath:indexPath];
    personCell.model = self.promediumsTOPArray[indexPath.item];
    switch (indexPath.item) {
        case 0:
            personCell.globImageView.image = [UIImage imageNamed:@"num_1"];
            break;
        case 1:
            personCell.globImageView.image = [UIImage imageNamed:@"num_2"];
            break;
        case 2:
            personCell.globImageView.image = [UIImage imageNamed:@"num_3"];
            break;
        default:
            break;
    }
    cell = personCell;
    
    return cell;
}

#pragma mark - 跳转到专家详情页
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        BrokerInfoViewController *brokerInfoVC = [BrokerInfoViewController new];
        
        PromediumsModel *model = self.promediumsTOPArray[indexPath.item];
        
        NSDictionary *brokerDic = @{@"branch":model.branch,@"real_name":model.realName,@"id":@(model.promediumsID),@"year_experience":model.workYear,@"avatar":model.avatar,@"phone_num":model.phoneNum};
        
        brokerInfoVC.infoDic = brokerDic;
        
        [self.navigationController pushViewController:brokerInfoVC animated:YES];
    }
    
}

#pragma mark - 
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;

        
        [_myCollectionView registerClass:[ExpertAearHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ExpertAearHeadCollectionReusableView"];
        
        [_myCollectionView registerClass:[ExpertImageCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ExpertImageCollectionReusableView"];
        
        [_myCollectionView registerClass:[ExpertPersonCollectionViewCell class] forCellWithReuseIdentifier:@"ExpertPersonCollectionViewCell"];
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
