//
//  RecentlyPublishViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/15.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "RecentlyPublishViewController.h"
#import "FivePathCollectionViewCell.h"
#import "FactoryDetailViewController.h"


@interface RecentlyPublishViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation RecentlyPublishViewController

- (void)dealloc {
    
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setVCName:@"近期发布" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    [self addRightItemWithString:@"首页" andItemTintColor:BLACK_42];
    
    self.dataSource = [NSArray array];
    
    [self.view addSubview:self.myCollectionView];
    
}

- (void)rightItemButtonAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return self.dataSource.count;
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, 106);
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FivePathCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
    
}
#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FactoryDetailViewController *factoryDetailVC = [FactoryDetailViewController new];
    
    [self.navigationController pushViewController:factoryDetailVC animated:YES];
    
}

#pragma mark - lazyload -
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        
        layout.minimumInteritemSpacing = 1;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = GRAY_F5;
        
        _myCollectionView.delegate = self;
        
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[FivePathCollectionViewCell class] forCellWithReuseIdentifier:@"FivePathCollectionViewCell"];
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
