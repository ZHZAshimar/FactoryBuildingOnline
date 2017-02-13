//
//  RequestMessage.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "RequestMessage.h"
#import "WantedMessageModel.h"
#import "GeoCodeOfBaiduMap.h"

#import "ContacterModel.h"
#import "FactoryModel.h"
#import <FMDB.h>

@interface RequestMessage()

@end

@implementation RequestMessage
/**
 *  第一次加载界面
 *
 *  @param haveViewData 界面的data 是否有值
 */
- (void)firstGetDataState:(BOOL)haveViewData{
    /*
     *  获取数据库中最新的时间戳（值最大）,
     *  当 maxUdateTime 为 0时，数据库为空，since = 0；
     */
    NSString *maxUpdateTime = [WantedMessageModel findWithNewerData];
    
    NSString *since;
    if ([maxUpdateTime integerValue] == 0) {
        since = @"0";
    } else {
        since = maxUpdateTime;
    }
    
    NSInteger max = [[HTTPREQUEST_SINGLE getLocalTime] integerValue];
    
    NSDictionary *requestDic = @{@"since":since,@"max":@(max)};
    
    [HTTPREQUEST_SINGLE getRequestWithService:URL_GET_WANTEDMESSAGE andParameters:requestDic isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
        
        /*
         1.当数据库为空时，请求回来的数据，此时肯定有数据
         2.当数据库不为空时，请求回来的数据
             >能拿到最新数据
             >不能拿到最新数据
                 - 界面有数据，无需做
                 - 界面无数据，从数据库拿数据更新界面
         */
        NSArray *wmArr = response[@"wantedMessage"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        if (wmArr.count <= 0 && !haveViewData) {    // 界面无数据，服务器无更新数据，从数据库拿数据更新界面
            NSLog(@"界面无数据，从数据库拿数据更新界面");
            mArr = [WantedMessageModel findTenDataWithPage:1 addMore:0];
            // 将请求回来的数据 进行model处理 ，不插入SQL。
            
        } else if (wmArr.count <= 0 && haveViewData) {  // 界面有数据，服务器无更新数据，return
            
            return ;
            
        } else {
            
//            NSString *maxID = [WantedMessageModel findWithMaxID];
            
//            if ([wmArr[0][@"id"] intValue] <= [maxID intValue]) {
//                NSLog(@"界面无数据，从数据库拿数据更新界面");
//                mArr = [WantedMessageModel findTenDataWithPage:1 addMore:0];
//            } else {
            
                mArr = [RequestMessage dealWithDatabase:response andArray:wmArr andWriteSQL:YES];   // 将请求回来的数据 进行model处理并插入SQL
//            }
            mArr = (NSMutableArray *)[[mArr reverseObjectEnumerator] allObjects];   // 对数组进行数据
        }
        [self.delegate refreshView:mArr];   // 代理赋值
        
    } failure:^(RequestManager *manager, NSError *error) {
        if (!haveViewData) {
            NSLog(@"界面无数据，从数据库拿数据更新界面");
            NSMutableArray *mArr = [WantedMessageModel findTenDataWithPage:1 addMore:0];
            // 将请求回来的数据 返回，不插入SQL。
            [self.delegate refreshView:mArr];   // 代理赋值
        }
        
    }];
}

/**
 *  下拉加载更多
 */
