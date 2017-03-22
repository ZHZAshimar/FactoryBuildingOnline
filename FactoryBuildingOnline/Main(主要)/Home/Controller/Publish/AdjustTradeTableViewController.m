//
//  SelectDepositTableViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "AdjustTradeTableViewController.h"

#import "AdjustTradeTableViewCell.h"
@interface AdjustTradeTableViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger selectedCount;
    
}

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation AdjustTradeTableViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setVCName:@"适用行业" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    [self addRightItemWithString:@"完成" andItemTintColor:GREEN_19b8];
    self.dataSource = [NSMutableArray arrayWithArray:@[
                                                       @{@"title":@"医药卫生",@"isSelect":@(0)},
                                                       @{@"title":@"机械机电",@"isSelect":@(0)},
                                                       @{@"title":@"轻工食品",@"isSelect":@(0)},
                                                       @{@"title":@"服装纺织",@"isSelect":@(0)},
                                                       @{@"title":@"办公文教",@"isSelect":@(0)},
                                                       @{@"title":@"电子电工",@"isSelect":@(0)},
                                                       @{@"title":@"家居用品",@"isSelect":@(0)}]];
    
//    if (self.depositStr.length > 0) {
//        
//        // 获取已选的 押金方式
//        int i = 0;
//        for (NSString *str in self.dataSource) {
//            if ([str isEqualToString:self.depositStr]) {
//                
//                selectedIndex = i;
//            }
//            i++;
//        }
//    }
    
    [self.view addSubview:self.myTableView];
    selectedCount = 1;
}
// 完成
- (void)rightItemButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AdjustTradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adjustCell"];
    
    if (!cell) {
        cell = [[AdjustTradeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"adjustCell"];
    }
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    cell.titleLabel.text = dic[@"title"];
    
//    if (self.depositStr.length > 0 && indexPath.row == selectedIndex) {         // 绘制选中的钩钩
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_publish"]];
//        
//        imageView.frame = CGRectMake(Screen_Width - 30, 16, 16, 11);
//
//    }
    
    return cell;
}

#pragma mark - tableVeiw delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[indexPath.row]];
    
    NSInteger index = [mDic[@"isSelect"] integerValue];
    
    AdjustTradeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (index == 0) {
        
        if (selectedCount > 2) {
            [MBProgressHUD showError:@"选择项不能超过两个" ToView:nil];
            return;
        }
        
        cell.selectImageView.image = [UIImage imageNamed:@"choose_publish"];
        [mDic setValue:@(1) forKey:@"isSelect"];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:mDic];
        
        
        selectedCount ++;
    } else {
        cell.selectImageView.image = [UIImage imageNamed:@""];
        
        [mDic setValue:@(0) forKey:@"isSelect"];
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:mDic];
        selectedCount -- ;
    }
//    self.depositTypeBlock (self.dataSource[indexPath.row]);
}

#pragma mark - lazy load

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.tableFooterView = [[UIView alloc] init];
        
        [_myTableView registerClass:[AdjustTradeTableViewCell class] forCellReuseIdentifier:@"adjustCell"];
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
