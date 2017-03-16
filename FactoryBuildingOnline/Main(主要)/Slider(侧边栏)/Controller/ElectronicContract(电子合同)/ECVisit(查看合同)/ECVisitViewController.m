//
//  ECVisitViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECVisitViewController.h"

#import "ECVisitTableViewCell.h"

@interface ECVisitViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *dataSource;
}
@property (nonatomic, strong) UITableView *myTabelView;
@end

@implementation ECVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initArray];
    [self.view addSubview:self.myTabelView];
    
}

- (void)initArray {
    
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Height *96/568;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ECVisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECVisitTableViewCell" owner:self options:nil] firstObject];
    }
    
    
    
    return cell;
}

#pragma mark - lazy load
- (UITableView *)myTabelView {
    if (!_myTabelView) {
        
        _myTabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTabelView.backgroundColor = [UIColor colorWithHex:0xF4F5F9];
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
