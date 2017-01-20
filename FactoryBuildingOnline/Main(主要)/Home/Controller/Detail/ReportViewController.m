//
//  ReportViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/12.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    UILabel *placeholderLabel;
    UILabel *fontNumLabel;
    NSIndexPath *lastSelectIndexPath;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITextView *myTextView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *indexArr;
@end

@implementation ReportViewController

- (void)dealloc {
    
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
    self.myTextView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 ? YES:NO) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.frame = CGRectMake(0, 64, Screen_Width, Screen_Height+64);
    
    [self setVCName:@"举报" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self addRightItemWithString:@"完成" andItemTintColor:GREEN_1ab8];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.myTableView];
    
    self.dataSource = @[@"厂房位置有误",@"房源价格不符",@"发布人电话有误",@"图片或面积有误",@"其他"];
    
    self.indexArr = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        [self.indexArr addObject:@0];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 举报
- (void)rightItemButtonAction {
    
    if (self.myTextView.text.length <= 0 && self.myTextView.text.length > 200) {
        [MBProgressHUD showError:@"请输入吐槽内容" ToView:nil];
        
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/",URL_POST_FEEDBACKS_WANTEDMESSAGE,[NSString stringWithFormat:@"%d",self.model.id]];
    NSString *content = self.dataSource[lastSelectIndexPath.row];
    NSDictionary *requestDic = @{@"content":content,@"remark":self.myTextView.text};
    
    [HTTPREQUEST_SINGLE postRequestWithURL:urlStr andParameters:requestDic andShowAction:YES success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showError:response[@"erro_msg"] ToView:nil];
            return ;
        }
        [MBProgressHUD showSuccess:@"举报成功！" ToView:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"举报异常：%@",error.debugDescription);
        [MBProgressHUD showError:@"网络异常，稍后再操作！" ToView:nil];
    }];
    
}

- (void)keyboardWillShow: (NSNotification *)sender {
    
    
    NSValue *rectValue = sender.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [rectValue CGRectValue].size.height;
    CGFloat result = Screen_Height - keyboardHeight;
    CGFloat textFieldY = 511;
    if (result < textFieldY) {
        self.view.frame = CGRectMake(0, result - textFieldY, Screen_Width, Screen_Height);
    }
}

- (void)keyboardWillHidden:(NSNotification *)sender {
    self.view.frame = CGRectMake(0, 64, Screen_Width, Screen_Height+64);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.myTextView resignFirstResponder];
    
}

#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

// 头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 34)];
    headView.backgroundColor = GRAY_F5;
    
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*33.5, Screen_Width, 0.5)];
        lineView.backgroundColor = GRAY_db;
        [headView addSubview:lineView];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 1, Screen_Width-24, 32)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = BLACK_80;
    [headView addSubview:label];
    
    switch (section) {
        case 0:
            label.text = @"举报房源";
            break;
        case 1:
            label.text = @"举报内容";
            break;
        case 2:
            label.text = @"我要吐槽";
            break;
        default:
            break;
    }
    
    return headView;
}

// 尾部
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 59;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 100;
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView;
    
    if (section == 0) {
        
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 59)];
        footView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, Screen_Width-24, 59)];
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = BLACK_42;
        [footView addSubview:label];
        
        label.text = self.model.ftModel.title;
    } else {
        
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 100)];
        footView.backgroundColor = [UIColor whiteColor];
        
        [footView addSubview:self.myTextView];
        [footView addSubview:fontNumLabel];
    }
    return footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    int index = [self.indexArr[indexPath.row] intValue];
    
    if (index) {
        
        cell.imageView.image = [UIImage imageNamed:@"choose"];
    } else {
        
        cell.imageView.image = [UIImage imageNamed:@"uncheck"];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = BLACK_42;
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (lastSelectIndexPath && indexPath != lastSelectIndexPath) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.imageView.image = [UIImage imageNamed:@"choose"];
        
        self.indexArr[indexPath.row] = @1;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastSelectIndexPath];
       
        lastCell.imageView.image = [UIImage imageNamed:@"uncheck"];
        
        self.indexArr[lastSelectIndexPath.row] = @0;
        
        [tableView reloadRowsAtIndexPaths:@[lastSelectIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.imageView.image = [UIImage imageNamed:@"choose"];
        
        self.indexArr[indexPath.row] = @1;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    lastSelectIndexPath = indexPath;
    
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        
        placeholderLabel.hidden = NO;
        
    } else {
        
        placeholderLabel.hidden = YES;
    }
    
    if (textView.text.length > 200) {
        
        fontNumLabel.text = [NSString stringWithFormat:@"已超过%ld个字",textView.text.length - 200];
       
    } else {
        
        fontNumLabel.text = [NSString stringWithFormat:@"%ld",200-textView.text.length];
        
    }
}


#pragma mark - lazy load -
- (UITableView *)myTableView {
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _myTextView.userInteractionEnabled = YES;
        [_myTextView addGestureRecognizer:tap];
    }
    return _myTableView;
}

- (UITextView *)myTextView {
    
    if (!_myTextView) {
        
        _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 12, Screen_Width-24, 89)];
        _myTextView.backgroundColor = GRAY_F5;
        _myTextView.textColor = BLACK_42;
        _myTextView.delegate = self;
        _myTextView.layer.cornerRadius = 5;
        _myTextView.layer.masksToBounds = YES;
        
        NSString *string = @"请详细描述您的头数内容（字数在200以内）";
        CGFloat width = [NSString widthForString:string fontSize:12.0f andHeight:30];
        
        placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, width, 30)];
        placeholderLabel.text = string;
        placeholderLabel.textColor = GRAY_99;
        placeholderLabel.font = [UIFont systemFontOfSize:12.0];
        [_myTextView addSubview:placeholderLabel];
        
        fontNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-80-12, _myTextView.frame.size.height + 14, 80, 20)];
        fontNumLabel.textColor = RED_df3d;
//        fontNumLabel.backgroundColor = BLUE_bg;
        fontNumLabel.textAlignment = NSTextAlignmentRight;
        fontNumLabel.font = [UIFont systemFontOfSize:12.0f];
        fontNumLabel.text = [NSString stringWithFormat:@"200"];
        
    }
    return _myTextView;
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
