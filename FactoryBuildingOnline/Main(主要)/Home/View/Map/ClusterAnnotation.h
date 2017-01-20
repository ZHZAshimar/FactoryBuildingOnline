//
//  ClusterAnnotation.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/31.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

/*
 *点聚合Annotation
 */
@interface ClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSString *areaStr;
@property (nonatomic, assign) BOOL showPaoPao;
@property (nonatomic, assign) NSInteger area_id;
@end

/*
 *点聚合AnnotationView
 */
@interface ClusterAnnotationView : BMKPinAnnotationView {
    
}

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *areaStr;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage* strethImage;
@property (nonatomic, assign) BOOL showPaoPao;
@end
