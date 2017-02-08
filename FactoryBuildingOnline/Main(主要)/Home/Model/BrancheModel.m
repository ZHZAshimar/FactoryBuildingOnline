//
//  BrancheModel.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/6.
//  Copyright © 2017年 XFZY. All rights reserved.
//  分店资源的model

#import "BrancheModel.h"
#import <FMDB.h>

#define TABLENAME @"Branches"
#define ID @"id"
#define NAME @"name"

@implementation BrancheModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return  self;
}
/**
 *  创建数据库
 *
 *  @return FMDatabase
 */
+ (FMDatabase *)createDataBase {
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dbPath = [paths stringByAppendingPathComponent:@"FactoryDataCache.db"];
    
    NSLog(@"SQL分店资源的缓存路径%@",dbPath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    return db;
}
/**
 *  插入数据库
 *
 *  @prama BrancheModel model
 *  @return BOOL
 */
+ (BOOL)insertWithBranchModel:(BrancheModel *)model {
    
    BOOL flag = NO;
    
    FMDatabase *db = [BrancheModel createDataBase];
    
    // 创建数据库中的表
    if ([db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT)",TABLENAME,ID, NAME];
        
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success when creating db table");
        }
    }
    
    // 插入数据
    if ([db open]) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into '%@' ('%@','%@')values('%ld','%@')",TABLENAME,ID, NAME,model.branchID,model.name];
        
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
    
    FMDatabase *db = [BrancheModel createDataBase];
    
    // 创建数据库中的表
    if ([db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT)",TABLENAME,ID, NAME];
        
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
    
    while ([rs  next]) {
        BrancheModel *model = [BrancheModel new];
        model.branchID = [rs intForColumn:ID];
        model.name = [rs stringForColumn:NAME];
        
        [mArray addObject:model];
    }
    [db close];
    
    return mArray;
}
@end
