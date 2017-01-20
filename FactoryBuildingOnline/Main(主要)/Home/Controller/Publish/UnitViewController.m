//
//  UnitViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "UnitViewController.h"

@interface UnitViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation UnitViewController

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
    
    [self.view addSubview:self.myTableView];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"元/月";
    }else {
        cell.textLabel.text = @"元/m²/天";
    }
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = GRAY_198.CGColor;
    
    return cell;
    
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.unitBlock(indexPath.row);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 8, Screen_Width-16, Screen_Height-16) style:UITableViewStylePlain];
        _myTableView.backgroundColor = GRAY_LIGHT;
        
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
        _myTableView.tableFooterView = [[UIView alloc] init];
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
