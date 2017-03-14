//
//  MapViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface MapViewController : BaseViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService* _locService;
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@end
