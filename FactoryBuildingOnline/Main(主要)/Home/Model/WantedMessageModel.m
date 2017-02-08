//
//  WantedMessageModel.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/21.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "WantedMessageModel.h"
#import <FMDB.h>


#define TABLENAME @"WantedMessage"
#define ID @"id"
#define VIEW_COUNT @"view_count"
#define UPDATE_ID @"update_id"
#define DELETE_ID @"delete_id"
#define UPDATE_TIME @"update_time"
#define CONTACTER_ID @"contacter_id"
#define OWNER_ID @"owner_id"
#define FACTORY_ID @"factory_id"
#define ISCOLLECT @"isCollect"
#define CREATED_TIME @"created_time"

@implementation WantedMessageModel

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
+ (FMDatabase *)createDatabase {
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dbPath = [paths stringByAppendingPathComponent:@"FactoryDataCache.db"];
    
    NSLog(@"SQLPath:%@",dbPath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    return db;
}
/*
 *  插入数据库
 *
 *  @prama WantedMessageModel model
 *  @return BOOL
 */
+ (BOOL)insertWantedMessageModel:(WantedMessageModel *)wantedMessageModel{
    
    BOOL flag = NO;
    
    // 创建数据库
    FMDatabase *db = [WantedMessageModel createDatabase];

    /*
        创建数据库中的表
     */
    
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT)",TABLENAME,ID, VIEW_COUNT, UPDATE_ID,DELETE_ID,UPDATE_TIME,CONTACTER_ID,OWNER_ID,FACTORY_ID,ISCOLLECT,CREATED_TIME];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
    }
    /*
     插入数据
     */
    if ([db open]) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')values('%ld','%ld','%ld','%ld','%@','%ld','%ld','%ld','%d','%@')",TABLENAME,ID, VIEW_COUNT, UPDATE_ID,DELETE_ID,UPDATE_TIME,CONTACTER_ID,OWNER_ID,FACTORY_ID,ISCOLLECT,CREATED_TIME,wantedMessageModel.id,wantedMessageModel.view_count, wantedMessageModel.update_id,wantedMessageModel.delete_id,wantedMessageModel.update_time,wantedMessageModel.ctModel.id,wantedMessageModel.owner_id,wantedMessageModel.ftModel.id,wantedMessageModel.isCollect,wantedMessageModel.created_time];
        
        if ([db executeUpdate:insertSQL]) {
//            [db beginTransaction];
            
            flag = YES;
        } else {
            flag = NO;
        }
        [db close];
    }
    return flag;
}
/**
 *  多表插入数据库
 *
 *  @param wmModel WantedMessageModel
 *  @param ctModel ContacterModel
 *  @param ftModel FactoryModel
 *
 */
+ (void)insertOfMoreTable:(WantedMessageModel *)wmModel andContacterModel:(ContacterModel *)ctModel andeFactoryModel:(FactoryModel *)ftModel {
    
    // 将数据用事务多个表同事插入
    
    FMDatabase *db = [WantedMessageModel createDatabase];
    
    [db beginTransaction];      // 事务多表插入数据
    
    BOOL isRollBack = NO;
    
    @try {
        // 将数据插入 contacter 表中
        [ContacterModel insertContactorModel:ctModel];
        
        [FactoryModel insertFactoryModel:ftModel];
        
        [WantedMessageModel insertWantedMessageModel:wmModel];
        
        
    } @catch (NSException *exception) {
        isRollBack = YES;
        [db rollback];
    } @finally {
        if (!isRollBack) {
            [db commit];
        }
        if ([db open]) {
            [db close];
        }
    }
    
    
}

/*
    查询最新的 时间戳
 */
