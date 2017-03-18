//
//  ECDrawBoardView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BEGINDRAW) (BOOL isBeginDraw);

@interface ECDrawBoardView : UIView
@property (nonatomic, copy) BEGINDRAW beginDraw;
@property (nonatomic, assign) CGContextRef contextRef;      // 创建 绘制的环境

/*
 清除画布
 */
- (void)cleanScreen;

@end
