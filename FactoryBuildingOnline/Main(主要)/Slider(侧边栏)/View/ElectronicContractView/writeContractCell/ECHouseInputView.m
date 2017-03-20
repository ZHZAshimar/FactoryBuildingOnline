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

#import "ECSignatureViewController.h"   // 画板的View


#import "PickerView.h"
#import "DatePickerView.h"
@interface ECHouseInputView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTabelView;
@property (nonatomic, strong) PickerView *pickView;
@property (nonatomic, strong) DatePickerView *dateView;
@end

@implementation ECHouseInputView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = GRAY_F4F5F9;
        [self addSubview:self.myTabelView];
        [self addSubview:self.pickView];
        [self addSubview:self.dateView];
    }
    return self;
}

#pragma mark - tableView dataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: case 2:case 3: case 6:case 8:case 9:case 10:case 11:
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

        default:
        break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 8;
            break;
            
        case 1:case 4:case 9:
            return 26;
            break;
            
        case 11:
            return Screen_Height*75/568;
            break;
        default:
            break;
    }
    return 0;
}

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
    } else if (section == 9) {
        label.text = @"物业管理费、水、电、煤气、网络等费用的承担";
    } else if (section == 11) {
        label.text = @"(注：本栏仅供合同当事人在本类型合同项下的特别安排作出约定，合同当事人不得使用本栏填写违背、变更本合同目的的内容，否则，因此到时的损害后果由合同当事人自行承当)";
        label.textColor = RED_df3d;
        label.numberOfLines = 0;
        headerView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height*75/568);
        label.frame = CGRectMake(12, 0, headerView.frame.size.width, headerView.frame.size.height);
    }
        return headerView;
    }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 22;
            break;
            
        case 1:case 2:case 3:case 4: case 5:case 6:
            return 0;
            break;
        default:
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
        case 0:case 3:case 7:case 8:case 9:
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

- (UITableViewCell *)textFieldTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
    if (!cell ) {
        cell = [[ECTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"textFieldCell"];
    }
    
    if (indexPath.section == 10) {
        cell.placeholdStr = @"选填，可自定义其他条款";
        cell.titleStr = @"附加条款";
    } else {
        cell.titleStr = @"合同备注";
        cell.placeholdStr = @"选填，可备注合同信息";
    }
    
    return cell;
}

- (UITableViewCell *)text_textButtonTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECText_TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text_textCell"];
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECText_TextTableViewCell" owner:self options:nil] firstObject];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height *38/568-0.5, Screen_Width, 0.5)];
    lineView.backgroundColor = GRAY_F4F5F9;
    [cell addSubview:lineView];
    return cell;
}

// 单选按钮的样式
- (UITableViewCell *)singleSelectButtonTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECBtnSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleCell"];
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECBtnSelectTableViewCell" owner:self options:nil] firstObject];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height *38/568-0.5, Screen_Width, 0.5)];
    lineView.backgroundColor = GRAY_F4F5F9;
    [cell addSubview:lineView];
    return cell;
}

- (UITableViewCell *)inputNumTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECInputNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"numCell"];
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECInputNumTableViewCell" owner:self options:nil] firstObject];
    }
    cell.inputTF.placeholder = @"请输入";
    
    if (indexPath.section == 2) {
        cell.titleLabel.text = @"房屋面积";
        cell.unitLabel.text = @"平方米";
    } else {
        
        cell.titleLabel.text = @"租金金额";
        cell.unitLabel.text = @"元整/月";
    }
    
    return cell;
}
- (UITableViewCell *)pullDownTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ECSelectContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifiyCell"];
    
    if (!cell ) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ECSelectContractTableViewCell" owner:self options:nil] firstObject];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            cell.contentLabel.text = @"请选择您的合同身份";
        }
            break;
        case 3:
        {
            cell.contentLabel.text = @"请选择租赁用途";
        }
            break;
        case 7:
        {
            
            if(indexPath.row == 0) {
                
                cell.contentLabel.text = @"请选择";
            } else {
                
                cell.contentLabel.text = @"首期租金支付时间";
            }
        }
            break;
        case 9:
        {
            cell.contentLabel.text = @"请选择承担方";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)addressTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * normalCell;
    
    if (indexPath.row == 3) {
        ECTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        if (!cell ) {
            cell = [[ECTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"textFieldCell"];
        }
        cell.placeholdStr = @"请输入详细地址";
        return cell;
    } else {
        
        ECSelectContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adressCell"];
        
        if (!cell ) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ECSelectContractTableViewCell" owner:self options:nil] firstObject];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height *38/568-0.5, Screen_Width, 0.5)];
        lineView.backgroundColor = GRAY_F4F5F9;
        [cell addSubview:lineView];
        
        if (indexPath.row == 0) {
            cell.contentLabel.text = @"-请选择省份-";
            
        } else if (indexPath.row == 1) {
            cell.contentLabel.text = @"-请选择城市-";
        } else if (indexPath.row == 2) {
            cell.contentLabel.text = @"-请选择地区-";
        }
        
        return cell;
        
    }
    return normalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.dateView.hidden = YES;
    self.pickView.hidden = YES;
    
    switch (indexPath.section) {
        case 0:
        {
            self.pickView.hidden = NO;
            self.pickView.dataSource = @[@"请选择您的身份",@"出租人（房东）",@"承租人（租户）"];
            self.pickView.selectStrBlock = ^(NSString *selectStrBlock){
                ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.contentLabel.text = selectStrBlock;
            };
        }
            break;
        case 1:
        {
            
        }
            break;
        case 5:
        {
            self.dateView.hidden = NO;
            self.dateView.timeBlock = ^(NSDate *date){
                ECText_TextTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                [dateFormatter setDateFormat:@"YYY年MM月dd日"];
                cell.contentLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
            };
        }
        case 7:
        {
            if (indexPath.row == 1) {
                self.dateView.hidden = NO;
                self.dateView.timeBlock = ^(NSDate *date){
                    ECSelectContractTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    NSDateFormatter *dateFormatter = [NSDateFormatter new];
                    [dateFormatter setDateFormat:@"YYY年MM月dd日"];
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
                };
            } else {
                
            }
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
//            if (tagIndex == 101) {
//                ECSignatureViewController  *signatureVC = [ECSignatureViewController new];
//                [self.navigationController pushViewController:signatureVC animated:YES];
//            }
        };
        _myTabelView.tableFooterView = footerView;
        
        _myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;    // 去掉分割线
        
        [_myTabelView registerClass:[ECTextFieldTableViewCell class] forCellReuseIdentifier:@"textFieldCell"];
    }
    return _myTabelView;
}

- (PickerView *)pickView {
    if (!_pickView) {
        _pickView = [[PickerView alloc] initWithFrame:CGRectMake(0, Screen_Height*(1-207/568)-200, Screen_Width, Screen_Height*207/568)];
        _pickView.backgroundColor = [UIColor colorWithHex:0xD2D5DC];
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
