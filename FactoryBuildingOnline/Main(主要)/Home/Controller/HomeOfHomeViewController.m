//
//  HomeOfHomeViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "HomeOfHomeViewController.h"

#import "HeadOfImagePlayerCollectionReusableView.h"
#import "RecommendAndActionCollectionViewCell.h"    // 每日推荐 的cell
#import "FivePathHeadCollectionReusableView.h"
#import "FivePathCollectionViewCell.h"
#import "BoutiqueHeadViewCollectionReusableView.h"
#import "BoutiqueCollectionViewCell.h"

#import "FactoryDetailViewController.h"

#import "HomeCollectionViewCell.h"

#import "HomeWantedModel.h"
#import "HomeRequest.h"
#import "SecurityUtil.h"
#import "FOLUserInforModel.h"

#define self_width self.view.frame.size.width
#define self_height self.view.frame.size.height

@interface HomeOfHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UIActivityIndicatorView *yzActivityView;    // 优质厂房的活动指示器
@property (nonatomic, strong) NSMutableArray *mDataArray;                 // 数据源 优质厂房
@property (nonatomic, strong) HomeRequest *homeRequest;
@end

@implementation HomeOfHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    self.mDataArray = [NSMutableArray array];
    [self gethomeData];
    
}

#pragma mark - 获取数据
- (void)gethomeData {
    [self.yzActivityView startAnimating];   // 开启优质厂房的活动指示器
    
    self.homeRequest = [HomeRequest new];
    
    // 获取首页数据
    [self.homeRequest getHomeInfomation];   // 获取优质厂房
    
    __weak typeof (self) weakSelf = self;
    
    self.homeRequest.homeBlock = ^(NSMutableArray *mArr){   // 首页数据的回调
        
        if (mArr.count > 0) {   // 当数据大于0 的时候 加载界面
            
            for (HomeWantedModel *model in mArr) {
                
                [weakSelf.mDataArray addObject:model];
            }
            
            [weakSelf.myCollectionView reloadData];
        }
        
        [weakSelf.yzActivityView stopAnimating];    // 关闭优质厂房的活动指示器
        //        weakSelf.yzActivityView.hidden = YES;
        [weakSelf.myCollectionView.mj_footer endRefreshing];
    };
    
//    // 获取经纪人
//    [self.homeRequest getPromeDiums];
//    
//    self.homeRequest.promediusBlock = ^(NSDictionary *response){
//        
//        weakSelf.promediusDic = response;
//        [weakSelf.myCollectionView reloadData];
//    };
    
}

#pragma mark - collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
        {
            NSInteger count = self.mDataArray.count;
            return count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(Screen_Width*17/40, (Screen_Width*17/40)*35/69);
            break;
        case 1:case 2:
            return CGSizeMake(self_width, self_width*17/32);    // 用宽高的比例去算
            break;
        default:
            break;
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(Screen_Width, Screen_Height*65/284);
    }else if (section == 1) {
        return CGSizeMake(self_width, 32);
    }else if (section == 2) {
        return CGSizeMake(self_width, 32);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        
        return UIEdgeInsetsMake(14, 14, 14, 14);
    }
    return UIEdgeInsetsZero;
}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 16;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 16;
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView ;
    
    if (kind == UICollectionElementKindSectionHeader) {
        switch (indexPath.section) {
            case 0:
            {    // 图片轮播
                HeadOfImagePlayerCollectionReusableView *imagedPlayer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadOfImagePlayerCollectionReusableView" forIndexPath:indexPath];
                imagedPlayer.imageDataSource = @[@"http://oi653ezan.bkt.clouddn.com/banner1.png",@"http://oi653ezan.bkt.clouddn.com/banner2.png",@"http://oi653ezan.bkt.clouddn.com/banner3.png"];
                reusableView = imagedPlayer;
            }
                break;
            case 1:
            {
                BoutiqueHeadViewCollectionReusableView *cellHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BoutiqueHeadViewCollectionReusableView" forIndexPath:indexPath];
                reusableView = cellHeadView;
            }
                break;
            case 2:
            {
                FivePathHeadCollectionReusableView *cellHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FivePathHeadCollectionReusableView" forIndexPath:indexPath];
                [cellHeadView addSubview:self.yzActivityView];
                
                reusableView = cellHeadView;
            }
                break;
            default:
                break;
        }
    }
    return reusableView;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            cell = [self RecommendAndActionCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        case 1:
        {
            HomeCollectionViewCell *homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
            
            [self addChildViewController:homeCell.boutiqueVC];
            
            cell = homeCell;
            
        }
            break;
        case 2:
        {
            cell = [self fiveCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (UICollectionViewCell *)RecommendAndActionCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendAndActionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendAndActionCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        cell.titleLabel.text = @"每日推荐";
        cell.contentLabel.text = @"支付宝现重大漏洞10日上午被曝光";
        cell.imageView.image = [UIImage imageNamed:@"recommend"];
    } else {
        cell.titleLabel.text = @"活动";
        cell.contentLabel.text = @"找厂房APP上线，限时免费开通功能，更多功能请下载APP了解。";
        cell.imageView.image = [UIImage imageNamed:@"active"];
    }
    
    return cell;
}

- (UICollectionViewCell *)fiveCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FivePathCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.mDataArray[indexPath.item];
    return cell;
    
}

#pragma mark - collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld--%ld",indexPath.section,indexPath.item);
    
    switch (indexPath.section) {
        case 1:
        {
            NSLog(@"跳转到头条资讯");
            
        }
            break;
        case 2: // 跳转到厂房详情
        {
            FactoryDetailViewController *factoryVC = [[FactoryDetailViewController alloc] init];
            
            factoryVC.model = self.mDataArray[indexPath.item];
            
            [self.navigationController pushViewController:factoryVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - lazyload 
- (UICollectionView *) myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        
        _myCollectionView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:self.myCollectionView];
        
        _myCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_myCollectionView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_myCollectionView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_myCollectionView]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,_myCollectionView)]];
        // 注册 cell and headerView
        [_myCollectionView registerClass:[HeadOfImagePlayerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadOfImagePlayerCollectionReusableView"];
        [_myCollectionView registerClass:[RecommendAndActionCollectionViewCell class] forCellWithReuseIdentifier:@"RecommendAndActionCollectionViewCell"];
        
        [_myCollectionView registerClass:[BoutiqueHeadViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BoutiqueHeadViewCollectionReusableView"];
        [_myCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
        
        [_myCollectionView registerClass:[FivePathHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FivePathHeadCollectionReusableView"];
        [_myCollectionView registerClass:[FivePathCollectionViewCell class] forCellWithReuseIdentifier:@"FivePathCollectionViewCell"];
        
        __weak typeof (self) weakSelf = self;
        // 上拉加载更多
        self.myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            HomeWantedModel *model = weakSelf.mDataArray.lastObject;
            
            if (model.nextURL != nil) {
                
                [weakSelf.homeRequest requestNextURL:model.nextURL];    // 请求 nextURL 的内容
                return ;
            }
            
            [weakSelf.myCollectionView.mj_footer endRefreshing];
        }];
        
//        [_myCollectionView addSubview:self.yzActivityView];
    }
    return _myCollectionView;
}


// 优质厂房 活动指示器
- (UIActivityIndicatorView *)yzActivityView {
    
    if (!_yzActivityView) {
        _yzActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _yzActivityView.frame = CGRectMake(100, 5, 30, 30);
        _yzActivityView.hidden = YES;
    }
    
    return _yzActivityView;
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
