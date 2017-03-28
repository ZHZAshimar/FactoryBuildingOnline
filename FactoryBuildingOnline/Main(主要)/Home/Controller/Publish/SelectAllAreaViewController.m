//
//  SelectAllAreaViewController.m
//  SelectAreaTest
//
//  Created by myios on 2017/3/25.
//  Copyright © 2017年 Ashimar. All rights reserved.
//

#import "SelectAllAreaViewController.h"
#import "HMSegmentedControl.h"

#define VIEWWIDTH  self.view.frame.size.width
#define VIEWHEIGHT self.view.frame.size.height
#define SELECTWIDTH (VIEWWIDTH-80)/3
@interface SelectAllAreaViewController ()<UITableViewDelegate,UITableViewDataSource>

{
//    NSInteger provinceIndex;    // 省标记
//    NSInteger cityIndex;        // 市标记
//    NSInteger areaIndex;        // 区标记
    
    
}

@property (nonatomic, strong) UITableView *areaTableView;
@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, strong) NSMutableArray *mDataSource;
@property (nonatomic, strong) HMSegmentedControl *areaSegmentedControl;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, assign) NSInteger selectIndex;      // 选择的标记    0：省 1：市 2：区
@property (nonatomic, strong) NSMutableDictionary *mSelectedDict;
@end

@implementation SelectAllAreaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setVCName:@"选择地址" andShowSearchBar:NO andTintColor:[UIColor blackColor] andBackBtnStr:@"返回"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadDataOfPlist];
    
    [self.view addSubview:self.greenView];
    
    [self.view addSubview:self.areaSegmentedControl];
    [self.view addSubview:self.areaTableView];
}

- (void)loadDataOfPlist {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    
    NSDictionary *areaDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSLog(@"所有地区%@",areaDic);
    
    self.areaArray = [NSArray arrayWithArray:areaDic[@"cityList"]];
    self.mDataSource = [NSMutableArray arrayWithArray:self.areaArray];
    
//    self.mSelectedDict = [NSMutableDictionary dictionary];
}

- (void)setPushDict:(NSDictionary *)pushDict {
    
    _pushDict = pushDict;
        self.mSelectedDict = [NSMutableDictionary dictionaryWithDictionary:pushDict];
//    [self.mDataSource removeAllObjects];
//    self.mDataSource = [NSMutableArray arrayWithArray:self.areaArray];
//    NSLog(@"传过来的字典：%@",self.mSelectedDict);
    
    [self setSegmentedTitle];

    [self.areaTableView reloadData];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaCell" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12]];
    cell.textLabel.text = self.mDataSource[indexPath.row][@"name"];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (self.mSelectedDict.count > 0) {
        if (_selectIndex == 0) {
            
            if ([self.mSelectedDict[@"province"][2]  intValue] == indexPath.row) {
                cell.textLabel.textColor = GREEN_19b8 ;
            }
            
        } else if (_selectIndex == 1) {
            if ([self.mSelectedDict[@"city"][2]  intValue]== indexPath.row) {
                cell.textLabel.textColor = GREEN_19b8;
            }
        } else {
            if ([self.mSelectedDict[@"area"][2]  intValue]== indexPath.row) {
                cell.textLabel.textColor = GREEN_19b8;
            }
        }

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectIndex++;
    self.areaSegmentedControl.selectedSegmentIndex = self.selectIndex;
    switch (self.selectIndex) {
        case 0:
        {
            
            [self.mDataSource removeAllObjects];
            [self.mDataSource addObjectsFromArray:self.areaArray];
        }
            break;
        case 1:
        {
//            provinceIndex = indexPath.row;
            
            [self.mSelectedDict setValue:@[self.areaArray[indexPath.row][@"name"],self.areaArray[indexPath.row][@"code"],@(indexPath.row)] forKey:@"province"];
            
            [self.mSelectedDict setValue:@[
               self.areaArray[indexPath.row][@"edsAddrList"][0][@"name"],
               self.areaArray[indexPath.row][@"edsAddrList"][0][@"code"],
               @(0)
                   ] forKey:@"city"];
            NSArray *tmpArray = [NSArray arrayWithArray:self.mDataSource];
            
            [self.mDataSource removeAllObjects];
            
            [self.mDataSource addObjectsFromArray: tmpArray[indexPath.row][@"edsAddrList"]];
            NSLog(@"城市：%@",self.mDataSource);
            [self setSegmentedTitle];
            
        }
            break;
        case 2:
        {
//            cityIndex = indexPath.row;
            
            [self.mSelectedDict setValue:@[self.mDataSource[indexPath.row][@"name"],self.mDataSource[indexPath.row][@"code"],@(indexPath.row)] forKey:@"city"];
            
            NSArray *tmpArray = [NSArray arrayWithArray:self.mDataSource];
            
            [self.mDataSource removeAllObjects];
            
            [self.mDataSource addObjectsFromArray: tmpArray[indexPath.row][@"edsAddrList"]];
            
            [self setSegmentedTitle];
        }
            break;
        case 3:
        {
//            areaIndex = indexPath.row;
            
            [self.mSelectedDict setValue:@[self.mDataSource[indexPath.row][@"name"],self.mDataSource[indexPath.row][@"code"],@(indexPath.row)] forKey:@"area"];
            
            self.areaBlock(self.mSelectedDict);
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
            break;
        default:
            break;
    }
    
    
    [self.areaTableView reloadData];
    
    self.greenView.frame = CGRectMake(40+self.selectIndex*SELECTWIDTH, 0, SELECTWIDTH, Screen_Height*26/568);
}

- (void)setSegmentedTitle {
    
    
    if (self.mSelectedDict.count <= 0) {
        [self.areaSegmentedControl setSectionTitles:@[@"请选择",@"",@""]];
        return;
    }
    
    NSString *provinceTitle = self.mSelectedDict[@"province"][0];
    
    if (provinceTitle.length <= 0) {
        provinceTitle = @"请选择";
    }
    
    NSString *cityTitle = self.mSelectedDict[@"city"][0];
    NSInteger cityIndex = [self.mSelectedDict[@"city"][2] integerValue];
    if (cityTitle.length <= 0 && cityIndex == 0) {
        cityTitle = @"请选择";
    }
    
    NSString *areaTitle = self.mSelectedDict[@"area"][0];
    NSInteger areaIndex = [self.mSelectedDict[@"area"][2] integerValue];
    if (areaTitle.length <= 0 && areaIndex == 0 && cityIndex < 0) {
        areaTitle = @"";
    } else if (areaTitle.length <= 0 && areaIndex == 0){
        areaTitle = @"请选择";
    }
    
    [self.areaSegmentedControl setSectionTitles:@[provinceTitle,cityTitle,areaTitle]];
    
}

#pragma mark - lazyload
- (UITableView*)areaTableView {
    if (!_areaTableView) {
        _areaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT*26/568, VIEWWIDTH,  VIEWHEIGHT-64-VIEWHEIGHT*26/568) style:UITableViewStylePlain];
        
        _areaTableView.delegate = self;
        _areaTableView.dataSource = self;
        
        _areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_areaTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"areaCell"];
    }
    return _areaTableView;
}

