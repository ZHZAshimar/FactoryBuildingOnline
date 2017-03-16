//
//  FiveBtnView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "FiveBtnView.h"

@interface FiveBtnView () {
    NSArray *fivebtnTitleArray;
    UIButton *lastBtn;
}

@end

@implementation FiveBtnView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setButton];
    }
    return self;
}

- (void)setButton {
    
    fivebtnTitleArray = @[@"养老",@"医疗",@"公积金",@"工伤",@"失业"];
    
    UIButton *btn0 = [self createButton:0];
    UIButton *btn1 = [self createButton:1];
    UIButton *btn2 = [self createButton:2];
    UIButton *btn3 = [self createButton:3];
    UIButton *btn4 = [self createButton:4];
    
    NSMutableArray *widthArray = [NSMutableArray array];
    
    CGFloat allWidth = 0;
    for (NSString *title in fivebtnTitleArray) {
        CGFloat width = [NSString widthForString:title fontSize:[UIFont adjustFontSize:14] andHeight:self.frame.size.height/2] + 20;
        [widthArray addObject:@(width)];
        
        allWidth += width;
    }
    CGFloat interval = (Screen_Width - allWidth)/6;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(interval)-[btn0(aWidth)]-(interval)-[btn1(aWidth)]-(interval)-[btn2(bWidth)]-(interval)-[btn3(aWidth)]-(interval)-[btn4(aWidth)]-(interval)-|" options:0 metrics:@{@"interval":@(interval),@"aWidth":widthArray[0],@"bWidth":widthArray[2]} views:NSDictionaryOfVariableBindings(self,btn0,btn1,btn2,btn3,btn4)]];
    
}

- (UIButton *)createButton:(NSInteger )index {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.tag = 100 + index;

    [button addTarget:self action:@selector(tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:fivebtnTitleArray[index] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
    if (index == 0) {
        
        [button setTitleColor:[UIColor whiteColor] forState:0];
        button.backgroundColor = GREEN_19b8;
        lastBtn = button;
    } else {
        [button setTitleColor:BLACK_66 forState:0];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = BLACK_66.CGColor;
        button.backgroundColor = [UIColor clearColor];
    }
    
    button.layer.cornerRadius = self.frame.size.height/4;
    button.layer.masksToBounds = YES;
    
    [self addSubview:button];
    
    // 设置
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(height)-[button]-(height)-|" options:0 metrics:@{@"height":@(self.frame.size.height/4)} views:NSDictionaryOfVariableBindings(self,button)]];
    
    
    return button;
}

- (void)tagButtonAction:(UIButton *)sender {
    
    lastBtn.backgroundColor = [UIColor clearColor];
    lastBtn.layer.borderWidth = 0.5;
    lastBtn.layer.borderColor = BLACK_66.CGColor;
    [lastBtn setTitleColor:BLACK_66 forState:0];
    
    sender.backgroundColor = GREEN_19b8;
    [sender setTitleColor:[UIColor whiteColor] forState:0];
    sender.layer.borderWidth = 0;
    
    lastBtn = sender;
    
    NSInteger index = sender.tag - 100;
    self.tagBlock(index);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
