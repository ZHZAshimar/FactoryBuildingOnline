//
//  HomeRequest.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "HomeRequest.h"
#import "HomeWantedModel.h"
#import <FMDB.h>
#import "GeoCodeOfBaiduMap.h"
#import "BrokerFactoryInfoModel.h"

@implementation HomeRequest

/**
 *  获取首页优质厂房
 */
- (void) getHomeInfomation{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_POST_PUBLISH,@"home"];
    
    [HTTPREQUEST_SINGLE getRequestWithService:url andParameters:nil isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200) {
            NSLog(@"筛选请求失败 = %@",response[@"erro_msg"]);
        }
        NSArray *wmArr = response[@"wantedMessage"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        if (wmArr.count <= 0) {
            
            NSLog(@"暂无该类项目");
            
        } else {
            mArr = [HomeRequest dealWithHomeDatabase:wmArr andNextURL:response[@"next"] isWriteDB:YES];   // 将请求回来的数据 进行model处理并插入SQL
            for (HomeWantedModel *model in mArr) {
                [HomeWantedModel insertWantedMessageModel:model];
            }
            mArr = (NSMutableArray *)[[mArr reverseObjectEnumerator] allObjects];   // 对数组进行数据
        }
        self.homeBlock(mArr);
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"界面无数据，从数据库拿数据更新界面");
        NSMutableArray *mArr = [HomeWantedModel findTenDataWithPage:1 addMore:0];
        // 将请求回来的数据 返回，不插入SQL。
        self.homeBlock(mArr);   // 代理赋值
    }];
    
}

// 请求next url
- (void)requestNextURL:(NSString *)url {
    
    [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:url andParameters:nil success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200) {
            NSLog(@"筛选请求失败 = %@",response[@"erro_msg"]);
        }
        NSArray *wmArr = response[@"wantedMessage"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        if (wmArr.count <= 0) {
            
            NSLog(@"暂无该类项目");
            
        } else {
            mArr = [HomeRequest dealWithHomeDatabase:wmArr andNextURL:response[@"next"] isWriteDB:YES];   // 将请求回来的数据 进行model处理并插入SQL
            
            mArr = (NSMutableArray *)[[mArr reverseObjectEnumerator] allObjects];   // 对数组进行数据
        }
        self.homeBlock(mArr);   // block 回调
    } failure:^(RequestManager *manager, NSError *error) {
        
    }];
    
}

/**
 *  获取 首页 经纪人
 */
- (void)getPromeDiums{
    
    [HTTPREQUEST_SINGLE getRequestWithService:URL_GET_PROMEDIUMS andParameters:nil isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200){
            return ;
        }
        
        self.promediusBlock(response);
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"获取经纪人ERROR：%@",error);
    }];
    
}

/**
 *  获取经纪人 NEXT URL
 */
- (void)getNextPromediumsWithURL:(NSString *)url {
    
    [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:url andParameters:nil success:^(RequestManager *manager, NSDictionary *response) {
        if ([response[@"erro_code"] intValue] != 200){
            return ;
        }
        self.promediusBlock(response);
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"获取经纪人NEXTURL ERROR：%@",error);
    }];
}
/**
 *  获取发布人发布的厂房
 *
 *  @param brokerDic   发布人ID 通过broken回调
 *
 */
- (void)getBrokerPublishSourceWithDic:(NSDictionary *)brokerDic {
    
    NSString *url = [NSString stringWithFormat:@"%@messages/%@",URL_GET_PROMEDIUMS,brokerDic[@"id"]];
    
    [HTTPREQUEST_SINGLE getRequestWithService:url andParameters:nil isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200){
            return ;
        }
        
        NSArray *pmArr = response[@"proMediumMessage"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        if (pmArr.count <= 0) {
            
            NSLog(@"暂无该类项目");
            
        } else {
            mArr = [HomeRequest dealWithBrokerDatabase:response isWriteDB:NO];   // 将请求回来的数据 进行model处理并插入SQL
            
            mArr = (NSMutableArray *)[[mArr reverseObjectEnumerator] allObjects];   // 对数组进行数据
        }
        self.publishBlock(mArr);   // block 回调
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"获取发布人厂房：%@",error);
        [MBProgressHUD showError:@"网络出了小差💔，请稍后再试！" ToView:nil];
    }];
    
}

/**
 *  请求回来的 wantedMessage 数据进行处理
 *
 *  @param responseArray  数组
 *  @param nextURLStr nexturl
 *  @return NSMutableArray
 */
