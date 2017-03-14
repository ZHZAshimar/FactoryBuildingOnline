//
//  FMView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "FMView.h"
#import "FMHeaderView.h"
#import "FMCollectionViewCell.h"

@interface FMView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation FMView


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"FM_bg"];
    imageView.backgroundColor = [UIColor brownColor];
    [self addSubview:imageView];
    
    FMHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"FMHeaderView" owner:self options:nil] firstObject];
    headerView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height*373/568);
    headerView.backgroundColor = [UIColor clearColor];
    [self addSubview:headerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, headerView.frame.size.height + 15, Screen_Width, 40)];
    label.text = @"猜你喜欢";
    label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:16.0]];
    label.textColor = BLACK_66;
    [self addSubview:label];
    
    [self addSubview:self.myCollectionView];

}

#pragma mark - collectinView dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width - 88 - 20)/5, Screen_Height*65/568);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 44);
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"nrcell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - lazy load
- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, Screen_Height*373/568+55, Screen_Width-40,Screen_Height- Screen_Height*373/568-55-64) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        [_myCollectionView registerClass:[FMCollectionViewCell class] forCellWithReuseIdentifier:@"nrcell"];
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
