//
//  ECDrawBoardView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECDrawBoardView.h"

@interface ECDrawBoardView (){
    
    CGPoint startPoint;     // 开始的点
    CGPoint endPoint;       // 结束的点
    
    NSMutableArray *linesArr;   // 存放点的数组
}
@end

@implementation ECDrawBoardView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled =   YES;    // 开启用户交互
        
        self.backgroundColor = [UIColor clearColor];    // 清楚背景颜色
        
        linesArr = [NSMutableArray array];              // 点的数组
        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation. */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    _contextRef = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < linesArr.count; i++) {
        NSMutableArray *points = [linesArr objectAtIndex:i];
        
        if (points.count > 1) {
            
            for (int j = 0; j < points.count - 1; j++) {
                
                CGPoint myStartPoint = [[points objectAtIndex:j] CGPointValue];
                CGPoint myEndPoint = [[points objectAtIndex:j+1] CGPointValue];
                
                CGContextMoveToPoint(_contextRef, myStartPoint.x, myStartPoint.y);
                CGContextAddLineToPoint(_contextRef, myEndPoint.x, myEndPoint.y);
            }
        }
    }
    
    CGContextSetLineWidth(_contextRef, 2);
    
    CGContextSetStrokeColorWithColor(_contextRef, [UIColor blackColor].CGColor);
    [[UIColor blackColor] setStroke];
    
    CGContextDrawPath(_contextRef, kCGPathStroke);
    
    if (linesArr.count == 0) {
        return;
    }
}

// 手指开始触碰屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.beginDraw(YES);
    NSMutableArray *points = [NSMutableArray array];
    [linesArr addObject:points];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSMutableArray *points = [linesArr lastObject];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [points addObject:[NSValue valueWithCGPoint:point]];
    
    NSLog(@"%@",points);
    NSLog(@"%@",[linesArr lastObject]);
    
    [self setNeedsDisplay];             // 界面重绘
    
}

/*
    清除画布
 */
- (void)cleanScreen {
    [linesArr removeAllObjects];    // 将线的数组清除，
    
    [self setNeedsDisplay];         // 重绘界面
}


@end
