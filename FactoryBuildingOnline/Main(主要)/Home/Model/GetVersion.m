
//
//  GetVersionk.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/2/22.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "GetVersion.h"
#import <AFNetworking.h>

@implementation GetVersion

/*
 *  通过AppStore 更新版本
 */
- (void)appStoreUpdateVersion {
    // 获取手机程序的版本号
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    // post 必须上传字段p
    NSDictionary *dic = @{@"id":APPID};
    
    [manager POST:@"https://itunes.apple.com/cn/lookup" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"results"];
        if (array.count != 0) { // 先判断返回的数据是否为空
            NSDictionary *dictionary = array[0];
            NSLog(@"版本更新 = %@",dictionary);
            // 判断版本
            NSString *appStoreVersion = dictionary[@"version"];
            
            NSLog(@"%f----%f",[self systemVersionCovertToFloat:currentVersion],[self systemVersionCovertToFloat:appStoreVersion]);
            // 通过版本号将版本号转换为float类型，再进行判断大小
            if ([self systemVersionCovertToFloat:currentVersion] < [self systemVersionCovertToFloat:appStoreVersion]) {
                
                self.versionStr = appStoreVersion;
                
                // 显示提示框
                self.block(@{@"releaseNotes":dictionary[@"releaseNotes"],@"version":dictionary[@"version"]});
                
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"版本检测更新：error = %@",error.debugDescription);
    }];
    
}


- (CGFloat)systemVersionCovertToFloat:(NSString *)sVersion{
    
    //    NSString *sVersion = [[UIDevice currentDevice] systemVersion];
    
    NSRange fRange = [sVersion rangeOfString:@"."];
    
    
    CGFloat version = 0.0f;
    
    if(fRange.location != NSNotFound){
        sVersion = [sVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSMutableString *mVersion = [NSMutableString stringWithString:sVersion];
        [mVersion insertString:@"." atIndex:fRange.location];
        version = [mVersion floatValue];
    }else {
        // 版本应该有问题(由于ios 的版本 是7.0.1，没有发现出现过没有小数点的情况)
        version = [sVersion floatValue];
    }
    
    return version;
}

@end
