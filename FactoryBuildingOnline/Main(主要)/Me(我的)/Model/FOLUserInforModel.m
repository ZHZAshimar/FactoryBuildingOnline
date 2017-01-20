
//
//  FOLUserInforModel.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/7.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "FOLUserInforModel.h"
#import <FMDB.h>

#define TABLENAME @"userInfo"
#define USERID @"userID"
#define AVATAR @"avatar"
#define PHONENUM @"phoneNum"
#define PUBLISH_COUNT @"publish_count"
#define REGIST_TIME @"regist_time"
#define USERTYPE @"type"
#define USERNAME @"userName"
#define TOKEN_TIME @"token_time"
#define TOKEN @"token"
#define PASSWORD @"password"

@implementation FOLUserInforModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}


/**
 *  创建数据库和表
 *
 *  @return FMDatabase
 */
+ (FMDatabase *)createDatabase {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"FactoryUser.db"];
    
    NSLog(@"user infornation path:%@",dbPath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    // 创建数据库的中的表
    if ([db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",TABLENAME,USERID,AVATAR,PHONENUM,PUBLISH_COUNT,REGIST_TIME,USERTYPE,USERNAME,TOKEN_TIME,TOKEN,PASSWORD];
        
        if (![db executeUpdate:sqlCreateTable]) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
    }
    
    return db;
}

/**
 *  插入数据
 *
 *  @param userInfoModel 传入 FOLUserInforModel
 *  @return BOOL 输出插入是否成功
 */
+ (BOOL)insertUserInfoModel:(FOLUserInforModel *)userInfoModel {
    
    BOOL flag = NO;
    
    // 创建数据库
    FMDatabase *db = [FOLUserInforModel createDatabase];
    
    // 插入数据
    if ([db open]) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')values('%@','%@','%@','%d','%@','%ld','%@','%@','%@','%@')",TABLENAME,USERID,AVATAR,PHONENUM,PUBLISH_COUNT,REGIST_TIME,USERTYPE,USERNAME,TOKEN_TIME,TOKEN,PASSWORD,userInfoModel.userID,userInfoModel.avatar,userInfoModel.phoneNum,userInfoModel.publish_count,userInfoModel.regist_time,userInfoModel.type,userInfoModel.userName,userInfoModel.token_time,userInfoModel.token,userInfoModel.password];
        
        if (![db executeUpdate:insertSQL]) {
            flag = NO;
            NSLog(@"error when insert db table");
        } else {
            flag = YES;
            NSLog(@"success when insert db table");
        }
        [db close]; // 关闭数据库
    }
    
    return flag;
}

/**
 *  修改数据
 *
 *  @param key   传入 要修改的列名
 *  @param value 传入 要修改的值
 *  @param userId 传入 用户id
 *
 *  @return BOOL 输出插入是否成功
 */
+ (BOOL)updateUserInfo:(NSString *)key andupdateValue:(NSString *)value andUserID:(NSString *)userId {
    
    BOOL flag = NO;
    // 创建数据库
    FMDatabase *db = [FOLUserInforModel createDatabase];
    
    // 修改数据
    if ([db open]) {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@' WHERE %@='%@'",TABLENAME,key,value,USERID,userId];
        
        if (![db executeUpdate:updateSQL]) {
            NSLog(@" error update userInfo database");
            flag = NO;
        } else {
            NSLog(@"success update userInfo database");
            flag = YES;
        }
        [db close]; // 关闭数据库
    }
    
    return flag;
}

/**
 *  查找数据
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)findAll {
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    // 创建数据库
    FMDatabase *db = [FOLUserInforModel createDatabase];
    
    if (![db open]) {
        return mArray;
    }
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM '%@'",TABLENAME];
    
    FMResultSet *rs = [db executeQuery:selectSQL];
    
    while ([rs next]) {
        
        FOLUserInforModel *model = [FOLUserInforModel new];
        
        model.userID = [rs stringForColumn:USERID];
        model.avatar = [rs stringForColumn:AVATAR];
        model.phoneNum = [rs stringForColumn:PHONENUM];
        model.publish_count = [rs intForColumn:PUBLISH_COUNT];
        model.regist_time = [rs stringForColumn:REGIST_TIME];
        model.type = [rs intForColumn:USERTYPE];
        model.userName = [rs stringForColumn:USERNAME];
        model.token_time = [rs stringForColumn:TOKEN_TIME];
        model.token = [rs stringForColumn:TOKEN];
        model.password = [rs stringForColumn:PASSWORD];
        
        [mArray addObject:model];
    }
    [db close];
    
    return mArray;
}

/**
 *  删除 userinfo表
 *
 *  @return NSMutableArray
 */
+ (BOOL) deleteAll {
    
    BOOL flag = NO;
    
    // 打开数据库
    FMDatabase *db = [FOLUserInforModel createDatabase];
    
    if (![db open]) {
        return flag;
    }
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DROP TABLE '%@'",TABLENAME];
    
    if ([db executeUpdate:deleteSQL]) {
        flag = YES;
        NSLog(@"success delete database's table.");
    } else {
        flag = NO;
        NSLog(@"error delete database's table.");
    }

    return flag;
}

@end
