//
//  TextCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/2/22.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "TextCollectionViewCell.h"

@implementation TextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"TextCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count <= 0) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfViews[0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 绘制边框， 圆角为4
    self.layer.borderColor = GRAY_db.CGColor;
    
    self.layer.borderWidth = 0.5;
    
    self.layer.cornerRadius = 4;
    
    self.layer.masksToBounds = YES;
    
    self.label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12.0f]];
}

@end
