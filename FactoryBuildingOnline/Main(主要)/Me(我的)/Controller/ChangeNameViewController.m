//
//  ChangeNameViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/3.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "FOLUserInforModel.h"

@interface ChangeNameViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITextField *myTextField;
@end

@implementation ChangeNameViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setVCName:@"修改名称" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];
    
    [self addRightItemWithString:@"保存" andItemTintColor:GREEN_19b8];
    
    [self.view addSubview:self.myTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Screen_Width-10, 44)];
    
    self.myTextField.text = self.userName;
    
    self.myTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    self.myTextField.font = [UIFont systemFontOfSize:14.0];
    
    self.myTextField.textColor = BLACK_42;
    
    [cell addSubview:self.myTextField];
    
    
    return cell;
}

- (UITableView*)myTableView {
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _myTableView.backgroundColor = GRAY_F5;
        
        [_myTableView setSeparatorColor:GRAY_db];   // 设置分各线的颜色
        
        _myTableView.scrollEnabled = NO;
    }
    return _myTableView;
}

- (void)rightItemButtonAction {
    // 请求修改名称的接口
    if (self.myTextField.text.length <= 0) {
        
        [MBProgressHUD showAutoMessage:@"请输入新名称" ToView:nil];
        
        return;
    }
    
    if ([self.myTextField.text isEqualToString:self.userName]) {    // 当修改的名称和之前的名称一致，不做改变
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self.myTextField resignFirstResponder];
    
    NSDictionary *requestDic = @{@"update_type":@(2),@"update_value":self.myTextField.text};
    __weak typeof (self) weakSelf = self;
    
    [HTTPREQUEST_SINGLE putRequestWithService:URL_POST_LOGIN andParameters:requestDic isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {

        if ([response[@"erro_code"] intValue]!= 200) {
            
            [MBProgressHUD showSuccess:response[@"erro_msg"] ToView:nil];
            return ;
        }
        [MBProgressHUD showSuccess:@"修改成功👏" ToView:nil];
        
        FOLUserInforModel *userModel = [[FOLUserInforModel findAll] firstObject];
        // 修改数据库
        [FOLUserInforModel updateUserInfo:@"userName" andupdateValue:self.myTextField.text andUserID:userModel.userID];
        
        // 返回界面
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"%@",error.debugDescription);
        [MBProgressHUD showError:@"网络出小差了，请稍后再修改💔" ToView:nil];
    }];
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