+ (NSString *)findWithNewerData{
    
    NSString *string = @"";
    
    FMDatabase *db = [WantedMessageModel createDatabase];
    
    /**
     *  创建数据库中的表
     */
    if ([db open]) {
        
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT)",TABLENAME,ID, VIEW_COUNT, UPDATE_ID,DELETE_ID,UPDATE_TIME,CONTACTER_ID,OWNER_ID,FACTORY_ID,ISCOLLECT,CREATED_TIME];
        if (![db executeUpdate:sqlCreateTable]) {
            return string;
        } else {
            NSLog(@"success to creating db table");
        }
        
    }
    /*
     查找
     */
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT max(update_time) as update_time FROM WantedMessage"];
    
    FMResultSet *rs = [db executeQuery:selectSQL];
    NSLog(@"%@",rs);
    while ([rs next]) {
        WantedMessageModel *wmModel = [[WantedMessageModel alloc] init];
        wmModel.update_time = [rs stringForColumn:UPDATE_TIME];
        string = [NSString stringWithFormat:@"%d",[rs intForColumnIndex:0]];
    }
    
    return string;
}

/*
     查询最大的ID
 */
+ (NSString *)findWithMaxID{
    
    NSString *string = @"";
    
    FMDatabase *db = [WantedMessageModel createDatabase];
    
    /**
     *  创建数据库中的表
     */
    if ([db open]) {
        
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT)",TABLENAME,ID, VIEW_COUNT, UPDATE_ID,DELETE_ID,UPDATE_TIME,CONTACTER_ID,OWNER_ID,FACTORY_ID,ISCOLLECT,CREATED_TIME];
        if (![db executeUpdate:sqlCreateTable]) {
            return string;
        } else {
            NSLog(@"success to creating db table");
        }
        
    }
    /*
     查找
     */
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT max(id) as id FROM WantedMessage"];
    
    FMResultSet *rs = [db executeQuery:selectSQL];
    NSLog(@"%@",rs);
    while ([rs next]) {
        WantedMessageModel *wmModel = [[WantedMessageModel alloc] init];
        wmModel.update_time = [rs stringForColumn:ID];
        string = [NSString stringWithFormat:@"%d",[rs intForColumnIndex:0]];
    }
    
    return string;
}
/*
 * 从数据库拿数据 10条
 */
+ (NSMutableArray *)findTenDataWithPage:(int)page addMore:(int)dataCount{
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    FMDatabase *db = [WantedMessageModel createDatabase];
    
    /**
     *  创建数据库中的表
     */
    if ([db open]) {
        
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT)",TABLENAME,ID, VIEW_COUNT, UPDATE_ID,DELETE_ID,UPDATE_TIME,CONTACTER_ID,OWNER_ID,FACTORY_ID,ISCOLLECT,CREATED_TIME];
        if (![db executeUpdate:sqlCreateTable]) {
            return mArray;
        } else {
            NSLog(@"success to creating db table");
        }
        
    }
    /*
     查找
     */
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM (WantedMessage INNER JOIN Factory ON WantedMessage.factory_id=Factory.id) INNER JOIN Contacter ON WantedMessage.contacter_id=Contacter.id order by id desc LIMIT 10 OFFSET %d",(page-1)*10];
    
    if (dataCount > 0) {    // 内联查询 排除 dataCount 条 取10条数据
        selectSQL = [NSString stringWithFormat:@"SELECT * FROM (WantedMessage INNER JOIN Factory ON WantedMessage.factory_id=Factory.id) INNER JOIN Contacter ON WantedMessage.contacter_id=Contacter.id order by id desc LIMIT 10 OFFSET %d",dataCount];
    }
    
    
    FMResultSet *rs = [db executeQuery:selectSQL];
    
    while ([rs next]) {
    
        // 主要是用到factory
        FactoryModel *fac_model = [[FactoryModel alloc] init];
        fac_model.id = [rs intForColumn:FACTORY_ID];
        fac_model.tags = [rs objectForColumnName:@"tags"];
        fac_model.thumbnail_url = [rs stringForColumn:@"thumbnail_url"];
        fac_model.title = [rs stringForColumn:@"title"];
        fac_model.price = [rs stringForColumn:@"price"];
        fac_model.range = [rs stringForColumn:@"range"];
        fac_model.description_factory = [rs stringForColumn:@"description_factory"];
        fac_model.address_overview = [rs stringForColumn:@"address_overview"];
        fac_model.pre_pay = [rs stringForColumn:@"pre_pay"];
        fac_model.image_urls = [rs objectForColumnName:@"image_urls"];
        fac_model.geohash = [rs stringForColumn:@"geohash"];
        fac_model.rent_type = [rs stringForColumn:@"rent_type"];
        
        ContacterModel *ctModel = [[ContacterModel alloc] init];
        ctModel.id = [rs intForColumn:CONTACTER_ID];
        ctModel.name = [rs stringForColumn:@"name"];
        ctModel.phone_num = [rs stringForColumn:@"phone_num"];
        
        
        WantedMessageModel *wmModel = [[WantedMessageModel alloc] init];
    
        wmModel.id = [rs intForColumn:ID];
        wmModel.update_id = [rs intForColumn:UPDATE_ID];
        wmModel.delete_id = [rs intForColumn:DELETE_ID];
        wmModel.update_time = [rs stringForColumn:UPDATE_TIME];
        wmModel.owner_id = [rs intForColumn:OWNER_ID];
        wmModel.isCollect = [rs intForColumn:ISCOLLECT];
        wmModel.created_time = [rs stringForColumn:CREATED_TIME];
        wmModel.ftModel = fac_model;
        wmModel.ctModel = ctModel;
        wmModel.view_count = [rs intForColumn:VIEW_COUNT];
        
        [mArray addObject:wmModel];
    }
    return mArray;
}

