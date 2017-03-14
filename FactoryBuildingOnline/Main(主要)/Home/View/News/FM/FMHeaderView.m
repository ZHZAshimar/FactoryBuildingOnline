//
//  FMHeaderView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "FMHeaderView.h"

@implementation FMHeaderView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FMHeaderView" owner:self options:nil];
//        if (arrayOfViews.count < 1) {
//            return nil;
//        }
//        if (![arrayOfViews[0] isKindOfClass:[UIView class]]) {
//            return nil;
//        }
//        self = arrayOfViews[0];
    }
    return self;
}
- (IBAction)shareBtn:(UIButton *)sender {
}

- (IBAction)playerBtnAction:(UIButton *)sender {
}
- (IBAction)likeBtnAction:(UIButton *)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
