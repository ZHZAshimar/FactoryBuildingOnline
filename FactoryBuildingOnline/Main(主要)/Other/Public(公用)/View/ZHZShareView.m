//
//  ZHZShareView.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/1/19.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ZHZShareView.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import <ShareSDK/ShareSDK.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
// 自定义分享编辑界面所需要导入的头文件
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#define self_width self.frame.size.width
#define self_height self.frame.size.height

#define shareArray @[@{@"icon":@"sns_icon_22",@"name":@"微信",@"platform":@(22)},@{@"icon":@"sns_icon_23",@"name":@"朋友圈",@"platform":@(23)},@{@"icon":@"sns_icon_1",@"name":@"微博",@"platform":@(1)},@{@"icon":@"sns_icon_24",@"name":@"QQ",@"platform":@(24)},@{@"icon":@"sns_icon_6",@"name":@"QQ空间",@"platform":@(6)}]

@interface ZHZShareView()
{
    UIView *bottomView;
    UIView *lineView;   // 分割线
}
@end

@implementation ZHZShareView

- (id)init {
    
    if (self = [super init]) {
        
//        [self setAlphaView];
//        
//        [self setBottomView];
        
        NSString *strContent = @"哈哈";
        
        NSString *strImage = nil;
        
        NSString *strUrl = @"http://www.baidu.com";
        
        NSString *strDes = @"测试一下";
        
        NSString *strTitle = @"请忽略";
        
        //1、创建分享参数
        NSArray* imageArray = @[[UIImage imageNamed:@"about_us"]];
//        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        //    if (self.shareImage) {
        //
        //        shareImage = [[SSDKImage alloc] initWithImage:self.shareImage format:SSDKImageFormatPng settings:nil];
        //
        //    }
        //
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        //
        //    if (self.shareImageFlag) {
        //        //如果有shareImage，先覆盖。
        //
        //        [shareParams SSDKSetupShareParamsByText:strContent
        //                                         images:shareImage
        //                                            url:[NSURL URLWithString:strUrl]
        //                                          title:strTitle
        //                                           type:SSDKContentTypeImage];
        //        // 把 shareImageFlag 还原
        //        self.shareImageFlag = NO;
        //
        //    }else{
        
        //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传image参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        
        //构造分享内容
        [shareParams SSDKSetupShareParamsByText:strContent
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:strTitle
                                           type:SSDKContentTypeAuto];
        
        [SSUIShareActionSheetStyle setCancelButtonLabelColor:GREEN_19b8];
        
        //分享
        [ShareSDK showShareActionSheet:nil
         //将要自定义顺序的平台传入items参数中
                                 items:@[
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         @(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformTypeQQ),
                                         @(SSDKPlatformTypeSinaWeibo)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               
                               NSLog(@"error = %@",error);
                               
                               break;
                           }
                           default:
                               break;
                               
                               
                       }
                   }];

    }
    return self;
}

- (void)setAlphaView {
    
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.bounds];
    
    alphaView.backgroundColor = [UIColor blackColor];
    
    alphaView.alpha = 0.4;
    
    [self addSubview:alphaView];
    // 给阴影层添加 点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    alphaView.userInteractionEnabled = YES;
    [alphaView addGestureRecognizer:tap];
}

- (void)setBottomView {
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,Screen_Height-Screen_Height * 75/284, Screen_Width, Screen_Height * 75/284)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:bottomView];
    //// 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, bottomView.frame.size.height*54/75, Screen_Width, bottomView.frame.size.height*21/75);
    
    [closeBtn setTitleColor:GREEN_19b8 forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:0];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeBtn];
    
    // 分割线
    lineView = [[UIView alloc] initWithFrame:CGRectMake(17, closeBtn.frame.origin.y-0.5, Screen_Width-34, 0.5)];
    lineView.backgroundColor = GRAY_cc;
    [bottomView addSubview:lineView];
    
    UIButton *btnWX = [self makeupButton:0];
    UIButton *btnWXF = [self makeupButton:1];
    UIButton *btnWB = [self makeupButton:2];
    UIButton *btnQQ = [self makeupButton:3];
    UIButton *btnQQF = [self makeupButton:4];
    
    float width = (Screen_Width-24)/5.0f;
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[btnWX(witdh)]-(0)-[btnWXF(witdh)]-(0)-[btnWB(witdh)]-(0)-[btnQQ(witdh)]-(0)-[btnQQF(witdh)]-(0)-|" options:0 metrics:@{@"witdh":@(width)}  views:NSDictionaryOfVariableBindings(bottomView,btnWX,btnWXF,btnWB,btnQQ,btnQQF)]];
    
}

