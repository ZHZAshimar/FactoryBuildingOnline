//
//  FMCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "FMCollectionViewCell.h"

@implementation FMCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FMCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
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
    
    self.FMnameLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.FMnameLabel.font.pointSize weight:0.2]];
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
}
@end
