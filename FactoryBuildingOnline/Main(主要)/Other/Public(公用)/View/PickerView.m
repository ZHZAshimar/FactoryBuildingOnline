//
//  PickerView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "PickerView.h"

#define sHeight self.frame.size.height
#define sWidth self.frame.size.width

@interface PickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    
}
@property (nonatomic, strong) UIPickerView *pickerView; // 选择器
@property (nonatomic, strong) UIView *headerView;       // 头部的两个按钮
@end

@implementation PickerView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHex:0xD2D5DC];
        
        self.dataSource = [NSArray array];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.headerView];
        [self addSubview:self.pickerView];
    }
    return self;
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.pickerView reloadAllComponents];
}

#pragma mark - pickerView datasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = self.dataSource[row];
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger i = [self.pickerView selectedRowInComponent:0];
    
    [self getSelectString:i];
}

#pragma mark - 按钮的点击事件
- (void) buttonTagAction:(UIButton *)sender {
    
    if (sender.tag == 100) {  // 取消
        
        self.hidden = YES;
        
    } else {                // 完成
        
        NSInteger i = [self.pickerView selectedRowInComponent:0];
        
        [self getSelectString:i];
        
        self.hidden = YES;
    }
}

- (void)getSelectString:(NSInteger)index {
    
    NSString *string = self.dataSource[index];
    
    NSLog(@"%@",string);
    
    self.selectStrBlock(string);    // 回调
}

#pragma mark - lazyload
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, sHeight/5, sWidth, sHeight*4/5)];
        _pickerView.backgroundColor = [UIColor clearColor];
        // 设置代理
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
    }
    return _pickerView;
}

- (UIView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sWidth, sHeight/5)];
        _headerView.backgroundColor = [UIColor colorWithHex:0xF0F1F2];
        
        for (int i = 0; i < 2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(0+i*(sWidth-60), 0, 60, sHeight/5);
            
            button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11.0]];
            
            button.tag = i+100;
            
            [button addTarget:self action:@selector(buttonTagAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0) {
                [button setTitle:@"取消" forState:0];
                [button setTitleColor:BLACK_99 forState:0];
            } else {
                [button setTitle:@"完成" forState:0];
                [button setTitleColor:GREEN_19b8 forState:0];
            }
            [_headerView addSubview:button];
        }
        
    }
    return _headerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
