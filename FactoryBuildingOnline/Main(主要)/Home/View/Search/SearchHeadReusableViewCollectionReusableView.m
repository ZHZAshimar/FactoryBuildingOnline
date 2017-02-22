//
//  SearchHeadReusableViewCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/16.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SearchHeadReusableViewCollectionReusableView.h"

@implementation SearchHeadReusableViewCollectionReusableView

- (instancetype) initWithFrame:(CGRect)frame {
 
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(19, 20, Screen_Width/64, Screen_Height*13/568)];
        
        greenView.backgroundColor = GREEN_1ab8;
        
        [self addSubview:greenView];
        
        self.historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(19+5+9, 20, Screen_Width/2, 13)];
        
        self.historyLabel.text = @"搜索历史";
        
        self.historyLabel.textColor = BLACK_42;
        
        self.historyLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]];
        
        [self addSubview:self.historyLabel];
        // 清除按钮
        self.cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.cleanBtn.frame = CGRectMake(Screen_Width-19-30, 19, Screen_Width*3/32, Screen_Height*13/568);
        
        self.cleanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self.cleanBtn setTitle:@"清除" forState:UIControlStateNormal];
        
        [self.cleanBtn setTitleColor:GREEN_1ab8 forState:UIControlStateNormal];
        
        self.cleanBtn.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:13.0f]];
        
        [self addSubview:self.cleanBtn];
        
        // 分割线
        UIView *lineCutView = [[UIView alloc] initWithFrame:CGRectMake(19, self.frame.size.height-0.5, Screen_Width-38, 0.5)];
        lineCutView.backgroundColor = GRAY_db;
        [self addSubview:lineCutView];
    }
    return  self;
}

@end
