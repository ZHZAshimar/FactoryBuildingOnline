//
//  HomeFirstPathImagePlayerView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/4.
//  Copyright © 2016年 XFZY. All rights reserved.
//  首页图片轮播器

#import "HomeFirstPathImagePlayerView.h"
#import "ImagePlayerView.h"

@interface HomeFirstPathImagePlayerView()<ImagePlayerViewDelegate>

@property (nonatomic, strong)ImagePlayerView *imagePageView;

@end

@implementation HomeFirstPathImagePlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageDataSource = @[[UIImage imageNamed:@"11"],[UIImage imageNamed:@"nav_icon1_pressed"]];
        
        [self createImagePlayerView];
        
    }
    return self;
}

- (void)createImagePlayerView {
    // 初始化图片轮播器
    self.imagePageView = [[ImagePlayerView alloc] initWithFrame:self.bounds];
    // 设置背景颜色
    self.imagePageView.backgroundColor = [UIColor lightGrayColor];
    // 设置委托为当前的视图
    self.imagePageView.imagePlayerViewDelegate = self;
    // 设置滚动时间
    self.imagePageView.scrollInterval = 2.0f;
    // 设置滚动指示器的位置
    self.imagePageView.pageControlPosition = ICPageControlPosition_BottomCenter;
    // 设置显示滚动指示器
    self.imagePageView.hidePageControl = NO;
    // 设置滚动指示器的背景色  默认为灰色
    self.imagePageView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    // 设置滚动指示器前景色  默认是白色
    self.imagePageView.pageControl.currentPageIndicatorTintColor = NaviBackColor;
    // 可以根据 imagePageView 的 edgeInsets 的属性 设置偏移量，间接控制 imagePageView 与 pageControl 的间距
    self.imagePageView.edgeInsets = UIEdgeInsetsMake(0, 0, 4, 0);
    
    [self addSubview:self.imagePageView];
    
    // 重新加载数据
    [self.imagePageView reloadData];
    
}

#pragma mark - imagePlayerDelegate 
/**
 *  Number of items
 *
 *  @return Number of items
 */
- (NSInteger)numberOfItems{
    return self.imageDataSource.count;
}

/**
 *  Init imageview
 *  加载图片
 *  @param imagePlayerView ImagePlayerView object
 *  @param imageView       UIImageView object
 *  @param index           index of imageview
 */
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    imageView.image = [self.imageDataSource objectAtIndexCheck:index];
}

// 单击图片
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index {
    NSLog(@"you tap %d picture.",index);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
