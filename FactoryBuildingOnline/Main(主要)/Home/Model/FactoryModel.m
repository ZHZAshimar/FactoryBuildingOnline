//
//  FactoryModel.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "FactoryModel.h"
#import <FMDB.h>

#define TABLENAME @"Factory"

#define TAGS @"tags"
#define ID @"id"
#define THUMBNAIL_URL @"thumbnail_url"
#define TITLE @"title"
#define PRICE @"price"
#define RANGE @"range"
#define DESCRIPTION @"description_factory"
#define ADDRESS_OVERVIER @"address_overview"
#define PRE_PAY @"pre_pay"
#define IMAGE_URLS @"image_urls"
#define GEOHASH @"geohash"
#define RENT_TYPE @"rent_type"

@implementation FactoryModel

/**
 *  初始化
 *
 *  @param dictionary 字典
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
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dbPath = [path stringByAppendingPathComponent:@"FactoryDataCache.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if ([db open]) {
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",TABLENAME,ID,TAGS,THUMBNAIL_URL,TITLE,PRICE,DESCRIPTION,ADDRESS_OVERVIER,PRE_PAY,IMAGE_URLS,GEOHASH,RENT_TYPE,RANGE];
        
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
+ (BOOL)insertFactoryModel:(FactoryModel *)model {
    
    BOOL flag = NO;
    
    FMDatabase *db = [FactoryModel createDatabase];
    //
    if ([db open]) {
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into '%@' ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')values('%ld','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",TABLENAME,ID,TAGS,THUMBNAIL_URL,TITLE,PRICE,DESCRIPTION,ADDRESS_OVERVIER,PRE_PAY,IMAGE_URLS,GEOHASH,RENT_TYPE,RANGE, model.id,model.tags,model.thumbnail_url,model.title,model.price,model.description_factory,model.address_overview,model.pre_pay,model.image_urls,model.geohash,model.rent_type,model.range];
        if ([db executeUpdate:insertSQL]) {
            flag = YES;
        } else {
            flag = NO;
        }
        [db close];
        
    }
    return flag;
}

//+ (BOOL)


@end
