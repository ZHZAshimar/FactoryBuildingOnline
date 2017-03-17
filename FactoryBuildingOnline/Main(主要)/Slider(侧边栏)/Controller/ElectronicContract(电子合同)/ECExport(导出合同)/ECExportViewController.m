//
//  ECExportViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECExportViewController.h"

#import "ECExportTableViewCell.h"

#import "ShareViewOfContract.h"

@interface ECExportViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *dataSource;
}
@property (nonatomic, strong) UITableView *myTabelView;
@end

@implementation ECExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self initArray];
    [self.view addSubview:self.myTabelView];
    
}

- (void) setNavigation {
    
    UIBarButtonItem *exportBtn = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportBtnAction)];
    exportBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = exportBtn;
    
}
#pragma MARK - 导出按钮
- (void)exportBtnAction {
    ShareViewOfContract *shareView = [[ShareViewOfContract alloc] init];
    [shareView show];
}

- (void)initArray {
    
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Height *172/568;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ECExportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECExportTableViewCell" owner:self options:nil] firstObject];
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
