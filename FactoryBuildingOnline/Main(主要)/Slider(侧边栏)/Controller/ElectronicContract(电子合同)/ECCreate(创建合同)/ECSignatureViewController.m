//
//  ECSignatureViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ECSignatureViewController.h"
#import "ECDrawBoardView.h"

@interface ECSignatureViewController ()
{
    ECDrawBoardView *drawView;
    
}
@property (nonatomic, strong) UILabel *writeLabel;
@end

@implementation ECSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手写签名区";
    self.view.backgroundColor = GRAY_cc;
    
    drawView = [[ ECDrawBoardView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:drawView];
    
    __weak typeof(self) weakSelf = self;
    drawView.beginDraw = ^(BOOL isBegin) {
        
        [weakSelf.writeLabel removeFromSuperview];
    };
    [self drawView];
   
}

- (void)drawView {
    // 绘制按钮
    CGFloat btnheight = Screen_Width *30/320;
    CGFloat btnWidth = Screen_Height* 150/568;
    CGFloat contextY = Screen_Height-Screen_Width+btnWidth/2-20;   // 第一个button的y坐标
    for (int i = 0; i < 2; i++) {
        
        
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0-btnWidth/2 + 12 + btnheight/2, contextY+i*(Screen_Width/2), btnWidth, btnheight)];
        button.backgroundColor = [UIColor colorWithHex:0x00AAEE];
        button.titleLabel.font=[UIFont systemFontOfSize:[UIFont adjustFontSize:16]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //    button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        //    button.titleLabel.numberOfLines=0;
        
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        
        button.transform = CGAffineTransformMakeRotation(M_PI_2);   // 旋转90度
        
        button.tag = 100+i; // 设置tag
        
        if (i == 0) {       // 设置文字title
            [button setImage:[UIImage imageNamed:@"trash"] forState:0];
            [button setTitle:@"清空" forState:UIControlStateNormal];
        } else {
            [button setImage:[UIImage imageNamed:@"white_OK"] forState:0];
            [button setTitle:@"完成" forState:UIControlStateNormal];
        }
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button addTarget:self action:@selector(buttonTagAction:) forControlEvents:UIControlEventTouchUpInside];    // 添加点击事件
        
        [self.view addSubview:button];
    }
    
    // 绘制label
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateFormat:@"YYY年MM月dd日"];
    
    NSString *timerStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    
    NSString *dateStr = [NSString stringWithFormat:@"签署日期:%@",timerStr];
    CGFloat labelWidth = [NSString widthForString:dateStr fontSize:16.0 andHeight:30]+30;
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width- labelWidth/2 - 12 - 10, labelWidth/2+64, labelWidth, 30)];
    dateLabel.text = dateStr;
    dateLabel.textColor = BLACK_66;
    dateLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    dateLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:16.0]];
    [self.view addSubview:dateLabel];
    
    [self.view addSubview:self.writeLabel];
}
#pragma mark - 按钮的点击事件
- (void)buttonTagAction: (UIButton *)sender {
    
    if (sender.tag == 100) {        // 清除按钮
        [drawView cleanScreen];
    } else {
        NSLog(@"完成");
        
        UIGraphicsBeginImageContextWithOptions(drawView.bounds.size, NO, 0.0);
        

        // 保存签名
        CGContextRef ctx =  UIGraphicsGetCurrentContext();
        
        // 从上下文获取图片
        [drawView.layer renderInContext:ctx];
        
        UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭上下文
        UIGraphicsEndImageContext();
        // 图片旋转
        UIImage *image = [UIImage imageWithCGImage:signatureImage.CGImage scale:2.0 orientation:UIImageOrientationLeft];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(100, 100, 200, 100);
        imageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:imageView];
    }
}

- (UILabel *)writeLabel{
    
    if (!_writeLabel) {
        
        _writeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width/2, Screen_Height/2-50, 100, 60)];
        _writeLabel.text = @"手写区";
        _writeLabel.textColor = [UIColor whiteColor];
        _writeLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        
//        _writeLabel.center = self.view.center;
        _writeLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:24.0]];
    }
    return _writeLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
