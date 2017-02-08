//
//  BoutiqueRequest.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/7.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "BoutiqueRequest.h"

#import "BoutiqueWantedModel.h"
#import "BoutiqueFactoryModel.h"
#import "BoutiqueContacterModel.h"
#import "GeoCodeOfBaiduMap.h"

@implementation BoutiqueRequest
/// 获取精品厂房
- (void)getBoutiqueFactoryData {
    
    [HTTPREQUEST_SINGLE getRequestWithService:URL_GET_BOUTIQUE andParameters:nil isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        if ([response[@"erro_code"] intValue] != 200) {
            
            return ;
        }
        NSMutableArray *mArray = [BoutiqueRequest dealWithHomeDatabase:response[@"wantedMessage"] isWriteDB:YES];
        self.dataBlock(mArray);
        
    } failure:^(RequestManager *manager, NSError *error) {
        
        NSMutableArray *mArray = [BoutiqueWantedModel findAll];
        self.dataBlock(mArray);
    }];
    
}

/**
 *  请求回来的 wantedMessage 数据进行处理
 *
 *  @param responseArray  数组
 *  @return NSMutableArray
 */
+ (NSMutableArray *) dealWithHomeDatabase:(NSArray*)responseArray isWriteDB:(BOOL)isWriteDB{
    NSArray *wmArr = responseArray;
    
    NSMutableArray *viewArray = [NSMutableArray array];
    
    for (NSDictionary *wmDic in wmArr) {
        
        NSDictionary *contacter = wmDic[@"contacter"];
        
        NSDictionary *factory = wmDic[@"factory"];
        
        NSInteger f_id = [factory[@"id"] integerValue];
        NSString *f_title = factory[@"title"];
        NSString *f_thumbnail_url = factory[@"thumbnail_url"];
        if (f_thumbnail_url.length < 1) {
            f_thumbnail_url = @" ";
        }
        NSString *f_price = factory[@"price"];
        NSString *f_range = factory[@"range"];
        NSString *f_rent_type = factory[@"rent_type"];
        NSString *f_pre_pay = factory[@"pre_pay"];
        NSString *f_description = factory[@"description"];
        NSArray *f_image_urls = factory[@"image_urls"];
        NSArray *f_tags = factory[@"tags"];
        NSString *f_address_overview = factory[@"address_overview"];
        
        
        NSArray *areaArray = [GeoCodeOfBaiduMap getArea:factory[@"geohash"]];
        NSLog(@"反 geohash----%@",areaArray);
        NSString *f_geohash = [NSString arrayToJson:areaArray];
        
        NSString *f_image_urls_str = [NSString arrayToJson:f_image_urls];
        NSString *f_tags_str = [NSString arrayToJson:f_tags];
        
        NSInteger userid = [wmDic[@"id"] integerValue];
        NSInteger view_count = [wmDic[@"view_count"] integerValue];
        NSInteger update_id = [wmDic[@"update_id"] integerValue];
        NSInteger delete_id = [wmDic[@"delete_id"] integerValue];
        NSString * update_time = wmDic[@"update_time"];
        
        NSInteger owner_id = [wmDic[@"owner_id"] integerValue];
        BOOL isCollect = [wmDic[@"isCollect"] integerValue];
        NSString *created_time = wmDic[@"created_time"];
        
        
        NSDictionary *f_dic = @{@"id":@(f_id), @"title":f_title,@"thumbnail_url":f_thumbnail_url,@"price":f_price,@"range":f_range,@"rent_type":f_rent_type,@"pre_pay":f_pre_pay,@"description_factory":f_description,@"image_urls":f_image_urls_str,@"tags":f_tags_str,@"address_overview":f_address_overview,@"geohash":f_geohash};
        
        BoutiqueContacterModel *contacterModel = [[BoutiqueContacterModel alloc] initWithDictionary:contacter];
        
        BoutiqueFactoryModel *factoryModel = [[BoutiqueFactoryModel alloc] initWithDictionary:f_dic];
        
        NSDictionary *wantedDic = @{@"id":@(userid),@"view_count": @(view_count),@"update_id":@(update_id),
                                    @"delete_id":@(delete_id),@"update_time":update_time,
                                    @"ctModel":contacterModel,@"owner_id":@(owner_id),
                                    @"ftModel":factoryModel,@"isCollect":@(isCollect),
                                    @"created_time":created_time};
        
        BoutiqueWantedModel *wmModel = [[BoutiqueWantedModel alloc] initWithDictionary:wantedDic];
        
        [viewArray addObject:wmModel];
        
        
        if (isWriteDB) {
            
            [BoutiqueWantedModel insertOfMoreTable:wmModel andContacterModel:contacterModel andeFactoryModel:factoryModel];  // 多表插入
        }
        
        
    }
    return viewArray;
}



@end
