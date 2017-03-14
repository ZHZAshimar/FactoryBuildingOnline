//
//  NewsChannelHeaderCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/9.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NewsChannelHeaderCollectionReusableView.h"

@implementation NewsChannelHeaderCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NewsChannelHeaderCollectionReusableView" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = arrayOfViews[0];
    }
    return self;
}

- (void)setIsShowEditBtn:(BOOL)isShowEditBtn{
    _isShowEditBtn = isShowEditBtn;
    if (isShowEditBtn) {
        self.editButton.layer.cornerRadius = self.editButton.frame.size.height/2;
        self.editButton.layer.masksToBounds = YES;
        self.editButton.layer.borderColor = GREEN_19b8.CGColor;
        self.editButton.layer.borderWidth = 0.5;
    } else {
        self.editButton.hidden = YES;
    }
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

@end
