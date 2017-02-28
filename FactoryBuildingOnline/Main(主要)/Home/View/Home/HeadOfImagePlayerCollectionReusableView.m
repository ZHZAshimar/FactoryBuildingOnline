//
//  HeadOfImagePlayerCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "HeadOfImagePlayerCollectionReusableView.h"


@interface HeadOfImagePlayerCollectionReusableView()<ImagePlayerViewDelegate>
{
    // 下拉刷新出现的View
    UIView *refreshView;
}
@end

@implementation HeadOfImagePlayerCollectionReusableView


- (void)dealloc {
    self.imagePlayerView.imagePlayerViewDelegate = nil;
    if (self.imagePlayerView != nil) {
        self.imagePlayerView = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.imageDataSource = [NSArray array];
        
        self.imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(14, 8, Screen_Width-28, Screen_Height*65/284)];
        
        self.imagePlayerView.layer.masksToBounds = YES;
        self.imagePlayerView.layer.cornerRadius = 10;
        
        [self addSubview:self.imagePlayerView];
        
        [self createImagePlayerView];
    }
    return self;
}

- (void)setNumDic:(NSDictionary *)numDic {
    _numDic = numDic;
    [self showOnlineNum];
}
#pragma mark - 显示View
- (void)showOnlineNum{
    // 下拉刷新出现的View
    refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height*15/284)];
    refreshView.backgroundColor = [UIColor whiteColor];
    [self addSubview:refreshView];
    
    // 重置头部的frame
    self.imagePlayerView.frame = CGRectMake(14, Screen_Height*15/284, Screen_Width-28, self.frame.size.height - refreshView.frame.size.height);
    
    UILabel *onlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, refreshView.frame.size.width/2, refreshView.frame.size.height)];
    onlineLabel.textAlignment = NSTextAlignmentCenter;
    onlineLabel.textColor = GRAY_99;
    onlineLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
    [refreshView addSubview:onlineLabel];
    int onlineNum = arc4random()%1000+100;
    onlineLabel.text = [NSString stringWithFormat:@"在线人数：%d ",onlineNum];
    
    // 厂房信息的Label
    UILabel *infotmationLabel = [[UILabel alloc] initWithFrame:CGRectMake(refreshView.frame.size.width/2, 0, refreshView.frame.size.width/2, refreshView.frame.size.height)];
    infotmationLabel.textAlignment = NSTextAlignmentCenter;
    infotmationLabel.textColor = GRAY_99;
    infotmationLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0]];
    [refreshView addSubview:infotmationLabel];
    int factoryNum = arc4random()%10000+1000;
    infotmationLabel.text = [NSString stringWithFormat:@"厂房信息：%d",factoryNum];
    
    [self performSelector:@selector(removeRefreshView) withObject:self afterDelay:2.0];
}


/// 去除掉 在线人数的 view;
- (void)removeRefreshView {
    [refreshView removeFromSuperview];
    
    // 重置头部的frame
    self.imagePlayerView.frame = CGRectMake(14, 8, Screen_Width-28, self.frame.size.height);
    
    self.removeBlock(YES);
}

- (void)createImagePlayerView {
    
    // 设置背景颜色
    self.imagePlayerView.backgroundColor = [UIColor lightGrayColor];
    // 设置委托为当前的视图
    self.imagePlayerView.imagePlayerViewDelegate = self;
    // 设置滚动时间
    self.imagePlayerView.scrollInterval = 2.0f;
    // 设置滚动指示器的位置
    self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomRight;
    // 设置显示滚动指示器
    self.imagePlayerView.hidePageControl = NO;
    // 设置滚动指示器的背景色  默认为灰色
    self.imagePlayerView.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    // 设置滚动指示器前景色  默认是白色
    self.imagePlayerView.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    // 可以根据 imagePlayerView 的 edgeInsets 的属性 设置偏移量，间接控制 imagePlayerView 与 pageControl 的间距
    self.imagePlayerView.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 重新加载数据
    [self.imagePlayerView reloadData];
    
}

- (void)setImageDataSource:(NSArray *)imageDataSource {
    _imageDataSource = imageDataSource;
    [self.imagePlayerView reloadData];
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
    
    NSString *imageURL = self.imageDataSource[index];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:PLACEHOLDER_IMAGE];
    
}

// 单击图片
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index {
    NSLog(@"you tap %ld picture.",index);
    
}

@end
