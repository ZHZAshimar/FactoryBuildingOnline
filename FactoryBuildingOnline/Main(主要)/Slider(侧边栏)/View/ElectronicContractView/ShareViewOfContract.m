//
//  ShareViewOfContract.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/17.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ShareViewOfContract.h"



//新浪微博SDK头文件
//#import "WeiboSDK.h"

#import <ShareSDK/ShareSDK.h>
// 弹出分享菜单需要导入的头文件
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
// 自定义分享编辑界面所需要导入的头文件
#import <ShareSDKUI/SSUIEditorViewStyle.h>

#import "SecurityUtil.h"

#define self_width self.frame.size.width
#define self_height self.frame.size.height

#define shareArray @[@{@"icon":@"contract_download",@"name":@"保存到手机",@"platform":@(22)},@{@"icon":@"contract_wb",@"name":@"新浪微博",@"platform":@(23)},@{@"icon":@"contract_wc",@"name":@"微信好友",@"platform":@(19)},@{@"icon":@"contract_qq",@"name":@"QQ好友"}]

@interface ShareViewOfContract()
{
    UIView *bottomView;
    UIView *lineView;   // 分割线
}
@end

@implementation ShareViewOfContract

- (id)init {
    
    if (self = [super init]) {
        
        [self setAlphaView];
        
        [self setBottomView];
        
        
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
    
    bottomView.backgroundColor = [UIColor colorWithHex:0xF6F6F6];
    
    [self addSubview:bottomView];
    //// 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, bottomView.frame.size.height*54/75, Screen_Width, bottomView.frame.size.height*21/75);
    
    [closeBtn setTitleColor:BLACK_42 forState:UIControlStateNormal];
    [closeBtn setTitle:@"取消" forState:0];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeBtn];
    
//    // 分割线
//    lineView = [[UIView alloc] initWithFrame:CGRectMake(17, closeBtn.frame.origin.y-0.5, Screen_Width-34, 0.5)];
//    lineView.backgroundColor = GRAY_cc;
//    [bottomView addSubview:lineView];
    
    CGFloat btnWidth =(Screen_Width-22*5)/4;
    
    for (int i = 0; i < 4; i++) {
        // 按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(22+i*(btnWidth+22), 15, btnWidth, btnWidth);
        button.tag = 100+i;
        NSString *img = shareArray[i][@"icon"];
        [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        
        [bottomView addSubview:button];
        // 文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(11+i*(Screen_Width-22)/4, button.frame.origin.y + btnWidth+6, (Screen_Width-22)/4, 30)];
        label.text = shareArray[i][@"name"];
        label.font = [UIFont systemFontOfSize:[UIFont adjustFontSize:11.0f]];
        label.textColor = BLACK_42;
        label.textAlignment = NSTextAlignmentCenter;
        [bottomView addSubview:label];
    }
    
}

- (void)shareButton:(UIButton *)sender {
    NSLog(@"%@",sender.titleLabel.text);
//    
//    NSInteger index = sender.tag - 100;
//    
//    NSInteger shareType = [shareArray[index][@"platform"] integerValue];
//    
//    [self shareIndex:shareType];
    
}

- (void)setShareDic:(NSDictionary *)shareDic {
    _shareDic = shareDic;
}
// @{@"linkerName":self.model.ctModel.name,@"phoneNum":self.model.ctModel.phone_num,@"title":self.model.ftModel.title,@"image":self.model.ftModel.thumbnail_url};
-(void)shareIndex:(SSDKPlatformType) shareType{
    
    NSString *strImage = [SecurityUtil decodeBase64String:self.shareDic[@"image"]];
    
    NSString *strContent = [NSString stringWithFormat:@"%@",self.shareDic[@"content"]];
    
    NSString *strUrl = @"http://apps.oncom.cn";
    
    NSString *strTitle = self.shareDic[@"title"];
    
    //1、创建分享参数
    SSDKImage *shareImage = [[SSDKImage alloc] initWithURL:[NSURL URLWithString:strImage]];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
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
        
    } else{
        //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传image参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
        if (shareType == SSDKPlatformTypeSMS){
            strContent = [NSString stringWithFormat:@"您的好友向您推荐《找厂房》App,点击连接下载%@",@"http://apps.oncom.cn"];
            //构造分享内容
            [shareParams SSDKSetupShareParamsByText:strContent
                                             images:nil
                                                url:nil
                                              title:nil
                                               type:SSDKContentTypeText];
        } else {
            
            //构造分享内容
            [shareParams SSDKSetupShareParamsByText:strContent
                                             images:@[strImage]
                                                url:[NSURL URLWithString:strUrl]
                                              title:strTitle
                                               type:SSDKContentTypeAuto];
        }
        
        //         if (shareType == SSDKPlatformSubTypeQZone) {
        //            // 短信的分享只能分享 image 或 text 形式的
        //
        //             strContent = [NSString stringWithFormat:@"厂房标题：%@\n联系人：%@\n联系方式：%@\n图片查看：%@",self.shareDic[@"title"],self.shareDic[@"linkerName"],self.shareDic[@"phoneNum"],strImage];
        //             //构造分享内容
        //             [shareParams SSDKSetupShareParamsByText:strContent
        //                                              images:nil
        //                                                 url:nil
        //                                               title:nil
        //                                                type:SSDKContentTypeText];
        //
        //         } else {
        //
        //             strContent = [NSString stringWithFormat:@"联系人：%@\n联系方式：%@",self.shareDic[@"linkerName"],self.shareDic[@"phoneNum"]];
        //             //构造分享内容
        //             [shareParams SSDKSetupShareParamsByText:strContent
        //                                              images:@[strImage]
        //                                                 url:nil
        //                                               title:strTitle
        //                                                type:SSDKContentTypeAuto];
        //
        //         }
        // 分享
        [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
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



@end