- (void)requestNetWithPage:(int)page{

    /*
     *  获取数据库中最新的时间戳（值最大）,
     *  当 maxUdateTime 为 0时，数据库为空，since = 0；
     */
    NSString *maxUpdateTime = [WantedMessageModel findWithNewerData];
    
    NSString *since;
    if ([maxUpdateTime integerValue] == 0) {
        since = @"0";
    } else {
        since = maxUpdateTime;
    }
    
    NSInteger max = [[HTTPREQUEST_SINGLE getLocalTime] integerValue];
    
    NSDictionary *requestDic = @{@"since":since,@"max":@(max),@"page":@(page)};
    
    [HTTPREQUEST_SINGLE getRequestWithService:URL_GET_WANTEDMESSAGE andParameters:requestDic isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog(@"%@",response);
        
        NSMutableArray *wmArr = [NSMutableArray arrayWithArray:response[@"wantedMessage"]];
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        if (wmArr.count > 0) {
            
            NSString *maxID = [WantedMessageModel findWithMaxID];
            
            if (wmArr.count > 1) {
                [wmArr removeObject:wmArr[0]];
                
            } else {
                
                if ([wmArr[0][@"id"] intValue] == [maxID intValue]) {
                    return;
                }
            }
            
            
            mArr = [RequestMessage dealWithDatabase:response andArray:wmArr andWriteSQL:YES];   // 将请求回来的数据 进行model处理并插入SQL
            
//            mArr = (NSMutableArray *)[[mArr reverseObjectEnumerator] allObjects];   // 对数组进行数据
            
        }
        
        [self.delegate refreshView:mArr];   // 代理赋值

    } failure:^(RequestManager *manager, NSError *error) {
    
    }];
    
}

/**
 *  上拉加载更多  从数据库中获取除了界面显示的信息外的10条，
 *
 *  @param count 界面的data 的个数
 */
- (void)requestSQLTogetModeData:(int)count {
    
    NSMutableArray *mArray = [WantedMessageModel findTenDataWithPage:0 addMore:count];
    
    [self.delegate refreshView:mArray];   // 代理赋值
}
/**
 *  筛选请求数据
 *
 *  @param mDic 界面的data 的个数
 */
- (void)requestNetWithDic:(NSMutableDictionary *)mDic isShowActivity:(BOOL)showActivity{
    
    NSLog(@"筛选的字典-%@",mDic);
    [HTTPREQUEST_SINGLE getRequestWithService:URL_GET_WANTEDMESSAGE andParameters:mDic isShowActivity:showActivity success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"%@",response);
        
        if ([response[@"erro_code"] intValue] != 200) {
            NSLog(@"筛选请求失败 = %@",response[@"erro_msg"]);
        }
        NSArray *wmArr = response[@"wantedMessage"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        if (wmArr.count <= 0) {
            
            NSLog(@"暂无该类项目");
            
        } else {
            mArr = [RequestMessage dealWithDatabase:response andArray:wmArr andWriteSQL:NO];   // 将请求回来的数据 进行model处理并插入SQL
            
            mArr = (NSMutableArray *)[[mArr reverseObjectEnumerator] allObjects];   // 对数组进行数据
        }
        [self.delegate refreshView:mArr];   // 代理赋值
        
    } failure:^(RequestManager *manager, NSError *error) {
        
#pragma warming net work error
        
    }];
    
}
/**
 *  通过个人next url 获取数据
 *
 *  @param url 界面的data 的个数
 */
- (void)requestNestURL:(NSString *)url {
    
    [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:url andParameters:nil success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200) {
            NSLog(@"筛选请求失败 = %@",response[@"erro_msg"]);
        }
        NSArray *wmArr = response[@"wantedMessage"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        
        if (wmArr.count <= 0) {
            
            NSLog(@"暂无该类项目");
            
        } else {
            mArr = [RequestMessage dealWithDatabase:response andArray:wmArr andWriteSQL:NO];   // 将请求回来的数据 进行model处理并插入SQL
            
            mArr = (NSMutableArray *)[[mArr reverseObjectEnumerator] allObjects];   // 对数组进行数据
        }
        [self.delegate refreshView:mArr];   // 代理赋值
        
    } failure:^(RequestManager *manager, NSError *error) {
        
        
        
    }];
    
}

/**
 *  请求 业主 收藏接口 收藏 取消收藏，查看收藏状态
 *
 *  @param factoryID  厂房id
 *  @param type       请求方式  0：get 1:post 2:delete

 */
