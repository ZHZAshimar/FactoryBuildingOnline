//
//  SelectCityTableViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/8.
//  Copyright © 2016年 XFZY. All rights reserved.
//   选择城市

#import "SelectCityTableViewController.h"
#import "HomeViewController.h"
//#import "ChineseString.h"

#define CellIdentifier @"CellIdentifer"
@interface SelectCityTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *cityListArray;
@property (nonatomic, strong) NSMutableArray *indexArray;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *indexLabel;
@end

@implementation SelectCityTableViewController

- (void)dealloc {
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVCName:@"选择城市" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];

    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    // 隐藏多余的分割线
    self.myTableView.tableFooterView = [[UIView alloc] init];

    self.myTableView.showsVerticalScrollIndicator = NO;

    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [self requestData];
    
}

- (void)requestData {
    
    self.cityListArray = @[@"东莞"];
    
    // 存放 索引 的 字母  获取城市的首字母英文
    //    self.indexArray = [ChineseString IndexArray:self.cityListArray forKey:@""];
    self.indexArray = [NSMutableArray arrayWithObjects:@"A",@"B",@"C", nil];
    NSLog(@"%@",self.indexArray);
    
    // 空页面显示
    if (self.cityListArray.count < 1) {
        
//        EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) andString:@"网络开了小差哦~"];
//        
//        [self.view addSubview:emptyView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cityListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 88.0f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}
#pragma mark - tableView 分区表头显示的 内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 88.0f)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(11, 15, 4, 14)];
    greenView.backgroundColor = GREEN_19b8;
    [view addSubview:greenView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Screen_Width-44, 44)];
    label.text = @"已开通服务城市";
    label.textColor = BLACK_42;
    label.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:label];
    
    UIView *linecutView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, Screen_Width, 1)];
    linecutView.backgroundColor = GRAY_db;
    [view addSubview:linecutView];
    
    // 显示定位的城市
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(12, 44, Screen_Width, 43);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:GREEN_1ab8 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:2.0f];
    [view addSubview:button];
    [button addTarget:self action:@selector(backHomeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-80, 44, 80, 44)];
    cityLabel.textColor = GREEN_1ab8;
    cityLabel.font = [UIFont systemFontOfSize:14.0f];
    cityLabel.text = @"当前定位";
    cityLabel.hidden = NO;
    [view addSubview:cityLabel];
    
    
    if (self.cityStr.length < 1) {
        self.cityStr = @"无法获取定位";
        cityLabel.hidden = YES;
    }
    
    [button setTitle:self.cityStr forState:UIControlStateNormal];
    
    
    // 障眼法：由于此处的布局 header是不悬停的，固采 tableView 用 group 样式，而group 样式的section前后都会添加一条 宽度 为 屏幕宽度的分割线。所以这个View 是用于挡住 sectionView 的分割线，挡住前15个像素。为了避免 绿色的重用，直接把 定位城市添加到headerView 中。
    UIView *linecutView_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 87, 15, 2)];
    linecutView_bottom.backgroundColor = [UIColor whiteColor];
    [view addSubview:linecutView_bottom];
    
    return view;
}

// 返回主页面
- (void)backHomeVC: (UIButton *)sender {
    
    
    if ([sender.titleLabel.text isEqualToString:@"无法获取定位"]) {
        return;
    }
    
    
    self.area_city(sender.titleLabel.text);
    
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - 区块快速索引
//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    return self.indexArray;
//}
//#pragma mark - 索引点击事件
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    // 设置点击索引时显示的UILabel
//
//    [self drawIndexLabel:title];
//
//    return index;
//}

- (void)drawIndexLabel:(NSString *)string {
    
    self.indexLabel.text = string;
    // 开始动画
    [UIView animateWithDuration:1.0 animations:^{
        self.indexLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.indexLabel.alpha = 0.0;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = self.cityListArray[indexPath.row];

    return cell;
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *areaStr = cell.textLabel.text;
    
    self.area_city(areaStr);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy load
//- (UITableView *)tableView {
//    
//    if (!_tableView) {
//        
//        _tableView = [[ UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height+100) style:UITableViewStylePlain];
//        
//        _tableView.backgroundColor = [UIColor clearColor];
//        
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
//        
//        // 隐藏多余的分割线
//        _tableView.tableFooterView = [[UIView alloc] init];
//        
//        //        _tableView.showsHorizontalScrollIndicator = NO;
//        
//        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
//    }
//    return _tableView;
//}

// 引索出现的label
- (UILabel*)indexLabel {
    
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width/2-Screen_Width/12, Screen_Height/2-Screen_Width/12, Screen_Width/6, Screen_Width/6)];
        
        _indexLabel.backgroundColor = NaviBackColor;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.layer.cornerRadius = 5;
        _indexLabel.layer.masksToBounds = YES;
        
        [self.view addSubview:_indexLabel];
    }
    return _indexLabel;
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
