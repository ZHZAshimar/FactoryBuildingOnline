//
//  SJAvatarBrowser.m
//  zhitu
//
//  Created by 陈少杰 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import "SJAvatarBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>

// JDY 图片浏览器的头文件
#import "JDYBrowseDefine.h"

// JTS 图片浏览器的头文件
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

//
#import "UIImageView+CustomImageView.h"

#define DEFAIN_IMAGE @"12"

#define screen_size [UIScreen mainScreen].bounds.size
#define screen_size_width [UIScreen mainScreen].bounds.size.width
#define screen_size_height [UIScreen mainScreen].bounds.size.height

static CGRect oldframe;

@interface SJAvatarBrowser()<JTSImageViewControllerInteractionsDelegate>

@end

@implementation SJAvatarBrowser

+(void)showImage:(UIImageView *)avatarImageView{
    // 获取图片资源
    UIImage *image=avatarImageView.image;
    // 获取window
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    // 设置背景view
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor=[UIColor blackColor];
    
    backgroundView.alpha=0;
    // 初始化 imageView
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    // 将 imageView 添加到 backgroundView 中
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    // 初始化单击事件
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    // 为 背景层 设置单击事件
    [backgroundView addGestureRecognizer: tap];
    // 动画
    [UIView animateWithDuration:0.3 animations:^{
        // 计算imageView 在屏幕显示的位置
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        // 背景层的透明度为 1
        backgroundView.alpha=1;
        
    } completion:^(BOOL finished) {
        
    }];
}
// tap 事件的 响应的方法
+(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView=tap.view;
    
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        //
        imageView.frame=oldframe;
        
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        
    }];
}
//  加载网络图片，单张
+(void)showImageWithURLStr:(NSString *)urlStr {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe = CGRectMake(screen_size_width/2-10, screen_size.height/2-10, 20, 20);
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    // 加载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:DEFAIN_IMAGE] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageContinueInBackground];
    //
    UIImage *image = imageView.image;
    
    imageView.tag = 1;
    
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}
// 通过 JDYBrowseViewController 图片浏览器 浏览 多张网络图片
+ (void)showImageBrowserWithImageURL:(NSArray *)urlImageArr withSmallImageArr:(NSArray *)smallImageArr imageIndex:(NSInteger)index{
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < smallImageArr.count; i++) {
        
        JDYBrowseModel *browseItem = [[JDYBrowseModel alloc] init];
        browseItem.bigImageUrl = urlImageArr[i];    // 大图url地址
        browseItem.smallImageView = smallImageArr[i];   // 小图
        [browseItemArray addObject:browseItem];
    }
    
    JDYBrowseViewController *bVC = [[JDYBrowseViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    
    [bVC showBrowseViewController];
 
}

+ (void)showJTSImageBrowserForImage:(UIImage *)image {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = image;
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    imageViewer.interactionsDelegate = self;
    
    // Present the view controller.
    [imageViewer showFromViewController:[self getCurrentVC] transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
}

+ (void)showJTSImageBrowserForUrl:(NSString *)url{
    // Create image info
    CGRect oldframe=CGRectMake(screen_size_width/2-10, screen_size.height/2-10, 20, 20);
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    
    [imageView setImageWithURLStr:url];
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    
    imageInfo.image = imageView.image;
    //    imageInfo.referenceRect = self.ddHeaderImageView.frame;
    //    imageInfo.referenceView = self.ddHeaderImageView.superview;
    //    imageInfo.referenceContentMode = self.ddHeaderImageView.contentMode;
    //    imageInfo.referenceCornerRadius = self.ddHeaderImageView.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    // Present the view controller.
    [imageViewer showFromViewController:[self getCurrentVC] transition:JTSImageViewControllerTransition_FromOriginalPosition];
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
