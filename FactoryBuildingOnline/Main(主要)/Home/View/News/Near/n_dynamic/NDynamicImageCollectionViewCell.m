//
//  NDynamicImageCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NDynamicImageCollectionViewCell.h"

@implementation NDynamicImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NDynamicImageCollectionViewCell" owner:self options:nil];
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
}

@end
