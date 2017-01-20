//
//  DetailMapCollectionViewCell.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMapCollectionViewCell : UICollectionViewCell

//@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

@property (strong, nonatomic) NSDictionary *locationDic ;

@end
