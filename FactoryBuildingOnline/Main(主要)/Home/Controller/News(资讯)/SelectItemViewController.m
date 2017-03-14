//
//  SelectItemViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/9.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SelectItemViewController.h"
#import "TextCollectionViewCell.h"      // 文字cell
#import "NewsChannelHeaderCollectionReusableView.h"
#import "SearchFile.h"

@interface SelectItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray *allChannelArray;   // 所有频道
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *recommendChannelArray;
@end

@implementation SelectItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initArray];
    [self.view addSubview:self.myCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES];
    [self initNavi];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
// 设置数组
- (void)initArray {
    self.recommendChannelArray = [NSMutableArray array];
    allChannelArray = @[@"推荐",@"行情",@"排行榜",@"小视频",@"附近",@"FM"];
    [self.recommendChannelArray addObjectsFromArray:allChannelArray];
    for (NSString *title in self.myChannelArray) {
        if ([allChannelArray containsObject:title]) {
            [self.recommendChannelArray removeObject:title];
        }
    }
}
// 设置导航栏
- (void)initNavi {
    self.navigationController.navigationBar.barTintColor = GRAY_F5;
    
    [self addRightItemWithLogo:[UIImage imageNamed:@"closeBack"] andItemTintColor:GREEN_19b8];
    
    self.view.backgroundColor = GRAY_F5;
}

- (void)setMyChannelArray:(NSMutableArray *)myChannelArray {
    _myChannelArray = myChannelArray;
}

- (void)rightItemButtonAction {
    
    [SearchFile deleteSearchFileWithdocumentNamue: @"MyChannel.txt"];
    [SearchFile writeSearchFileArray:self.myChannelArray documentNamue:@"MyChannel.txt"];
    NSLog(@"%@",self.myChannelArray);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 编辑按钮
- (void)editBtnAction:(UIButton *)button {
    NSLog(@"编辑");
}

#pragma mark - collectinView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, Screen_Height*50/568);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        NewsChannelHeaderCollectionReusableView *channelHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            channelHeaderView.cellTitle.text = @"我的频道";
            channelHeaderView.isShowEditBtn = YES;
            [channelHeaderView.editButton addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            channelHeaderView.cellTitle.text = @"推荐频道";
            channelHeaderView.isShowEditBtn = NO;
        }
        headerView = channelHeaderView;
    }
    return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.myChannelArray.count;
    } else {
        return self.recommendChannelArray.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width-24-4*10)/4, Screen_Height*25/568);
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"textCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.label.text = self.myChannelArray[indexPath.item];
        
    } else {
        cell.label.text = self.recommendChannelArray[indexPath.item];
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    
    if (sourceIndexPath.section == 0) {
        
        // 取出源item数据
        id objc = [self.myChannelArray objectAtIndex:sourceIndexPath.item];
        //从资源数组中移除该数据
        [self.myChannelArray removeObject:objc];
        //将数据插入到资源数组中的目标位置上
        [self.myChannelArray insertObject:objc atIndex:destinationIndexPath.item];
        
    }
    
    [self.myCollectionView reloadData];
}

#pragma mark - collectionView delegate 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSString *channel = self.myChannelArray[indexPath.row];
        [self.myChannelArray removeObject:channel];
        [self.recommendChannelArray addObject:channel];
        
    } else {
        
        NSString *channel = self.recommendChannelArray[indexPath.row];
        [self.recommendChannelArray removeObject:channel];
        [self.myChannelArray addObject:channel];
        
    }
    
    [self.myCollectionView reloadData];
}

- (void)handleLongGesture: (UILongPressGestureRecognizer *)sender {
    
    switch (sender.state) { // 判断手势状态
        case UIGestureRecognizerStateBegan:
        {
            // 判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.myCollectionView indexPathForItemAtPoint:[sender locationInView:self.myCollectionView]];
            if (indexPath == nil) {
                break;
            }
            // 在路径上则开始移动该路径上的cell
            [self.myCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            // 移动过程当中随时更新cell位置
            [self.myCollectionView updateInteractiveMovementTargetPosition:[sender locationInView:self.myCollectionView]];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            // 移动结束后关闭cell移动
            [self.myCollectionView endInteractiveMovement];
            
        }
            break;
            
        default:
            [self.myCollectionView cancelInteractiveMovement];
            break;
    }
}


- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor clearColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        [_myCollectionView registerClass:[TextCollectionViewCell class] forCellWithReuseIdentifier:@"textCell"];
        [_myCollectionView registerClass:[NewsChannelHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        
//        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
//        
//        [_myCollectionView addGestureRecognizer:longGesture];

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
