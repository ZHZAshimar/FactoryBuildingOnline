//
//  ECCreateViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECCreateViewController.h"
#import "ECCreateTableViewCell.h"
#import "ECWriteContractViewController.h"// 房

@interface ECCreateViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *dataSource;
}
@property (nonatomic, strong) UITableView *myTabelView;
@end

@implementation ECCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    // Do any additional setup after loading the view.
    [self initArray];
    [self.view addSubview:self.myTabelView];
    
}
#pragma mark - 设置导航栏
- (void)setNavigation {
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closeBack"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];   // 设置返回按钮
    
    backBtn.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)backBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]; // 设置状态栏的状态为高亮
}

- (void)initArray {
    dataSource = @[
  @{@"first":@"厂",@"title":@"厂房经济合同",@"detail":@"16",@"color":[UIColor colorWithHex:0x54B941]},
  @{@"first":@"劳",@"title":@"劳动合同",@"detail":@"14",@"color":[UIColor colorWithHex:0x3898FE]},
  @{@"first":@"装",@"title":@"装修合同",@"detail":@"14",@"color":[UIColor colorWithHex:0xFF9600]},
  @{@"first":@"房",@"title":@"个人房屋租赁合同",@"detail":@"18",@"color":[UIColor colorWithHex:0x3898FE]},
  @{@"first":@"车",@"title":@"个人车位租赁合同",@"detail":@"24",@"color":[UIColor colorWithHex:0x55b843]},
  @{@"first":@"贷",@"title":@"个人借款合同",@"detail":@"20",@"color":[UIColor colorWithHex:0xFF9600]},
  @{@"first":@"家",@"title":@"家教雇佣合同",@"detail":@"18",@"color":[UIColor colorWithHex:0xA53CF9]},
  @{@"first":@"设",@"title":@"个人设计服务合同",@"detail":@"12",@"color":[UIColor colorWithHex:0xF5DF3B]},
  @{@"first":@"服",@"title":@"个人服务合同",@"detail":@"10",@"color":[UIColor colorWithHex:0x39F0F6]}
  ];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Height *70/568;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ECCreateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECCreateTableViewCell" owner:self options:nil] firstObject];
    }
    
    NSDictionary *dic = dataSource [indexPath.row];

    cell.bigLabel.text = dic[@"first"];
    cell.bigLabel.backgroundColor = dic[@"color"];
    
    cell.nameLabel.text = dic[@"title"];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@项必填",dic[@"detail"]];
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ECWriteContractViewController *writeContractVC = [ECWriteContractViewController new];
    
    if (indexPath.row == 0) {
        writeContractVC.contractType = 0;
    } else if (indexPath.row == 3) {
        writeContractVC.contractType = 3;
    }
    
    [self.navigationController pushViewController:writeContractVC animated:YES];
    
}

#pragma mark - lazy load
- (UITableView *)myTabelView {
    if (!_myTabelView) {
        
        _myTabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTabelView.delegate = self;
        _myTabelView.dataSource = self;
        _myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTabelView;
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
