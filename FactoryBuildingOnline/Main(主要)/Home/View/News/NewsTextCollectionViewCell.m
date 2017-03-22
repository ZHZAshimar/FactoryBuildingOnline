//
//  NewsTextCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/21.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NewsTextCollectionViewCell.h"

@implementation NewsTextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NewsTextCollectionViewCell" owner:self options:nil];
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
//    self.label.layer.borderColor = GRAY_db.CGColor;
//    
//    self.label.layer.borderWidth = 0.5;
    
    self.label.layer.cornerRadius = 4;
    
    self.label.layer.masksToBounds = YES;
    
    self.label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:12.0f]];
}
@end
