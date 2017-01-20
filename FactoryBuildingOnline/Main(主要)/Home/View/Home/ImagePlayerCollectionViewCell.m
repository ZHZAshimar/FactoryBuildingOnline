//
//  ImagePlayerCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/14.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ImagePlayerCollectionViewCell.h"

@interface ImagePlayerCollectionViewCell()<ImagePlayerViewDelegate>

@end

@implementation ImagePlayerCollectionViewCell


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
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ImagePlayerCollectionViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndexCheck:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndexCheck:0];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        self.imageDataSource = [NSArray array];
        
        self.imagePlayerView.frame = self.bounds;
        
        [self createImagePlayerView];
        
    }
    return self;
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
