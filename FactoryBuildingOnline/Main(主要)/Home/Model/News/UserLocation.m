//
//  UserLocation.m
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/3/23.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "UserLocation.h"

@implementation UserLocation

@synthesize geohashStr = _geohashStr;

static UserLocation *_instance = nil;

+ (UserLocation *)shareInstance {
    if (_instance == nil) {
        _instance = [[super alloc] init];
    }
    return _instance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
//    [super dealloc];
}

@end
