//
//  UIFont+AdaptSize.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/12.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "UIFont+AdaptSize.h"

@implementation UIFont (AdaptSize)

+(UIFont *)adjustFont:(UIFont *)font {
    
    UIFont *newFont = nil;
    
    if (IS_IPHONE_6) {
        
        newFont = [UIFont fontWithName:font.fontName size:font.pointSize+IPHONE6_INCREMENT];
        
    } else if (IS_IPHONE_6_PLUS) {
        
        newFont = [UIFont fontWithName:font.fontName size:font.pointSize + IPHONE6PLUS_INCREMENT];
    } else {
        newFont = font;
    }
    
    return newFont;
}


+(CGFloat )adjustFontSize:(CGFloat)fontsize {
    
    CGFloat newSize;
    
    if (IS_IPHONE_6) {
        
        newSize = fontsize + IPHONE6_INCREMENT;
        
    } else if (IS_IPHONE_6_PLUS) {
        
        newSize = fontsize + IPHONE6PLUS_INCREMENT;
        
    } else {
        newSize = fontsize;
    }
    return newSize;
}
@end
