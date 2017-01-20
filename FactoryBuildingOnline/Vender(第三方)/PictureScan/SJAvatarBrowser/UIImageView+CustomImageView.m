//
//  UIImageView+CustomImageView.m
//  ViwepagerAndCoolView
//
//  Created by zhenhuaonline on 16/8/18.
//  Copyright © 2016年 Winnie. All rights reserved.
//

#import "UIImageView+CustomImageView.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
// 图片未加载或加载失败显示的默认图片
#define DEFAUTIMAGE @"1.gif"

@implementation UIImageView (CustomImageView)

- (void)setImageWithURLStr:(NSString *)urlName {
    
    BOOL isExit = [[[SDWebImageManager sharedManager] imageCache] diskImageExistsWithKey:urlName];
    
    if (isExit) {
        
        [self setImageWithURLStrOrg:urlName withPlaceHolder:DEFAUTIMAGE];
    } else {
        
        NSString *str = [NSString stringWithFormat:@"%@_small",urlName];
        
        [self setImageWithURLStrOrg:str withPlaceHolder:DEFAUTIMAGE];
        
    }
    
}

- (void)setImageWithURLStrOrg:(NSString *)urlName withPlaceHolder:(NSString *)placeHolder{
    
    NSURL *urlImage = [NSURL URLWithString:urlName];
    
    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:urlName];
    
    if (image) {
        
        self.image = image;
        
    }else {
        
//        [self sd_setImageWithURL:urlImage];
        [self sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:placeHolder]];
        
    }
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    self.clipsToBounds = YES;
}

@end
