//
//  RankingListView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/10.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "RankingListView.h"
#import "NRankCollectionViewCell.h"
#import "NRankHeaderCollectionReusableView.h"

@interface RankingListView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation RankingListView


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.myCollectionView];
    }
    return self;
}

#pragma mark - collectinView dataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, Screen_Height*120/568+30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"nrheaderCell" forIndexPath:indexPath];
        
    }
    return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width,Screen_Height*55/568);
}



// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NRankCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nrcell" forIndexPath:indexPath];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.item+1];
    return cell;
}

#pragma mark - lazy load
- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-64) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerClass:[NRankCollectionViewCell class] forCellWithReuseIdentifier:@"nrcell"];
        [_myCollectionView registerClass:[NRankHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"nrheaderCell"];
    }
    return _myCollectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
