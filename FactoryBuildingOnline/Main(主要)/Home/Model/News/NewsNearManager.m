//
//  NewsNearManager.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/23.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NewsNearManager.h"

@implementation NewsNearManager

/**
 *  附近厂房的请求
 *
 *  @param geohash geohash值
 *  @param type    0:厂房 1:动态 2:  人
 */
- (void)getNearByFactoryWithGeohash:(NSString *)geohash withType:(NSString *)type
{
    NSString *urlStr = [NSString stringWithFormat:@"%@apps/nearby/",URL_HOST_LOCATION];
    [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:urlStr andParameters:@{@"type":@(0),@"geohash":geohash} andShouldToken:NO success:^(RequestManager *manager, NSDictionary *response) {
        [MBProgressHUD hideHUD];
        NSLog(@"附近厂房请求 成功resonse%@",response);
        if ([response[@"erro_code"] intValue]!= 200) {
            NSLog(@"附近厂房：%@",response[@"erro_msg"]);
        }
        NSArray *array = response[@"nearby_info"];
        
        self.factoryBlock(array);
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"附近厂房请求失败：%@",error);
        self.errorBlock(YES);
    }];
    
}
/*
"nearby_info" =     (
                     {
                         "AVATAR_URL" = "http://img.oncom.cn/\U5934\U50cf11";
                         "LAST_LOGIN" = "98\U59296\U5c0f\U65f640\U5206";
                         RANGE = "11079.202";
                         TAG = "\U4e16\U754c\U4e4b\U90fdA";
                         USERNAME = a1;
                         "USER_TYPE" = 0;
                     },
                     {
                         "AVATAR_URL" = "http://img.oncom.cn/\U5934\U50cf14";
                         "LAST_LOGIN" = "96\U59296\U5c0f\U65f644\U5206";
                         RANGE = "11079.252";
                         TAG = "\U6c38\U5229\U8fbe";
                         USERNAME = a4;
                         "USER_TYPE" = 1;
                     }
                     );
*/

/**
 *  附近人的请求
 *
 *  @param geohash geohash值
 */
- (void)getNearByPeopleWithGeohash:(NSString *)geohash
{
    NSString *urlStr = [NSString stringWithFormat:@"%@apps/nearby/",URL_HOST_LOCATION];
    
    [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:urlStr andParameters:@{@"type":@(2),@"geohash":geohash} andShouldToken:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog(@"附近人请求 成功resonse%@",response);
        
        if ([response[@"erro_code"] intValue]!= 200) {
            NSLog(@"附近人请求：%@",response[@"erro_msg"]);
        }
        NSArray *array = response[@"nearby_info"];
        
        self.peopleBlock(array);

        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"附近人请求失败：%@",error);
        self.errorBlock(YES);
    }];
    
}

/**
 *  附近动态的请求
 *
 *  @param geohash geohash值
 */
- (void)getNearByDynamicWithGeohash:(NSString *)geohash
{
    NSString *urlStr = [NSString stringWithFormat:@"%@apps/nearby/",URL_HOST_LOCATION];
    
    [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:urlStr andParameters:@{@"type":@(1),@"geohash":geohash} andShouldToken:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog(@"附近动态请求 成功resonse%@",response);
        
        
        if ([response[@"erro_code"] intValue]!= 200) {
            NSLog(@"附近动态：%@",response[@"erro_msg"]);
        }
        NSArray *array = response[@"nearby_info"];
        self.dynamicBlock(array);

    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"附近动态请求失败：%@",error);
        self.errorBlock(YES);
    }];
    
}
/**
 *  附近点赞
 *
 *  @param dynamicID 动态ID
 */
- (void)putNearbyLaudWithDynamicID:(int)dynamicID {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@apps/nearby/laud/",URL_HOST_LOCATION];
    
    [HTTPREQUEST_SINGLE putDataToServiceWithURL:urlStr withParams:@{@"dynamic_id":@(dynamicID)} andisToken:YES andisActivity:NO andisEncry:NO success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"%@",response);
        
        NSInteger errorCode = [response[@"erro_code"] integerValue];
        
        if (errorCode != 200) {
            
            [MBProgressHUD showError:response[@"erro_msg"] ToView:nil];
            
        } else {
            
            [MBProgressHUD showSuccess:@"点赞成功！" ToView:nil];
            
        }
        
    } failure:^(RequestManager *manager, NSError *error) {
        
        NSLog(@"%@",error.description);
        self.errorBlock(YES);
    }];
}


@end
