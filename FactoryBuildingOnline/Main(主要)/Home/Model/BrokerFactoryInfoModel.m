//
//  BrokerFactoryInfoModel.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/9.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "BrokerFactoryInfoModel.h"

@implementation BrokerFactoryInfoModel

- (id)initWithDictionary:(NSDictionary *)dic {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
