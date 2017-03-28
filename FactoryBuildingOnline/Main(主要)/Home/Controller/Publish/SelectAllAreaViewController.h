//
//  SelectAllAreaViewController.h
//  SelectAreaTest
//
//  Created by myios on 2017/3/25.
//  Copyright © 2017年 Ashimar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void(^SELECTALLAREABLOCK) (NSDictionary *selectDict);

@interface SelectAllAreaViewController :BaseViewController

@property (nonatomic, copy) SELECTALLAREABLOCK areaBlock;

@property (nonatomic, strong) NSDictionary *pushDict;

@end


/*
 mSelectedDict 的结构说明：
 {
    province:@[@"北京市",11,0],        // 选中的省
    city:@[@"市辖区",1101,0],          // 选中的市
    area:@[@"东城区",110101,0],        // 选中的区
 }
 
 @[@"北京市",11,0]  第一个表示 选中的name,第二个表示选中的code,的三个表示他是所属列表中的第0号位置
 
 
 */
