//
//  SJAvatarBrowser.h
//  zhitu
//
//  Created by 陈少杰 QQ：417365260 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SJAvatarBrowser : NSObject
/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像所在的imageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

//////////////// 二次开发 Winnie 添加  ////////////////////

// 展示 网络图片 （单张）
+(void)showImageWithURLStr:(NSString *)urlStr;

// 使用 JDY 图片浏览器 多张网络图片
+ (void)showImageBrowserWithImageURL:(NSArray *)urlImageArr withSmallImageArr:(NSArray *)smallImageArr imageIndex:(NSInteger)index;

// 使用 JTS 图片浏览器加载网络图片
+ (void)showJTSImageBrowserForUrl:(NSString *)url;

+ (void)showJTSImageBrowserForImage:(UIImage *)image;

@end
