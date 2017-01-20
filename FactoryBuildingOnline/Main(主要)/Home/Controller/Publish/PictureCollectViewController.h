//
//  PictureCollectViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/21.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PHOTOSARR) (NSMutableArray *photosArray,NSMutableArray *keyArray);

@interface PictureCollectViewController : BaseViewController

@property (nonatomic, strong) NSArray<UIImage *> *photos;   // 图片资源数组
@property (nonatomic, strong) NSArray *littleBtnPhotos;    // 通过小按钮选择的图片数组
@property (nonatomic, assign) NSInteger showImageCount;     // 视图横向显示图片的个数

@property (nonatomic, copy) PHOTOSARR photosArr;

@property (nonatomic, strong) NSMutableArray *imageKeyArr;  // 从七牛返回的图片key

@property (nonatomic, assign) BOOL uploadQiniu;             // 是否上传七牛

@end
