//
//  CuttingLineView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/3.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuttingLineView : UIView

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
