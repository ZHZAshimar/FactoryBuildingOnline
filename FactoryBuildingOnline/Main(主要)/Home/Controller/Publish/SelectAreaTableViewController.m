//
//  SelectAreaTableViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SelectAreaTableViewController.h"

@interface SelectAreaTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSDictionary *dataDict;



@end

@implementation SelectAreaTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
    [self setNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.myTableView.delegate = nil;
    
    self.myTableView.dataSource = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.dataDict = [NSDictionary dictionary];
    
    
    [self.view addSubview:self.myTableView];
    
    [self getData];
}

- (void)setNavigationBar {
    
    self.title = @"选择区域";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(-10, 0, 50, 44);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [backButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [backButton setTitleColor:GREEN_19b8 forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView: backButton];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"CityInfo" ofType:@"plist"];
    
    self.dataDict = [NSDictionary dictionaryWithContentsOfFile:dataPath];
    
}

#pragma mark - tableView datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    tableView.tableHeaderView = [[UIView alloc] init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 88.0f)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(11, 15, 4, 14)];
    greenView.backgroundColor = GREEN_19b8;
    [view addSubview:greenView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Screen_Width-44, 44)];
    label.text = @"当前可选城市";
    label.textColor = BLACK_42;
    label.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:label];
    
    UIView *linecutView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, Screen_Width, 1)];
    linecutView.backgroundColor = GRAY_db;
    [view addSubview:linecutView];
    
    // 显示定位的城市
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 44, Screen_Width, 43);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:GREEN_1ab8 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:2.0f];
    [button setTitle:@"东莞" forState:UIControlStateNormal];
    [view addSubview:button];
//    [button addTarget:self action:@selector(backHomeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-165, 44, 150, 44)];
    cityLabel.textColor = GREEN_1ab8;
    cityLabel.textAlignment = NSTextAlignmentRight;
    cityLabel.font = [UIFont systemFontOfSize:12.0f];
    cityLabel.text = @"选择区域";
    cityLabel.hidden = NO;
    [view addSubview:cityLabel];
    
    if (self.selectedStr.length > 0 && ![self.selectedStr isEqualToString:@"请选择您想发布的区域"]) {
        cityLabel.text = self.selectedStr;
    }
    
    
    // 障眼法：由于此处的布局 header是不悬停的，固采 tableView 用 group 样式，而group 样式的section前后都会添加一条 宽度 为 屏幕宽度的分割线。所以这个View 是用于挡住 sectionView 的分割线，挡住前15个像素。为了避免 绿色的重用，直接把 定位城市添加到headerView 中。
    UIView *linecutView_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 87, 15, 2)];
    linecutView_bottom.backgroundColor = [UIColor whiteColor];
    [view addSubview:linecutView_bottom];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.dataDict[@"child"];
    
    return array.count;
    
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataDict[@"child"][indexPath.row];
    
    cell.textLabel.text = dic[@"name"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    cell.textLabel.textColor = BLACK_42;
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataDict[@"child"][indexPath.row];
    
    self.selectAreaBlock(dic[@"name"],dic[@"id"],@"东莞市",self.dataDict[@"id"]);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy load 
- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height+44) style:UITableViewStyleGrouped];
        
        _myTableView.dataSource = self;
        
        _myTableView.delegate = self;
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        
    }
    return _myTableView;
}
- (void)hideEmptySeparators:(UITableView *)tableView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView setTableFooterView:v];
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