- (HMSegmentedControl *)areaSegmentedControl {
    if (!_areaSegmentedControl) {
        
        _areaSegmentedControl = [[HMSegmentedControl alloc] init];
        
        _areaSegmentedControl.backgroundColor = [UIColor clearColor];
        
        _areaSegmentedControl.frame = CGRectMake(40, 0, VIEWWIDTH-80, VIEWHEIGHT*26/568);
        
//        [self setSegmentedTitle];
        
        _areaSegmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:12]],NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        _areaSegmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont adjustFontSize:12]],NSForegroundColorAttributeName:GREEN_19b8};
        
        _areaSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _areaSegmentedControl.selectionIndicatorHeight = 0;
        __weak typeof(self) weakSelf = self;
        
        [_areaSegmentedControl setIndexChangeBlock:^(NSInteger index) {
            weakSelf.greenView.frame = CGRectMake(40+index*SELECTWIDTH, 0, SELECTWIDTH, Screen_Height*26/568);
            weakSelf.selectIndex = index;
            
            switch (index) {
                case 0:
                {
                    
                    [weakSelf.mDataSource removeAllObjects];
                    [weakSelf.mDataSource addObjectsFromArray:weakSelf.areaArray];
                }
                    break;
                case 1:
                {
                    NSInteger provinceIndex = [weakSelf.mSelectedDict[@"province"][2] intValue];
                    
                    NSArray *tmpArray = weakSelf.areaArray[provinceIndex][@"edsAddrList"];
                    
                    [weakSelf.mDataSource removeAllObjects];
                    
                    [weakSelf.mDataSource addObjectsFromArray: tmpArray];
                    
//                    [self setSegmentedTitle];
                    
                }
                    break;
                case 2:
                {
                    
                    NSInteger provinceIndex = [weakSelf.mSelectedDict[@"province"][2] intValue];
                    NSInteger cityIndex = [weakSelf.mSelectedDict[@"city"][2] intValue];
                    
                    NSArray *tmpArray = weakSelf.areaArray[provinceIndex][@"edsAddrList"][cityIndex][@"edsAddrList"];
                    
                    [weakSelf.mDataSource removeAllObjects];
                    
                    [weakSelf.mDataSource addObjectsFromArray: tmpArray];
                    
//                    [self setSegmentedTitle];
                }
                    break;
                
                default:
                    break;
            }
            
            
            [weakSelf.areaTableView reloadData];
            
        }];
        
    }
    return _areaSegmentedControl;
}

- (UIView *)greenView {
    if (!_greenView) {
        
        _greenView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, SELECTWIDTH, Screen_Height*26/568)];
        _greenView.backgroundColor = GREEN_19b8;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT*26/568-0.5, VIEWWIDTH, 0.5)];
        lineView.backgroundColor = GRAY_cc;
        [self.view addSubview:lineView];
    }
    return _greenView;
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
