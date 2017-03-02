//
//  AppFeedbackViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/8.
//  Copyright © 2017年 XFZY. All rights reserved.
//  app 的意见反馈

#import "AppFeedbackViewController.h"

@interface AppFeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UILabel *placeholdLabel;    // textView 中的提示文字
    UITextView *textView;
    UITextField *textField;
}
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation AppFeedbackViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.rdv_tabBarController.tabBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setVCName:@"意见反馈" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    [self addRightItemWithString:@"完成" andItemTintColor:GREEN_19b8];
    
    [self.view addSubview:self.myTableView ];
    
}
#pragma mark - 完成
- (void)rightItemButtonAction {
    
    if (textView.text.length > 400 && textView.text.length < 2) {
        [MBProgressHUD showError:@"请输入2-400个字" ToView:nil];
        return;
    }
    
    NSString *linkStr = textField.text;
    
    if (linkStr.length <= 0) {
        [MBProgressHUD showError:@"请输入联系方式" ToView:nil];
        return;
    }
    if ([NSString validateEmail:linkStr] || [NSString validateMobile:linkStr]) {

        NSDictionary *params = @{@"app_type":@"1",@"feedback_content":textView.text,@"contact_way":textField.text};
        
        [HTTPREQUEST_SINGLE postRequestWithURL:URL_POST_APP_FEEDBACKS andParameters:params andShowAction:YES success:^(RequestManager *manager, NSDictionary *response) {
            NSLog(@"APP意见反馈：%@",response);
            [MBProgressHUD showSuccess:@"反馈成功，我们将认真查看！" ToView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(RequestManager *manager, NSError *error) {
            NSLog(@"APP意见反馈：%@",error);
            [MBProgressHUD showSuccess:@"反馈失败！" ToView:nil];
        }];
    }
    
    
}

#pragma mark - tableView datasource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Screen_Height*4/71;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height*4/71)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, Screen_Width, Screen_Height*4/71)];
    
    if (section == 0) {
        label.text = @"问题描述";
    } else {
        label.text = @"联系方式";
    }
    
    label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0]];
    label.textColor = GRAY_80;
    
    [headView addSubview:label];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return Screen_Height*135/568;
    }
    
    return Screen_Height*43/568;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    // 添加两条分割线
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*cell.frame.size.height-0.5, Screen_Width, 0.5)];
        lineView.backgroundColor = GRAY_db;
        [cell addSubview:lineView];
    }
    
    if (indexPath.section == 0) {   // 问题描述
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(13, 0, Screen_Width-26, cell.frame.size.height-20)];
        
        textView.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13]];
        textView.textColor = BLACK_42;
        textView.delegate = self;
        [cell addSubview:textView];
        // 提示文字
        placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, Screen_Width-26, 30)];
        placeholdLabel.text = @"您好，请描述反馈的问题或建议……";
        placeholdLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13]];
        placeholdLabel.textColor = GRAY_80;
        [cell addSubview:placeholdLabel];
        
        // 2-400字的文字提示
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-13-80, cell.frame.size.height-25, 80, 25)];
        label.text = @"2-400字";
        label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11.0]];
        label.textColor = GRAY_80;
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
    } else {    // 联系方式
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(13, 0, Screen_Width-26, cell.frame.size.height)];
    
        textField.placeholder = @"请输入您的QQ号码/手机号/邮箱";
        textField.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13]];
        textField.textColor = BLACK_42;
        [cell addSubview:textField];
        
    }
    
    return cell;
}
#pragma mark -
- (void) textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length <= 0) {
        placeholdLabel.hidden = NO;
    } else {
        placeholdLabel.hidden = YES;
    }
    
}

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStylePlain];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.tableFooterView = [UIView new];
        
        _myTableView.backgroundColor = GRAY_F5;
        
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
