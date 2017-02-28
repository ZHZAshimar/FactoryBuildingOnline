//
//  ShowQRCodeViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/3.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "ShowQRCodeViewController.h"

@interface ShowQRCodeViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;   // 图标

@property (nonatomic, strong) UIView *qrcodeView; // 二维码

@property (nonatomic, strong) UIImageView *textImageView;   // 文字图标

@end

@implementation ShowQRCodeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.rdv_tabBarController setTabBarHidden:YES];
    
    [self setVCName:@"推荐二维码" andShowSearchBar:NO andTintColor:GREEN_19b8 andBackBtnStr:@"返回"];
    
    [self.leftNaviButton setImage:[UIImage imageNamed:@"greenBack"] forState:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.logoImageView];
    
    [self.view addSubview:self.qrcodeView];
    
    [self.view addSubview:self.textImageView];
    
}

- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        
        UIImage *image = [UIImage imageNamed:@"about_us"];
        
        CGFloat width = Screen_Height*105/568 * image.size.width/image.size.height;
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width/2-width/2, Screen_Height*35/568, width, Screen_Height*105/568)];
        
        _logoImageView.image = image;
    }
    return _logoImageView;
}

- (UIImageView *)textImageView {

    if (!_textImageView) {
        
        UIImage *image = [UIImage imageNamed:@"setting_text"];
        
        CGFloat width = Screen_Height*15/568 *image.size.width/image.size.height;
        
        _textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width/2-width/2, Screen_Height*377/568, width, Screen_Height*15/568)];
        _textImageView.image = image;
    }
    return _textImageView;
}

- (UIView *)qrcodeView {
    
    if (!_qrcodeView) {
        
        
        _qrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width/2-Screen_Height*175/568/2, Screen_Height*85/284, Screen_Height*175/568, Screen_Height*175/568)];
        
        _qrcodeView.backgroundColor = [UIColor whiteColor];
        
        _qrcodeView.layer.borderColor = GRAY_db.CGColor;
        _qrcodeView.layer.borderWidth = 1;
        _qrcodeView.layer.cornerRadius = 5;
        _qrcodeView.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _qrcodeView.frame.size.width-10, _qrcodeView.frame.size.width-10)];
        [_qrcodeView addSubview:imageView];
        
        // 1.创建过滤器
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2. 恢复默认
        [filter setDefaults];
        // 3. 给过滤器添加数据（）
        NSString *dataString = @"http://apps.oncom.cn";
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKeyPath:@"inputMessage"];
        // 4. 获取输出的二维码
        CIImage *outputImage = [filter outputImage];
        // 5. 将CIImage 转换成UIImage 并放大显示
        UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:imageView.frame.size.width];
        
        imageView.image = image;
    }
    return _qrcodeView;
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
