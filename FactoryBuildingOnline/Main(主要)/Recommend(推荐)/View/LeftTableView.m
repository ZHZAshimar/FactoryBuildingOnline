//
//  LeftTableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "LeftTableView.h"

#define CellID @"cellID"

@interface LeftTableView()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSIndexPath *preIndexPath;  // 用于保存上一次点击的 indexPath
    BOOL firstLoad;
    NSMutableArray *marrayOfindex;  // 用0，1来标记 cell 的文字颜色，防止重用
}
@end

@implementation LeftTableView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        marrayOfindex = [NSMutableArray array];
        firstLoad = YES;
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.separatorColor = GRAY_db;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = GRAY_db.CGColor;
    }
    
    return self;
}

- (void)setLeftListArray:(NSArray *)leftListArray {
    _leftListArray = leftListArray;
    for (int i = 0; i < leftListArray.count; i++) {
        [marrayOfindex addObject:@0];
    }
    [self reloadData];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    _selectIndex = selectIndex;
    [marrayOfindex replaceObjectAtIndex:selectIndex withObject:@1];
    [self reloadData];
}

#pragma mark - tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _leftListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
    }
    
    if ([marrayOfindex[indexPath.row] intValue] == 1) {
        
        cell.textLabel.textColor = GREEN_1ab8;
        cell.backgroundColor = [UIColor whiteColor];
        preIndexPath = indexPath;
        
    } else {
        cell.textLabel.textColor = BLACK_42;
        cell.backgroundColor = GRAY_235;
    }
    
    cell.textLabel.text = _leftListArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
    
    
//    NSInteger num = 10;
//    
//    CGFloat numWidth = [NSString widthForString:[NSString stringWithFormat:@"%ld",num] fontSize:8.0f andHeight:12];
//    
//    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width-10-numWidth-5, cell.frame.size.height/2-6, numWidth+5, 12)];
//    numLabel.backgroundColor = GRAY_cc;
//    numLabel.text = [NSString stringWithFormat:@"%ld",num];
//    numLabel.textColor = [UIColor whiteColor];
//    numLabel.textAlignment = NSTextAlignmentCenter;
//    numLabel.font =[UIFont systemFontOfSize:8.0f];
//    numLabel.layer.cornerRadius = 5;
//    numLabel.layer.masksToBounds = YES;
//    [cell addSubview:numLabel];
    
    
    // cell 取消点击效果
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (firstLoad) {
//        // 现在点击的cell
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        cell.textLabel.textColor = GREEN_1ab8;
//        cell.backgroundColor = [UIColor whiteColor];
//        // 上一个点击的cell
//        
//        UITableViewCell *preCell = [tableView cellForRowAtIndexPath:preIndexPath];
//        preCell.textLabel.textColor = BLACK_42;
//        preCell.backgroundColor = GRAY_235;
//        
//        firstLoad = NO;
//    } else if ( indexPath != preIndexPath ) {
//        // 现在点击的cell
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        cell.textLabel.textColor = GREEN_1ab8;
//        cell.backgroundColor = [UIColor whiteColor];
//        // 上一个点击的cell
//        UITableViewCell *preCell = [tableView cellForRowAtIndexPath:preIndexPath];
//        
//        preCell.textLabel.textColor = BLACK_42;
//        preCell.backgroundColor = GRAY_235;
//    }
//    
//    [marrayOfindex replaceObjectAtIndex:indexPath.row withObject:@1];
//    [marrayOfindex replaceObjectAtIndex:preIndexPath.row withObject:@0];
//    // 将 此次点击的 indexPath 赋值给 preIndexPath;
//    preIndexPath = indexPath;
//    // 消除点击的痕迹
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    [tableView setSectionIndexBackgroundColor:[UIColor whiteColor]];
// 
//    // 回调
//    if (self.leftTableViewSelectIndex) {
//        self.leftTableViewSelectIndex(indexPath);
//    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
