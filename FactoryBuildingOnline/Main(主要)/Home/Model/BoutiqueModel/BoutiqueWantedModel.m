                                                           //
//  BoutiqueWantedModel.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/7.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "BoutiqueWantedModel.h"
#import <FMDB.h>

#define TABLENAME @"Boutique_WantedMessage"
#define ID @"id"
#define UPDATE_ID @"update_id"
#define DELETE_ID @"delete_id"
#define UPDATE_TIME @"update_time"
#define VIEW_COUNT @"view_count"
#define CONTACTER_ID @"contacter_id"
#define OWNER_ID @"owner_id"
#define FACTORY_ID @"factory_id"
#define ISCOLLECT @"isCollect"
#define CREATED_TIME @"created_time"

@implementation BoutiqueWantedModel
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
+ (BOOL)insertWantedMessageModel:(BoutiqueWantedModel *)wantedMessageModel{
    
    BOOL flag = NO;
    
    // 创建数据库
    FMDatabase *db = [BoutiqueWantedModel createDatabase];
    
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
            [db beginTransaction];
            
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
+ (void)insertOfMoreTable:(BoutiqueWantedModel *)wmModel andContacterModel:(BoutiqueContacterModel *)ctModel andeFactoryModel:(BoutiqueFactoryModel *)ftModel {
    
    // 将数据用事务多个表同事插入
    
    FMDatabase *db = [BoutiqueWantedModel createDatabase];
    
    [db beginTransaction];      // 事务多表插入数据
    
    BOOL isRollBack = NO;
    
    @try {
        // 将数据插入 contacter 表中
        [BoutiqueContacterModel insertContactorModel:ctModel];
        
        [BoutiqueFactoryModel insertFactoryModel:ftModel];
        
        [BoutiqueWantedModel insertWantedMessageModel:wmModel];
        
        
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
 * 从数据库拿数据
 */
+ (NSMutableArray *)findAll{
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    FMDatabase *db = [BoutiqueWantedModel createDatabase];
    
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
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM (Boutique_WantedMessage INNER JOIN Boutique_Factory ON Boutique_WantedMessage.factory_id=Boutique_Factory.id) INNER JOIN Boutique_Contacter ON Boutique_WantedMessage.contacter_id=Boutique_Contacter.id order by id ASC LIMIT 3"];
    
    FMResultSet *rs = [db executeQuery:selectSQL];
    
    while ([rs next]) {
        
        // 主要是用到factory
        BoutiqueFactoryModel *fac_model = [[BoutiqueFactoryModel alloc] init];
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
        
        BoutiqueContacterModel *ctModel = [[BoutiqueContacterModel alloc] init];
        ctModel.id = [rs intForColumn:CONTACTER_ID];
        ctModel.name = [rs stringForColumn:@"name"];
        ctModel.phone_num = [rs stringForColumn:@"phone_num"];
        
        
        BoutiqueWantedModel *wmModel = [[BoutiqueWantedModel alloc] init];
        
        wmModel.id = [rs intForColumn:ID];
        wmModel.view_count = [rs intForColumn:VIEW_COUNT];
        wmModel.update_id = [rs intForColumn:UPDATE_ID];
        wmModel.delete_id = [rs intForColumn:DELETE_ID];
        wmModel.update_time = [rs stringForColumn:UPDATE_TIME];
        wmModel.owner_id = [rs intForColumn:OWNER_ID];
        wmModel.isCollect = [rs intForColumn:ISCOLLECT];
        wmModel.created_time = [rs stringForColumn:CREATED_TIME];
        wmModel.ftModel = fac_model;
        wmModel.ctModel = ctModel;
        
        [mArray addObject:wmModel];
    }
    return mArray;
}

@end
