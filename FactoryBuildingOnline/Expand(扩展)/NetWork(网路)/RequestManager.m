//
//  RequestManager.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/27.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking.h>
#import "NSString+Judge.h"                  // nsstring 类目
#import "SecurityUtil.h"                    // 加密解密类
//#import "UserInfoModel+CoreDataClass.h"
#import "FOLUserInforModel.h"

@implementation RequestManager

static AFHTTPSessionManager * instance;


#pragma mark - Base Method

/**
 *  时间戳
 *  @return string 时间戳
 */
- (NSString *)getLocalTime {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%f",time];
}

/**
 *  设备ID
 *  @return string 设备ID
 */
- (NSString *)getDeviceID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/**
 *  简历网络请求单例
 */
+ (RequestManager *)shareInstance {
    
    static RequestManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;   // 使用dispatch_one 函数初始化，保证在多线程环境执行百分百安全
    
    dispatch_once(&oncePredicate, ^{
       
        _sharedInstance = [[RequestManager alloc] init];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 设置请求格式
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 设置返回格式
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //如果报接受类型
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        manager.requestSerializer.timeoutInterval = 8.0f;
        
        instance = manager;
        
        // 增加
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        
    });
    return _sharedInstance;
    
}
/// 设置 time 和token 返回 time
+ (NSString *)getTokenAndTime {
    
    FOLUserInforModel *user = [[FOLUserInforModel findAll] firstObject];
    
    NSString *time_token = user.token_time;
    
    NSString *token = [SecurityUtil AES128Decrypt:user.token andKey:time_token andIV:[time_token stringByReversed]];
    
    // 当前时间
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] *1000;
    
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    
    timeStr = [timeStr substringWithRange:NSMakeRange(0, 13)];  // 拿到13位的时间戳
    
    timeStr  = [NSString stringWithFormat:@"%@000",timeStr];    // 拿到16位的时间戳
    
    NSString *iv = [timeStr stringByReversed];     // IV为时间戳的反转
    
    NSString *encodeToken = [SecurityUtil AES128Encrypt:token andKey:timeStr andIV:iv];
    [instance.requestSerializer setValue:timeStr forHTTPHeaderField:@"TIME"];
    [instance.requestSerializer setValue:[NSString stringWithFormat:@"Token %@",encodeToken] forHTTPHeaderField:@"Authorization"];
    
    return timeStr;
}

