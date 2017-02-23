//
//  RightTableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//



#import "RightTableView.h"
#import "CuttingLineView.h"

#define RightTableViewCellID @"RightTableViewCell"

@interface RightTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *marrayOfindex;  // 用0，1来标记 cell 的文字颜色，防止重用
    NSIndexPath *preIndexPath;  // 用于保存上一次点击的 indexPath
    BOOL firstLoad;
}
@end

@implementation RightTableView

- (void)dealloc {
    self.delegate = nil;
    self.dataSource = nil;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        marrayOfindex = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:RightTableViewCellID];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return self;
}

- (void)setRightListArray:(NSArray *)rightListArray {
    _rightListArray = rightListArray;
    for (int i = 0; i < _rightListArray.count; i++) {
        [marrayOfindex addObject:@0];
    }
    [self reloadData];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [marrayOfindex removeAllObjects];
    for (int i = 0; i < _rightListArray.count; i++) {
        [marrayOfindex addObject:@0];
    }
    [marrayOfindex replaceObjectAtIndex:selectIndex withObject:@1];
    NSLog(@"%@",marrayOfindex);
    [self reloadData];
}

- (void)drawRect:(CGRect)rect {
    
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rightListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RightTableViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _rightListArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13]];
    
    // 判断是否为选中状态  1 表示 选中
    if ([marrayOfindex[indexPath.row] intValue] == 1) {
        cell.textLabel.textColor = GREEN_1ab8;
        preIndexPath = indexPath;
    } else {
        cell.textLabel.textColor = BLACK_42;
    }
//    NSInteger num = 10;
//    CGFloat numWidth = [NSString widthForString:[NSString stringWithFormat:@"%ld",num] fontSize:13.0f andHeight:20];
//    // 绘制 数字label
//    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-numWidth-8, 0, numWidth, 44)];
//    numLabel.text = [NSString stringWithFormat:@"%ld",num];
//    numLabel.textColor = BLACK_57;
//    numLabel.font = [UIFont systemFontOfSize:13.0f];
//    [cell addSubview:numLabel];
    
    // 绘制虚线分割线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
    [CuttingLineView drawDashLine:view lineLength:3 lineSpacing:1 lineColor:GRAY_da];
    [cell addSubview:view];
    
    return cell;
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 判断是否为第一次加载
    if (firstLoad) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = GREEN_1ab8;
        
        UITableViewCell *preCell = [tableView cellForRowAtIndexPath:preIndexPath];
        preCell.textLabel.textColor = BLACK_42;
        
        firstLoad = NO;
    }
    
    if (indexPath != preIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = GREEN_1ab8;
        
        UITableViewCell *preCell = [tableView cellForRowAtIndexPath:preIndexPath];
        preCell.textLabel.textColor = BLACK_42;
    }
    [marrayOfindex replaceObjectAtIndex:indexPath.row withObject:@1];
    [marrayOfindex replaceObjectAtIndex:preIndexPath.row withObject:@0];
    
    preIndexPath = indexPath;
    
    
    if (self.rightTableViewSelectIndex) {
        self.rightTableViewSelectIndex(indexPath);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
