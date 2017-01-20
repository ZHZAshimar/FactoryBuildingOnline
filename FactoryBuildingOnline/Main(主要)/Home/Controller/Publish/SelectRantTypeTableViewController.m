//
//  SelectIdentityTableViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SelectRantTypeTableViewController.h"

@interface SelectRantTypeTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger selectedIndex;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation SelectRantTypeTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.myTableView.delegate = nil;
    
    self.myTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setVCName:@"出租方式" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.myTableView];
    
    self.dataSource = @[@"整租",@"分租"];
    
    if (self.rantStr.length > 0) {
        
        int i = 0;
        
        for (NSString *str in self.dataSource) {
            
            if ([str isEqualToString:self.rantStr]) {
                selectedIndex = i;
            }
            i++;
        }
    }
    
    
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    cell.textLabel.textColor = BLACK_42;
    
    if (self.rantStr.length > 0 && indexPath.row == selectedIndex) {         // 绘制选中的钩钩
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_publish"]];
        
        imageView.frame = CGRectMake(Screen_Width - 30, 16, 16, 11);
        
        [cell addSubview:imageView];
    }
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.rantBlock (self.dataSource[indexPath.row]);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy load
- (UITableView *)myTableView {
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.tableFooterView = [[UIView alloc] init];
        
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
