//
//  SSMyViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/14.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SSMyViewController.h"

#import "SSMyHeaderView.h"
@interface SSMyViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *logoTextArray;
}
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation SSMyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    
    logoTextArray = @[@[
                          @{@"name":@"购买人信息",@"logo":@"ss_my"},
                          @{@"name":@"我的信息",@"logo":@"ss_myMessage"},
                          @{@"name":@"现金额",@"logo":@"ss_cashcoupon"}],
                      @[
                          @{@"name":@"邮寄地址",@"logo":@"ss_address"},
                          @{@"name":@"账户与安全",@"logo":@"ss_userSecurity"},
                          @{@"name":@"联系我们",@"logo":@"ss_callus"}],
                      ];
    
    SSMyHeaderView *headerView = [[SSMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height*218/568)];
    [self.view addSubview:headerView];
    
    [self.view addSubview:self.myTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - tableView dataSource 
// 设置返回的section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
// 设置返回的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
// 设置header的大小
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section
{
    return 8.0 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Height*45/568;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // 设置右边显示的的箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 设置logo和text
    NSDictionary *dic = logoTextArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"logo"]];
    cell.textLabel.text = dic[@"name"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];   // 设置字体大小
    cell.textLabel.textColor = BLACK_66;    // 设置文字颜色
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Screen_Height*218/568, Screen_Width, Screen_Height-Screen_Height*218/568) style:UITableViewStyleGrouped];
        _myTableView.delegate =self;
        _myTableView.dataSource =self;
        
        _myTableView.sectionFooterHeight = 1.0;
        
        _myTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
    }
    return _myTableView;
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