/**
 *  POST请求   注册登录专用
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param requestType   请求方式（0：注册，1：登录）
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)postRequestWithService:(NSString *)urlStr andParameters:(NSDictionary *)params andRequestType:(NSInteger)requestType success:(void(^)(RequestManager *manager,NSDictionary *response,NSString *time))success failure:(void(^)(RequestManager *manager,NSError *error))failure {
    
    [instance.requestSerializer clearAuthorizationHeader];  // 此处需要清除 http header中的上一次请求的token，
    
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];
    
    // 当前时间
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] *1000;
    
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    
    timeStr = [timeStr substringWithRange:NSMakeRange(0, 13)];  // 拿到13位的时间戳
    
    timeStr  = [NSString stringWithFormat:@"%@000",timeStr];    // 拿到16位的时间戳
    
    NSString *iv = [timeStr stringByReversed];     // IV为时间戳的反转
    
    NSString *encodeStr = [NSString dictionaryToJson:params];   // 字典转字符串
    
    encodeStr = [SecurityUtil AES128Encrypt:encodeStr andKey:timeStr andIV:iv]; // AES128 CBC nopadding 加密
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    if (requestType == 0) {
        dic = @{@"regist":encodeStr};
    } else if (requestType == 1){
        dic = @{@"login":encodeStr};
    }
    
    __weak RequestManager *weakSelf = self;
    
    [MBProgressHUD showAction:@"光速加载..." ToView:nil];
    
    [instance.requestSerializer setValue:timeStr forHTTPHeaderField:@"TIME"];
    
    [instance POST:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        // 隐藏加载框
        [MBProgressHUD hideHUD];
        
        // 将加密的字节流转成String
        NSString *tmpStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
 
        // 将返回的数据转成json数据格式
        NSDictionary *jsonDic = [NSString dictionaryWithJsonString:tmpStr];
        
        // 获取 header  中的time的方法：
        NSString *time;
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            time = [r allHeaderFields][@"TIME"];
            NSLog(@"%@",r);
        }
        
        // 成功回调
        success(weakSelf,jsonDic,time);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        //通过block,将错误信息回传给用户
        if (failure) failure(weakSelf,error);
        
    }];
}
/**
 *  POST请求 普通
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)postRequestWithURL:(NSString *)urlStr andParameters:(NSDictionary *)params andShowAction:(BOOL)isShow success:(void (^)(RequestManager *manager,NSDictionary *response))success failure:(void (^)(RequestManager *manager, NSError *error))failure {
    
    [instance.requestSerializer clearAuthorizationHeader];
    
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];
    
    __weak RequestManager *weakSelf = self;
    
    if (isShow) [MBProgressHUD showAction:@"光速加载..." ToView:nil];
    
    [instance POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 隐藏加载框
        if (isShow) [MBProgressHUD hideHUD];
        
        // 将返回的数据转成json 数据格式
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        // 成功回调
        success(weakSelf,response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isShow) [MBProgressHUD hideHUD];
        
        //通过block,将错误信息回传给用户
        if (failure) failure(weakSelf,error);
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"%@",r);
        }
        
    }];
}

/**
 *  POST请求 带token 和 TIME
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)postRequestWithService:(NSString *)urlStr andParameters:(NSDictionary *)params isShowActivity:(BOOL)isShow dicIsEncode:(BOOL)isEncode success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure {

    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];
    
    __weak RequestManager *weakSelf = self;
    
    if (isShow) {
        [MBProgressHUD showAction:@"光速加载..." ToView:nil];
    }
    
    [RequestManager getTokenAndTime];
    
    [instance POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 隐藏加载框
        [MBProgressHUD hideHUD];

        // 将返回的数据转成json 数据格式
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        // 成功回调
        success(weakSelf,response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        
        // 获取 http 错误状态 当errorcode = 401 是大部分都是token的问题，当出现两端登录时，一端的token则作废，发送通知提示重新登录
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            NSLog(@"401");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnauthorizedRequest" object:nil];
            return ;
        }
        
        //通过block,将错误信息回传给用户
        if (failure) failure(weakSelf,error);
        
    }];
}

/**
 *  get请求   用户信息
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)getUserInfo:(NSString *)urlStr andParameters:(NSDictionary *)params success:(void(^)(RequestManager *manager,NSDictionary *response,NSString *time))success failure:(void(^)(RequestManager *manager,NSError *error))failure{
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];
    
    __weak RequestManager *weakSelf = self;
    
//    [MBProgressHUD showAction:@"光速加载..." ToView:nil];
    
    [RequestManager getTokenAndTime];
    
    [instance GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        // 获取 header  中的time的方法：
        NSString *time;
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            time = [r allHeaderFields][@"TIME"];
            NSLog(@"%@",r);
        }
        
        // 成功回调
        success(weakSelf,response,time);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.debugDescription);
        // 获取 http 错误状态 当errorcode = 401 是大部分都是token的问题，当出现两端登录时，一端的token则作废，发送通知提示重新登录
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            NSLog(@"401");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnauthorizedRequest" object:nil];
            return ;
        }
        failure(weakSelf,error);
    }];
}

/**
 *  get请求 普通请求，不带token
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param isShow     显示提示框
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)getRequestWithService:(NSString *)urlStr andParameters:(NSDictionary *)params isShowActivity:(BOOL)isShow success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure {
    
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];
    
    __weak RequestManager *weakSelf = self;
    
    if (isShow) [MBProgressHUD showAction:PULL_REFRESH_TEXT ToView:nil];
    
//    [instance.requestSerializer setValue:@"7a228e88d27b64d46beb7f8a72d9831d" forHTTPHeaderField:@"apikey"];
    [instance GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (isShow) [MBProgressHUD hideHUD];
        // 将返回的数据转成json 数据格式
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        success(weakSelf, response);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"error :%@",error.debugDescription);
        // 通过block,将错误信息
        if (failure) {
            failure(weakSelf,error);
        }
    }];
    
}

/**
 *  请求 带header:token 收藏 取消收藏，查看收藏状态
 *
 *  @param urlStr     请求接口
 *  @param type       请求方式  0：get 获取收藏状态/获取我的发布/ 获取我的收藏 1:post 请求收藏 2:delete 取消收藏
 *  @param isShow     显示提示框
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)requestWithServiceOfCollection:(NSString *)urlStr andParameters:(NSDictionary *)params requestType:(NSInteger)type isShowActivity:(BOOL)isShow success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure{
    
    [instance.requestSerializer clearAuthorizationHeader];  // 清楚http的头
    
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];
    
    __weak RequestManager *weakSelf = self;
    
//    [MBProgressHUD showAction:@"光速加载..." ToView:nil];
    [RequestManager getTokenAndTime];
    
    if (isShow) [MBProgressHUD showAction:PULL_REFRESH_TEXT ToView:nil];
    
    switch (type) {
        case 0: // get
        {
            [instance GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (isShow) [MBProgressHUD hideHUD];
                
                // 将返回的数据转成json 数据格式
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                success(weakSelf, response);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (isShow) [MBProgressHUD hideHUD];

                NSLog(@"error :%@",error.debugDescription);
                // 获取 http 错误状态 当errorcode = 401 是大部分都是token的问题，当出现两端登录时，一端的token则作废，发送通知提示重新登录
                BOOL isCollect = [urlStr rangeOfString:@"collection"].location != NSNotFound;
                
                if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401 && !isCollect) {
                    NSLog(@"401");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnauthorizedRequest" object:nil];
                    return ;
                }
                // 通过block,将错误信息
                if (failure) {
                    failure(weakSelf,error);
                }
            }];
        }
            break;
        case 1: // post
        {
            [instance POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (isShow) [MBProgressHUD hideHUD];
                // 将返回的数据转成json 数据格式
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                success(weakSelf, response);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (isShow) [MBProgressHUD hideHUD];
                NSLog(@"error :%@",error.debugDescription);
                // 获取 http 错误状态 当errorcode = 401 是大部分都是token的问题，当出现两端登录时，一端的token则作废，发送通知提示重新登录
                if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
                    NSLog(@"401");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnauthorizedRequest" object:nil];
                    return ;
                }
                // 通过block,将错误信息
                if (failure) {
                    failure(weakSelf,error);
                }
            }];
        }
            break;
        case 2: // delete
        {
            [instance DELETE:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (isShow) [MBProgressHUD hideHUD];
                // 将返回的数据转成json 数据格式
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                success(weakSelf, response);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (isShow) [MBProgressHUD hideHUD];
                NSLog(@"error :%@",error.debugDescription);
                // 获取 http 错误状态 当errorcode = 401 是大部分都是token的问题，当出现两端登录时，一端的token则作废，发送通知提示重新登录
                if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
                    NSLog(@"401");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnauthorizedRequest" object:nil];
                    return ;
                }
                // 通过block,将错误信息
                if (failure) {
                    failure(weakSelf,error);
                }
            }];
        }
            break;
        default:
            break;
    }
    
    
    
}

/**
 *  get请求 直接的连接 无需拼接 返回 string
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)getRequestWithURL:(NSString *)urlStr andParameters:(NSDictionary *)params success:(void(^)(RequestManager *manager,id responseObject))success failure:(void(^)(RequestManager *manager,NSError *error))failure {
    
    __weak RequestManager *weakSelf = self;
    
    [MBProgressHUD showAction:PULL_REFRESH_TEXT ToView:nil];
    //    [instance.requestSerializer setValue:@"7a228e88d27b64d46beb7f8a72d9831d" forHTTPHeaderField:@"apikey"];
    [instance GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        success(weakSelf, responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"error :%@",error.debugDescription);
        // 通过block,将错误信息
        if (failure) {
            failure(weakSelf,error);
        }
    }];
    
}
/**
 *  get请求 直接的连接 无需拼接 返回 dic
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)getRequestWithURLReturnDic:(NSString *)urlStr andParameters:(NSDictionary *)params success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure {
    
    __weak RequestManager *weakSelf = self;
    
    [MBProgressHUD showAction:PULL_REFRESH_TEXT ToView:nil];
    //    [instance.requestSerializer setValue:@"7a228e88d27b64d46beb7f8a72d9831d" forHTTPHeaderField:@"apikey"];
    [instance GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];   // 将返回的数据转成json 数据格式
        
        success(weakSelf,response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"error :%@",error.debugDescription);
        // 通过block,将错误信息
        if (failure) {
            failure(weakSelf,error);
        }
    }];
    
}
/**
 *  delete 请求
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)deleteRequestWithService:(NSString*)urlStr andParameters:(NSDictionary *)params success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure {
    
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];   // 拼接url
    
    [MBProgressHUD showAction:PULL_REFRESH_TEXT ToView:nil];        // 显示加载框
    
    __weak RequestManager *weakSelf = self;
    
    [instance DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];   // 将返回的数据转成json 数据格式
        
        success(weakSelf,response);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSLog(@"error :%@",error.debugDescription);
        
        if (failure) {
            failure(weakSelf,error);    // 通过block,将错误信息回调
        }
    }];
    
}

/**
 *  PUT 请求 带token
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param isShow     显示提示框
 *  @param isEncode   是否加密处理
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)putRequestWithService:(NSString *)urlStr andParameters:(NSDictionary *)params isShowActivity:(BOOL)isShow isEncode:(BOOL)isEncode success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure{
    
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];
    
    __weak RequestManager *weakSelf = self;
    
    if (isShow) [MBProgressHUD showAction:@"光速加载..." ToView:nil];
    
    NSString *time = [RequestManager getTokenAndTime];  // 设置 TIME AND TOKEN
    
    NSString *encodeStr = [NSString dictionaryToJson:params];   // 将字典转成字符串
    
    if (isEncode) {
        
        encodeStr = [SecurityUtil AES128Encrypt:encodeStr andKey:time andIV:[time stringByReversed]];
    }
    
    
    params = [NSDictionary dictionary];
    params = @{@"updateUser":encodeStr};
    
    
    
    NSLog(@"%@",params);
    
    [instance PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (isShow) [MBProgressHUD hideHUD];
        
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        success(weakSelf,responseDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if (isShow) [MBProgressHUD hideHUD];
        NSLog(@"error :%@",error.debugDescription);
        // 获取 http 错误状态 当errorcode = 401 是大部分都是token的问题，当出现两端登录时，一端的token则作废，发送通知提示重新登录
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            NSLog(@"401");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UnauthorizedRequest" object:nil];
            return ;
        }
        if (failure) {
            failure(weakSelf,error);    // 通过block,将错误信息回调
        }
    }];
    
}
/**
 *  Delect 退出登录
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param isShow     显示提示框
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)delectWithQuitLogin:(NSString *)urlStr andParameters:(NSDictionary *)params isShowActivity:(BOOL)isShow success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure {
    
    urlStr = [NSString stringWithFormat:@"%@%@",URL_HOST,urlStr];
    
    __weak RequestManager *weakSelf = self;
    
    if (isShow) [MBProgressHUD showAction:@"正在退出..." ToView:nil];
    
    [RequestManager getTokenAndTime];   // 添加token 和 time
    
    [instance DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (isShow) [MBProgressHUD hideHUD];
        
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        

        success(weakSelf, responseDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (isShow) [MBProgressHUD hideHUD];
        
        failure(weakSelf, error);
    }];
    
}

- (void)postRequestWithService:(NSString *)urlStr andWithEncryParams:(NSDictionary *)params  withBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void(^)(RequestManager *manager,NSDictionary *response))sucess failure:(void(^)(RequestManager *manager,NSError *error))failure {
    
    
}

@end
