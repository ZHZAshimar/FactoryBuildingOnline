//
//  RecommendViewController.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/9/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BaseViewController.h"

typedef enum{
    REQUEST_NORMAL, // 普通请求
    REQUEST_FILTER, // 筛选
}REQUEST_TYPE;

@interface RecommendViewController : UIViewController
/// 请求类型，默认是普通请求
@property (nonatomic, assign) REQUEST_TYPE request_type;

@end
