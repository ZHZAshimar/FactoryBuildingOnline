//
//  BoutiqueRequest.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/7.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DATABLOCK) (NSMutableArray *mArr);

@interface BoutiqueRequest : NSObject

@property (nonatomic, copy) DATABLOCK dataBlock;
/// 获取精品厂房
- (void)getBoutiqueFactoryData;

@end
