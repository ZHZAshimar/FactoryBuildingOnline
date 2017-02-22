//
//  SettingTableViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SettingTableViewController.h"


#import <UIImageView+WebCache.h>
#import "AboutUsViewController.h"
#import "VersionInfoViewController.h"
#import "ShowQRCodeViewController.h"
#import "WantedMessageModel.h"
#import "SearchFile.h"

@interface SettingTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    UILabel *cacheLabel;
}
@property (nonatomic, strong)UITableView *myTableView;

@end

@implementation SettingTableViewController

- (void)dealloc {
    
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setVCName:@"设置" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
    titleArray = @[@[@"清空缓存"],@[@"关于我们",@"版权信息",@"推荐二维码"]];
    
    [self.view addSubview:self.myTableView];
    
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Height *11/142;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = titleArray[indexPath.section][indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14]];
    
    cell.textLabel.textColor = BLACK_42;
    
    if (indexPath.section == 0) {
        
        cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-130, 0, 100, Screen_Height *11/142)];;
        cacheLabel.textColor = GRAY_9e;
//        cacheLabel.backgroundColor = YELLOW_bg;
        cacheLabel.textAlignment = NSTextAlignmentRight;
        cacheLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12]];
        cacheLabel.text = [NSString stringWithFormat:@"缓存：%.2fM",[self getCacheSize]];
        [cell addSubview:cacheLabel];
    }
    
    return cell;
}
#pragma mark - 计算缓存大小
- (CGFloat)getCacheSize {
    
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];    // SDWebImage里面的缓存
    
    CGFloat cacheSize = size/1024.00/1024.00;
    
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 计算数据库的大小
    NSString *dbPath = [paths stringByAppendingPathComponent:@"FactoryDataCache.db"];
    
    CGFloat dbSize = [self fileSizeAtPath:dbPath]/(1024.00*1024.00);
    
    cacheSize += dbSize;
    
    // 计算搜索文本的大小
    NSString *searchTextPath = [paths stringByAppendingPathComponent:@"searchText.txt"];
    
    CGFloat searchSize = [self fileSizeAtPath:searchTextPath]/(1024.00*1024.00);
    
    cacheSize += searchSize;
    
    return cacheSize;
}

- (long long) fileSizeAtPath:(NSString *)filePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [[SDImageCache sharedImageCache] clearDisk];
        cacheLabel.text = @"缓存：0.00M";
        
        [WantedMessageModel deleteDatabase];  // 删除数据库
        [SearchFile deleteSearchFile];  // 删除文件
    } else {
    
        switch (indexPath.row) {
            case 0: // 关于我们
            {
                AboutUsViewController *aboutVC = [AboutUsViewController new];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            case 1: // 版权信息
            {
                VersionInfoViewController *versionVC = [VersionInfoViewController new];
                
                [self.navigationController pushViewController:versionVC animated:YES];
            }
                break;
            case 2: // 推荐二维码
            {
                ShowQRCodeViewController *QRCodeVC = [ShowQRCodeViewController new];
                [self.navigationController pushViewController:QRCodeVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.backgroundColor = GRAY_F5;
        
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.sectionFooterHeight = 10.0f;
        
        [_myTableView setSeparatorColor:GRAY_db];   // 设置tableView 分割线的颜色
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
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
