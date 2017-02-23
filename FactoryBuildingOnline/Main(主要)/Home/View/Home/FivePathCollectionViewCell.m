//
//  FivePathCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/4.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "FivePathCollectionViewCell.h"
#import "FactoryModel.h"
#import "ContacterModel.h"
#import "SecurityUtil.h"

@implementation FivePathCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FivePathCollectionViewCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndexCheck:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndexCheck:0];
        
        self.imageView.layer.borderColor = GRAY_e6.CGColor;
        self.imageView.layer.borderWidth = 0.5;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 2;
        
        self.tagView.backgroundColor = [UIColor clearColor];
        self.nameLabel.lineBreakMode =  NSLineBreakByTruncatingTail;

        
        // 设置字体自适应
        self.nameLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:self.nameLabel.font.pointSize] weight:0.5];
//        self.nameLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.nameLabel.font.pointSize]];
        self.addressLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.addressLabel.font.pointSize]];
        self.moneyOfdayLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.moneyOfdayLabel.font.pointSize]];
        self.areaLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.areaLabel.font.pointSize]];
        self.scanLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.scanLabel.font.pointSize]];
    }
    
    return self;
}

- (void)setBrokerModel:(BrokerFactoryInfoModel *)brokerModel {
    
    _brokerModel = brokerModel;
    
    ProMediumFactoryModel *proFactoryModel = brokerModel.factoryModel;
    
    NSString *imageURL = [SecurityUtil decodeBase64String:proFactoryModel.thumbnail_url];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:PLACEHOLDER_IMAGE];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",proFactoryModel.title];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",proFactoryModel.area,proFactoryModel.address];
    
    NSString *price = [NSString stringWithFormat:@"%@元/m²",proFactoryModel.price];
    
    self.moneyOfdayLabel.text = price;  // 每月一平方的租金
//    CGFloat priceOfMonth = [proFactoryModel.range floatValue] * [proFactoryModel.price floatValue]; // 计算出每月的总租金
    
//    self.moneyOfMonthLabel.text = [NSString stringWithFormat:@"%.0f元/月",priceOfMonth];
    
    self.areaLabel.text = [NSString stringWithFormat:@"%@ m²",proFactoryModel.range];
    // 在绘制 label 之前先 将已有的Label 移除
    for (UILabel *label in [self.tagView subviews]) {
        
        if ([label isKindOfClass:[UILabel class]]) {
            
            [label removeFromSuperview];
            
        }
    }
    
    [self.scanLabel removeFromSuperview];
    [self.eyeImageView removeFromSuperview];
    
    self.bottomHeight.constant = 20;
}

- (void)setModel:(WantedMessageModel *)model {
    
    _model = model;
        
    FactoryModel *ftModel = model.ftModel;
    
    NSString *imageURL = [SecurityUtil decodeBase64String:ftModel.thumbnail_url];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:PLACEHOLDER_IMAGE];
    
    self.scanLabel.text = [NSString stringWithFormat:@"浏览:%ld人",model.view_count];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",ftModel.title];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@",ftModel.address_overview];
    
    NSString *price = [NSString stringWithFormat:@"%@元/m²",ftModel.price];
    
    self.moneyOfdayLabel.text = price;  // 每月一平方的租金
    CGFloat priceOfMonth = [ftModel.range floatValue] * [ftModel.price floatValue]; // 计算出每月的总租金
    
    self.moneyOfMonthLabel.text = [NSString stringWithFormat:@"%.0f元/月",priceOfMonth];
    
    self.areaLabel.text = [NSString stringWithFormat:@"%@ m²",ftModel.range];
    
    NSArray *tagsArr = [NSString arrayWithJsonString:ftModel.tags];
    
    [self drawTagsLabel:tagsArr];
 
}

- (void)drawTagsLabel :(NSArray *)tagsArr {
    
    NSArray *fontColorArr = @[GREEN_1ab8,BLUE_font,YELLOW_font,PINK_font,PURPLE_font,RED_font,CYAN_font];        // label font 的颜色数组
    NSArray *bgColorArr = @[GREEN_bg,BLUE_bg,YELLOW_bg,PINK_bg,PURPLE_bg,RED_bg,CYAN_bg];                // label background 的颜色数组
    NSMutableArray *widthArr = [NSMutableArray array];                  // 文字的宽度数组  第一个标签的x 为0，第二个标签的x 是上一个标签的文字宽度+间距
    
    
    // 在绘制 label 之前先 将已有的Label 移除
    for (UILabel *label in [self.tagView subviews]) {
        
        if ([label isKindOfClass:[UILabel class]]) {
            
            [label removeFromSuperview];
            
        }
    }
    
    for (int i = 0; i < tagsArr.count; i++) {
        
        NSString *tagStr = tagsArr[i][@"name"];   // 拿到标签文字
        CGFloat width = [NSString widthForString:tagStr fontSize:[UIFont adjustFontSize:11] andHeight:self.frame.size.height*15/160]+5;  // 获取string 的宽度
        [widthArr addObject:@(width)];

        CGFloat lastWidth = 0.0;
        if (i == 1) {
            lastWidth = [widthArr[0] floatValue];
        }
        if (i == 2) {
            lastWidth = [widthArr[0] floatValue] + [widthArr[1] floatValue];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*8+lastWidth, 0, width, self.frame.size.height*15/170)];
        label.text = tagsArr[i][@"name"];
        label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11]];
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 0.8;
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        [self.tagView addSubview:label];
        
        // 设置标签的名字
        if ([tagStr isEqualToString:@"空间大"]) {
            
            label.textColor = fontColorArr[0];
            label.backgroundColor = bgColorArr[0];
        } else if ([tagStr isEqualToString:@"楼层多"]) {
            
            label.textColor = fontColorArr[1];
            label.backgroundColor = bgColorArr[1];
        } else if ([tagStr isEqualToString:@"环境好"]) {
            
            label.textColor = fontColorArr[2];
            label.backgroundColor = bgColorArr[2];
        } else if ([tagStr isEqualToString:@"性价高"]) {
            
            label.textColor = fontColorArr[3];
            label.backgroundColor = bgColorArr[3];
        } else if ([tagStr isEqualToString:@"原房东"]) {
            
            label.textColor = fontColorArr[4];
            label.backgroundColor = bgColorArr[4];
        } else if ([tagStr isEqualToString:@"新建房"]) {
            
            label.textColor = fontColorArr[5];
            label.backgroundColor = bgColorArr[5];
        } else {
            
            label.textColor = fontColorArr[6];
            label.backgroundColor = bgColorArr[6];
        }
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
