//
//  ECHouseInputView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECHouseInputView.h"
#import "ECBtnSelectTableViewCell.h"
#import "ECSelectContractTableViewCell.h"
#import "ECText_TextTableViewCell.h"
#import "ECTextFieldTableViewCell.h"
#import "ECTimerView.h"
#import "ECTwoButtonFooter.h"
#import "ECInputNumTableViewCell.h"

#import "ECLabel_TextFieldTableViewCell.h"
#import "ECSignatureViewController.h"   // 画板的View

#import "PickerView.h"
#import "DatePickerView.h"

#import "ECDepoistInputTableViewCell.h"
#import "ECSwichButtonTableViewCell.h"

@interface ECHouseInputView ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *singleArray;                   // 单选 数组
    ECBtnSelectTableViewCell *lastCell;     // 记录当选区域的 最后一个cell
    ECBtnSelectTableViewCell *currentCell;  // 记录单选区域的 当前 cell
    NSIndexPath *sixIndexPath;              // 记录单选区域的 其他 cell
    BOOL isOn;                              // 开关按钮是否打开
}
@property (nonatomic, strong) UITableView *myTabelView;
@property (nonatomic, strong) PickerView *pickView;
@property (nonatomic, strong) DatePickerView *dateView;
@property (nonatomic, strong) NSMutableArray *selectedArray;   // 已经选择或填好的数据，按照界面的顺序来排序

@property (nonatomic, strong)NSArray *allAreaArray;     // 所有地点的数据集
@property (nonatomic, strong)NSMutableArray *provinceArray; // 省 数组
@property (nonatomic, strong)NSMutableArray *cityArray;     // 城市 数组
@property (nonatomic, strong)NSMutableArray *areaArray;     // 区数组
@property (nonatomic, assign)NSInteger tagIndex;
@end

@implementation ECHouseInputView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = GRAY_F4F5F9;
        [self addSubview:self.myTabelView];
        [self addSubview:self.pickView];
        [self addSubview:self.dateView];
        [self getDataSource];
    }
    return self;
}
#pragma mark - 初始化与获取数据
- (void)getDataSource {
    
    self.selectedArray = [NSMutableArray array];
    self.provinceArray = [NSMutableArray array];
    self.cityArray = [NSMutableArray array];
    self.areaArray = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.allAreaArray  = [NSArray arrayWithArray:dic[@"cityList"]];
    
    [self.provinceArray removeAllObjects];
    for (NSDictionary *dic in self.allAreaArray) {
        [self.provinceArray addObject:dic[@"name"]];
    }
    
    //为已选择的数组添加内容，以免发生数组越界的问题
    for (int i = 0; i < 12; i++) {
        NSMutableArray *marray = [NSMutableArray array];
        
        if (i == 1) {
            
            for (int i = 0; i < 4; i++) {
                [marray addObject:[NSArray array]];
            }
            
        } else if (i == 5 || i==8 ) {
            for (int i = 0; i < 2; i++) {
                [marray addObject:@""];
            }
        } else if (i == 7) {
            for (int i = 0; i < 2; i++) {
                [marray addObject:[NSArray array]];
            }
        }
        [self.selectedArray addObject:marray];
        
    }
    singleArray = @[@"热水器",@"空调",@"床",@"桌子",@"洗衣机",@"冰箱"];
}

#pragma mark - swichButtonDidTouch:
- (void)swichButtonDidTouch:(UISwitch*)sender {
    
    sender.on = !sender.on;
    
    isOn = sender.on;
    // 刷新第八个section
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:8];
    [self.myTabelView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    lastCell.selectLogo.image = [UIImage imageNamed:@"uncheck"];
    
    currentCell = [self.myTabelView cellForRowAtIndexPath:sixIndexPath];
    currentCell.selectLogo.image = [UIImage imageNamed:@"choose"];
    
    lastCell = currentCell;
    [self.selectedArray replaceObjectAtIndex:4 withObject:@[@"其他设备",@(6)]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.selectedArray replaceObjectAtIndex:4 withObject:@[textField.text,@(6)]];
}