- (void) collectionRequestWithID:(int)factoryID andRequestType:(int)type {
    
    NSString *url = [NSString stringWithFormat:@"%@%d/collection/",URL_POST_PUBLISH,factoryID];
    
    [HTTPREQUEST_SINGLE requestWithServiceOfCollection:url andParameters:nil requestType:type isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"收藏接口的请求：%@",response[@"erro_msg"]);
        
        if (type == 0) {
            
            self.datablock(response);
        }
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"收藏接口的请求：%@",error);
    }];
}
/**
 *  获取发布人的基本信息
 *
 *  @param publisherID  发布人id
 */
- (void) getPublisherInfomation :(NSString *)publisherID {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_POST_REGISTER,publisherID];
    
    [HTTPREQUEST_SINGLE getRequestWithService:url andParameters:nil isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog( @"%@",response);
        
        self.datablock(response[@"userPublic"]);
        
    } failure:^(RequestManager *manager, NSError *error) {
        
    }];
    
}

/**
 *  获取历史记录  path My 页面
 *
 */
- (void)getHistoryData {
    
    [MBProgressHUD showAction:@"正在加载" ToView:nil];
    
    [HTTPREQUEST_SINGLE getUserInfo:URL_GET_HISTORY andParameters:nil success:^(RequestManager *manager, NSDictionary *response, NSString *time) {
        [MBProgressHUD hideHUD];
        
        NSLog(@"历史记录：%@",response);
        
        if ([response[@"erro_code"] intValue] != 200) {
            return ;
        }
        
        NSMutableArray *mArray = [RequestMessage dealWithDatabase:response andArray:response[@"wantedMessage"] andWriteSQL:NO];
        
        [self.delegate refreshView:mArray];   // 代理赋值
        
    } failure:^(RequestManager *manager, NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"历史记录：%@", error);
        // 当请求失败时，返回一个空的数组，以判断请求失败
        NSMutableArray *array = [NSMutableArray array];
        
        [self.delegate refreshView:array];
    }];
    
}


/**
 *  请求回来的数据进行处理
 *
 *  @param response     response
 *  @param wmArr        response中wantedMessage
 *  @param isWriteSQL   是否加入数据库
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *) dealWithDatabase:(NSDictionary*)response andArray:(NSArray *)wmArr andWriteSQL:(BOOL)isWriteSQL{
    
    
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
        
        
        NSDictionary *f_dic = @{@"id":@(f_id),@"title":f_title,@"thumbnail_url":f_thumbnail_url,@"price":f_price,@"range":f_range,@"rent_type":f_rent_type,@"pre_pay":f_pre_pay,@"description_factory":f_description,@"image_urls":f_image_urls_str,@"tags":f_tags_str,@"address_overview":f_address_overview,@"geohash":f_geohash};
        
        ContacterModel *contacterModel = [[ContacterModel alloc] initWithDictionary:contacter];
        
        FactoryModel *factoryModel = [[FactoryModel alloc] initWithDictionary:f_dic];
        
        NSDictionary *wantedDic = @{@"id":@(userid),@"view_count":@(view_count),@"update_id":@(update_id),
                                    @"delete_id":@(delete_id),@"update_time":update_time,
                                    @"ctModel":contacterModel,@"owner_id":@(owner_id),
                                    @"ftModel":factoryModel,@"isCollect":@(isCollect),
                                    @"created_time":created_time,@"nextURL":response[@"next"]};
        
        WantedMessageModel *wmModel = [[WantedMessageModel alloc] initWithDictionary:wantedDic];
        
        [viewArray addObject:wmModel];
        
        if (isWriteSQL) {
            
            [WantedMessageModel insertOfMoreTable:wmModel andContacterModel:contacterModel andeFactoryModel:factoryModel];  // 多表插入
        }
        
    }
    return viewArray;
}


@end
