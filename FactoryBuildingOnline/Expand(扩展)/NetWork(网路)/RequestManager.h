//
//  RequestManager.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/27.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject
/**
 *  简历网络请求单例
 */
+ (RequestManager *)shareInstance;

/**
 *  设备ID
 *  @return string 设备ID
 */
- (NSString *)getDeviceID;

/**
 *  时间戳
 *  @return string 时间戳
 */
- (NSString *)getLocalTime;

/**
 *  POST请求   注册登录专用
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param requestType   请求方式（0：注册，1：登录）
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)postRequestWithService:(NSString *)urlStr andParameters:(NSDictionary *)params andRequestType:(NSInteger)requestType success:(void(^)(RequestManager *manager,NSDictionary *response,NSString *time))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

/**
 *  POST请求 带Token 和 time
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param isEncode   参数是否加密
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)postRequestWithService:(NSString *)urlStr andParameters:(NSDictionary *)params dicIsEncode:(BOOL)isEncode success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure;
/**
 *  POST请求 普通
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)postRequestWithURL:(NSString *)urlStr andParameters:(NSDictionary *)params andShowAction:(BOOL)isShow success:(void (^)(RequestManager *manager,NSDictionary *response))success failure:(void (^)(RequestManager *manager, NSError *error))failure;

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
- (void)putRequestWithService:(NSString *)urlStr andParameters:(NSDictionary *)params isShowActivity:(BOOL)isShow isEncode:(BOOL)isEncode success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

/**
 *  get请求 不带header
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param isShow     显示提示框
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)getRequestWithService:(NSString *)urlStr andParameters:(NSDictionary *)params isShowActivity:(BOOL)isShow success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

/**
 *  get请求 带header:token
 *
 *  @param urlStr     请求接口
 *  @param type       请求方式  0：get 1:post 2:delete
 *  @param isShow     显示提示框
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)requestWithService:(NSString *)urlStr requestType:(NSInteger)type isShowActivity:(BOOL)isShow success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

/**
 *  get请求 直接的连接，无需拼接 返回 string
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)getRequestWithURL:(NSString *)urlStr andParameters:(NSDictionary *)params success:(void(^)(RequestManager *manager,id responseObject))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

/**
 *  get请求 直接的连接 无需拼接 返回 dic
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)getRequestWithURLReturnDic:(NSString *)urlStr andParameters:(NSDictionary *)params success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

/**
 *  get请求 带header:token 收藏 取消收藏，查看收藏状态
 *
 *  @param urlStr     请求接口
 *  @param type       请求方式  0：get 1:post 2:delete
 *  @param isShow     显示提示框
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)requestWithServiceOfCollection:(NSString *)urlStr andParameters:(NSDictionary *)params requestType:(NSInteger)type isShowActivity:(BOOL)isShow success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

/**
 *  get请求   用户信息
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)getUserInfo:(NSString *)urlStr andParameters:(NSDictionary *)params success:(void(^)(RequestManager *manager,NSDictionary *response,NSString *time))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

/**
 *  delete 请求
 *
 *  @param urlStr     请求接口
 *  @param params     向服务器请求时的参数
 *  @param success    请求成功，block的参数为服务返回的数据
 *  @param failure    请求失败，block的参数为错误信息
 */
- (void)deleteRequestWithService:(NSString*)urlStr andParameters:(NSDictionary *)params success:(void(^)(RequestManager *manager,NSDictionary *response))success failure:(void(^)(RequestManager *manager,NSError *error))failure;

@end
