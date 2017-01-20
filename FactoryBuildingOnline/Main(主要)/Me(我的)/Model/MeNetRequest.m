//
//  MeNetRequest.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/8.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "MeNetRequest.h"
#import "QNConfiguration.h"
#import <QiniuSDK.h>
#import "FOLUserInforModel.h"
#import "SecurityUtil.h"

@interface MeNetRequest()
{
    NSString *imageQNKey;   // 图片上传七牛成功之后返回的图片key
}
@end

@implementation MeNetRequest

/**
 *  获取图片的七牛token
 *
 *  @param image 要上传的图片
 */
- (void)getImageTokenToPushQN:(UIImage *)image {
    
    [MBProgressHUD showAction:@"正在上传图片" ToView:nil];
    
    // 从服务器拿到 七牛的token
    [HTTPREQUEST_SINGLE requestWithServiceOfCollection:@"qiniutokens/1/" andParameters:nil requestType:0 isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"%@--%@",response,response[@"token"]);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 获取一个全局队列
        
        dispatch_async(queue, ^{    // 2、把任务添加到队列中执行
            
            NSString *token = response[@"token"];
            
            [self pushImageToQN:token andImage:image];  // 上传图片到七牛
        });
    } failure:^(RequestManager *manager, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络出小差了，请稍后再修改💔" ToView:nil];
    }];

}
/**
 *  将图片上传到七牛七牛token
 *
 *  @param image        要上传的图片
 *  @param imageToken   从后台获取的图片token
 */
- (void)pushImageToQN:(NSString *)imageToken andImage:(UIImage *)image{
    
    NSString *imageKey = [NSString stringWithFormat:@"factory_%@.jpg",[[NSUUID UUID] UUIDString]];  // 设置图片名称 = factory_设备UUID.jpg

    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone1];  // 将七牛的服务器设置到zone1
    }];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];    // 七牛 管理上传的类
    
    NSData *data = [self compressOriginalImage:image toMaxDataSizeKBytes:100.0];    // 压缩图片
    // 上传图片到七牛
    [upManager putData:data key:imageKey token:imageToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        NSLog(@"%@", resp);
        
        imageQNKey = resp[@"key"];
        
        if (imageKey != nil) {
            [self updateUserAvater:resp[@"key"] andUpdateType:1 getUserInfo:YES];   // 修改头像
        } else {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络出小差，稍后再试！" ToView:nil];
            
        }
        [MBProgressHUD hideHUD];
        
    } option:nil];
}

/**
 *  修改用户的基本信息
 *
 *  @param value 修改的值
 *  @param updateType : 1.更新头像2.更新用户名3.更新密码
 *  @param getUserInfo 是否获取用户基本信息
 */
- (void)updateUserAvater:(NSString *)value andUpdateType:(NSInteger)updateType getUserInfo:(BOOL)getUserInfo{
    
    NSDictionary *requestDic = @{@"update_type":@(updateType),@"update_value":value};
    
    [HTTPREQUEST_SINGLE putRequestWithService:URL_POST_LOGIN andParameters:requestDic isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        int code = [response[@"erro_code"] intValue];
        
        if (code != 200) {
            [MBProgressHUD showAutoMessage:response[@"erro_msg"] ToView:nil];
            return ;
        }
        if (getUserInfo) {
             [self getUserInfoAfterUpdateData:1];
        } else {
            // 请求成功更新数据库中的用户信息表
            NSString *str = [SecurityUtil decodeBase64String:value];
            
            NSDictionary *dic = [NSString dictionaryWithJsonString:str];
            
            FOLUserInforModel *model = [[FOLUserInforModel findAll] firstObject];
            
            BOOL flag = [FOLUserInforModel updateUserInfo:@"password" andupdateValue:dic[@"pwd"] andUserID:model.userID];
            
            if (flag) {
                self.psdBlock(YES);
            }
        }
       
    } failure:^(RequestManager *manager, NSError *error) {
        [MBProgressHUD showError:@"网络出小差了，请稍后再修改💔" ToView:nil];
    }];
    
}
/**
 *  获取用户的基本信息
 *
 *  @param updateType : 1.更新头像2.更新用户名3.更新密码
 *
 */

- (void)getUserInfoAfterUpdateData:(NSInteger)updateType {
    
    [HTTPREQUEST_SINGLE getUserInfo:URL_GET_USERINFO andParameters:nil success:^(RequestManager *manager, NSDictionary *response, NSString *time) {
        
        int code = [response[@"erro_code"] intValue];
        
        if (code != 200) {
            [MBProgressHUD showAutoMessage:response[@"erro_msg"] ToView:nil];
            return ;
        }
        NSString *userStr = [SecurityUtil AES128Decrypt:response[@"user"] andKey:time andIV:[time stringByReversed]];
        
        NSDictionary *userDic = [NSString dictionaryWithJsonString:userStr];    // string转字典
    
        // 请求成功更新数据库中的用户信息表
        FOLUserInforModel *model = [[FOLUserInforModel findAll] firstObject];
        
        if ([model.userID intValue] != [userDic[@"id"] intValue]) {
            return;
        }
        
        switch (updateType) {
            case 1:
            {
//                NSString *avatarUrl = [SecurityUtil decodeBase64String:userDic[@"avatar"]]; // 对拿到的图片进行base64解密
                BOOL flag = [FOLUserInforModel updateUserInfo:@"avatar" andupdateValue:userDic[@"avatar"] andUserID:model.userID];  // 修改数据库
                
                if (flag) {
                    [MBProgressHUD showSuccess:@"修改成功👏" ToView:nil];
                    
                    self.avatarBlock(YES);  // 头像更改成功回调
                }
            }
                break;
            
            default:
                break;
        }
    } failure:^(RequestManager *manager, NSError *error) {
        [MBProgressHUD showError:@"网络出小差了，请稍后再修改💔" ToView:nil];
    }];
    
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

@end
