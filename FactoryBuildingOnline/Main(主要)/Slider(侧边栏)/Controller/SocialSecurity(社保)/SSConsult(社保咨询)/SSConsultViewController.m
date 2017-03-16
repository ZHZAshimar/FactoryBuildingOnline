//
//  SSConsultViewController.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/14.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "SSConsultViewController.h"
#import "HeadOfImagePlayerCollectionReusableView.h"
#import "SSHomeLogoTextCollectionViewCell.h"

#import "FiveBtnView.h"
//typedef enum {
//    FIRSTBTN = 0,   // 第一个按钮 养老
//    SECONDBTN,  // 第二个按钮 医疗
//    THIRDBTN,   // 第三个按钮 公积金
//    FOURTHBTN,  // 第四个按钮 工伤
//    FIFTHBTN,   // 第五个按钮 失业
//}TAGDATATYPE;   // 点击的按钮的数据样式

@interface SSConsultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *firstmArray;
@property (nonatomic, strong) NSMutableArray *secondmArray;
@property (nonatomic, strong) NSMutableArray *thirdmArray;
@property (nonatomic, strong) NSMutableArray *fourthmArray;
@property (nonatomic, strong) NSMutableArray *fifthmArray;

@property (nonatomic, strong) UISegmentedControl *mySegmented;
@property (nonatomic, assign) NSInteger tagIndex;
@end

@implementation SSConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.view.backgroundColor = [UIColor colorWithHex:0xF4F5F9];
    
    [self setFiveButton];
    
    [self setArray];
    
    [self.view addSubview:self.myTableView];
    
}

- (void)setFiveButton {
    // 自定义的view
    FiveBtnView *fiveBtnView = [[FiveBtnView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height*42/568)];
    fiveBtnView.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self) weakSelf = self;
    fiveBtnView.tagBlock = ^(NSInteger tagIndex) {
        weakSelf.tagIndex = tagIndex;
        
        
        [UIView transitionWithView:weakSelf.myTableView
                          duration: 0.35f
                           options: UIViewAnimationOptionTransitionFlipFromLeft
                        animations: ^(void)
         {
             [weakSelf.myTableView reloadData];
         }
                        completion: ^(BOOL isFinished)
         {  
             
         }];
    };
    [self.view addSubview: fiveBtnView];
}

- (void)setArray {
    self.firstmArray = [NSMutableArray array];
    self.secondmArray = [NSMutableArray array];
    self.thirdmArray = [NSMutableArray array];
    self.fourthmArray = [NSMutableArray array];
    self.firstmArray = [NSMutableArray array];
    
    [self.firstmArray addObject:@"企业职工养老保险关系转移操作步骤"];
    [self.firstmArray addObject:@"城乡居民养老保险还是企业职工养老保险"];
    [self.firstmArray addObject:@"参保人死亡或者出国定居，基本养老保险关系怎么处理"];
    [self.firstmArray addObject:@"个体参加保险，退休待遇和企业职工一样吗？"];
    [self.firstmArray addObject:@"企业职工养老保险关系转移操作步骤"];
    [self.firstmArray addObject:@"城乡居民养老保险还是企业职工养老保险"];
    [self.firstmArray addObject:@"参保人死亡或者出国定居，基本养老保险关系怎么处理"];
    [self.firstmArray addObject:@"个体参加保险，退休待遇和企业职工一样吗？"];
    [self.firstmArray addObject:@"个体参加保险，退休待遇和企业职工一样吗？"];
    [self.firstmArray addObject:@"企业职工养老保险关系转移操作步骤"];
    [self.firstmArray addObject:@"城乡居民养老保险还是企业职工养老保险"];
    [self.firstmArray addObject:@"参保人死亡或者出国定居，基本养老保险关系怎么处理"];
    [self.firstmArray addObject:@"个体参加保险，退休待遇和企业职工一样吗？"];
    
    [self.secondmArray addObjectsFromArray:self.firstmArray];
    [self.thirdmArray addObjectsFromArray:self.firstmArray];
    [self.fourthmArray addObjectsFromArray:self.firstmArray];
    [self.fourthmArray addObjectsFromArray:self.firstmArray];
    
}
#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.tagIndex) {
        case 0:
            return self.firstmArray.count;
            break;
        case 1:
            return self.secondmArray.count;
            break;
        case 2:
            return self.thirdmArray.count;
            break;
        case 3:
            return self.fourthmArray.count;
            break;
        case 4:
            return self.fifthmArray.count;
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Screen_Height*44/568;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 设置cell的textlabel
    cell.textLabel.numberOfLines = 2;
    
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12.0]];
    cell.textLabel.textColor = BLACK_66;
    cell.imageView.image = [UIImage imageNamed:@"ss_point"];
    switch (self.tagIndex) {
        case 0:
            cell.textLabel.text = self.firstmArray[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = self.secondmArray[indexPath.row];
            break;
        case 2:
            cell.textLabel.text = self.thirdmArray[indexPath.row];
            break;
        case 3:
            cell.textLabel.text = self.fourthmArray[indexPath.row];
            break;
        case 4:
            cell.textLabel.text = self.fifthmArray[indexPath.row];
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - lazy load
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Screen_Height*42/568+64, Screen_Width, Screen_Height-Screen_Height*42/568-64-50) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        
        _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;    // 去除掉分割线
//        _myTableView.pagingEnabled = YES;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
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
