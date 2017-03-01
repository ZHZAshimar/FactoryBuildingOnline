//
//  BoutiqueViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
// 精品厂房

#import "BoutiqueViewController.h"

#import "BoutiqueCollectionViewCell.h"
#import "FactoryDetailViewController.h"

#import "BoutiqueRequest.h"

@interface BoutiqueViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger scrollIndex;  // 滚动到第几个item
    CGFloat lastContentOffSetX; // 偏移的位置 x轴
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation BoutiqueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSArray array];
    
    scrollIndex = 0;
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self getBoutiqueFactoryData];
}

#pragma mark - 获取精品厂房的数据
- (void)getBoutiqueFactoryData {
    
    BoutiqueRequest *request = [BoutiqueRequest new];
    
    [request getBoutiqueFactoryData];
    __weak typeof(self) weakSelf = self;
    request.dataBlock = ^(NSMutableArray *mArr) {
        
        weakSelf.dataArray = mArr;
        
        [weakSelf.myCollectionView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BoutiqueFactoryCount" object:self userInfo:@{@"count":@(mArr.count)}];
    };
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat contentOffSetX = self.myCollectionView.contentOffset.x; // 拿到偏移的位置
//    判断滚动到了哪一个item
    if (lastContentOffSetX > contentOffSetX) {
        
        scrollIndex = (NSInteger)(contentOffSetX+16*scrollIndex)/Screen_Width;
        
    } else {
    
        scrollIndex = (NSInteger)(contentOffSetX+16*(scrollIndex+1))/Screen_Width;
    }
    
    [self sendNotification:scrollIndex];
    
    lastContentOffSetX = contentOffSetX;
}

- (void)sendNotification:(NSInteger) index {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BOUTIQUEFACTORYINDEX" object:self userInfo:@{@"index":@(index)}];
}

#pragma mark - collection dele
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BoutiqueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BoutiqueCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}
#pragma mark - 跳转到厂房详情
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FactoryDetailViewController *factoryDetailVC = [FactoryDetailViewController new];
    
    factoryDetailVC.model = self.dataArray[indexPath.section];
    
    [self.navigationController pushViewController:factoryDetailVC animated:YES];
}


#pragma mark - Lazy load 
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        
        layout.minimumInteritemSpacing = 0;
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:self.myCollectionView];
        
        _myCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_myCollectionView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_myCollectionView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_myCollectionView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_myCollectionView)]];
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        
        
        _myCollectionView.pagingEnabled = YES;
        
        [_myCollectionView registerClass:[BoutiqueCollectionViewCell class] forCellWithReuseIdentifier:@"BoutiqueCollectionViewCell"];
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
