//
//  PublishManHeadView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "PublishManHeadView.h"

@implementation PublishManHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"PublishManHeadView" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            return nil;
        }
        if (![arrayOfView[0] isKindOfClass:[PublishManHeadView class]]) {
            return nil;
        }
        self = arrayOfView[0];
        
        self.publishManHeadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.publishManHeadImageView.layer.borderWidth = 2;
        self.publishManHeadImageView.layer.cornerRadius = 36;
        self.publishManHeadImageView.layer.masksToBounds = YES;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
