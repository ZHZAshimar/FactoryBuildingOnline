//
//  UserLocation.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/23.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLocation : NSObject
{
    NSString *_geohashStr;
}
@property (nonatomic, strong) NSString *geohashStr;

+(UserLocation *)shareInstance;

@end
