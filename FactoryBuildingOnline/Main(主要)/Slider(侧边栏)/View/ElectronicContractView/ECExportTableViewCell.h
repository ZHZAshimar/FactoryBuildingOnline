//
//  ECExportTableViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECExportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;        // 选中按钮
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;           // 状态
@property (weak, nonatomic) IBOutlet UILabel *bigTextLabel;         //  合同关键字
@property (weak, nonatomic) IBOutlet UILabel *contractNameLabel;    // 合同名称
@property (weak, nonatomic) IBOutlet UILabel *contractNumLabel;     // 合同编号
@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;         // 发起人
@property (weak, nonatomic) IBOutlet UILabel *invitedPeopleLabel;   // 受邀人
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;            // 日期Label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;            // 时间


// 前面的文字说明，为了适配文字大小才设置输出
@property (weak, nonatomic) IBOutlet UILabel *iLabel;
@property (weak, nonatomic) IBOutlet UILabel *sLabel;
@property (weak, nonatomic) IBOutlet UILabel *nLabel;


@end
