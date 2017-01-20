//
//  HomeTopLogoView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/6.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeTopLogoView.h"
@interface HomeTopLogoView ()
@end

@implementation HomeTopLogoView

- (void)dealloc {
    self.searchBar.delegate = nil;
}
- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // LOGO imageView
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width/2-Screen_Width/8, 20, Screen_Width/4, Screen_Width/12)];
        _logoImageView.image = [UIImage imageNamed:@"nav_logo"];
        
        [self addSubview:_logoImageView];
        
        // 扫一扫 按钮
        _scanButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _scanButton.frame = CGRectMake(Screen_Width-Screen_Width/5, 20, Screen_Width/5, 44);
        [_scanButton setTitleColor:[UIColor whiteColor] forState:0];
        [_scanButton setTitle:@"扫一扫" forState:0];
        _scanButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:_scanButton];
        
        // 位置的label
        _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, Screen_Width/5, 40)];
//        _areaLabel.backgroundColor = [UIColor redColor];
        _areaLabel.numberOfLines = 2;   // 设置 最多行数为 2行
        _areaLabel.userInteractionEnabled = YES;    // 开启用户交互
        _areaLabel.text = @"东莞 v";
        _areaLabel.textColor = [UIColor whiteColor];
        _areaLabel.textAlignment = NSTextAlignmentCenter;
        _areaLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_areaLabel];
        
        // searchBar
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 30+_logoImageView.frame.size.height, Screen_Width-16, 30)];
        _searchBar.placeholder = @"搜索";
        _searchBar.barTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = 5;
        [self addSubview:_searchBar];
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
