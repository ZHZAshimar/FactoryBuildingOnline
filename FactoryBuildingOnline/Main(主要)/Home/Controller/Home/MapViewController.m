//
//  MapViewController.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "MapViewController.h"
#import "BMKClusterManager.h"
//#import "FactoryPoiModel.h"
#import "MapStatisticalPoiModel.h"
#import "MapCollectionView.h"
#import "NSString+Judge.h"
#import "ClusterAnnotation.h"
#import "RequestManager.h"
#import "GeoCodeOfBaiduMap.h"
#import "RequestMessage.h"
#import "FactoryDetailViewController.h"

@interface MapViewController ()<RequestMessageDelegate>
{
    BOOL isTap;
    BMKClusterManager *clusterManager;//点聚合管理类
    NSInteger clusterZoom;//聚合级别
    NSMutableArray *clusterCaches;//点聚合缓存标注
    //    FactoryPoiModel *factoryPoiModel;
    NSMutableArray *mArrayofModel;
    
    MapCollectionView *mapCollectionView;   // 显示房源信息的 view
    int allNum;
    RequestMessage *request;
}
@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self.rdv_tabBarController setTabBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    request.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setVCName:@"地图找房" andShowSearchBar:NO andTintColor:BLACK_42 andBackBtnStr:nil];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    mArrayofModel = [NSMutableArray array];
    isTap = NO;
    allNum = 0;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more2"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    [self setBaiduMapView];
    
    mapCollectionView = [[MapCollectionView alloc] initWithFrame:CGRectMake(0, Screen_Height/2-44, Screen_Width, Screen_Height/2+44)];
    mapCollectionView.hidden = YES;
    [mapCollectionView.packUpBtn addTarget:self action:@selector(hiddenMapCollectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapCollectionView];
    
    __weak typeof (self) weakSelf = self;
    
    mapCollectionView.tapBlock = ^(NSIndexPath *indexPath,WantedMessageModel*model) {
        
        FactoryDetailViewController *detailVC = [FactoryDetailViewController new];
        
        detailVC.model = model;
        
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
}

- (void)setBaiduMapView {
    /*
     enum {
     BMKMapTypeNone       = 0,               ///< 空白地图
     BMKMapTypeStandard   = 1,               ///< 标准地图
     BMKMapTypeSatellite  = 2,               ///< 卫星地图
     };
     */
    self.mapView.mapType = BMKMapTypeStandard;
    /// 设定是否显式比例尺
    self.mapView.showMapScaleBar = YES;
    /// 比例尺的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
//    self.mapView.mapScaleBarPosition = CGPointMake(8, Screen_Height-20);
    self.mapView.updateTargetScreenPtWhenMapPaddingChanged = YES;
    //打开实时路况图层
//    [self.mapView setTrafficEnabled:YES];
    
    // 地图logo的位置
    self.mapView.logoPosition = BMKLogoPositionLeftBottom;
    /// 设定定位模式，取值为：BMKUserTrackingMode
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    /// 设定是否显示定位图层
    self.mapView.showsUserLocation = YES;
    
    clusterCaches = [[NSMutableArray alloc] init];
    for (NSInteger i = 3; i < 22; i++) {
        [clusterCaches addObject:[NSMutableArray array]];
    }
    [self data];
    
}
- (void)hiddenMapCollectionAction: (UIButton *)sender {
    mapCollectionView.hidden = YES;
    self.viewHeight.constant = 0.0;
}

// tap barButton
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    
    isTap = !isTap;
    if (isTap) {
        [sender setImage:[UIImage imageNamed:@"more1"]];
    } else {
        [sender setImage:[UIImage imageNamed:@"more2"]];
    }
    
}

