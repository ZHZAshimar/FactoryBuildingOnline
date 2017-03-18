//
//  ECTwoButtonFooter.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECTwoButtonFooter.h"

@implementation ECTwoButtonFooter

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self createTwoButton];
        
    }
    return self;
}

- (void)createTwoButton {
    
    CGFloat btnWidth = (Screen_Width - 120)/2;
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(55+i*(btnWidth+10), 8, btnWidth, self.frame.size.height-18);
        button.tag = 100+i;
        
        [button addTarget:self action:@selector(tagButonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor colorWithHex:0x00AAEC];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        
        if (i == 0) {
            [button setTitle:@"存为草稿" forState:0];
        } else {
            [button setTitle:@"下一步" forState:0];
        }
        
        [self addSubview:button];
    }
    
}


- (void)tagButonAction: (UIButton *)sender {
    self.tagBlock(sender.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
