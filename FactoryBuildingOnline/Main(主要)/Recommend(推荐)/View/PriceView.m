//
//  PriceView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "PriceView.h"
#import "CuttingLineView.h"
#import "MBProgressHUD+NH.h"
#define priceViewCellID @"PriceViewCellID"

@interface PriceView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *marrayOfindex;
}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UIView *footView;
@end

@implementation PriceView

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (id)initWithFrame:(CGRect)frame withData:(NSArray *)array withIndexType:(NSUInteger)type{
    
    if (self = [super initWithFrame:frame]) {
        self.dataArray = array;
        marrayOfindex = [NSMutableArray array];
        for (int i = 0; i < self.dataArray.count; i++) {
            [marrayOfindex addObject:@0];
        }
        self.segmentIndex_type = (int)type;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self footView];
    }
    
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [marrayOfindex removeAllObjects];
    for (int i = 0; i < self.dataArray.count; i++) {
        [marrayOfindex addObject:@0];
    }
    [marrayOfindex replaceObjectAtIndex:selectIndex withObject:@1];
    [self.tableView reloadData];
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:priceViewCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:priceViewCellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = BLACK_4c;
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
    
    if (self.selectIndex == indexPath.row) {
        cell.textLabel.textColor = GREEN_1ab8;
    }
    
    // 绘制虚线分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
    [CuttingLineView drawDashLine:view lineLength:3 lineSpacing:1 lineColor:GRAY_da];
    [cell addSubview:view];
    
    return cell;
}
#pragma mark - 点击cell 响应的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *text = cell.textLabel.text;
    
    NSString *low,*hight;
    
    if (indexPath.row != 0) {   // 处理字符串：将价格和面积分割出最大值和最小值。发送通知进行数据请求
        
        if (self.segmentIndex_type >0 ) {   // 面积
            
            if ([text rangeOfString:@"大于"].location != NSNotFound) {
                text = [text stringByReplacingOccurrencesOfString:@"大于" withString:@""];
                text = [text stringByReplacingOccurrencesOfString:@"m²" withString:@""];
                low = text;
                hight = @"-1";
            } else {
                text = [text stringByReplacingOccurrencesOfString:@"m²" withString:@""];
                NSArray *array = [text componentsSeparatedByString:@"-"];
                low = array[0];
                hight = array[1];
            }
            
        } else {    // 价格
            
            if ([text rangeOfString:@"大于"].location != NSNotFound) {
                text = [text stringByReplacingOccurrencesOfString:@"大于" withString:@""];
                text = [text stringByReplacingOccurrencesOfString:@"元/m²" withString:@""];
                low = text;
                hight = @"-1";
            } else {
                text = [text stringByReplacingOccurrencesOfString:@"元/m²" withString:@""];
                NSArray *array = [text componentsSeparatedByString:@"-"];
                low = array[0];
                hight = array[1];
            }
            
        }
    }else { // 不限的处理
        
        low = @"-1";
        hight = @"-1";
    }
    
    self.priceBlock(cell.textLabel.text, self.segmentIndex_type+1, indexPath);
    
    NSDictionary *dictionary = @{@"low":low,@"hight":hight,@"segmentType":@(self.segmentIndex_type),@"isCellTag":@YES};
    // 发送 通知 SELECTSURE 到 RecommendViewController 页面进行数据更新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTSURE" object:self userInfo:dictionary];
}

- (void)buttonAction:(UIButton*)sender
{
    [self.lowPriceTF resignFirstResponder];
    [self.hightPriceTF resignFirstResponder];
    if (![self isPureNumandCharacters:self.lowPriceTF.text] || ![self isPureNumandCharacters:self.hightPriceTF.text]) {
        
        [MBProgressHUD showAutoMessage:@"请输入纯数字~" ToView:nil];
        
//        ZHZAlertView *alertView = [[ZHZAlertView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width*3/5, 40) alertWord:@"请输入纯数字~"];
//        [self.window addSubview:alertView];
        
        return;
    }
    
    if ( self.lowPriceTF.text.length <= 0 || self.hightPriceTF.text.length <= 0) {
        
        [MBProgressHUD showAutoMessage:@"文本不能为空哦~" ToView:nil] ;
        
        return;
    }
    if ( [self.lowPriceTF.text intValue] >[self.hightPriceTF.text intValue]) {
        
        [MBProgressHUD showAutoMessage:@"请输入正确的范围哦！" ToView:nil];
        
        return;
    }
    
    NSDictionary *dictionary = @{@"low":self.lowPriceTF.text,@"hight":self.hightPriceTF.text,@"segmentType":@(self.segmentIndex_type),@"isCellTag":@NO};
    // 发送 通知 SELECTSURE 到 RecommendViewController 页面进行数据更新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTSURE" object:self userInfo:dictionary];
    
    
}
#pragma mark - 判断字符串是否为纯数字
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 回收键盘
    [_hightPriceTF resignFirstResponder];
    [_lowPriceTF resignFirstResponder];
    
    return  YES;
}

#pragma mark - lazy load
- (UITableView *)tableView
{
    
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.frame.size.height-44) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];     // 去除多余的分割线
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:priceViewCellID];  // 注册cell
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;      // 设置分割线的样式为 none
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)footView
{
    
    if (!_footView)
    {
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-44, Screen_Width, 44)];
        _footView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 0.5)];
        view.backgroundColor = GRAY_db;
        [_footView addSubview:view];
        
        _lowPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, Screen_Width/4, 28)];
        _lowPriceTF.backgroundColor = GRAY_LIGHT;
        _lowPriceTF.textAlignment = NSTextAlignmentCenter;
        _lowPriceTF.placeholder = @"最低价格";
        _lowPriceTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]];
        _lowPriceTF.layer.masksToBounds = YES;
        _lowPriceTF.layer.cornerRadius = 5;
        _lowPriceTF.delegate = self;
        [_footView addSubview:_lowPriceTF];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width/4+8, 8, 10, 30)];
        label.text = @"-";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = GRAY_LIGHT;
        [_footView addSubview:label];
        
        _hightPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(8+Screen_Width/4+10, 8, Screen_Width/4, 28)];
        _hightPriceTF.backgroundColor = GRAY_LIGHT;
        _hightPriceTF.placeholder = @"最高价格";
        _hightPriceTF.textAlignment = NSTextAlignmentCenter;
        _hightPriceTF.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]];
        _hightPriceTF.layer.masksToBounds = YES;
        _hightPriceTF.layer.cornerRadius = 5;
        _hightPriceTF.delegate = self;
        [_footView addSubview:_hightPriceTF];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(Screen_Width/2+18+6, 8, Screen_Width*2/5, 30);
        [button setTitle:@"确定" forState:0];
        [button setTitleColor:GREEN_1ab8 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]];
        button.layer.borderColor = GREEN_1ab8.CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(buttonAction:)forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:button];
        
        [self addSubview:_footView];
        
        if (self.segmentIndex_type > 0)
        {
            _lowPriceTF.placeholder = @"最小面积";
            _hightPriceTF.placeholder = @"最大面积";
        }
    }
    
    return _footView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
