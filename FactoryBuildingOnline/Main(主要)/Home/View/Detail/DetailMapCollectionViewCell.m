//
//  DetailMapCollectionViewCell.m
//  FactoryBuildingOnline
//
//  Created by ZHZ on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "DetailMapCollectionViewCell.h"

@interface DetailMapCollectionViewCell ()
@end

@implementation DetailMapCollectionViewCell

//- (void)dealloc {
//    self.mapView.delegate = nil;
//    self.mapView = nil;
//    _locService.delegate = nil;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"DetailMapCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1) {
            return nil;
        }
        
        if (![arrayOfView[0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = arrayOfView[0];
        
        self.addressLabel.font = [UIFont adjustFont:[UIFont systemFontOfSize:self.addressLabel.font.pointSize]];
        
//        self.mapView.layer.borderWidth = 1;
//        self.mapView.layer.borderColor = GRAY_db.CGColor;
//        self.mapView.delegate = self;
//        
//        _locService = [[BMKLocationService alloc] init];
//        _locService.delegate = self;
//        //启动LocationService
//        [_locService startUserLocationService];
    }
    
    return self;
}

- (void)setLocationDic:(NSDictionary *)locationDic {
    
    _locationDic = locationDic;
    
    self.addressLabel.text = locationDic[@"adress"];
    
//    // 添加一个 PointAnnotation
//    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = [locationDic[@"location"][0] floatValue];
//    coor.longitude = [locationDic[@"location"][1] floatValue];
//    annotation.coordinate = coor;
//    [_mapView addAnnotation:annotation];
//    self.mapView.gesturesEnabled = NO;
//    self.mapView.zoomLevel = 18;
//    [self.mapView setCenterCoordinate:coor animated:YES];
}

////实现相关delegate 处理位置信息更新
////处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"heading is %@",userLocation.heading);
////    userLocation.location.coordinate.latitude = @2323;
//    
//    [_mapView updateLocationData:userLocation];
//    
//}
//
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
//        
//        return newAnnotationView;
//    }
//    return nil;
//}
//

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