+ (NSArray *)findWith{
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    FMDatabase *db = [WantedMessageModel createDatabase];
    
    /**
     *  创建数据库中的表
     */
    if ([db open]) {
        
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' INTEGER, '%@' TEXT)",TABLENAME,ID, VIEW_COUNT, UPDATE_ID,DELETE_ID,UPDATE_TIME,CONTACTER_ID,OWNER_ID,FACTORY_ID,ISCOLLECT,CREATED_TIME];
        if (![db executeUpdate:sqlCreateTable]) {
            return mArray;
        } else {
            NSLog(@"success to creating db table");
        }
        
    }
    /*
     查找
     */
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM WantedMessage INNER JOIN Factory ON WantedMessage.factory_id=Factory.id"];
    
    FMResultSet *rs = [db executeQuery:selectSQL];
    NSLog(@"%@",rs);
    while ([rs next]) {
        WantedMessageModel *wmModel = [[WantedMessageModel alloc] init];
        wmModel.id = [rs intForColumn:ID];
        wmModel.update_id = [rs intForColumn:UPDATE_ID];
        wmModel.delete_id = [rs intForColumn:DELETE_ID];
        wmModel.update_time = [rs stringForColumn:UPDATE_TIME];
//        wmModel.contacter_id = [rs intForColumn:];
        wmModel.owner_id = [rs intForColumn:OWNER_ID];
//        wmModel.factory_id = [rs intForColumn:FACTORY_ID];
        wmModel.isCollect = [rs intForColumn:ISCOLLECT];
        wmModel.created_time = [rs stringForColumn:CREATED_TIME];
        
        [mArray addObject:wmModel];
        // 主要是用到factory
        FactoryModel *fac_model = [[FactoryModel alloc] init];
        fac_model.id = [rs intForColumn:@"id"];
        fac_model.tags = [rs objectForColumnName:@"tags"];
        fac_model.thumbnail_url = [rs stringForColumn:@"thumbnail_url"];
        fac_model.title = [rs stringForColumn:@"title"];
        fac_model.price = [rs stringForColumn:@"price"];
        fac_model.range = [rs stringForColumn:@"range"];
        fac_model.description_factory = [rs stringForColumn:@"description_factory"];
        fac_model.address_overview = [rs stringForColumn:@"address_overview"];
        fac_model.pre_pay = [rs stringForColumn:@"pre_pay"];
        fac_model.image_urls = [rs objectForColumnName:@"image_urls"];
        fac_model.geohash = [rs stringForColumn:@"geohash"];
        fac_model.rent_type = [rs stringForColumn:@"rent_type"];
        
        
//        wmModel setValue:<#(nullable id)#> forKey:@"factory"];
        
        [mArray addObject:fac_model];
        
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

//+ (BOOL)updateWantedMessageModel:(WantedMessageModel *)wantedMessageModel {
//    
//    BOOL flag;
//    
//    // 创建数据库
//    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    
//    NSString *dbPath = [paths stringByAppendingPathComponent:@"FactoryDataCache.db"];
//    
//    
//    
//}

@end
