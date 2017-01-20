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
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(19, 20, 5, 13)];
        
        greenView.backgroundColor = GREEN_1ab8;
        
        [self addSubview:greenView];
        
        self.historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(19+5+9, 20, 80, 13)];
        
        self.historyLabel.text = @"搜索历史";
        
        self.historyLabel.textColor = BLACK_42;
        
        self.historyLabel.font = [UIFont systemFontOfSize:13.0f];
        
        [self addSubview:self.historyLabel];
        
        self.cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.cleanBtn.frame = CGRectMake(Screen_Width-19-30, 19, 30, 13);
        
        self.cleanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self.cleanBtn setTitle:@"清除" forState:UIControlStateNormal];
        
        [self.cleanBtn setTitleColor:GREEN_1ab8 forState:UIControlStateNormal];
        
        self.cleanBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        
        [self addSubview:self.cleanBtn];
        
        
        //
        UIView *lineCutView = [[UIView alloc] initWithFrame:CGRectMake(19, 40.5, Screen_Width-38, 0.5)];
        lineCutView.backgroundColor = GRAY_db;
        [self addSubview:lineCutView];
    }
    return  self;
}

@end
