//
//  PaySocialSecurityViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "PaySocialSecurityViewController.h"
#import "SSPayHeaderCollectionReusableView.h"
#import "HMSegmentedControl.h"
#import "PaySSBottomView.h"
#import "SSPayItemCollectionViewCell.h"
@interface PaySocialSecurityViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) HMSegmentedControl *mySegmented;
@property (nonatomic, strong) PaySSBottomView *bottomView;  // 底部view
@end

@implementation PaySocialSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myCollectionView];
    
    [self.view addSubview:self.bottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setNavigation {
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftBack"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    btnItem.tintColor = BLACK_42;
    self.navigationItem.leftBarButtonItem = btnItem;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - datasource collectionview
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        if (self.vctype == 0) {
            return CGSizeMake(Screen_Width, Screen_Height*278/568);
        } else {
            return CGSizeMake(Screen_Width, Screen_Height*303/568);
        }
    } else {
        return CGSizeMake(Screen_Width, Screen_Height*33/568);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            
            SSPayHeaderCollectionReusableView *payheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FristHeaderView" forIndexPath:indexPath];
            
            if (self.vctype == 0) {
                // 缴社保页面没有 提示view
                payheader.warningView.hidden = YES;
            } else {
                // 补缴社保没有 "可购" 文字提示
                payheader.cellHeight.constant = 41;
                payheader.reminder_1.hidden = YES;
                payheader.reminder_2.hidden = YES;
            }
            headerView = payheader;
        } else {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"secondHeaderView" forIndexPath:indexPath];
            [headerView addSubview:self.mySegmented];
            headerView.backgroundColor = [UIColor redColor];
            
        }
    }
    return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 8;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Height*39/568);
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if (indexPath.section == 1) {
        SSPayItemCollectionViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sspayItemCell" forIndexPath:indexPath];
        cell = itemCell;
    }
    
    return cell;
}

#pragma mark - lazy load
- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-55) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[SSPayHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FristHeaderView"];
        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"secondHeaderView"];
        [_myCollectionView registerClass:[SSPayItemCollectionViewCell class] forCellWithReuseIdentifier:@"sspayItemCell"];
    }
    return _myCollectionView;
}

- (HMSegmentedControl *)mySegmented {
    if (!_mySegmented) {
        _mySegmented = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"本地城镇",@"本地农村",@"外地城镇",@"外地农村"]];
        
        _mySegmented.frame = CGRectMake(0, 0, Screen_Width, Screen_Height*33/568);
        
        _mySegmented.backgroundColor = [UIColor colorWithHex:0xF0F7F8];
        _mySegmented.selectionIndicatorColor = GREEN_19b8;
        _mySegmented.selectionIndicatorHeight = 1;
        _mySegmented.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:GREEN_19b8,NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:11.0]]};
        _mySegmented.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:11.0]],NSForegroundColorAttributeName:BLACK_66};
        
        _mySegmented.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;     // 设置指示器方向
        
    }
    return _mySegmented;
}

- (PaySSBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PaySSBottomView alloc] initWithFrame:CGRectMake(0, Screen_Height-55, Screen_Width, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.bottomType = PAYSS;
        _bottomView.tagBlock = ^(NSInteger tagIndex){
            switch (tagIndex) {
                case 100:
                {
                    NSLog(@"服务");
                }
                    break;
                case 101:
                {
                    NSLog(@"一键续交");
                }
                    break;
                case 102:
                {
                    NSLog(@"我要购买");
                }
                    break;
                case 103:
                {
                    NSLog(@"热线");
                }
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _bottomView;
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
