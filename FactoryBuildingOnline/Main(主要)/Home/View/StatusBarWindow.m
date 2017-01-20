//
//  StatusBarWindow.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/14.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "StatusBarWindow.h"
@implementation StatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //设置window的优先级
        
        self.windowLevel = UIWindowLevelStatusBar;
        
        //设置背景颜色
        
        self.backgroundColor = [UIColor blackColor];
        
    }
    
    return self;
    
}

//显示状态栏进度加载

- (void)showProgressView:(NSString *)text show:(BOOL)show operation:(CGFloat)operation

{
    //创建加载进度条
    
    //做安全判断，如果已经创建，则不再重复创建
    
    if (_progressView == nil) {
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 15, Screen_Width, 5)];
        
    }
    
    [self addSubview:_progressView];
    
    
    
    //创建sendLabel显示文字，正在加载，加载成功
    
    //做安全判断，如果已经创建，则不再重复创建
    
       //window设置为不隐藏
    
    self.hidden = NO;
    
    
    
    if(show) {
        
        //显示window
        
        //使用第三方框架AFNetworking中的"UIProgressView+AFNetworking"文件实现上传进度显示
        
//        [_progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
        
        
        
    }else {
        
        //延迟2秒，隐藏window
        
        [self performSelector:@selector(hidden) withObject:nil afterDelay:2];
        
    }
    
}

//隐藏

- (void)hidden

{
    
    self.hidden = YES;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
