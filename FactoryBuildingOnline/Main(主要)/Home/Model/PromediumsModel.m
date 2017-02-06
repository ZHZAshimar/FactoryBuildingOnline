//
//  PromediumsModel.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/6.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "PromediumsModel.h"
#import <FMDB.h>

#define TABLENAME @"Promediums"
#define ID        @"id"
#define BRANCH    @"branch"
#define REALNAME  @"realName"
#define WORKYEAR  @"workYear"
#define AVATAR    @"avatar"
#define PHONENUM  @"phoneNum"

@implementation PromediumsModel
/**
 *  初始化
 *
 *  @prama dictionary 字典
 *  @return self
 */
- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

/**
 *  创建数据库
 *
 *  @return FMDatabase
 */
+ (FMDatabase *)createDataBase {
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dbPath = [paths stringByAppendingPathComponent:@"FactoryDataCache.db"];
    
    NSLog(@"SQL专家缓存的路径:%@",dbPath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    return db;
}

/**
 *  插入数据库
 *
 *  @prama WantedMessageModel model
 *  @return BOOL
 */
+ (BOOL)insertPromediumsModel:(PromediumsModel *)promediumsModel {
    
    BOOL flag = NO;
    
    // 创建数据库
    FMDatabase *db = [PromediumsModel createDataBase];
    
    // 创建数据库中的表
    if ([db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",TABLENAME,ID, BRANCH, REALNAME, WORKYEAR, AVATAR, PHONENUM];
        
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success when creating db table");
        }
    }
    
    // 插入数据
    if ([db open]) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into '%@' ('%@','%@','%@','%@','%@','%@')values('%ld','%@','%@','%@','%@','%@')",TABLENAME,ID, BRANCH, REALNAME, WORKYEAR, AVATAR, PHONENUM,promediumsModel.promediumsID,promediumsModel.branch,promediumsModel.realName, promediumsModel.workYear, promediumsModel.avatar, promediumsModel.phoneNum];
        
        if ([db executeUpdate:insertSQL]) {
            flag = YES;
        } else {
            flag = NO;
        }
        [db close];
    }
    
    return flag;
}

/**
 *  查找 表中的所有数据
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)findAll {
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    FMDatabase *db = [PromediumsModel createDataBase];
    
    // 创建数据库中的表
    if ([db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",TABLENAME,ID, BRANCH, REALNAME, WORKYEAR, AVATAR, PHONENUM];
        
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if (!res) {
            NSLog(@"error when creating db table");
            return mArray;
        } else {
            NSLog(@"success when creating db table");
        }
    }
    
    // 查找
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM %@",TABLENAME];
    
    FMResultSet *rs = [db executeQuery:selectSQL];
    NSLog(@"专家塞选：%@",rs);
    while ([rs next]) {
        PromediumsModel *model = [PromediumsModel new];
        model.promediumsID = [rs intForColumn:ID];
        model.branch = [rs stringForColumn:BRANCH];
        model.realName = [rs stringForColumn:REALNAME];
        model.workYear = [rs stringForColumn:WORKYEAR];
        model.avatar = [rs stringForColumn:AVATAR];
        model.phoneNum = [rs stringForColumn:PHONENUM];
        
        [mArray addObject:model];
    }
    [db close];
    
    return mArray;
}

// 删除数据库
+ (BOOL)deleteDatabase {
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dbPath = [paths stringByAppendingPathComponent:@"FactoryDataCache.db"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    if ([manager removeItemAtPath:dbPath error:&error]) {
        NSLog(@"删除数据库成功");
        return YES;
    } else {
        NSLog(@"删除数据库失败");
        return NO;
    }
    
}

@end