+ (NSMutableArray *) dealWithHomeDatabase:(NSArray*)responseArray andNextURL:(NSString *)nextURLStr isWriteDB:(BOOL)isWriteDB{
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
        
        HomeContacterModel *contacterModel = [[HomeContacterModel alloc] initWithDictionary:contacter];
        
        HomeFactoryModel *factoryModel = [[HomeFactoryModel alloc] initWithDictionary:f_dic];
        
        NSDictionary *wantedDic = @{@"id":@(userid),@"view_count": @(view_count),@"update_id":@(update_id),
                                    @"delete_id":@(delete_id),@"update_time":update_time,
                                    @"ctModel":contacterModel,@"owner_id":@(owner_id),
                                    @"ftModel":factoryModel,@"isCollect":@(isCollect),
                                    @"created_time":created_time,@"nextURL":nextURLStr};
        
        HomeWantedModel *wmModel = [[HomeWantedModel alloc] initWithDictionary:wantedDic];
        
        [viewArray addObject:wmModel];
        
        
        if (isWriteDB) {
            
            [HomeWantedModel insertOfMoreTable:wmModel andContacterModel:contacterModel andeFactoryModel:factoryModel];  // 多表插入
        }
 
        
    }
    return viewArray;
}

/**
 *  请求回来的 proMediumMessage 数据进行处理
 *
 *  @param response  数组
 *  @return NSMutableArray
 */
+ (NSMutableArray *) dealWithBrokerDatabase:(NSDictionary*)response isWriteDB:(BOOL)isWriteDB{
    
    NSArray *brokerArr = response[@"proMediumMessage"];
    
    NSMutableArray *viewArray = [NSMutableArray array];
    
    for (NSDictionary *wmDic in brokerArr) {
        
        NSDictionary *factory = wmDic[@"proMediumFactory"];
        
        NSInteger f_id = [factory[@"id"] integerValue];
        
        NSString *f_thumbnail_url = factory[@"thumbnail_url"];
        
        if (f_thumbnail_url.length < 1) {
            f_thumbnail_url = @" ";
        }
        
        NSString *f_title = factory[@"title"];
        
        NSString *f_price = factory[@"price"];
        NSString *f_range = factory[@"range"];
        
        
        NSString *f_area = factory[@"area"];
        NSString *f_address = factory[@"address"];
        
        NSString *f_description = factory[@"description"];
        
        NSArray *f_image_urls = factory[@"image_urls"];
        NSString *f_image_urls_str = [NSString arrayToJson:f_image_urls];
        
        NSString *f_rent_type = factory[@"rent_type"];
        
        NSString *f_pre_pay = factory[@"pre_pay"];
        
//        NSArray *f_tags = factory[@"tags"];
//        NSString *f_tags_str = [NSString arrayToJson:f_tags];
        //-------------------
//        NSInteger update_id = [wmDic[@"update_id"] integerValue];
//        NSInteger delete_id = [wmDic[@"delete_id"] integerValue];
//        NSString * update_time = wmDic[@"update_time"];
        
        NSInteger owner_id = [wmDic[@"owner_id"] integerValue];
        NSInteger collected_count = [wmDic[@"collected_count"] integerValue];
        NSString *created_time = wmDic[@"created_time"];
        
        // 厂房信息
        NSDictionary *f_dic = @{@"id":@(f_id),@"title":f_title,@"thumbnail_url":f_thumbnail_url,@"price":f_price,@"range":f_range,@"rent_type":f_rent_type,@"pre_pay":f_pre_pay,@"description_pro":f_description,@"image_urls":f_image_urls_str,@"address":f_address,@"area":f_area};
        
        ProMediumFactoryModel *factoryModel = [[ProMediumFactoryModel alloc] initWithDictionary:f_dic];
        
        NSDictionary *wantedDic = @{@"next":response[@"next"],@"collected_count":@(collected_count),@"factoryModel":factoryModel, @"owner_id":@(owner_id),@"created_time":created_time};
        
        BrokerFactoryInfoModel *brokerModel = [[BrokerFactoryInfoModel alloc] initWithDictionary:wantedDic];
        
        [viewArray addObject:brokerModel];
        
        
        if (isWriteDB) {
            
//            [HomeWantedModel insertOfMoreTable:wmModel andContacterModel:contacterModel andeFactoryModel:factoryModel];  // 多表插入
        }
        
        
    }
    return viewArray;
}


@end
