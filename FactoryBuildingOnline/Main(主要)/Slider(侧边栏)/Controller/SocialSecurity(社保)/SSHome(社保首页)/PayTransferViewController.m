//
//  PayTransferViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/16.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "PayTransferViewController.h"
#import "PaySSBottomView.h"
#import "SStransferFooterView.h"

@interface PayTransferViewController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
{
    NSArray *textArray;
}
@property (nonatomic, strong) PaySSBottomView *bottomView;
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation PayTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.bottomView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setNavigation {
    self.navigationItem.hidesBackButton = YES;  // 隐藏返回按钮
    // 自定义返回按钮
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftBack"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    btnItem.tintColor = BLACK_42;
    self.navigationItem.leftBarButtonItem = btnItem;
    
    self.title = @"社保转移";
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Screen_Height*158/568;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height*158/568)];
    headerView.backgroundColor = [UIColor colorWithHex:0xF4F5F9];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height*98/568)];
    imageView.image = [UIImage imageNamed:@"loading"];
    [headerView addSubview:imageView];
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height*98/568, Screen_Width, Screen_Height *53/568)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, Screen_Width-24, whiteView.frame.size.height)];
    label.text = @"适用场景：参保人需要跨省区转养老医疗关系，合并两地社保账户";
    label.textColor = BLACK_42;
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13]];
    
    [whiteView addSubview:label];
    [headerView addSubview:whiteView];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return Screen_Height *195/568;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SStransferFooterView *footerView = [[SStransferFooterView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height *195/568)];
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    // 设置 textlabel
    cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"办理项目";
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"请选择";
        cell.detailTextLabel.textColor = [UIColor colorWithHex:0x666666];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11.0]];
    } else {
        UITextField *detailTF = [[UITextField alloc] initWithFrame:CGRectMake(Screen_Width/2-12, 0, Screen_Width/2, cell.frame.size.height)];
        detailTF.textAlignment = NSTextAlignmentRight;
        detailTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11.0]];
        detailTF.tag = indexPath.row;
        detailTF.delegate = self;
        if (indexPath.row == 1) {
            cell.textLabel.text = @"办理人";
            detailTF.placeholder = @"请输入名称";
        } else {
            detailTF.placeholder = @"请输入说明";
            cell.textLabel.text = @"说明";
        }
        [cell addSubview:detailTF];
    }
    return cell;
}



#pragma mark - lazyload
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-55) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _myTableView;
}

- (PaySSBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PaySSBottomView alloc] initWithFrame:CGRectMake(0, Screen_Height-55, Screen_Width, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.bottomType = 1;
        _bottomView.tagBlock = ^(NSInteger tagIndex){
            switch (tagIndex) {
                case 100:
                {
                    NSLog(@"服务");
                }
                    break;
                case 103:
                {
                    NSLog(@"热线");
                }
                    break;
                case 104:
                {
                    NSLog(@"办理转移");
                }
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _bottomView;
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
