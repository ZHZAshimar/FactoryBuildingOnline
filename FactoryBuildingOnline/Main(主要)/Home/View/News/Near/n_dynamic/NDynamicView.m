//
//  NDynamicView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//  资讯 - 附近 - 动态

#import "NDynamicView.h"
#import "NDynamicMapCollectionReusableView.h"
#import "NDynamicHeaderCollectionReusableView.h"
#import "NDynamicFooterCollectionReusableView.h"
#import "NDynamicImageCollectionViewCell.h"
#import "UserLocation.h"

#import "NewsNearManager.h"
#import "FOLUserInforModel.h"
#import "LogoViewController.h"
@interface NDynamicView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NewsNearManager *netManager;
    int selectIndex;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *mDataSource;
@property (nonatomic, strong) EmptyView *emptyView;
@end


@implementation NDynamicView

- (id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.myCollectionView];
        [self initManager];
        
        [self.myCollectionView.mj_header beginRefreshing];
    }
    return self;
}
/*
 
 {
 "avatar_url" = "http://img.oncom.cn/\U5934\U50cf11";
 "comment_count" = 1;
 "dynamic_explain" = 1ex;
 "dynamic_id" = 1;
 "last_login" = "99\U59292\U5c0f\U65f636\U5206";
 "laud_count" = 0;
 "photo_urls" =             (
 "http://img3.oncom.cn/1url?e=1492928638&token=jNcGseCZLES3PrEFUCQ6WOv4fO_khg4LqYHSpxns:ClldfK5LXCFhBjkZkauW2KsZHfY=",
 "http://img3.oncom.cn/10url?e=1492928638&token=jNcGseCZLES3PrEFUCQ6WOv4fO_khg4LqYHSpxns:2IAk86sAyEMtCZKKLx7zgnr-ZCk="
 );
 range = "0.022";
 "user_type" = 0;
 username = a1;
}
 */
- (void)initManager {
    self.mDataSource = [NSMutableArray array];
    
    netManager = [NewsNearManager new];
    // 获取数据
    [netManager getNearByDynamicWithGeohash:[UserLocation shareInstance].geohashStr];
    
    __weak typeof(self) weakSelf = self;
    
    netManager.dynamicBlock = ^(NSArray *response) {
        
        if (response.count <= 0 && self.mDataSource.count <= 0) {
            weakSelf.emptyView.hidden = NO;
        } else {
            weakSelf.emptyView.hidden = YES;
        }
        
        [weakSelf.mDataSource addObjectsFromArray:response];
        [weakSelf.myCollectionView reloadData];
    };
    netManager.errorBlock = ^(BOOL isError) {
        if (self.mDataSource.count <= 0) {
            
            weakSelf.emptyView.hidden = NO;
            weakSelf.emptyView.emptyStr = @"网络异常，请稍候再试！";
        }
    };

}

#pragma mark - likeButton touch action
- (void)likeButtonDidTouch: (UIButton *)button {
    
    if (![self judgeLogin]) {
        return;
    }
    
    int tagIndex = [self.mDataSource[button.tag-200][@"dynamic_id"] intValue];
    
    [netManager putNearbyLaudWithDynamicID:tagIndex];
    
    netManager.errorBlock = ^(BOOL isError){
        if (isError) {
            [MBProgressHUD showError:@"网络有点小问题，请稍候再点赞！" ToView:nil];
        } else {
            
        }
    };
    [UIView animateWithDuration:0.5 animations:^{
        
        button.transform = CGAffineTransformScale(button.transform, 2, 2);
    
    } completion:^(BOOL finished) {
        button.transform = CGAffineTransformScale(button.transform, 0.5, 0.5);
    }];

}
- (void)dicussButtonDidTouch: (UIButton *)button {
    
    int tagIndex = [self.mDataSource[button.tag-300][@"dynamic_id"] intValue];
    
//    [netManager putNearbyLaudWithDynamicID:tagIndex];
}
- (void)moreButtonDidTouch: (UIButton *)button {
    
    int tagIndex = [self.mDataSource[button.tag-400][@"dynamic_id"] intValue];
    
    [netManager putNearbyLaudWithDynamicID:tagIndex];
}

#pragma mark - collectinView dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mDataSource.count+1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(Screen_Width, Screen_Height*130/568);
    } else {
        // 跟据文本的大小来设定
        return CGSizeMake(Screen_Width, Screen_Height*110/568);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(Screen_Width, Screen_Height*50/568);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView;
    
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
            NDynamicMapCollectionReusableView *ndheaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mapHeader" forIndexPath:indexPath];
            headerView = ndheaderView;
        }
        return headerView;
    } else {
    
        if (kind == UICollectionElementKindSectionHeader) {
            NDynamicHeaderCollectionReusableView *nrheaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell" forIndexPath:indexPath];
            NSInteger index = indexPath.section-1;
            nrheaderView.dataDic = self.mDataSource[index];
            
            headerView = nrheaderView;
        } else {
            NDynamicFooterCollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell" forIndexPath:indexPath];
            
            footView.likeBtn.tag = 200+indexPath.section -1;
            footView.dicussBtn.tag = 300 + indexPath.section - 1;
            footView.moreBtn.tag = 400 + indexPath.section - 1;
            
            [footView.likeBtn addTarget:self action:@selector(likeButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
            [footView.dicussBtn addTarget:self action:@selector(dicussButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
            [footView.moreBtn addTarget:self action:@selector(moreButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            headerView = footView;
        }
        return headerView;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        
        NSArray *imageArray = self.mDataSource[section-1][@"photo_urls"];
        return imageArray.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width-24-18)/3,Screen_Height*110/568);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 9;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NDynamicImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ndcell" forIndexPath:indexPath];
    
    NSArray *imageArray = self.mDataSource[indexPath.section-1][@"photo_urls"];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[indexPath.item]] placeholderImage:[UIImage imageNamed:@"FM_bg"]] ;
    
    return cell;
}

#pragma mark - 判断是否登录
- (BOOL)judgeLogin {
    
    NSMutableArray *users = [FOLUserInforModel findAll];
    if (users.count > 0) {
        return YES;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GOTOLOGINOFNEWS" object:nil];
        return NO;
    }
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
        
        [_myCollectionView registerClass:[NDynamicMapCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mapHeader"];
        [_myCollectionView registerClass:[NDynamicHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"];
        [_myCollectionView registerClass:[NDynamicFooterCollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier:@"footerCell"];
        [_myCollectionView registerClass:[NDynamicImageCollectionViewCell class] forCellWithReuseIdentifier:@"ndcell"];
        
        //
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
