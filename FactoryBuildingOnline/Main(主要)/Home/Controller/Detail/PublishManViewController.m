//
//  PublishManViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "PublishManViewController.h"
#import "PublishManHeadView.h"
#import "RecentlyPublishViewController.h"
#import "SecurityUtil.h"

@interface PublishManViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *myTableView;
@property (nonatomic, strong) UIView *footView;
@end

@implementation PublishManViewController

- (void)dealloc {
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.footView];
}

- (void)leftItemButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 发送短信 和拨打电话
- (void)sendMessageBtnAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.contanterDic[@"phone_num"]]]];
}

- (void)callPhoneBtnAction:(UIButton *)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.contanterDic[@"phone_num"]]]];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.contanterDic[@"phone_num"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 250.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PublishManHeadView *headView = [[PublishManHeadView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 250)];
    
    NSString *avatarURL = [SecurityUtil decodeBase64String:self.contanterDic[@"avatar"]];
    
    [headView.publishManHeadImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"detail_broker"]];
    
    headView.publishNameLabel.text = self.contanterDic[@"username"];
    
    [headView.backButton addTarget:self action:@selector(leftItemButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.textColor = BLACK_42;
    switch (indexPath.row) {
        case 0:
        {
            NSString * count = [NSString stringWithFormat:@"%d",12];
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"近期发布%@条记录",count]];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:RED_df3d range:NSMakeRange(4, count.length)];
            cell.textLabel.attributedText = attributedStr;
            
            // 设置
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%d条被删除",0];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%d条被举报",1];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - tableView delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
//        RecentlyPublishViewController *recentlyPublishVC = [[RecentlyPublishViewController alloc] init];
//        
//        [self.navigationController pushViewController:recentlyPublishVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark - lazy load
- (UITableView *)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 50) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = GRAY_F5;
        _myTableView.scrollEnabled = NO;                // 不允许滚动
        _myTableView.tableFooterView = [UIView new];    // 去除多余的分割线
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        
    }
    return _myTableView;
}

- (UIView *)footView {
    
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height-50, Screen_Width, 50)];
        _footView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
        view.backgroundColor = GRAY_db;
        [_footView addSubview:view];
        
        // 发送短信按钮
        UIButton *sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendMessageBtn.frame = CGRectMake(Screen_Width/9, 8, Screen_Width/3, 35);
        [sendMessageBtn setTitle:@"发送短信" forState:UIControlStateNormal];
        [sendMessageBtn setImage:[UIImage imageNamed:@"publish_msg"] forState:UIControlStateNormal];
        [sendMessageBtn setTitleColor:BLUE_5ca6 forState:UIControlStateNormal];
        sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        sendMessageBtn.layer.borderColor = BLUE_5ca6.CGColor;
        sendMessageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        sendMessageBtn.layer.borderWidth = 1;
        sendMessageBtn.layer.cornerRadius = 5;
        sendMessageBtn.layer.masksToBounds = YES;
        [sendMessageBtn addTarget:self action:@selector(sendMessageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:sendMessageBtn];
        
        // 发送短信按钮
        UIButton *callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        callPhoneBtn.frame = CGRectMake(Screen_Width*2/9+Screen_Width/3, 8, Screen_Width/3, 35);
        [callPhoneBtn setTitle:@"电话拨打" forState:UIControlStateNormal];
        [callPhoneBtn setImage:[UIImage imageNamed:@"publish_tel"] forState:UIControlStateNormal];
        [callPhoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [callPhoneBtn setTintColor:[UIColor whiteColor]];
        callPhoneBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        callPhoneBtn.backgroundColor = GREEN_19b8;
        callPhoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        callPhoneBtn.layer.cornerRadius = 5;
        callPhoneBtn.layer.masksToBounds = YES;
        [callPhoneBtn addTarget:self action:@selector(callPhoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:callPhoneBtn];
        
    }
    return _footView;
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
