//
//  ExpertAearHeadCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ExpertAearHeadCollectionReusableView.h"
#import "AreaCollectionViewCell.h"

@interface ExpertAearHeadCollectionReusableView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation ExpertAearHeadCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.mDataArray = [NSMutableArray array];
        
        [self addSubview:self.myCollectionView];
        
    }
    return self;
}

- (void)setMDataArray:(NSMutableArray *)mDataArray {
    
    _mDataArray = mDataArray;
    
    [self.myCollectionView reloadData];
}

#pragma mark - collection datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.mDataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Screen_Width*5/16, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 18.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 18, 0, 18);

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AreaCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.mDataArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrancheModel *model = self.mDataArray[indexPath.item];
    self.areaBlock(indexPath.item, model);
}

- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView ) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 设置滚动方向位横向滚动
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_myCollectionView registerClass:[AreaCollectionViewCell class] forCellWithReuseIdentifier:@"AreaCollectionViewCell"];
        
    }
    return _myCollectionView;
}

@end
