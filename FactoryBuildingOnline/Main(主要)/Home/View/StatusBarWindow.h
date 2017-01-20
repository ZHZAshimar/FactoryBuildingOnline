//
//  StatusBarWindow.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/14.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface StatusBarWindow : UIWindow

{
    
    UIProgressView *_progressView;
    
    UILabel *_sendLabel;
    
}

//显示状态栏进度加载

- (void)showProgressView:(NSString *)text show:(BOOL)show operation:(CGFloat)operation;

//隐藏

- (void)hidden;

@end
