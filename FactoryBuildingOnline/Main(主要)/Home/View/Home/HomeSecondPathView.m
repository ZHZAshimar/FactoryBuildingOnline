 //
//  HomeSecondPathView.m
//  Test111
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 ZHZ. All rights reserved.
//

#import "HomeSecondPathView.h"
#import "HMSegmentedControl.h"
#import "HomeSecondPathTempCell.h"


@interface HomeSecondPathView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    NSArray *segmentImageArr;
}

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *segmentedImageView;
@end

@implementation HomeSecondPathView

- (void)dealloc {
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
}

- (id)initWithFrame:(CGRect)frame index:(NSUInteger)index{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.indexSegment = index;
        segmentImageArr = @[[UIImage imageNamed:@"segment_1.png"],[UIImage imageNamed:@"segment_2"],[UIImage imageNamed:@"segment_3"]];
        
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        
    }
    return self;
}

- (void)setIndexSegment:(NSInteger)indexSegment {
    _indexSegment = indexSegment;
    [self.myCollectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"x = %f",scrollView.contentOffset.x);
//    NSLog(@"y = %f",scrollView.contentOffset.y);
    
    if (self.myCollectionView.contentOffset.x >= Screen_Width * 0.5 && self.myCollectionView.contentOffset.x < Screen_Width * 1.5) {
        
        [self.segmentedControl setSelectedSegmentIndex:1];
        self.indexSegment = 1;
    } else if (self.myCollectionView.contentOffset.x >= Screen_Width * 1.5) {
        
        [self.segmentedControl setSelectedSegmentIndex:2];
        self.indexSegment = 2;
    } else {
        
        [self.segmentedControl setSelectedSegmentIndex:0];
        self.indexSegment = 0;
    }
    self.segmentedImageView.frame = CGRectMake(self.indexSegment * self.frame.size.width/3, 0, self.frame.size.width/3, 40);
    switch (self.indexSegment) {
        case 0:
            self.segmentedImageView.image = [UIImage imageNamed:@"segment_1.png"];
            break;
        case 1:
            self.segmentedImageView.image = [UIImage imageNamed:@"segment_2.png"];
            break;
        case 2:
            self.segmentedImageView.image = [UIImage imageNamed:@"segment_3.png"];
            break;
        default:
            break;
    }
    
    [self.myCollectionView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INDEXCHANGE" object:self userInfo:@{@"index":[NSString stringWithFormat:@"%ld",self.indexSegment]}];
}

#pragma mark - CollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, 100);
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeSecondPathTempCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSecondPathTempCell" forIndexPath:indexPath];
//    NSLog(@"indexPath.row = %ld---%ld",indexPath.item,self.indexSegment);
    cell.secondPathCellView.collect_type = self.indexSegment;
    cell.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADDATA" object:self];
    return cell;
}

#pragma mark - lazyload -

- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 滚动方向为水平滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        
        _myCollectionView.pagingEnabled = YES;  // 允许翻页
        
        [self.bgView addSubview:_myCollectionView];
        
        _myCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_myCollectionView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.bgView,_myCollectionView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_myCollectionView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.bgView,_myCollectionView)]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_myCollectionView attribute:NSLayoutAttributeTop multiplier:1.0 constant:1.0]];
        
        [_myCollectionView registerClass:[HomeSecondPathTempCell class] forCellWithReuseIdentifier:@"HomeSecondPathTempCell"];
    }
    
    return _myCollectionView;
}

- (HMSegmentedControl *)segmentedControl{
    
    if (!_segmentedControl) {
        
        self.segmentedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, 40)];
        self.segmentedImageView.image = [UIImage imageNamed:@"segment_1.png"];
        [self.bgView addSubview:self.segmentedImageView];
        
        // 初始化 segmentedControl
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"我要找房",@"我是业主",@"经纪人"]];
        [self.bgView addSubview:_segmentedControl];
        // 分段控件的背景颜色
        _segmentedControl.backgroundColor = [UIColor clearColor];
        // 指示器的位置
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        // 分段控件文字的大小及颜色
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:GRAY_9e,NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
        
        // 被选中后的文字大小与文字
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:BLACK_42,NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
        
        [_segmentedControl setSelectedSegmentIndex:self.indexSegment];
        
        __weak typeof(self) weakSelf = self;
        
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            
            weakSelf.segmentedImageView.frame = CGRectMake(index * self.frame.size.width/3, 0, self.frame.size.width/3, 40);
            switch (index) {
                case 0:
                    weakSelf.segmentedImageView.image = [UIImage imageNamed:@"segment_1.png"];
                    break;
                case 1:
                    weakSelf.segmentedImageView.image = [UIImage imageNamed:@"segment_2.png"];
                    break;
                case 2:
                    weakSelf.segmentedImageView.image = [UIImage imageNamed:@"segment_3.png"];
                    break;
                default:
                    break;
            }
            
            weakSelf.indexSegment = (long)index;
            
            [weakSelf.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            
        }];
        
        _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_segmentedControl]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.bgView,_segmentedControl)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_segmentedControl(40)]-0-[_myCollectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.bgView,_segmentedControl,_myCollectionView)]];
        
        
    }
    
    return _segmentedControl;
}

-(UIView*)bgView {
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = GRAY_F5;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
