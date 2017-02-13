//
//  GeoCodeOfBaiduMap.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/19.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "GeoCodeOfBaiduMap.h"
#import "geohash.h"

@interface GeoCodeOfBaiduMap()
{
    BMKGeoCodeSearch* _geocodesearch;
}
@end

@implementation GeoCodeOfBaiduMap


/**
 *  将经纬度转成 geohash
 *
 *  @param lat 纬度
 *  @param lon 经度
 *  @param length 长度
 *
 *  @return NSString 返回geohash
 */
+ (NSString *)getGeohash:(CGFloat)lat andLon:(CGFloat)lon andLength:(int)length{
    
    char *hash = GEOHASH_encode(lat,lon,length);    // 通过 geohash.h C文件 获取 geohash 值
    
    NSString *string = [NSString stringWithFormat:@"%s",hash];  // 将char 转成 string
    
    return string;
}

/**
 *  将 geohash 转成 经纬度
 *
 *  @param area 纬度
 *
 *  @return NSArray [lat,lon]
 */
+ (NSArray *)getArea:(NSString *)area{
    char myArea[100];
    strcpy(myArea,(char *)[area UTF8String]);
    
    GEOHASH_area *hash = (GEOHASH_decode(myArea));    // 通过 geohash.h C文件 获取 geohash 值

    float lat = hash->latitude.min;
    float lon = hash->longitude.min;
    
    NSArray *areaArray = @[@(lat),@(lon)];
    
    return areaArray;
}

/**
 *  初始化 传入城市和街道
 *
 *  @param city 城市
 *  @param address 街道
 *
 */
- (id)initWithGeoCode:(NSString *)city andAddress:(NSString *)address {
    
    if (self = [super init]) {
        
        _geocodesearch.delegate = self;
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        
        //    geo检索信息类
        BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geocodeSearchOption.city= city;
        geocodeSearchOption.address = address;
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        
        BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
        if(flag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
            NSLog(@"geo检索发送失败");
        }
    }
    
    return self;

}

// 正向地理编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSString*string = [GeoCodeOfBaiduMap getGeohash:result.location.latitude andLon:result.location.longitude andLength:12];
    
    self.geocodeBlock(string);
}

- (void)dealloc {
    _geocodesearch.delegate = nil;
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}

/* 通过经纬度，获取百度地图 静态图片 */
- (void)getBaiduStaticimageWithArray:(NSArray *)array {
    
    NSString *center = [NSString stringWithFormat:@"%@,%@",array[1],array[0]];
    
    NSDictionary *params = @{@"center":center,@"zoom":@(18),@"markers":center,@"markerStyles":@"m,,0xff0000"};
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage"];
    [HTTPREQUEST_SINGLE getRequestWithURL:url andParameters:params success:^(RequestManager *manager, id responseObject) {
        NSLog(@"获取百度静态图片请求成功");    // 拿到的是图片的data ,直接赋值给image即可
        UIImage *image = [[UIImage alloc] initWithData:responseObject];
        
        self.imageBlock(image);
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"获取百度静态图片失败：%@",error);
    }];
    
}

/* 通过文字位置，获取百度地图 静态图片 */
- (void)getBaiduStaticimageWithAddress:(NSString *)address {
    NSDictionary *param = @{@"center":address,@"zoom":@(18),@"markers":address,@"markerStyles":@"m,,0xff0000"};
    
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage"];
    [HTTPREQUEST_SINGLE getRequestWithURL:url andParameters:param success:^(RequestManager *manager, id responseObject) {
        NSLog(@"获取百度静态图片请求成功");    // 拿到的是图片的data ,直接赋值给image即可
        UIImage *image = [[UIImage alloc] initWithData:responseObject];
        self.imageBlock(image);
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"获取百度静态图片失败：%@",error);
    }];
    
}

@end
