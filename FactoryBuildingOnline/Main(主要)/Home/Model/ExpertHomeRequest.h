//
//  ExpertHomeRequest.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/6.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PROMEDIUMSBLOCK) (BOOL flag);

@interface ExpertHomeRequest : NSObject

@property (nonatomic, copy) PROMEDIUMSBLOCK promediumsBlock;

/**
 *  请求专家前三名
 */
- (void)getPromediumsTOP;

/**
 *  请求分店资源
 */
- (void)getPromediumsArea;

@end
