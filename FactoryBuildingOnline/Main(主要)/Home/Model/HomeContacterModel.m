//
//  HomeContacter.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeContacterModel.h"
#import <FMDB.h>

#define TABLENAME @"Home_Contacter"

#define ID @"id"
#define PHONE_NUM @"phone_num"
#define NAME @"name"

@implementation HomeContacterModel

/**
 *  初始化
 *
 *  @param dictionary 字典
 *  @return self
 */
- (id)initWithDictionary :(NSDictionary *)dictionary {
    
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
+ (FMDatabase *)createDatabase {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"FactoryDataCache.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if ([db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT)",TABLENAME,ID,PHONE_NUM,NAME];
        
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
    }
    
    return db;
}

/*
 *  插入数据库
 *
 *  @param model FactoryModel
 *
 *  @return BOOL
 */
+ (BOOL)insertContactorModel:(HomeContacterModel *)model {
    
    BOOL flag = NO;
    
    FMDatabase *db = [HomeContacterModel createDatabase];
    
    if ([db open]) {
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into '%@' ('%@','%@','%@')values('%ld','%@','%@')",TABLENAME,ID,PHONE_NUM,NAME,model.id,model.phone_num,model.name];
        
        if ([db executeUpdate:insertSQL]) {
            flag = YES;
        } else {
            flag = NO;
        }
        [db close];
        
    }
    return flag;
}



@end
