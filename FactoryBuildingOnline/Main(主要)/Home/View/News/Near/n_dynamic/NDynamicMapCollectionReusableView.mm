//
//  NDynamicMapCollectionReusableView.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/11.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "NDynamicMapCollectionReusableView.h"

@implementation NDynamicMapCollectionReusableView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NDynamicMapCollectionReusableView" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![arrayOfViews[0] isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        self = arrayOfViews[0];
        
        [self viewWillAppear];
        [self setLocationMap];
    }
    return self;
}
- (void)dealloc {
    self.mapView.delegate = nil;
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)viewWillAppear {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;   // 不需要使用时要释放
}

- (void)setLocationMap {
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    // 启动locationService
    [_locService startUserLocationService];
    
    //
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;  // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    self.mapView.mapType = BMKMapTypeStandard;
    /// 设定是否显示比例尺
    self.mapView.showMapScaleBar = NO;
    /// 比例尺的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
    //    self.mapView.mapScaleBarPosition = CGPointMake(8, Screen_Height-20);
    self.mapView.updateTargetScreenPtWhenMapPaddingChanged = YES;
    //打开实时路况图层
    //    [self.mapView setTrafficEnabled:YES];
    
    // 地图logo的位置
    self.mapView.logoPosition = BMKLogoPositionRightBottom;
    /// 设定定位模式，取值为：BMKUserTrackingMode
//    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    /// 设定是否显示定位图层
//    self.mapView.showsUserLocation = YES;

    self.mapView.zoomLevel = 18;
}

#pragma mark - BMKMapViewDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = pt;
    annotation.title = @"我在这";
    [_mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:pt animated:YES];
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];    ///反geo检索信息类
    reverseGeocodeSearchOption.reverseGeoPoint = pt;    ///经纬度
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    } else
    {
        NSLog(@"反geo检索发送失败");
        self.titleLabel.text = @"定位失败";
    }
    
    [_locService stopUserLocationService];
}
/**
 *返回反地理编码搜索结果
 */
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"定位结果：%u",error);
    
    NSString *street;
    
    if (error == 9) {
        self.titleLabel.text = @"哎呦，定位不到您的位置哦";
        
    } else {
        
        self.titleLabel.text = result.address; // 拿到当前城市

    }
    
}

/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
