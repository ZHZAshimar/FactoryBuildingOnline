//
//  MyReserveCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by Ashimar ZHENG on 2017/2/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "MyReserveCollectionViewCell.h"

@implementation MyReserveCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MyReserveCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count <=0 ) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfViews[0];
        self.publishTimeLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13]];
        self.matchTimeLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
        self.contentLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14]];
        
        self.matchTimeLabel.layer.cornerRadius = 5;
        self.matchTimeLabel.layer.masksToBounds = YES;
        
    }
    return self;
}

/*、
 {
 "created_time" = 1486265438;
 "delete_id" = 0;
 id = 1;
 need =             {
 "callback_day" = 7;
 content = 651651;
 id = 1;
 };
 "owner_id" = 10;
 status = 1;
 "update_id" = 0;
 "update_time" = 1486265438;
 }
 */
#pragma mark - 重写 setter 方法
- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    NSString *contentStr = dataDic[@"need"][@"content"];
    
    NSLog(@"%ld",contentStr.length);
    
    NSString * matchStr;
    int type = [dataDic[@"status"] intValue];
    if (type == 1) {
        // 匹配中
        matchStr = [NSString stringWithFormat:@"处理中:%@天",dataDic[@"need"][@"callback_day"]];
        self.matchTimeLabel.backgroundColor = [UIColor redColor];
    } else {
        
        matchStr = [NSString stringWithFormat:@"处理结束:%@天",dataDic[@"need"][@"callback_day"]];
        self.matchTimeLabel.backgroundColor = GREEN_19b8;
    }
    
    CGFloat matchStrLength = [NSString widthForString:matchStr fontSize:[UIFont adjustFontSize:self.matchTimeLabel.font.pointSize] andHeight:30];
    self.matchTimeLabel.text = matchStr;
    self.matchLength.constant = matchStrLength+5;
    
    NSString *dateStr = [self stringWithTimeFormat:dataDic[@"created_time"]];
    // 日期赋值
    self.publishTimeLabel.text = [NSString stringWithFormat:@"发布时间:%@",dateStr];
    
}

- (NSString *)stringWithTimeFormat:(NSString *)string {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[string doubleValue]];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYY/MM/dd"];
    NSString *timeFormat = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
    return timeFormat;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
