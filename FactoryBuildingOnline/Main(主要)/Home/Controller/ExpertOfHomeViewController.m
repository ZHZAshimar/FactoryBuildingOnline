//
//  ExpertOfHomeViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//  首页的专家

#import "ExpertOfHomeViewController.h"


#import "ExpertAearHeadCollectionReusableView.h"    // 地方区域名
#import "ExpertImageCollectionReusableView.h"   // 销售冠军
#import "ExpertPersonCollectionViewCell.h"  //   cell

#import "BrokerAreaViewController.h"

@interface ExpertOfHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation ExpertOfHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.myCollectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Height * 43/284);
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
            
//            __weak typeof(self) weakSelf = self;
            
            headerView.areaBlock = ^(NSInteger index, NSString *areaStr) {
                // 跳转到区域经纪人
                BrokerAreaViewController *brokerAreaVC = [BrokerAreaViewController new];
                brokerAreaVC.titleStr = areaStr;
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
