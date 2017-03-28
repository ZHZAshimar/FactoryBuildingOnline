//
//  NearView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NearView.h"
#import "NDynamicView.h"
#import "NFactoryView.h"

#import "NPeopleView.h"
#import "GeoCodeOfBaiduMap.h"
#import "UserLocation.h"

@interface NearView () {
    UIButton *lastButton;
    NSString *geoHashString;
}
@property (nonatomic, strong) UIScrollView *myScrollView;
@end

@implementation NearView

- (void)dealloc {
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        geoHashString = [UserLocation shareInstance].geohashStr;
        
        [self initView];
        
        [self addSubview:self.myScrollView];
    }
    return self;
}

- (void)initView {
    
    CGFloat buttonWidth =  (Screen_Width*3/5-12)/3;
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(Screen_Width*1/5+i*buttonWidth+i*6, 10, buttonWidth, Screen_Height*20/568);
        button.tag = i;
        [button setTitleColor:BLACK_66 forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
        button.layer.cornerRadius = 5;
        button.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [button setTitle:@"厂房" forState:0];
            
            [button setTitleColor:GREEN_19b8 forState:0];
            lastButton = button;
        } else if (i == 1) {
            [button setTitle:@"人" forState:0];
        } else {
            [button setTitle:@"动态" forState:0];
        }
        [self addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)sender {
    
    [sender setTitleColor:GREEN_19b8 forState:0];
    self.myScrollView.contentOffset = CGPointMake(sender.tag*Screen_Width, 0);
    // 清除上一个按钮的title 颜色
    [lastButton setTitleColor:BLACK_66 forState:0];
    lastButton = sender;
    
}

- (UIScrollView *)myScrollView {
    
    if (!_myScrollView) {
        CGFloat contentY = Screen_Height*43/568;
        
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, contentY, Screen_Width, Screen_Height-contentY-64)];
        _myScrollView.contentSize = CGSizeMake(Screen_Width*3, Screen_Height);
        _myScrollView.scrollEnabled = NO;
        
        NDynamicView *dynamicView = [[NDynamicView alloc] initWithFrame:CGRectMake(Screen_Width*2, 0, Screen_Width, self.myScrollView.frame.size.height)];
                [_myScrollView addSubview:dynamicView];
        
        NFactoryView *factoryView = [[NFactoryView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.myScrollView.frame.size.height)];
        
        [_myScrollView addSubview:factoryView];
        
        NPeopleView *peopleView = [[NPeopleView alloc] initWithFrame:CGRectMake(Screen_Width, 0, Screen_Width, self.myScrollView.frame.size.height)];
        [_myScrollView addSubview:peopleView];
    }
    return _myScrollView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
