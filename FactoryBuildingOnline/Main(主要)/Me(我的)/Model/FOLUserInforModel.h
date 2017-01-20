//
//  FOLUserInforModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/7.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FOLUserInforModel : NSObject

@property (nonatomic, strong) NSString *avatar;         // 用户头像
@property (nonatomic, strong) NSString *userID;             // 用户 id
@property (nonatomic, strong) NSString *phoneNum;       // 用户手机号码
@property (nonatomic, assign) int16_t publish_count;                    // 用户发布的信息条数
@property (nonatomic, strong) NSString *regist_time;    // 用户注册的时间
@property (nonatomic, assign) int16_t type;                             // 用户类型
@property (nonatomic, strong) NSString *userName;       // 用户名称
@property (nonatomic, strong) NSString *token_time;     // token的解密key
@property (nonatomic, strong) NSString *token;          // token值， 未解密
@property (nonatomic, strong) NSString *password;       // 密码

/**
 *  初始化
 *
 *  @prama dictionary 字典
 *  @return self
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  插入数据
 *
 *  @param userInfoModel 传入 FOLUserInforModel
 *  @return BOOL 输出插入是否成功
 */
+ (BOOL)insertUserInfoModel:(FOLUserInforModel *)userInfoModel;

/**
 *  查找数据
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)findAll;

/**
 *  修改数据
 *
 *  @param key   传入 要修改的列名
 *  @param value 传入 要修改的值
 *  @param userId 传入 用户id
 *
 *  @return BOOL 输出插入是否成功
 */
+ (BOOL)updateUserInfo:(NSString *)key andupdateValue:(NSString *)value andUserID:(NSString *)userId;

/**
 *  删除 userinfo表
 *
 *  @return NSMutableArray
 */
+ (BOOL) deleteAll;

@end
