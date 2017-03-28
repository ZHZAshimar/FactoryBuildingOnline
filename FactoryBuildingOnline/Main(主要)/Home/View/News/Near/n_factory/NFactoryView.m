
//
//  NFactoryView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/13.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NFactoryView.h"
#import "NDynamicFactoryCollectionViewCell.h"

#import "UserLocation.h"
#import "NewsNearManager.h"
@interface NFactoryView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NewsNearManager *netManager;
}

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *mDataSource;
@property (nonatomic, strong) EmptyView *emptyView;
@end


@implementation NFactoryView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.mDataSource = [NSMutableArray array];
        [self addSubview:self.myCollectionView];
        [self initManager];
        [self.myCollectionView.mj_header beginRefreshing];
    }
    return self;
}

- (void)initManager {    
    netManager = [NewsNearManager new];
    
    [netManager getNearByFactoryWithGeohash:[UserLocation shareInstance].geohashStr withType:@"0"];
    
    __weak typeof(self) weakSelf = self;
    
    netManager.factoryBlock = ^(NSArray *response) {
        if (response.count <= 0 && self.mDataSource.count <= 0) {
            weakSelf.emptyView.hidden = NO;
        } else {
            weakSelf.emptyView.hidden = YES;
        }
        
        [weakSelf.mDataSource addObjectsFromArray:response];
        [weakSelf.myCollectionView reloadData];
    };
    
    netManager.errorBlock = ^(BOOL iserror) {
        if (self.mDataSource.count <= 0) {
            
            weakSelf.emptyView.hidden = NO;
            weakSelf.emptyView.emptyStr = @"网络异常，请稍候再试！";
        }
    };
}

#pragma mark - collectinView dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mDataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width-24-8)/2,Screen_Height*180/568);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NDynamicFactoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ndcell" forIndexPath:indexPath];
    cell.dataDic = self.mDataSource[indexPath.row];
    return cell;
}

#pragma mark - lazy load
- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.frame.size.height) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor clearColor];
       
        [_myCollectionView registerClass:[NDynamicFactoryCollectionViewCell class] forCellWithReuseIdentifier:@"ndcell"];
        
        _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_myCollectionView.mj_header endRefreshing];
        }];
        
        _myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [_myCollectionView.mj_footer endRefreshing];
        }];

    }
    return _myCollectionView;
}


- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initWithFrame:self.bounds];
        _emptyView.emptyStr = @"暂无内容";
        _emptyView.image = [UIImage imageNamed:@"error_1"];
        _emptyView.hidden = YES;
        [self addSubview:_emptyView];
    }
    return _emptyView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