#pragma mark - tableView dataSource
// 多少个section
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}
// 每个section有多少个row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: case 2:case 3: case 6:case 9:case 10:case 11:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 4:
            return 7;
            break;
        case 5:case 7:
            return 2;
            break;
        case 8:
        {
            if (isOn) {
                return 3;
            } else {
                return 1;
            }
        }
            break;
        default:
        break;
    }
    return 0;
}
// 每个section的header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 8;
            break;
            
        case 1:case 4:case 7:case 9:
            return Screen_Height*26/568;
            break;
        case 11:
            return Screen_Height*89/568;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}
// headerView 的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height*26/568)];
    headerView.backgroundColor = [UIColor clearColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, headerView.frame.size.width, headerView.frame.size.height)];
    label.textColor = BLACK_66;
    label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
    [headerView addSubview:label];

    if (section == 1) {

        label.text = @"房屋的具体地址";
    } else if (section == 4) {
        label.text = @"房屋内的设施";
    } else if (section == 7) {
        label.text = @"租金应支付时间";
    } else if (section == 9) {
        label.text = @"物业管理费、水、电、煤气、网络等费用的承担";
    } else if (section == 11) {
        label.text = @"(注：本栏仅供合同当事人在本类型合同项下的特别安排作出约定，合同当事人不得使用本栏填写违背、变更本合同目的的内容，否则，因此到时的损害后果由合同当事人自行承当)";
        label.textColor = RED_df3d;
        label.numberOfLines = 0;
        headerView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height*89/568);
        label.frame = CGRectMake(12, 0, headerView.frame.size.width, Screen_Height*70/568);
    }
        return headerView;
    }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 22;
            break;
        case 7:
            return 14;
            break;
        case 9:
            return 24;
            break;
        case 11:
            return 40;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return Screen_Height *44/568;
            break;
            
        case 1:case 2:case 3:case 4: case 5:case 6:case 7: case 8:case 9:case 10:case 11:
            return Screen_Height *38/568;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:case 3:case 7:case 9:
        {
            cell = [self pullDownTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case 1:
        {
            cell = [self addressTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case 2:case 6:
        {
            cell = [self inputNumTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case 4:
        {
            cell = [self singleSelectButtonTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case 5:
        {
            cell = [self text_textButtonTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case 8:
        {
            cell = [self swichCellTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        case 10:case 11:
        {
            cell = [self textFieldTableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    return cell;
}
#pragma mark - 绘制 开关cell
- (UITableViewCell *)swichCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ECSwichButtonTableViewCell *swichCell = [tableView dequeueReusableCellWithIdentifier:@"ECSwichButtonTableViewCell"];
        if (!swichCell ) {
            swichCell = [[[NSBundle mainBundle] loadNibNamed:@"ECSwichButtonTableViewCell" owner:self options:nil] firstObject];
        }
        [swichCell.swichButton addTarget:self action:@selector(swichButtonDidTouch:) forControlEvents:UIControlEventValueChanged];   // 为UISwitch 添加监听事件
        
        swichCell.swichButton.on = isOn;
        
        return swichCell;
        
    } else if (indexPath.row == 1) {
        ECDepoistInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECDepoistInputTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ECDepoistInputTableViewCell" owner:self options:nil] firstObject];
        }
        // 取值
        NSMutableArray *array = self.selectedArray[8];
        if (array.count > 1) {
            cell.depoistTF.text = array[0];
        }
        __weak typeof(self) weakSelf = self;
        cell.inputBlock = ^(NSString *inputText){
            [array replaceObjectAtIndex:0 withObject:inputText];
            [weakSelf.selectedArray replaceObjectAtIndex:8 withObject:array];
        };
        return cell;
    } else {
        ECText_TextTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"ECText_TextTableViewCell"];
        if (!timeCell) {
            timeCell = [[[NSBundle mainBundle] loadNibNamed:@"ECText_TextTableViewCell" owner:self options:nil] firstObject];
        }
        timeCell.titleLabel.text = @"押金支付时间";
        NSMutableArray *array = self.selectedArray[8];
        if (array.count > 1) {
            timeCell.contentLabel.text = array[1];
        }
        return timeCell;
    }
}

- (UITableViewCell *)textFieldTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECLabel_TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECLabel_TextFieldTableViewCell"];
    if (!cell ) {
        cell = [[ECLabel_TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ECLabel_TextFieldTableViewCell"];
    }
    NSArray *array = self.selectedArray[indexPath.section];
    // cell 赋值
    cell.myTextView.text = array.count > 0 ? array[0] : @"";
    if (indexPath.section == 10) {
        cell.placeholdStr = @"选填，可自定义其他条款";
        cell.titleStr = @"附加条款";
    } else {
        cell.titleStr = @"合同备注";
        cell.placeholdStr = @"选填，可备注合同信息";
    }
    __weak typeof(self) weakSelf = self;
    // block 替代值
    cell.textBlock = ^(NSString *text) {
        [weakSelf.selectedArray replaceObjectAtIndex:indexPath.section withObject:@[text]];
    };
    return cell;
}

- (UITableViewCell *)text_textButtonTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECText_TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text_textCell"];
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECText_TextTableViewCell" owner:self options:nil] firstObject];
    }
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"租期开始时间";
        
    } else {
        cell.titleLabel.text = @"租期结束时间";
    }
    // 若有值，进行赋值
    NSArray *array = self.selectedArray[5];
    if (array.count > 0) {
        
        cell.contentLabel.text =array[indexPath.row];
    }
   
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height *38/568-0.5, Screen_Width, 0.5)];
    lineView.backgroundColor = GRAY_F4F5F9;
    [cell addSubview:lineView];
    
    return cell;
}

#pragma mark - 单选按钮的样式
- (UITableViewCell *)singleSelectButtonTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECBtnSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleCell"];
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECBtnSelectTableViewCell" owner:self options:nil] firstObject];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height *38/568-0.5, Screen_Width, 0.5)];
    lineView.backgroundColor = GRAY_F4F5F9;
    [cell addSubview:lineView];
    
    if (indexPath.row == 6) {
        cell.contentTF.placeholder = @"其他设施";
        cell.contentTF.enabled = YES;
        cell.contentTF.delegate = self;
        sixIndexPath = indexPath;
    } else {
        cell.contentTF.enabled = NO;
        cell.contentTF.text = singleArray[indexPath.row];
    }
    NSArray *array = self.selectedArray[indexPath.section];
    if (array.count > 1) {
        if ([array[1] integerValue] == indexPath.row) {
            cell.selectLogo.image = [UIImage imageNamed:@"choose"];
            cell.contentTF.text = array[0];
            lastCell = cell;
        } else {
            cell.selectLogo.image = [UIImage imageNamed:@"uncheck"];
        }
    }
    
    return cell;
}

- (UITableViewCell *)inputNumTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECInputNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"numCell"];
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECInputNumTableViewCell" owner:self options:nil] firstObject];
    }
    cell.inputTF.placeholder = @"请输入";
    
    __weak typeof(self) weakSelf = self;
    
    NSArray *tmpArray = self.selectedArray[indexPath.section];
    cell.inputTF.text = tmpArray.count > 0 ? tmpArray[0] : @"";
    
    if (indexPath.section == 2) {
        cell.titleLabel.text = @"房屋面积";
        cell.unitLabel.text = @"平方米";
        
        
        cell.inputBlock = ^(NSString *text) {
            NSArray *array = [NSArray arrayWithObject:text];
            [weakSelf.selectedArray replaceObjectAtIndex:2 withObject:array];
        };
    } else {
        
        cell.titleLabel.text = @"租金金额";
        cell.unitLabel.text = @"元整/月";
        cell.inputBlock = ^(NSString *text) {
            NSArray *array = [NSArray arrayWithObject:text];
            [weakSelf.selectedArray replaceObjectAtIndex:6 withObject:array];
        };
    }
    
    return cell;
}
#pragma mark - cell 的绘制
- (UITableViewCell *)pullDownTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ECSelectContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifiyCell"];
    
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECSelectContractTableViewCell" owner:self options:nil] firstObject];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            NSArray *array = self.selectedArray[0];
            if (array.count <= 0) {
                cell.contentLabel.text = @"请选择您的合同身份";
            } else {
                cell.contentLabel.text = self.selectedArray[0][@"name"];
            }
            
        }
            break;
        case 3:
        {
            NSArray *array = self.selectedArray[3];
            if (array.count <= 0) {
                cell.contentLabel.text = @"请选择租赁用途";
            } else {
                cell.contentLabel.text = self.selectedArray[3][@"name"];
            }
        }
            break;
        case 7:
        {
            NSDictionary *dic = self.selectedArray[7][indexPath.row];
            
            if(indexPath.row == 0) {
                
                cell.contentLabel.text =  dic.count > 0 ? dic[@"name"] : @"请选择";
            } else {
                
                cell.contentLabel.text = dic.count > 0 ? dic[@"value"] : @"首期租金支付时间";
            }
        }
            break;
        case 9:
        {
            NSArray *array = self.selectedArray[9];
            if (array.count <= 0) {
                cell.contentLabel.text = @"请选择承担方";
            } else {
                cell.contentLabel.text = self.selectedArray[9][@"name"];
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)addressTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * normalCell;
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 3) {
        ECTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        if (!cell ) {
            cell = [[ECTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"textFieldCell"];
        }
        cell.placeholdStr = @"请输入详细地址";
        
        NSMutableArray *mArr = weakSelf.selectedArray[1];
        NSDictionary *dic = mArr[3];
        if (dic.count >= 1) {
            cell.myTextView.text = dic[@"value"];
            cell.placeholdStr = @"";
        }
        
        cell.textBlock = ^(NSString *areaText) {
            [mArr replaceObjectAtIndex:3 withObject:@{@"value":areaText}];
            [weakSelf.selectedArray replaceObjectAtIndex:1 withObject:mArr];
        };
        return cell;
    } else {
        
        ECSelectContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adressCell"];
        
        if (!cell ) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ECSelectContractTableViewCell" owner:self options:nil] firstObject];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height *38/568-0.5, Screen_Width, 0.5)];
        lineView.backgroundColor = GRAY_F4F5F9;
        [cell addSubview:lineView];
        // 取出selectedarray 中的数据，绘制界面
        NSDictionary *dic = self.selectedArray[1][indexPath.row];
        
        if (indexPath.row == 0) {
            if (dic.count <= 0) {
                cell.contentLabel.text = @"-请选择省份-";
            } else {
                cell.contentLabel.text = dic[@"name"];
            }
        } else if (indexPath.row == 1) {
            if (dic.count <= 0) {
                cell.contentLabel.text = @"-请选择城市-";
            } else {
                cell.contentLabel.text = dic[@"name"];
            }
        } else if (indexPath.row == 2) {
            if (dic.count <= 0) {
                cell.contentLabel.text = @"-请选择地区-";
            } else {
                cell.contentLabel.text = dic[@"name"];
            }
        }
        
        return cell;
        
    }
    return normalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    
//    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
//    CGRect rect  = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
    // 先隐藏，需要显示的时候再显示
    self.dateView.hidden = YES;
    self.pickView.hidden = YES;
    
    switch (indexPath.section) {
#pragma mark - 选择身份
        case 0:
        {
            self.pickView.hidden = NO;
            self.pickView.dataSource = @[@"请选择您的身份",@"出租人（房东）",@"承租人（租户）"];
            self.pickView.selectStrBlock = ^(NSString *selectStr,NSInteger index){
                if (index < 1) {
                    return ;
                }
                ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.contentLabel.text = selectStr;
                
                [weakSelf.selectedArray replaceObjectAtIndex:0 withObject:@{@"name":selectStr,@"index":@(index-1)}] ;   // 将数据插入已选数组中
                
            };
        }
            break;
#pragma mark - 选择省市区
        case 1:
        {
            self.pickView.hidden = NO;
            ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.selectedArray[1]];
            
            switch (indexPath.row) {
                case 0:     // 选择省
                {
                    
                    self.pickView.dataSource = self.provinceArray;
                    
                    self.pickView.selectStrBlock = ^(NSString *string, NSInteger index){
                        
                        cell.contentLabel.text = string;
                        
                        NSArray *tmpArray = weakSelf.allAreaArray[index][@"edsAddrList"];
                        
                        [weakSelf.cityArray removeAllObjects];
                        
                        for (NSDictionary *dic in tmpArray) {
                            [weakSelf.cityArray addObject:dic[@"name"]];
                        }
                        weakSelf.tagIndex = index;
                        // 将数据添加到selectedArray 中
                        [mArray replaceObjectAtIndex:0 withObject:@{@"name":string,@"index":@(index)}];
                         [weakSelf.selectedArray replaceObjectAtIndex:1 withObject:mArray];
                        
                    };
                }
                    break;
                case 1:     // 选择市
                {
                    
                    self.pickView.dataSource = self.cityArray;
                    
                    __weak typeof(self) weakSelf = self;
                    
                    self.pickView.selectStrBlock = ^(NSString *string, NSInteger index){
                        
                        if (string.length <= 0) {
                            return ;
                        }
                        
                        cell.contentLabel.text = string;
                        [weakSelf.areaArray removeAllObjects];
                        NSArray *tmpArray = weakSelf.allAreaArray[weakSelf.tagIndex][@"edsAddrList"][index][@"edsAddrList"];
                        for (NSDictionary *dic in tmpArray) {
                            [weakSelf.areaArray addObject:dic[@"name"]];
                        }
                        [mArray replaceObjectAtIndex:1 withObject:@{@"name":string,@"index":@(index)}];
                         [weakSelf.selectedArray replaceObjectAtIndex:1 withObject:mArray];
                    };
                }
                    break;
                case 2:     // 选择区域
                {
                    self.pickView.dataSource = self.areaArray;
                    
                    self.pickView.selectStrBlock = ^(NSString *string, NSInteger index){
                        if (string.length <= 0) {
                            return ;
                        }

                        cell.contentLabel.text = string;
                        
                        [mArray replaceObjectAtIndex:2 withObject:@{@"name":string,@"index":@(index)}];
                        [weakSelf.selectedArray replaceObjectAtIndex:1 withObject:mArray];
                        NSLog(@"%@",weakSelf.selectedArray);
                    };

                }
                    break;

                default:
                    break;
            }
            
            
            
        }
            break;
#pragma mark - 选择租赁用途
        case 3:
        {
            self.pickView.hidden = NO;
            self.pickView.dataSource = @[@"请选择租赁用途",@"住宅",@"办公"];
            self.pickView.selectStrBlock = ^(NSString *selectStr,NSInteger index){
                if (index < 1) {
                    return ;
                }
                ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.contentLabel.text = selectStr;
                
                [weakSelf.selectedArray replaceObjectAtIndex:3 withObject:@{@"name":selectStr,@"index":@(index-1)}] ;   // 将数据插入已选数组中
                
            };

        }
            break;
            
#pragma mark - 房屋内的设施
        case 4:{
            
            lastCell.selectLogo.image = [UIImage imageNamed:@"uncheck"];
            
            currentCell = [tableView cellForRowAtIndexPath:indexPath];
            currentCell.selectLogo.image = [UIImage imageNamed:@"choose"];

            lastCell = currentCell;
            
            if (indexPath.row < 6) {
                [self.selectedArray replaceObjectAtIndex:4 withObject:@[currentCell.contentTF.text,@(indexPath.row)]];
            }
        }
            break;
#pragma mark - 租期开始时间
        case 5:
        {
            self.dateView.hidden = NO;
            self.dateView.timeBlock = ^(NSDate *date){
                ECText_TextTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                [dateFormatter setDateFormat:@"YYY年MM月dd日"];
                cell.contentLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
                
                NSMutableArray *mArr = [NSMutableArray arrayWithArray:weakSelf.selectedArray[5]];
                [mArr replaceObjectAtIndex:indexPath.row withObject:cell.contentLabel.text];
                [weakSelf.selectedArray replaceObjectAtIndex:5 withObject:mArr];
                NSLog(@"%@",weakSelf.selectedArray);
            };
        }
            break;
#pragma mark - 租金应付时间
        case 7:
        {
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.selectedArray[7]];
            if (indexPath.row == 1) {
                self.dateView.hidden = NO;
                self.dateView.timeBlock = ^(NSDate *date){
                    
                    ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    NSDateFormatter *dateFormatter = [NSDateFormatter new];
                    [dateFormatter setDateFormat:@"YYY年MM月dd日"];
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
                    
                    [mArr replaceObjectAtIndex:1 withObject:@{@"value":cell.contentLabel.text,@"date":date}];
                    [weakSelf.selectedArray replaceObjectAtIndex:7 withObject:mArr];
                    [weakSelf.myTabelView reloadData];
                };
            } else {
                
                self.pickView.hidden = NO;
                self.pickView.dataSource = @[@"请选择租金应付时间",@"每月",@"每季度",@"每半年",@"每一年"];
                self.pickView.selectStrBlock = ^(NSString *selectStr,NSInteger index){
                    if (index < 1) {
                        return ;
                    }
                    ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.contentLabel.text = selectStr;
                    
                    [mArr replaceObjectAtIndex:0 withObject:@{@"name":selectStr,@"index":@(index-1)}] ;   // 将数据插入已选数组中
                    [weakSelf.selectedArray replaceObjectAtIndex:7 withObject:mArr];
                    [weakSelf.myTabelView reloadData];
                };
            }
        }
            break;
