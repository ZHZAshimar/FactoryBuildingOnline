//
//  MeBackgroundView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "MeBackgroundView.h"

@implementation MeBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/\

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    self.backgroundColor = GRAY_F5;
    // 上面的View
    UIBezierPath *pathUp = [UIBezierPath bezierPath];
    
    [pathUp moveToPoint:CGPointMake(0, 0)]; //起点
    [pathUp addLineToPoint:CGPointMake(0, Screen_Height*65/284)];
    [pathUp addLineToPoint:CGPointMake(Screen_Width/2, Screen_Height*110/284)];
    [pathUp addLineToPoint:CGPointMake(Screen_Width, Screen_Height*65/284)];
    [pathUp addLineToPoint:CGPointMake(Screen_Width, 0)];
    [pathUp closePath]; // 关闭绘制路径
    
    UIView *view = [[UIView alloc] init];
//        view.frame = self.f;
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = pathUp.CGPath;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [view.layer addSublayer:shapeLayer];
    
    
    // 下面的View
    UIView *viewDown = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height*73/284, Screen_Width, Screen_Height-Screen_Height*73/284)];
    
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:viewDown];
    
    UIBezierPath *pathDown = [UIBezierPath bezierPath];
    [pathDown moveToPoint:CGPointMake(0, 0)];
    [pathDown addLineToPoint:CGPointMake(0, viewDown.frame.size.height)];
    [pathDown addLineToPoint:CGPointMake(Screen_Width, viewDown.frame.size.height)];
    [pathDown addLineToPoint:CGPointMake(Screen_Width, viewDown.frame.size.height *165/376)];
    [pathDown closePath];   // 关闭绘制路径 使得终点于原点闭合
    
    CAShapeLayer *shapeLayerDown = [CAShapeLayer layer];
    shapeLayerDown.path = pathDown.CGPath;
    shapeLayerDown.fillColor = [UIColor whiteColor].CGColor;
    [viewDown.layer addSublayer:shapeLayerDown];
    
    // 积分兑换的白色背景的绘制
    UIBezierPath *integralPath = [UIBezierPath bezierPath];
    [integralPath moveToPoint:CGPointMake(Screen_Width, Screen_Height*73/284)];
    [integralPath addLineToPoint:CGPointMake(Screen_Width*239/320, Screen_Height*195/568)];
    [integralPath addLineToPoint:CGPointMake(Screen_Width*239/320, Screen_Height*133/284)];
    [integralPath addLineToPoint:CGPointMake(Screen_Width, Screen_Height*39/71)];
    [integralPath closePath];   //
    
    CAShapeLayer *shapelayerIntegral = [CAShapeLayer layer];
    shapelayerIntegral.path = integralPath.CGPath;
    shapelayerIntegral.fillColor = [UIColor whiteColor].CGColor;
    [view.layer addSublayer:shapelayerIntegral];
    // 红色短竖
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width*239/320, Screen_Height*59/142, Screen_Width/320, Screen_Height * 15/568)];
    redView.backgroundColor = RED_df3d;
    [view addSubview:redView];
    // 蓝色短竖
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width*123/160-2, Screen_Height*221/568, Screen_Width/320, Screen_Height * 15/568)];
    blueView.backgroundColor = BLUE_5ca6;
    [view addSubview:blueView];
    // 绿色短竖
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width*63/80-2, Screen_Height*51/142, Screen_Width/320, Screen_Height * 15/568)];
    greenView.backgroundColor = GREEN_19b8;
    [view addSubview:greenView];
    
    // 靠近蓝色的那条 灰色线条的绘制
    UIBezierPath *nearBluePath = [UIBezierPath bezierPath];
    [nearBluePath moveToPoint:CGPointMake(Screen_Width*61/80, Screen_Height*97/284)];
    [nearBluePath addLineToPoint:CGPointMake(Screen_Width*61/80, Screen_Height*65/142)];
    [nearBluePath addLineToPoint:CGPointMake(Screen_Width, Screen_Height*38/71)];
    [nearBluePath stroke];
    nearBluePath.lineWidth = Screen_Width/160;
    
    CAShapeLayer *nearBlueLayer = [CAShapeLayer layer];
    nearBlueLayer.path = nearBluePath.CGPath;
    nearBlueLayer.fillColor = [UIColor clearColor].CGColor;
    nearBlueLayer.strokeColor = GRAY_F5.CGColor;
    [view.layer addSublayer:nearBlueLayer];

    // 靠近绿色的那条 灰色线条的绘制
    UIBezierPath *nearGreenPath = [UIBezierPath bezierPath];
    [nearGreenPath moveToPoint:CGPointMake(Screen_Width*25/32, Screen_Height*95/284)];
    [nearGreenPath addLineToPoint:CGPointMake(Screen_Width*25/32, Screen_Height*255/568)];
    [nearGreenPath addLineToPoint:CGPointMake(Screen_Width, Screen_Height*295/568)];
    [nearGreenPath stroke];
    nearGreenPath.lineWidth = Screen_Width/160;
    
    CAShapeLayer *nearGreenLayer = [CAShapeLayer layer];
    nearGreenLayer.path = nearGreenPath.CGPath;
    nearGreenLayer.fillColor = [UIColor clearColor].CGColor;
    nearGreenLayer.strokeColor = GRAY_F5.CGColor;
    [view.layer addSublayer:nearGreenLayer];

}


@end
