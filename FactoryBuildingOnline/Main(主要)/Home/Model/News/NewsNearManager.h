//
//  NewsNearManager.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/23.
//  Copyright © 2017年 XFZY. All rights reserved.
//  附近的人

#import <Foundation/Foundation.h>

typedef void(^FACTORYDATABLOCK) (NSArray *response);
typedef void(^PEOPLEDATABLOCK) (NSArray *response);
typedef void(^DYNAMICDATABLOCK) (NSArray *response);
typedef void(^NETERRORBLOCK)(BOOL isError);
@interface NewsNearManager : NSObject

@property (nonatomic, copy) FACTORYDATABLOCK factoryBlock;  // 厂房
@property (nonatomic, copy) PEOPLEDATABLOCK peopleBlock;    // 人
@property (nonatomic, copy) DYNAMICDATABLOCK dynamicBlock;  // 动态
@property (nonatomic, copy) NETERRORBLOCK errorBlock;
/**
 *  附近厂房的请求
 *
 *  @param geohash geohash值
 *  @param type    0:厂房 1:人 2:动态
 */
- (void)getNearByFactoryWithGeohash:(NSString *)geohash withType:(NSString *)type;

/**
 *  附近人的请求
 *
 *  @param geohash geohash值
 */
- (void)getNearByPeopleWithGeohash:(NSString *)geohash;


/**
 *  附近动态的请求
 *
 *  @param geohash geohash值
 */
- (void)getNearByDynamicWithGeohash:(NSString *)geohash;
/**
 *  附近点赞
 *
 *  @param dynamicID 动态ID
 */
- (void)putNearbyLaudWithDynamicID:(int)dynamicID;
@end
