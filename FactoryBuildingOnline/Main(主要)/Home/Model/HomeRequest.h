//
//  HomeRequest.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HomeRequestBlock)(NSMutableArray *mArr);  // 首页 优质厂房回调

typedef void(^PROMEDIUMS) (NSDictionary *response);       // 经纪人回调

typedef void (^BROKERPUBLISHBLOCK)(NSMutableArray *mArr);   // 经纪人发布的厂房数组回调

@interface HomeRequest : NSObject

@property (nonatomic, copy) HomeRequestBlock homeBlock;

@property (nonatomic, copy) PROMEDIUMS promediusBlock;

@property (nonatomic, copy) BROKERPUBLISHBLOCK publishBlock;

/**
 *  获取首页优质厂房
 */
- (void) getHomeInfomation;


// 请求next url
- (void)requestNextURL:(NSString *)url;


/**
 *  获取经纪人
 */
- (void)getPromeDiums;

/**
 *  获取经纪人 NEXT URL
 */
- (void)getNextPromediumsWithURL:(NSString *)url;

/**
 *  获取发布人发布的厂房
 *
 *  @param brokerDic   发布人ID 通过broken回调
 *
 */
- (void)getBrokerPublishSourceWithDic:(NSDictionary *)brokerDic;

/**
 *  请求回来的 wantedMessage 数据进行处理
 *
 *  @param responseArray  数组
 *  @param nextURLStr nexturl
 *  @return NSMutableArray
 */
+ (NSMutableArray *) dealWithHomeDatabase:(NSArray*)responseArray andNextURL:(NSString *)nextURLStr isWriteDB:(BOOL)isWriteDB;

/**
 *  请求回来的 proMediumMessage 数据进行处理
 *
 *  @param response  数组
 *  @param isWriteDB 是否写入数据库
 *  @return NSMutableArray
 */
+ (NSMutableArray *) dealWithBrokerDatabase:(NSDictionary*)response isWriteDB:(BOOL)isWriteDB;

@end