#pragma mark - 押金支付时间
        case 8:
        {
            
            if (indexPath.row == 2) {
                NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.selectedArray[8]];
                self.dateView.hidden = NO;
                self.dateView.timeBlock = ^(NSDate *date){
                    
                    ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    NSDateFormatter *dateFormatter = [NSDateFormatter new];
                    [dateFormatter setDateFormat:@"YYY年MM月dd日"];
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
                    
                    [mArr replaceObjectAtIndex:1 withObject:cell.contentLabel.text];
                    [weakSelf.selectedArray replaceObjectAtIndex:8 withObject:mArr];
                    [weakSelf.myTabelView reloadData];
                };
            }
        }
            break;
        case 9:
        {
            self.pickView.hidden = NO;
            self.pickView.dataSource = @[@"请选择承担方",@"出租人(房东)",@"承租人(租户)"];
            self.pickView.selectStrBlock = ^(NSString *selectStr,NSInteger index){
                if (index < 1) {
                    return ;
                }
                ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.contentLabel.text = selectStr;
                
                [weakSelf.selectedArray replaceObjectAtIndex:9 withObject:@{@"name":selectStr,@"index":@(index-1)}] ;   // 将数据插入已选数组中
                
            };
            
        }
            
            break;
        default:
            break;
    }
    
}

