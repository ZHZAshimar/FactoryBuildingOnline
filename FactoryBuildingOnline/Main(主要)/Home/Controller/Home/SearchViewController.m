//
//  SearchViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/7.
//  Copyright © 2016年 XFZY. All rights reserved.
//  搜索界面

#import "SearchViewController.h"
#import "SearchVCCollectionView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "SearchFile.h"
#import "SearchRequest.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>
{
    SearchRequest *searchRequest;
    
}
@property (nonatomic, strong) SearchVCCollectionView *searchCollectionView;
@property (nonatomic, strong) NSMutableArray *writeArray;       // 写入 搜索历史的数组
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) NSString *searchFile;             // 搜索文件的名称
@end

@implementation SearchViewController

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];  // 在视图将要离开 status bar 状态栏 设置成默认
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    [self setNavigation];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.writeArray = [NSMutableArray array];
    
    [self.view addSubview:self.searchCollectionView];
    self.searchFile = @"searchText.txt";
    NSArray *tmpArr = [SearchFile readFileArrayWithdocumentNamue:self.searchFile];          // 从沙盒中读取文件
    
    self.searchCollectionView.historyArray = tmpArr;       // 将读取到的数据赋值给collectionView de array
    
    if (tmpArr.count > 0) {
        
        for (NSString *str in tmpArr) {
            
            [self.writeArray addObject:str];
        }
    }
    searchRequest = [[SearchRequest alloc] init];   // 初始化搜索的数据请求类
}

#pragma mark - 设置导航栏  
- (void)setNavigation {
    
    self.navigationController.navigationBar.barTintColor = GREEN_1ab8;  // 设置navigation bar背景颜色
    
    // 将状态栏变成白色 在 info文件 添加 View controller-based status bar appearance 设置为no
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self setVCName:@"" andShowSearchBar:YES andTintColor:nil andBackBtnStr:nil];   // 设置名称
    
    self.searchBarOfNavi.frame = CGRectMake(19, 2, Screen_Width*4/5-10, 40);        // 设置搜索栏的位置
    
    self.searchBarOfNavi.placeholder = @"请输入地段/面积/关键字";
    
    self.searchBarOfNavi.delegate = self;
    
    [self.searchBarOfNavi becomeFirstResponder];
    
    [self addRightItemWithString:@"取消" andItemTintColor:[UIColor whiteColor]];     // 设置右边的取消按钮的
    
    self.navigationItem.hidesBackButton = YES;  // 隐藏 back button
}
#pragma mark - 取消按钮的点击事件
- (void)rightItemButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据请求
- (void)requestNet:(NSString *)key {
    
    [searchRequest searchRequestNetWork:key];       // 进行请求
    
    __weak SearchViewController *weakSelf = self;
    
    searchRequest.dataBlock = ^(NSMutableArray *dataArray){ // 请求的数据回调
        
        if (dataArray.count <= 0) {
            NSLog(@"暂无搜索结果");
            [MBProgressHUD showError:@"暂无相关信息" ToView:nil];
        }
        weakSelf.searchCollectionView.dataArray = dataArray;
        weakSelf.searchCollectionView.keyStr = key;
        
    };
    
    searchRequest.errorMsgBlock = ^(NSString *errorMsg) {
        
        [MBProgressHUD showError:errorMsg ToView:nil];
        
        [weakSelf.searchCollectionView.dataArray removeAllObjects];
        
        [weakSelf.searchCollectionView reloadData];
    };

}

#pragma mark - searchBar delegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%@",text);
    
    return YES;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);
    if (searchText.length < 1) {
        return;
    }
//    [self requestNet:searchText];
}

/// 响应键盘的搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];   // 注销 键盘的第一响应者
    
    [self requestNet:searchBar.text];
    
    NSLog(@"搜索");
    // 将搜索的关键字存在本地文件中
    if ([self.writeArray containsObject:searchBar.text]) {
        NSLog(@"数组已存在这个段字符串");
    } else {
        
        [self.writeArray addObject:searchBar.text];   // 将字符串保存在数组中
        
        if ([SearchFile writeSearchFileArray:self.writeArray documentNamue:self.searchFile]) {    // 写入文件
            
            self.searchCollectionView.historyArray = [SearchFile readFileArrayWithdocumentNamue:self.searchFile];
            
        }
    }
}

#pragma mark - lazyLoad
- (SearchVCCollectionView *)searchCollectionView {
    
    if (!_searchCollectionView) {
        
        UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
        
        layout.minimumLineSpacing = 5;
        
        layout.minimumInteritemSpacing = 5;
        
        _searchCollectionView = [[SearchVCCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        _searchCollectionView.backgroundColor = [UIColor whiteColor];
        
        __weak SearchViewController *weakSelf = self;
        
        // 点击搜索历史文字的标签
        _searchCollectionView.tapSearch = ^(NSString *searchStr) {
            
            weakSelf.searchBarOfNavi.text = searchStr;
            // 进行搜索
            [weakSelf requestNet:searchStr];
            NSLog(@"%@", weakSelf.searchBarOfNavi.text);
        };
        
         // 点击删除的回调
        _searchCollectionView.deleteFile = ^(BOOL flag) {
            
            [SearchFile deleteSearchFileWithdocumentNamue:weakSelf.searchFile];  // 删除文件
            
            [weakSelf.writeArray removeAllObjects];    // 删除数组
            
            weakSelf.searchCollectionView.historyArray = [SearchFile readFileArrayWithdocumentNamue:weakSelf.searchFile];    // 更新数组的内容
        };
        
        // 点击查看搜索的厂房 结果 的回调 分专家和业主
        _searchCollectionView.factoryDetail = ^(NSDictionary *dic) {
          
            if ([dic[@"count"] intValue] == 0) {
                
                return ;
            }
            
            SearchResultViewController *searchResultVC = [SearchResultViewController new];
            
            searchResultVC.dic = dic;
            
            [weakSelf.navigationController pushViewController:searchResultVC animated:YES];
//
        };
    }
    
    return _searchCollectionView;
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
