//
//  HomeThirdPathView.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/4.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HeadLineInformationView.h"
#import "NSString+Judge.h"

#import <ShareSDK/ShareSDK.h>

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>


#define self_width self.frame.size.width
#define self_height self.frame.size.height

@interface HeadLineInformationView()
{
    int count;
    UILabel *areaLabel_1;
    UILabel *areaLabel_2;
    UILabel *textLabel_1;
    UILabel *textLabel_2;
    UIView *textView;
}
@end

@implementation HeadLineInformationView

- (void)dealloc{

}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 头条的图片
        UIImageView *messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self_height/5, self_height*11/60, self_height*38/60, self_height*38/60)];
        messageImageView.image = [UIImage imageNamed:@"home_infomation"];
        [self addSubview:messageImageView];
        
        // 分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self_height*31/30, self_height*11/60, 0.5, self_height*38/60)];
        lineView.backgroundColor = GRAY_e6;
        [self addSubview:lineView];
        
        // 文字跳动的背景view
        textView = [[UIView alloc] initWithFrame:CGRectMake(self_height*6/5, self_height*11/60, Screen_Width-(Screen_Width/6+1), self_height*38/60)];
        [self addSubview:textView];
        
        // 第一行的地区名
        areaLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self_height/4)];
        areaLabel_1.textColor = RED_df3d;
        areaLabel_1.textAlignment = NSTextAlignmentCenter;
        areaLabel_1.font = [UIFont systemFontOfSize:10.0];
        areaLabel_1.layer.borderColor = RED_df3d.CGColor;
        areaLabel_1.layer.borderWidth = 0.5;
        areaLabel_1.layer.cornerRadius = 2;
        [textView addSubview:areaLabel_1];
        
        // 第二行的地区名
        areaLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self_height*23/60, 0, self_height/4)];
        areaLabel_2.textColor = RED_df3d;
        areaLabel_2.textAlignment = NSTextAlignmentCenter;
        areaLabel_2.font = [UIFont systemFontOfSize:10.0];
        areaLabel_2.layer.borderColor = RED_df3d.CGColor;
        areaLabel_2.layer.borderWidth = 0.5;
        areaLabel_2.layer.cornerRadius = 2;
        [textView addSubview:areaLabel_2];
        
        // 第一行的 内容
        textLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(areaLabel_1.frame.size.width+8, 0, textView.frame.size.width-areaLabel_1.frame.size.width-8, self_height/4)];
        textLabel_1.textColor = BLACK_42;
        textLabel_1.font = [UIFont systemFontOfSize:11.0];
        [textView addSubview:textLabel_1];
        
        // 第二行的 内容
        textLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(areaLabel_2.frame.size.width+8, self_height*23/60, textView.frame.size.width-areaLabel_2.frame.size.width-8, self_height/4)];
        textLabel_2.textColor = BLACK_42;
        textLabel_2.font = [UIFont systemFontOfSize:11.0];
        [textView addSubview:textLabel_2];
        
        // 添加单击事件
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTimerTextAction)];
//        messageImageView.userInteractionEnabled = YES;
//        textView.userInteractionEnabled = YES;
//        [textView addGestureRecognizer:tap];
//        [messageImageView addGestureRecognizer:tap];
//        
//        // 初始化计时器
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLabelAction) userInfo:nil repeats:YES];
        
    }
    return self;
}

// 每秒更新界面
- (void) updateLabelAction{
    
    if (count < self.textArray.count && self.textArray.count > 0) {
        
        NSArray *tmpArr = [self.textArray objectAtIndexCheck:count];
        
        NSString *string_1 = tmpArr[0];
        
        NSString *string_2 = tmpArr[1];
        
        NSArray *arrOf1 = [string_1 componentsSeparatedByString:@","];
        CGFloat width = [NSString widthForString:arrOf1[0] fontSize:12 andHeight:self_height/4];
        // 位置
        areaLabel_1.frame = CGRectMake(0, 0, width, self_height/4);
        textLabel_1.frame = CGRectMake(areaLabel_1.frame.size.width+8, 0, textView.frame.size.width-areaLabel_1.frame.size.width-8, self_height/4);
        // 文字
        areaLabel_1.text = arrOf1[0];
        textLabel_1.text = arrOf1[1];
        
        NSArray *arrOf2 = [string_2 componentsSeparatedByString:@","];
        width = [NSString widthForString:arrOf2[0] fontSize:12 andHeight:self_height/4];
        areaLabel_2.frame = CGRectMake(0, self_height*23/60, width, self_height/4);
        textLabel_2.frame = CGRectMake(areaLabel_2.frame.size.width+8, self_height*23/60, textView.frame.size.width-areaLabel_2.frame.size.width-8, self_height/4);
        areaLabel_2.text = arrOf2[0];
        textLabel_2.text = arrOf2[1];
        
        // 开始动画
        [UIView animateWithDuration:4 animations:^{
            
            textView.frame = CGRectMake(self_height*6/5, 0, Screen_Width-(Screen_Width/6+1), self_height*38/60);
            textView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            textView.frame = CGRectMake(self_height*6/5, self_height/3, Screen_Width-(Screen_Width/6+1), self_height*38/60);
            
            [UIView animateWithDuration:4 animations:^{
                
                textView.frame = CGRectMake(self_height*6/5, self_height*11/60, Screen_Width-(Screen_Width/6+1), self_height*38/60);
                
                textView.alpha = 1.0;
            }];
            
            count++;
        }];
        
    } else {
        count = 0;
    }
    
}


- (void)tapTimerTextAction{
//    点击后跳转
    NSLog(@"跳转到头条资讯");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
