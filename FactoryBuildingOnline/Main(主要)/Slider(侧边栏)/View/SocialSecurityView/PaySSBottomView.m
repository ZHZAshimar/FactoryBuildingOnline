//
//  PaySSBottomView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/15.
//  Copyright © 2017年 XFZY. All rights reserved.
/*
 按钮tag 说明
 
 100    服务
 101    一键续交
 102    我要购买
 103    热线
 104    办理转移
 
 */

#import "PaySSBottomView.h"

@interface PaySSBottomView() {
    CGFloat sideBtnWidth;
    CGFloat centerBtnWidth;
    CGFloat self_height;
}

@end

@implementation PaySSBottomView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        

    }
    return self;
}

- (void)setBottomType:(BOTTOMTYPE)bottomType {
    _bottomType = bottomType;
    [self setView];
}

- (void)setView {
    
    sideBtnWidth = (Screen_Width-40-10*3)/6;
    centerBtnWidth = 2* (Screen_Width-40-10*3)/6;
    self_height = self.frame.size.height;
    
    for (int i = 0; i < 2; i++) {
        //------------ 边边的按钮
        UIButton *sideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        sideBtn.frame = CGRectMake(20+i*(Screen_Width-sideBtnWidth-20-20), 0, sideBtnWidth, self_height);
        
        [sideBtn addTarget:self action:@selector(sideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        sideBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        // 添加文字
        UILabel *s_label = [[UILabel alloc] initWithFrame:CGRectMake(0, self_height-30, sideBtnWidth, 30)];
        s_label.textColor = BLACK_66;
        s_label.textAlignment = NSTextAlignmentCenter;
        s_label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:10]];
        
        [sideBtn addSubview:s_label];

        [self addSubview:sideBtn];
       
        
        if (i == 0) {
            sideBtn.tag = 100;
            s_label.text = @"服务";
            [sideBtn setImage:[UIImage imageNamed:@"ss_serve"] forState:0];
        } else {
            sideBtn.tag = 103;
            s_label.text = @"热线";
            [sideBtn setImage:[UIImage imageNamed:@"ss_hotline"] forState:0];
        }
        
        //----------- 中间的按钮
        
        if (self.bottomType == 0) {
            UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            centerBtn.frame = CGRectMake(30+sideBtnWidth+i*(centerBtnWidth+10), 12, centerBtnWidth, self_height-24);
            // 设置tag 和点击事件
            [centerBtn addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            // 设置圆角
            centerBtn.layer.cornerRadius = 5;
            centerBtn.layer.masksToBounds = YES;
            // 设置文字
            [centerBtn setTitleColor:[UIColor whiteColor] forState:0];
            centerBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:10]];
            
            [self addSubview:centerBtn];
            
            if (i == 0) {
                
                centerBtn.tag = 101;
                [centerBtn setTitle:@"一键续交" forState:0];
                centerBtn.backgroundColor = GREEN_19b8;
            } else {
                centerBtn.tag = 102;
                [centerBtn setTitle:@"我要购买" forState:0];
                centerBtn.backgroundColor = [UIColor colorWithHex:0x49A6F3];
            }
        } else if (self.bottomType == 1 && i == 0) {
            [self createTransferButton];
        }
    }
}

- (void)createTransferButton {
    centerBtnWidth = centerBtnWidth *2;
    
    UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transferBtn.frame = CGRectMake(30+sideBtnWidth, 12, centerBtnWidth, self_height-24);
    // 设置tag 和点击事件
    [transferBtn addTarget:self action:@selector(transferButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 设置圆角
    transferBtn.layer.cornerRadius = 5;
    transferBtn.layer.masksToBounds = YES;
    // 设置文字
    [transferBtn setTitleColor:[UIColor whiteColor] forState:0];
    transferBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:10]];
    
    transferBtn.tag = 104;
    [transferBtn setTitle:@"办理转移" forState:0];
    transferBtn.backgroundColor = GREEN_19b8;
    
    [self addSubview:transferBtn];
}
- (void)transferButtonAction:(UIButton *)sender {
    self.tagBlock(sender.tag);
}

- (void)sideButtonAction: (UIButton *)sender {
    self.tagBlock(sender.tag);
}
- (void)centerButtonAction: (UIButton *)sender {
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
