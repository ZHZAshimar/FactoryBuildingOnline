//
//  BoutiqueHeadViewCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "BoutiqueHeadViewCollectionReusableView.h"

@interface BoutiqueHeadViewCollectionReusableView()
{
    CGFloat scrollValue;
}
@end

@implementation BoutiqueHeadViewCollectionReusableView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BOUTIQUEFACTORYINDEX" object:nil];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BoutiqueHeadViewCollectionReusableView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = arrayOfViews[0];
        // 创建观察者 接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIndex:) name:@"BOUTIQUEFACTORYINDEX" object:nil];
        
        self.titleLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.titleLabel.font.pointSize]];
    }

    return self;
}
// 接到通知，改变数值
- (void)changeIndex:(NSNotification *)sender {
    
    NSDictionary *userInfo = sender.userInfo;
    
    
    
    self.pageControl.currentPage = [userInfo[@"index"] integerValue];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pageControl.currentPage = 0;

}

@end
