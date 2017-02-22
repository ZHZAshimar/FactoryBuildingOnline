//
//  BrokerInfoViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/6.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BrokerInfoViewController.h"

#import "BrokerDetailViewController.h"
#import "FivePathCollectionViewCell.h"
#import "BrokerHeaderCollectionReusableView.h"
#import "FactoryDetailViewController.h"
#import "HomeRequest.h"
#import "SearchRequest.h"

@interface BrokerInfoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    SearchRequest *searchRequest;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;

@property (nonatomic, strong) UIView *footView;

@property (nonatomic, strong) NSMutableArray *mDataSource;

@end

@implementation BrokerInfoViewController

- (void)dealloc {
    
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden: YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVCName:@"经纪人信息" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
    self.mDataSource = [NSMutableArray array];
    
    [self.view addSubview:self.myCollectionView];
    
    [self.view addSubview:self.footView];
    
    [self getData];
}
- (void)getData {
    
    HomeRequest *homeRequest = [HomeRequest new];
    
    [homeRequest getBrokerPublishSourceWithDic:self.infoDic];
    
    __weak typeof (self) weakSelf = self;
    
    homeRequest.publishBlock = ^(NSMutableArray *mArr) {
        
        weakSelf.mDataSource = mArr;
        
        [weakSelf.myCollectionView reloadData];
        
    };
    
}

#pragma mark - 发送短信 和拨打电话
- (void)sendMessageBtnAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.infoDic[@"phone_num"]]]];
}

- (void)callPhoneBtnAction:(UIButton *)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.infoDic[@"phone_num"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.infoDic[@"phone_num"]]]];
}

#pragma mark collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mDataSource.count;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Screen_Width, Screen_Width/2);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(Screen_Width, 128);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        BrokerHeaderCollectionReusableView *brokerHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        brokerHeaderView.infoDic = self.infoDic;
        
        brokerHeaderView.publishNumLabel.text = [NSString stringWithFormat:@"(%ld)",self.mDataSource.count];
        
//        headerView = brokerHeaderView;
        return brokerHeaderView;
    }
    return headerView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FivePathCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fivecell" forIndexPath:indexPath];
//    cell.model = self.mDataSource[indexPath.item];
    cell.brokerModel = self.mDataSource[indexPath.item];
    
    return cell;
}
#pragma mark collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrokerDetailViewController *factoryDetailVC = [BrokerDetailViewController new];
    
    factoryDetailVC.model = self.mDataSource[indexPath.item];
    
    factoryDetailVC.brokerInfoDic = self.infoDic;
    
    [self.navigationController pushViewController:factoryDetailVC animated:YES];
    
}

#pragma mark - lazy load
- (UICollectionView *)myCollectionView {
    
    if (!_myCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing  = 0;
        
        layout.minimumInteritemSpacing = 0;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-49-64) collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        
        _myCollectionView.delegate = self;
        
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[FivePathCollectionViewCell class] forCellWithReuseIdentifier:@"fivecell"];
        
        [_myCollectionView registerClass:[BrokerHeaderCollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        __weak typeof (self) weakSelf = self;
        _myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            BrokerFactoryInfoModel *model = [self.mDataSource lastObject];
            
            if (model.next.length > 0) {
                searchRequest = [SearchRequest new];
                
                [searchRequest getSearchWithURL:model.next andDataType:@"2"];
                searchRequest.dataBlock = ^(NSMutableArray *dataArray){
                    for (BrokerFactoryInfoModel *model in dataArray) {
                        [weakSelf.mDataSource addObject:model];
                    }
                    [weakSelf.myCollectionView.mj_footer endRefreshing];
                    [weakSelf.myCollectionView reloadData];
                };
            } else {
                [weakSelf.myCollectionView.mj_footer endRefreshing];
            }
        }];
    }
    
    return _myCollectionView;
}

- (UIView *)footView {
    
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height-64-49, Screen_Width, 49)];
        _footView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
        view.backgroundColor = GRAY_db;
        [_footView addSubview:view];
        
        // 发送短信按钮
        UIButton *sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendMessageBtn.frame = CGRectMake(Screen_Width/9, 8, Screen_Width/3, 35);
        [sendMessageBtn setTitle:@"发送短信" forState:UIControlStateNormal];
        [sendMessageBtn setImage:[UIImage imageNamed:@"publish_msg"] forState:UIControlStateNormal];
        [sendMessageBtn setTitleColor:BLUE_5ca6 forState:UIControlStateNormal];
        sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        sendMessageBtn.layer.borderColor = BLUE_5ca6.CGColor;
        sendMessageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        sendMessageBtn.layer.borderWidth = 1;
        sendMessageBtn.layer.cornerRadius = 5;
        sendMessageBtn.layer.masksToBounds = YES;
        [sendMessageBtn addTarget:self action:@selector(sendMessageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:sendMessageBtn];
        
        // 发送短信按钮
        UIButton *callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        callPhoneBtn.frame = CGRectMake(Screen_Width*2/9+Screen_Width/3, 8, Screen_Width/3, 35);
        [callPhoneBtn setTitle:@"电话拨打" forState:UIControlStateNormal];
        [callPhoneBtn setImage:[UIImage imageNamed:@"publish_tel"] forState:UIControlStateNormal];
        [callPhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [callPhoneBtn setTintColor:[UIColor whiteColor]];
        callPhoneBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        callPhoneBtn.backgroundColor = GREEN_19b8;
        callPhoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        callPhoneBtn.layer.cornerRadius = 5;
        callPhoneBtn.layer.masksToBounds = YES;
        [callPhoneBtn addTarget:self action:@selector(callPhoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:callPhoneBtn];
        
    }
    return _footView;
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
