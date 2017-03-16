//
//  SSHomeViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/14.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SSHomeViewController.h"
#import "SSImagePlayerCollectionReusableView.h"     // 图片轮播
#import "SSHomeLogoTextCollectionViewCell.h"        //
#import "FootCollectionReusableView.h"              // 灰色的分割线
#import "SSHomeCollectionViewCell.h"                // 第二个section 的cell
#import "PaySocialSecurityViewController.h"         // 补缴社保 和缴社保
#import "PayTransferViewController.h"
@interface SSHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray *logoArray; // 图标数组
}
@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation SSHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"服务";
    [self.view addSubview:self.myCollectionView];
    logoArray = @[@{@"name":@"缴社保",@"logo":@"pay_social"},@{@"name":@"社保补缴",@"logo":@"pay_social_1"},@{@"name":@"社保转移",@"logo":@"social_transfer"}];
}

- (void)setNavigation {
    
    self.navigationController.navigationBarHidden = YES;    // 隐藏导航栏
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closeBack"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];   // 设置返回按钮
    backBtn.tintColor = GREEN_19b8;
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)backBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentY = self.myCollectionView.contentOffset.y;
    
    if (contentY > 64) {        // dang
        self.navigationController.navigationBarHidden = NO;
        
        CGFloat alpha = MIN(1, contentY/64-1);
        
        self.navigationController.navigationBar.alpha = alpha;
        self.myCollectionView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64-50);
    } else {
        self.navigationController.navigationBarHidden = YES;
        self.myCollectionView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height-64);
    }
    
}
#pragma mark - uicollectionView datasource
// section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 5;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(Screen_Width, Screen_Height*169/568);
    } else {
        return CGSizeMake(Screen_Width, 8);
    }
}
// header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView;
    if (kind == UICollectionElementKindSectionHeader) {
        // 第一部分的头部
        if (indexPath.section == 0) {
            
            SSImagePlayerCollectionReusableView * imageHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SSHomeHeader" forIndexPath:indexPath];
            imageHeaderView.imageDataSource = @[@"http://oi653ezan.bkt.clouddn.com/banner1.png",@"http://oi653ezan.bkt.clouddn.com/banner2.png",@"http://oi653ezan.bkt.clouddn.com/banner3.png"];
            headerView = imageHeaderView;
        } else {    // 第二部分的头部
            FootCollectionReusableView *grayView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"grayView" forIndexPath:indexPath];
            headerView = grayView;
        }
        
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake((Screen_Width-5*22)/3, Screen_Height * 72/568);
    } else {
        return CGSizeMake(Screen_Width, Screen_Height*99/568);
    }
}
- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(22, 22, 22, 22);
    }
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 22;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *aCell;
    if (indexPath.section == 0) {
        SSHomeLogoTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"logotextCell" forIndexPath:indexPath];
        
        [cell.imageBtn setImage:[UIImage imageNamed:logoArray[indexPath.item][@"logo"]] forState:0];    //  设置图标
        cell.titleLabel.text = logoArray[indexPath.item][@"name"];  // 设置文字
        if (indexPath.item == 1) {
            cell.imageBtn.backgroundColor = [UIColor colorWithHex:0x9795fb];
        }else {
            
            cell.imageBtn.backgroundColor = [UIColor colorWithHex:0x47A7F3];
        }
        
        aCell = cell;
    } else {
        SSHomeCollectionViewCell *homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCell" forIndexPath:indexPath];
        aCell = homeCell;
    }
    return aCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            PaySocialSecurityViewController *payVC = [PaySocialSecurityViewController new];
            payVC.vctype = 0;
            payVC.title = @"缴社保";
            [self.navigationController pushViewController:payVC animated:YES];
        } else if (indexPath.item == 1) {
            PaySocialSecurityViewController *payVC = [PaySocialSecurityViewController new];
            payVC.title = @"续缴社保";
            payVC.vctype = 1;
            [self.navigationController pushViewController:payVC animated:YES];
        } else {
            PayTransferViewController *transferVC = [PayTransferViewController new];
            [self.navigationController pushViewController:transferVC animated:YES];
        }
    }
}

#pragma mark - lazy load
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES:NO) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        // 图片轮播
        [_myCollectionView registerClass:[SSImagePlayerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SSHomeHeader"];
        // logo text cell
        [_myCollectionView registerClass:[SSHomeLogoTextCollectionViewCell class] forCellWithReuseIdentifier:@"logotextCell"];
        // 灰色分割线
        [_myCollectionView registerClass:[FootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"grayView"];
        // section = 2 's cell
        [_myCollectionView registerClass:[SSHomeCollectionViewCell class] forCellWithReuseIdentifier:@"homeCell"];
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
