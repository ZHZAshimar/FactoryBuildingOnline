//
//  SelectIdentityTableViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ParkMakingTypeTableViewController.h"
#import "AdjustTradeTableViewCell.h"

@interface ParkMakingTypeTableViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger selectedCount;        // 记录选中的个数
}

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ParkMakingTypeTableViewController

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
    selectedCount = 1;
    [self setVCName:@"适用行业" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    [self addRightItemWithString:@"完成" andItemTintColor:GREEN_19b8];
    self.dataSource = [NSMutableArray arrayWithArray:@[
                                                       @{@"title":@"其他",@"isSelect":@(0)},
                                                       @{@"title":@"停车场",@"isSelect":@(0)},
                                                       @{@"title":@"篮球场",@"isSelect":@(0)},
                                                       @{@"title":@"图书馆",@"isSelect":@(0)},
                                                       @{@"title":@"健身中心",@"isSelect":@(0)},
                                                       @{@"title":@"超市",@"isSelect":@(0)},
                                                       @{@"title":@"党员活动中心",@"isSelect":@(0)},
                                                       @{@"title":@"咖啡厅",@"isSelect":@(0)}]];
    
    // 将拿到的字符串进行分解，确定已选的项
    if (self.parkTypeStr.length > 0) {
        
        if (self.parkTypeStr.length > 4) {
            
            NSArray *strArray = [self.parkTypeStr componentsSeparatedByString:@"/"];
            NSMutableArray *mArray = [NSMutableArray array];
            // 获取已选的 押金方式
            for (NSString *str in strArray) {
                
                int i = 0;
                // 遍历数组，拿到指定的index
                for (NSMutableDictionary *mDic in self.dataSource) {
                    
                    if ([mDic[@"title"] isEqualToString:str]) {
                        [mArray addObject:@(i)];
                        
                        selectedCount++;
                        
                    }
                    i++;
                }
                
            }
            // 遍历指定的index的数组，修改dataSource数组
            for (NSString *str in mArray) {
                NSInteger index = [str integerValue];
                NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[index]];
                [mDic setValue:@(1) forKey:@"isSelect"];
                [self.dataSource replaceObjectAtIndex:index withObject:mDic];
            }
            
        } else {
            // 获取已选的 押金方式
            int i = 0;
            for (NSMutableDictionary *mDic in self.dataSource) {
                
                if ([mDic[@"title"] isEqualToString:self.parkTypeStr]) {
                    selectedCount++;
                    break;
                }
                i++;
            }
            
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[i]];
            [mDic setValue:@(1) forKey:@"isSelect"];
            [self.dataSource replaceObjectAtIndex:i withObject:mDic];
            
        }
        
    }
    
    [self.view addSubview:self.myTableView];
    
}
#pragma mark - 完成
- (void)rightItemButtonAction {
    NSString *indexStr = @"";
    self.parkTypeStr = @"";
    
    int i = 0,count = 0;
    for (NSMutableDictionary *dic in self.dataSource) {
        
        if ([dic[@"isSelect"] integerValue] == 1) {
            if (count == 0) {
                self.parkTypeStr = dic[@"title"];
                indexStr = [NSString stringWithFormat:@"%d",i];
            } else {
                self.parkTypeStr = [NSString stringWithFormat:@"%@/%@",self.parkTypeStr,dic[@"title"]];
                indexStr = [NSString stringWithFormat:@"%@,%d",indexStr,i];
            }
            
            count++;
        }
        i++;
        
    }
    self.parkTypeBlock (self.parkTypeStr,indexStr);
    
    
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
    
    if ([dic[@"isSelect"] intValue] == 0) {
        cell.selectImageView.image = [UIImage imageNamed:@""];
    } else {
        cell.selectImageView.image = [UIImage imageNamed:@"choose_publish"];
    }
    
    
    
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