- (UIButton *)makeupButton:(NSInteger)index {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.tag = 100+index;
    NSString *img = shareArray[index][@"icon"];
    [button setTitle:shareArray[index][@"name"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button setTitleColor:BLACK_42 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:14.0f]];
    [button addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(15)-[button]-(15)-[lineView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomView,button,lineView)]];
    
    return button;
}

- (void)shareButton:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    
    NSInteger shareType = [shareArray[index][@"platform"] integerValue];
    
    [self shareIndex:shareType];
    
}

-(void)shareIndex:(SSDKPlatformType) shareType{
    
    
   
    
    //    //以新浪微博为例子，在客户端授权时有效，网页授权无效，另外如果用户已经关注了，那么客户端授权时那个关注选项是会被隐藏掉的
    //    [ShareSDK authorize:shareType settings: @{SSDKAuthSettingKeyScopes : @[@"follow_app_official_microblog"]} onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
    //        // 处理回调
    //        NSLog(@"user = %@",user);
    //
    //    }];
    
    NSString *strContent = @"哈哈";
    
    NSString *strImage = nil;
    
    NSString *strUrl = @"http://www.baidu.com";
    
    NSString *strDes = @"测试一下";
    
    NSString *strTitle = @"请忽略";
    
    //1、创建分享参数
    SSDKImage *shareImage = [[SSDKImage alloc] initWithURL:[NSURL URLWithString:strImage]];
    
//    if (self.shareImage) {
//        
//        shareImage = [[SSDKImage alloc] initWithImage:self.shareImage format:SSDKImageFormatPng settings:nil];
//        
//    }
//    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    
//    if (self.shareImageFlag) {
//        //如果有shareImage，先覆盖。
//        
//        [shareParams SSDKSetupShareParamsByText:strContent
//                                         images:shareImage
//                                            url:[NSURL URLWithString:strUrl]
//                                          title:strTitle
//                                           type:SSDKContentTypeImage];
//        // 把 shareImageFlag 还原
//        self.shareImageFlag = NO;
//        
//    }else{
    
        //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传image参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        
        //构造分享内容
        [shareParams SSDKSetupShareParamsByText:strContent
                                         images:shareImage
                                            url:[NSURL URLWithString:strUrl]
                                          title:strTitle
                                           type:SSDKContentTypeAuto];
        
//    }
    
    if (shareType == SSDKPlatformTypeSinaWeibo) {
        
        strContent = [NSString stringWithFormat:@"%@%@",strContent,strUrl];
        
        //构造分享内容
        [shareParams SSDKSetupShareParamsByText:strContent
                                         images:shareImage
                                            url:[NSURL URLWithString:strUrl]
                                          title:strTitle
                                           type:SSDKContentTypeAuto];
        
        
        [ShareSDK showShareEditor:shareType otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    
                    NSLog(@"error = %@",error);
                    
                    break;
                }
                default:
                    break;
                    
            }
            
        }];
        
    }else{
        
        
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//            
//            
//        }];
    }
}

/*
 * 显示
 */
- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    [self layoutIfNeeded];
    
    
}
/*
 *  清除
 */
-(void)dismiss{
    
    [self layoutIfNeeded];
    self.alpha = 1.0f;
    
    self.transform = CGAffineTransformMakeScale(1.0,1.0);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