#pragma mark - lazyload
- (UITableView *)myTabelView {
    if (!_myTabelView) {
        _myTabelView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _myTabelView.backgroundColor = [UIColor clearColor];
        
        _myTabelView.delegate = self;
        _myTabelView.dataSource = self;
        // 表头
        ECTimerView *timeHeaderView = [[ECTimerView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height * 32/568)];
        _myTabelView.tableHeaderView = timeHeaderView;
        
        // 表尾
        ECTwoButtonFooter *footerView = [[ECTwoButtonFooter alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height *49/568)];
        footerView.tagBlock = ^(NSInteger tagIndex){
            if (tagIndex == 101) {
                self.nextBlock(tagIndex);
            }
        };
        _myTabelView.tableFooterView = footerView;
        _myTabelView.sectionFooterHeight = 1.0;
        _myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;    // 去掉分割线
        
        [_myTabelView registerClass:[ECTextFieldTableViewCell class] forCellReuseIdentifier:@"textFieldCell"];
    }
    return _myTabelView;
}

- (PickerView *)pickView {
    if (!_pickView) {
        _pickView = [[PickerView alloc] initWithFrame:CGRectMake(0, Screen_Height*(1-207/568)-200, Screen_Width, Screen_Height*207/568)];
        _pickView.hidden = YES;
        
    }
    return _pickView;
}

- (DatePickerView *)dateView {
    if (!_dateView) {
        _dateView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, Screen_Height*(1-207/568)-200, Screen_Width, Screen_Height*207/568)];
        _dateView.backgroundColor = [UIColor colorWithHex:0xD2D5DC];
        _dateView.hidden = YES;
        
    }
    return _dateView;
}

@end
