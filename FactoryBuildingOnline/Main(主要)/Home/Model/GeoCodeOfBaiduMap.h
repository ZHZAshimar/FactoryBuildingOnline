//
//  GeoCodeOfBaiduMap.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/19.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef void(^GEOCODEBLOCK) (NSString *geoStr);
typedef void (^BaiduMapStaticImageBlock)(UIImage *image);
@interface GeoCodeOfBaiduMap : NSObject<BMKGeoCodeSearchDelegate>

@property (nonatomic, copy) GEOCODEBLOCK geocodeBlock;
@property (nonatomic, copy) BaiduMapStaticImageBlock imageBlock;
/**
 *  初始化 传入城市和街道
 *
 *  @param city 城市
 *  @param address 街道
 *
 */
- (id)initWithGeoCode:(NSString *)city andAddress:(NSString *)address;

/**
 *  将经纬度转成 geohash
 *
 *  @param lat 纬度
 *  @param lon 经度
 *  @param length 长度
 *
 *  @return NSString 返回geohash
 */
+ (NSString *)getGeohash:(CGFloat)lat andLon:(CGFloat)lon andLength:(int)length;

/**
 *  将 geohash 转成 经纬度
 *
 *  @param area 纬度
 *
 *  @return NSArray [lat,lon]
 */
+ (NSArray *)getArea:(NSString *)area;

/* 获取百度地图 静态图片 */
- (void)getBaiduStaticimageWithArray:(NSArray *)array;


/* 通过文字位置，获取百度地图 静态图片 */
- (void)getBaiduStaticimageWithAddress:(NSString *)adress;

@end
