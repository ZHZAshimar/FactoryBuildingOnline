//
//  SliderViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/3.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SliderViewController.h"
#import "SliderHeadView.h"
#import "FOLUserInforModel.h"
#import "SecurityUtil.h"

@interface SliderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;     // 表视图
@property (nonatomic, strong) NSMutableArray *mDataSource;  // 数据

@property (nonatomic, strong) UIImageView *bgImageView; // 背景图片
@property (nonatomic, strong) SliderHeadView *headView;         // 头部的headView
@end

@implementation SliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self loadData];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.myTableView];
    
    [self addRightGestureRecognizer];
}


#pragma mark - 加载数据
- (void)loadData {
    
    self.mDataSource = [NSMutableArray arrayWithObjects:
  @{@"title":@"电子合同",@"logo":@"slider_contract"},
  @{@"title":@"电子名片",@"logo":@"slider_card"},
  @{@"title":@"运动与健康",@"logo":@"slider_activity"},
  @{@"title":@"社保服务",@"logo":@"slider_socialSecurity"},
  @{@"title":@"在线考勤",@"logo":@"slider_attendance"},
  @{@"title":@"客户服务",@"logo":@"slider_service"},
  @{@"title":@"亲戚计算器",@"logo":@"slider_relative"},nil];
}

#pragma mark - 添加右扫手势，以隐藏侧边栏
- (void)addRightGestureRecognizer {
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
}
// 右扫手势响应事件
- (void)rightSwipeAction: (UISwipeGestureRecognizer *)gesture {
    
    self.sliderBlock(NO);
    
}

#pragma mark - 重写setter 方法
- (void)setUsersArray:(NSMutableArray *)usersArray {
    
    if (usersArray.count < 1) { // 没有登录的状态
        
//        self.headView.addressLabel.text = @"无法获取定位";
        self.headView.userNameLabel.text = @"未登录";
    } else {    // 登录状态
        
        FOLUserInforModel *user = usersArray[0];
        
//        self.headView.addressLabel.text = @"无法获取定位";
        self.headView.userNameLabel.text = user.userName;
        NSString *avatar = [SecurityUtil decodeBase64String:user.avatar];
        
        if (user.type == 2) {
            [self.headView.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"my_broker"]];
            
        } else {
            [self.headView.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"my_normal"]];
        }
        // 当用户有头像时，imageView 增加 一圈边框
        if (avatar.length > 0) {
            self.headView.userAvatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            self.headView.userAvatarImageView.layer.borderWidth = 3;
        }
    }
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = self.mDataSource[indexPath.row];    // 获取字典
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.textColor = BLACK_42;
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:dic[@"logo"]];
    
    // 设置选中时的背景颜色
    UIView *selectBgColorView = [[UIView alloc] initWithFrame:cell.frame];
    selectBgColorView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = selectBgColorView;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - lazy load
- (UITableView *)myTableView {
    
    if (!_myTableView) {
    
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headView.frame.size.height, self.view.frame.size.width, Screen_Height-self.headView.frame.size.height) style:UITableViewStylePlain];
        
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _myTableView.tableFooterView = [UIView new];
//        _myTableView.scrollEnabled = NO;
        
        // 将分割线 增长
        _myTableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    }
    return _myTableView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgImageView.image = [UIImage imageNamed:
                              @"slider_bg"];
        
    }
    return _bgImageView;
}

- (SliderHeadView *)headView {
    if (!_headView) {
        _headView = [[SliderHeadView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width*2/3, Screen_Height*26/71)];
        
    }
    return _headView;
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
