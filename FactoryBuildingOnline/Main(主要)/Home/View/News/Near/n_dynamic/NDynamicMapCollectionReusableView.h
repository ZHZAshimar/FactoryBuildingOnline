//
//  NDynamicMapCollectionReusableView.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface NDynamicMapCollectionReusableView : UICollectionReusableView<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch *_geocodesearch;   // 地理编码功能
}

@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end
