//
//  UIFont+AdaptSize.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//  文字自适应

#import <UIKit/UIKit.h>

#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0f)

// 这里设置iPhone6放大的字号数（现在是放大2号，也就是iPhone4s和iPhone5上字体为15时，iPhone6上字号为17）
#define IPHONE6_INCREMENT 2

// 这里设置iPhone6Plus放大的字号数（现在是放大3号，也就是iPhone4s和iPhone5上字体为15时，iPhone6上字号为18）
#define IPHONE6PLUS_INCREMENT 3

@interface UIFont (AdaptSize)

+(UIFont *)adjustFont:(UIFont *)font;

/**
 *  自适应 字体大小
 *  @param  fontsize 字体大小
 *  @return CGFloat
 */
+(CGFloat )adjustFontSize:(CGFloat)fontsize;
@end
