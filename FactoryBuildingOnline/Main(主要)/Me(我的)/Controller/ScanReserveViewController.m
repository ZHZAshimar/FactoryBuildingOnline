//
//  ScanReserveViewController.m
//  FactoryBuildingOnline
//
//  Created by Ashimar ZHENG on 2017/2/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ScanReserveViewController.h"
#import "MyReserveCollectionViewCell.h"


@interface ScanReserveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat oneLineHeight;  // 一行文字的高度
    EmptyView *emptyView;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSMutableArray *heightmArray;
@property (nonatomic, strong) NSMutableArray *selectmArray;
@property (nonatomic, strong) NSString *nextURL;
@end

@implementation ScanReserveViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVCName:@"我发布的预约" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];
    
    self.mArray = [NSMutableArray array];
    self.heightmArray = [NSMutableArray array];
    self.selectmArray = [NSMutableArray array];
    
    
    [self.view addSubview:self.myCollectionView];
    
    [self getData];
}

- (void)getData {
    
    emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds];
    emptyView.image = [UIImage imageNamed:@"error_1"];
    
    
    [HTTPREQUEST_SINGLE getUserInfo:@"user/publications/needs/" andParameters:nil success:^(RequestManager *manager, NSDictionary *response, NSString *time) {
       
        NSLog(@"%@",response);
        if ([response[@"erro_code"] intValue] != 200) {
            
            emptyView.emptyStr = [NSString stringWithFormat:@"%@",response[@"erro_msg"]];
            [self.view addSubview:emptyView];
            
            return ;
        }
        
        NSArray *neededArray = response[@"neededMessage"];
        self.nextURL = response[@"next"];
        for (NSDictionary *dic in neededArray) {
            [self.mArray addObject:dic];
        }
        
        for (int i = 0; i < self.mArray.count; i++) {
            [self.selectmArray addObject:@(0)];
        }
        [self.myCollectionView reloadData];
        
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}

- (void)getNextURLData{
    
    [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:self.nextURL andParameters:nil andShouldToken:YES success:^(RequestManager *manager, NSDictionary *response) {
        [self.myCollectionView.mj_footer endRefreshing];
        for (NSDictionary *dic in response[@"neededMessage"]) {
            [self.mArray addObject:dic];
        }
        self.nextURL = response[@"next"];
        [self.myCollectionView reloadData];
        
    } failure:^(RequestManager *manager, NSError *error) {
        [self.myCollectionView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat contentHeight = [NSString getHeightOfAttributeRectWithStr:self.mArray[indexPath.item][@"need"][@"content"] andSize:CGSizeMake(Screen_Width-33, 2000) andFontSize:[UIFont adjustFontSize:14] andLineSpace:10];
    
    // 将拿到高度添加到 高度数组中
    [self.heightmArray addObject:@(contentHeight)];
    
    oneLineHeight = [NSString getHeightOfAttributeRectWithStr:@"计算单一行文字的高度" andSize:CGSizeMake(Screen_Width-33, 20000) andFontSize:[UIFont adjustFontSize:14] andLineSpace:10];
    // 计算行数
    CGFloat lineNum = contentHeight/oneLineHeight;
    
    if (lineNum > 2) {  // 当行数大于二的时候
        
        BOOL  isShow= [self.selectmArray[indexPath.item] boolValue];
        
        if (isShow) {
            
            return CGSizeMake(Screen_Width, contentHeight+20+13+7+8+10+8);
            
        } else {
        
            return CGSizeMake(Screen_Width, oneLineHeight*2+20+13+7+8+10+8);
        }
    } else if (lineNum > 1 && lineNum <=2 ) {   // 行数在 （1,2]之间
        return CGSizeMake(Screen_Width, contentHeight+20+13+10+8);
    } else { // 一行的时候
        return CGSizeMake(Screen_Width, contentHeight+20+13+8+8);
    }
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyReserveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyReserveCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.mArray[indexPath.item];
    
    CGFloat lineNum = [self.heightmArray[indexPath.item] floatValue]/oneLineHeight;
    
    if (lineNum > 2) {

        cell.contentLabelBttom.constant = 23.5;
        BOOL isShow = [self.selectmArray[indexPath.item] boolValue];
        
        if (isShow) {
            cell.myImageView.image = [UIImage imageNamed:@"reserve_up"];
        } else {
            cell.myImageView.image = [UIImage imageNamed:@"reserve_down"];
        }
        cell.contentLabel.attributedText = [NSString attributedString:dic[@"need"][@"content"] andTextWidth:5000 andLineSpace:10];
    } else if (lineNum > 1 && lineNum <= 2 ){
       
        cell.contentLabelBttom.constant = 8;
        
        cell.contentLabel.attributedText = [NSString attributedString:dic[@"need"][@"content"] andTextWidth:100 andLineSpace:10];
    } else {
        cell.contentLabelBttom.constant = 8;
        
        cell.contentLabel.text = dic[@"need"][@"content"];
    }
    
    
//    self.contentLabel.attributedText = [NSString attributedString:contentStr andTextWidth:5000 andLineSpace:10];
    
    cell.dataDic = dic;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (oneLineHeight *2 < [self.heightmArray[indexPath.item] floatValue]) {
        NSLog(@"点中要展开的Cell");
        BOOL isChoose = [self.selectmArray[indexPath.item] intValue];
        
        [self.selectmArray replaceObjectAtIndex:indexPath.item withObject:@(!isChoose)];
        [self.myCollectionView reloadData];
    }
    
}

- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = GRAY_F5;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        [_myCollectionView registerClass:[MyReserveCollectionViewCell class] forCellWithReuseIdentifier:@"MyReserveCollectionViewCell"];
        
        _myCollectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            if (![self.nextURL isEqual:[NSNull null] ]) {
                [self getNextURLData];
                return ;
            }
            [_myCollectionView.mj_footer endRefreshing];
        }];
    }
    return _myCollectionView;
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
