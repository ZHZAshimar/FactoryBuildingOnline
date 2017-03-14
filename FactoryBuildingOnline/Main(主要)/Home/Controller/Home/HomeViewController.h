//
//  HomeViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef void(^ADDRESSBLOCK) (NSString *address);

@interface HomeViewController : BaseViewController<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;    // 百度定位
    BMKGeoCodeSearch *_geocodesearch;   // 地理编码功能
}
@property (nonatomic,strong) NSString *cityNameStr;
@property (nonatomic, strong) ADDRESSBLOCK address;
@end