//更新聚合状态
- (void)updateClusters {
    clusterZoom = (NSInteger)_mapView.zoomLevel;
    NSLog(@"clusterZoom = %d",clusterZoom);
    @synchronized(clusterCaches) {
        __block NSMutableArray *clusters = [clusterCaches objectAtIndex:(clusterZoom - 3)];
        
        if (clusters.count > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView addAnnotations:clusters];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                /// 获取聚合后的标注
                __block NSArray *array = [clusterManager getClustersOfID:clusterZoom];
//                __block NSArray *array = [clusterManager getClusters:clusterZoom];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (BMKCluster *item in array) {
                        
                        ClusterAnnotation *annotation = [[ClusterAnnotation alloc] init];
                        
                        annotation.coordinate = item.coordinate;
                        annotation.area_id = item.clusterMapPoiModel.area_id;
                        
                        annotation.showPaoPao = NO;
                            if (clusterZoom >= 1 && clusterZoom < 13) {
//                                annotation.areaStr = @"广东省";
//                                annotation.size = allNum;
//                            } else if (clusterZoom >= 7 && clusterZoom < 11) {
//                                annotation.areaStr = @"东莞市";
//                                annotation.size = allNum;
//                            } else if (clusterZoom >= 11 && clusterZoom < 15) {
                                annotation.areaStr = item.clusterMapPoiModel.area_description;
                                annotation.size = item.clusterMapPoiModel.count;
//                                annotation.showPaoPao = YES;
                            } else if (clusterZoom >= 13 /*&& clusterZoom < 15*/) {
                                annotation.areaStr = item.clusterMapPoiModel.area_description;
                                annotation.showPaoPao = YES;
                                annotation.size = item.clusterMapPoiModel.count;
//                            } else {
//                                annotation.areaStr = item.clusterFactoryPoiModel.address;
//                                annotation.showPaoPao = YES;
//                                 annotation.title = [NSString stringWithFormat:@"我是%@",item.clusterFactoryPoiModel.address];
                                annotation.title = [NSString stringWithFormat:@"这里有%ld套房哦😙",item.clusterMapPoiModel.count];
                            }
//                            NSLog(@"%@",annotation.areaStr);
                       
                       
                        [clusters addObject:annotation];
                    }
                    [_mapView removeAnnotations:_mapView.annotations];
                    [_mapView addAnnotations:clusters];
                });
            });
        }
    }
}

#pragma mark - BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"ClusterMark";
    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;
    ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    annotationView.size = cluster.size;
    annotationView.areaStr = cluster.areaStr;
    annotationView.draggable = YES;
    annotationView.annotation = cluster;
//    annotationView.alpha = 0.0;
    //    annotationView.animatesDrop = YES; // 设置该标注点动画显示
    if (mapView.zoomLevel >= 13) {
        annotationView.showPaoPao = YES;
    } else {
        annotationView.showPaoPao = NO;
    }
    
    return annotationView;
    
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    view.alpha = 0;
    if ([view isKindOfClass:[ClusterAnnotationView class]]) {
        ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
        if (clusterAnnotation.size > 1) {
            [mapView setCenterCoordinate:view.annotation.coordinate];
            [mapView zoomIn];
        }
    }
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"点击标注响应的方法");
    
    mapCollectionView.hidden = NO;  // 显示房源View
    
    ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
    
    [mapView setCenterCoordinate:clusterAnnotation.coordinate animated:YES];    // 将点击的标注作为地图的中心店
    
    mapCollectionView.areaStr = clusterAnnotation.areaStr;      // 显示view的名称
    
    mapCollectionView.num = clusterAnnotation.size; // 显示View 的数量
    
    self.viewHeight.constant = Screen_Height/2-44;
    
    request = [RequestMessage new];
    
    request.delegate = self;
    
    NSDictionary *dic = @{@"filtertype":[NSString arrayToJson:@[@1]],@"area_id":@(clusterAnnotation.area_id)};
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    mapCollectionView.activity.hidden = NO;
    [mapCollectionView.activity startAnimating];
    [request requestNetWithDic:mdic isShowActivity:NO];
    
}

- (void)refreshView:(NSMutableArray *)mArray {
    
    [mapCollectionView.activity stopAnimating];
    
    mapCollectionView.activity.hidden = YES;
    
    mapCollectionView.mDataSource = mArray;
    
}

