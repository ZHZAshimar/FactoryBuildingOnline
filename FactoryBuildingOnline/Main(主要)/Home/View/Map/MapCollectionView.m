//
//  MapCollectionView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/26.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "MapCollectionView.h"
#import "FivePathCollectionViewCell.h"
#import "FactoryDetailViewController.h"
#import "MapViewController.h"
#import "RequestMessage.h"
@interface MapCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RequestMessageDelegate>
{
    UILabel *areaLabel; // 区域的label
    UILabel *numLabel;  // 房源的套数
    
    RequestMessage *message;
   
}
@property (nonatomic, strong) UICollectionView *mycollectionView;
@property (nonatomic, strong) UIView *headView;
@end

@implementation MapCollectionView

- (void)dealloc {
    
    self.mycollectionView.delegate = nil;
    self.mycollectionView.dataSource = nil;
    message.delegate = nil;
}

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.mDataSource = [NSMutableArray array];
        [self addSubview:self.headView];
        [self addSubview:self.mycollectionView];
        [self addSubview:self.activity];
        message = [RequestMessage new];
        message.delegate = self;
    }
    return self;
}

- (void)setNum:(NSInteger)num {
    _num = num;
    numLabel.text = [NSString stringWithFormat:@"%d套厂房在租",num];
    [self.mycollectionView reloadData];
}

- (void)setAreaStr:(NSString *)areaStr {
    _areaStr = areaStr;
    areaLabel.text = areaStr;
}

- (void)setMDataSource:(NSMutableArray *)mDataSource{
    _mDataSource = mDataSource;
    
    [self.mycollectionView reloadData];
}

#pragma mark - collectionView datasource -
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mDataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Width/2);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FivePathCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.mDataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WantedMessageModel *model = self.mDataSource[indexPath.item];
    
    self.tapBlock(indexPath,model);
    
}

#pragma mark - requestMessage -
- (void)refreshView:(NSMutableArray *)mArray{
    
    if (mArray.count > 0) {
        for (WantedMessageModel *model in mArray) {
            [self.mDataSource addObject:model];
        }
        [self.mycollectionView reloadData];
    }
}

#pragma mark - lazy load
- (UICollectionView *)mycollectionView {
    
    if (!_mycollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _mycollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, Screen_Width, self.frame.size.height-44-64) collectionViewLayout:layout];
        
        _mycollectionView.backgroundColor = GRAY_F5;
        _mycollectionView.delegate = self;
        _mycollectionView.dataSource = self;
        
        [_mycollectionView registerClass:[FivePathCollectionViewCell class] forCellWithReuseIdentifier:@"FivePathCollectionViewCell"];
        _mycollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
           WantedMessageModel *model = [self.mDataSource lastObject];
            
            if (model.nextURL.length > 0) {
                
                [message requestNestURL:model.nextURL];
            }
            
        }];
        
    }
    return _mycollectionView;
}

- (UIView *)headView {
    
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 44)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, Screen_Width, 1)];
        view.backgroundColor = GRAY_LIGHT;
        [_headView addSubview:view];
        
        areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Screen_Width*3/5, 44)];
        areaLabel.font = [UIFont systemFontOfSize:16.0f];
        areaLabel.textColor = BLACK_42;
        [_headView addSubview:areaLabel];
        
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width*3/5, 0, Screen_Width*4/15, 44)];
        numLabel.textColor = BLACK_42;
        numLabel.font = [UIFont systemFontOfSize:12.0f];
        [_headView addSubview:numLabel];
        
        self.packUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.packUpBtn.frame = CGRectMake(Screen_Width*13/15, 0, Screen_Width*2/15, 44);
        self.packUpBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.packUpBtn setTitle:@"收起" forState:UIControlStateNormal];
        [self.packUpBtn setTitleColor:BLACK_42 forState:UIControlStateNormal];
        [_headView addSubview:self.packUpBtn];
        
    }
    return _headView;
}

- (UIActivityIndicatorView *)activity {
    
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activity.frame = CGRectMake(Screen_Width/2-15, 80, 30, 30);
//        _activity.center = self.center;
        _activity.hidden = YES;
//        _activity.backgroundColor = RED_df3d;
    }
    return _activity;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
