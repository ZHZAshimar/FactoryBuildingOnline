//
//  DetailOfFactoryInfoCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "DetailOfFactoryInfoCollectionViewCell.h"

@interface DetailOfFactoryInfoCollectionViewCell ()
{
    UIImage *upImage;
    UIImage *downImage;
}
@property (weak, nonatomic) IBOutlet UILabel *pLabel;   // 发布时间
@property (weak, nonatomic) IBOutlet UILabel *sLabel;   // 浏览量
@property (weak, nonatomic) IBOutlet UILabel *rLabel;   // 出租方式
@property (weak, nonatomic) IBOutlet UILabel *cLabel;   // 押金
@property (weak, nonatomic) IBOutlet UILabel *nLabel;   // 编号
@property (weak, nonatomic) IBOutlet UILabel *lwLabel;  // 租赁方式
@property (weak, nonatomic) IBOutlet UILabel *oLabel;   // 业主类型
@property (weak, nonatomic) IBOutlet UILabel *nlLabel;  // 新旧程度

@property (weak, nonatomic) IBOutlet UILabel *officeLabel;  // 办公室面积
@property (weak, nonatomic) IBOutlet UILabel *hLabel;   // 宿舍面积
@property (weak, nonatomic) IBOutlet UILabel *aLabel;   // 适用行业
@property (weak, nonatomic) IBOutlet UILabel *eLabel;   // 配电量
@property (weak, nonatomic) IBOutlet UILabel *onfLabel; // 所在楼层
@property (weak, nonatomic) IBOutlet UILabel *fsLabel;  // 楼层结构
@property (weak, nonatomic) IBOutlet    UILabel *frLabel;   // 厂房食堂
@property (weak, nonatomic) IBOutlet UILabel *feLabel;  // 厂房电梯
@property (weak, nonatomic) IBOutlet UILabel *fhLabel;  // 厂房高度
@property (weak, nonatomic) IBOutlet UILabel *fmLabel;  // 园区配套
@property (weak, nonatomic) IBOutlet UILabel *fireLabel;    // 消防
// ________________ 上面是灰色的label，用于修改文字大小
@property (weak, nonatomic) IBOutlet UILabel *utLabel;

@property (weak, nonatomic) IBOutlet UILabel *evrmLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel; // 发布时间
@property (weak, nonatomic) IBOutlet UILabel *scanCountLabel;   // 浏览量
@property (weak, nonatomic) IBOutlet UILabel *rentTypeLabel;    // 出租方式
@property (weak, nonatomic) IBOutlet UILabel *cashpledgeLabel;  // 押金
@property (weak, nonatomic) IBOutlet UILabel *rantAndSaleLabel; // 可租可售
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;  // 编号

@property (weak, nonatomic) IBOutlet UILabel *owerTypeLabel;    // 业主类型

@property (weak, nonatomic) IBOutlet UILabel *newofoldLabel;   // 新旧程度
@property (weak, nonatomic) IBOutlet UILabel *officeAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelAreaLabel;       // 宿舍
@property (weak, nonatomic) IBOutlet UILabel *adjustTradeLabel; // 适用行业
@property (weak, nonatomic) IBOutlet UILabel *electricitryLabel;    // 配电量
@property (weak, nonatomic) IBOutlet UILabel *onFloorLabel;         // 所在楼层
@property (weak, nonatomic) IBOutlet UILabel *factoryStrution;      // 厂房结构
@property (weak, nonatomic) IBOutlet UILabel *factoryCanteenLabel;  // 厂房食堂
@property (weak, nonatomic) IBOutlet UILabel *parkMakingLabel;      // 园区配套
@property (weak, nonatomic) IBOutlet UILabel *fireControlLabel;     // 消防
@property (weak, nonatomic) IBOutlet UILabel *factoryElevatorLabel; // 厂房电梯
@property (weak, nonatomic) IBOutlet UILabel *floorHeightLabel; // 楼层高度
@property (weak, nonatomic) IBOutlet UILabel *enviromentalLabel;

@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;

@end

@implementation DetailOfFactoryInfoCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"DetailOfFactoryInfoCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            return nil;
        }
        
        if (![arrayOfView[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfView[0];
        
        self.cellHeight.constant = Screen_Height*28/568;
        
        [self setFontAdjust];
    }
    
    return self;
}

- (void)setFontAdjust {
    
    CGFloat fontSize = 12.0f;
   
    self.publishTimeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.scanCountLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.rentTypeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.cashpledgeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.numberLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    
    self.rantAndSaleLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.owerTypeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.newofoldLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.officeAreaLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.hotelAreaLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    
    self.adjustTradeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.electricitryLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.onFloorLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.factoryStrution.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    
    self.factoryCanteenLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.parkMakingLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.fireControlLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.floorHeightLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.factoryElevatorLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.floorHeightLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.factoryElevatorLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    
    self.updateTimeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    self.enviromentalLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize]];
    
    
    self.utLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.evrmLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    

    
    self.pLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.sLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.rLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.cLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.nLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    
    self.lwLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.oLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.nlLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.officeLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.hLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    
    self.aLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.eLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.onfLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.fsLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.frLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    
    self.feLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.fhLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.fmLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    self.fireLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:fontSize-1]];
    
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:fontSize-1]];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    NSString *time = [NSString getTimeFormatter:dataDic[@"created_time"]];
    self.publishTimeLabel.text = time;
    self.rentTypeLabel.text = dataDic[@"rent_type"];
    self.cashpledgeLabel.text = dataDic[@"pre_pay"];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"factory_id"]];
    
    self.scanCountLabel.text = [NSString stringWithFormat:@"%ld",[dataDic[@"view_count"] integerValue]];

    if ([dataDic[@"data_type"] intValue] == 2) {
        self.sLabel.text = @"编号:";
        self.scanCountLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"factory_id"]];
        [self.numberLabel removeFromSuperview];
        [self.nLabel removeFromSuperview];
        self.cellHeight.constant = self.frame.size.height/2;
    }
    
}


- (IBAction)moreInfomationAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [sender setTitleColor:GRAY_80 forState:UIControlStateSelected];
        self.tagBlock(YES);
        [sender setImage:downImage forState:0];
    } else {
        [sender setTitleColor:GREEN_19b8 forState:UIControlStateNormal];
        self.tagBlock(NO);
        
        [sender setImage:upImage forState:0];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage *greenImage = [UIImage imageNamed:@"turnUp"];
    // 将原有的图片反转
    upImage = [UIImage imageWithCGImage:greenImage.CGImage scale:2.0 orientation:UIImageOrientationDown];
    [self.moreBtn setImage:upImage forState:0];
    
    UIImage *grayImage = [UIImage imageNamed:@"turnDown"];
    
    downImage = [UIImage imageWithCGImage:grayImage.CGImage scale:2.0 orientation:UIImageOrientationDown];
    
    
}

@end