/**3
 *地图初始化完毕时会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self updateClusters];
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapView 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (clusterZoom != 0 && clusterZoom != (NSInteger)mapView.zoomLevel) {
        [self updateClusters];
    }
}

//IOS 地图定位使用方向时取消指南针校准
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

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

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
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


- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)data {
    
    [HTTPREQUEST_SINGLE getRequestWithService:[NSString stringWithFormat:@"%@%d",URL_GET_Factorypois,305] andParameters:nil isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
//        NSLog(@"response = %@",response);
        
        NSArray *array = response[@"mapStatisticalPoi"];
        
        
        // 初始化点聚合管理类
        clusterManager = [[BMKClusterManager alloc] init];
        for (int i = 0; i < array.count; i++) {
            
            NSDictionary *dic = @{@"area_id":array[i][@"area_id"],@"count":array[i][@"count"],@"geohash":array[i][@"geohash"],@"area_description":array[i][@"description"]};
            
            MapStatisticalPoiModel* factoryPoiModel = [[MapStatisticalPoiModel alloc] initWithDictionary:dic error:nil];
            
            BMKClusterItem *clusterItem = [[BMKClusterItem alloc] init];
            clusterItem.mapPoiModel = factoryPoiModel;
            
            NSArray *locationArr = [GeoCodeOfBaiduMap getArea:factoryPoiModel.geohash];
            
            clusterItem.coor = CLLocationCoordinate2DMake([locationArr[0] doubleValue], [locationArr[1] doubleValue]);
            [clusterManager addClusterItem:clusterItem];
            allNum += factoryPoiModel.count;
        }
        
    } failure:^(RequestManager *manager, NSError *error) {
//        ZHZAlertView *zhzAlertView = [[ZHZAlertView alloc] initWithFrame:CGRectNull alertWord:@"网络出现点小问题~"];
//        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appdelegate.window addSubview:zhzAlertView];
    }];
    
    
    
}


@end
/*
 @{
 @"address":@"大岭山镇德政街",
 @"city":@"东莞市",
 @"city_id": @119,
 @"district": @"大岭山镇",
 @"district_id":@120,
 @"factory_id": @1834093026,
 @"location": @[@22.905901,@113.84869],
 @"province": @"广东省",
 @"province_id":@220,
 @"street":@"大岭山镇街道1",
 @"street_id":@320
 },
 @{
 @"address":@"大岭山镇德政街",
 @"city":@"东莞市",
 @"city_id": @119,
 @"district": @"大岭山镇",
 @"district_id":@120,
 @"factory_id": @1834092953,
 @"location": @[@22.910382,@113.83679],
 @"province": @"广东省",
 @"province_id":@220,
 @"street":@"大岭山镇街道1",
 @"street_id":@320
 },
 @{
 @"address":@"大岭山镇德政街",
 @"city":@"东莞市",
 @"city_id": @119,
 @"district": @"寮步镇",
 @"district_id":@121,
 @"factory_id": @1834092823,
 @"location": @[@22.996383,@113.897739],
 @"province": @"广东省",
 @"province_id":@220,
 @"street":@"寮步镇街道1",
 @"street_id":@420
 },
 @{
 @"address":@"寮步镇",
 @"city":@"东莞市",
 @"city_id": @119,
 @"district": @"寮步镇",
 @"district_id":@121,
 @"factory_id": @1834092756,
 @"location": @[@23.003646,@113.881287],
 @"province": @"广东省",
 @"province_id":@220,
 @"street":@"寮步镇街道1",
 @"street_id":@420
 },
 @{
 @"address":@"神前五街一巷大坣街路口附近",
 @"city":@"东莞市",
 @"city_id": @119,
 @"district": @"寮步镇",
 @"district_id":@121,
 @"factory_id": @1834092676,
 @"location": @[@22.997719,@113.894465],
 @"province": @"广东省",
 @"province_id":@220,
 @"street":@"寮步镇街道2",
 @"street_id":@421
 },
 @{
 @"address":@"寮步镇寮城西路168号",
 @"city":@"东莞市",
 @"city_id": @119,
 @"district": @"寮步镇",
 @"district_id":@121,
 @"factory_id": @1834092446,
 @"location": @[@23.00291,@113.885861],
 @"province": @"广东省",
 @"province_id":@220,
 @"street":@"寮步镇街道2",
 @"street_id":@421
 }
 */
