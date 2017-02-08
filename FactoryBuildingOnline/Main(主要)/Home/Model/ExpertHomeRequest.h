//
//  ExpertHomeRequest.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/6.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PROMEDIUMSBLOCK) (BOOL flag);     // 冠军前三名的回调

typedef void(^BRANCHPROMEDIUMSBLOCK) (NSDictionary *dic);   // 区域内的专家回调

@interface ExpertHomeRequest : NSObject

@property (nonatomic, copy) PROMEDIUMSBLOCK promediumsBlock;
@property (nonatomic, copy) BRANCHPROMEDIUMSBLOCK bpBlock;
/**
 *  请求专家前三名
 */
- (void)getPromediumsTOP;

/**
 *  请求分店资源
 */
- (void)getPromediumsArea;


/**
 *  获取对应分店的专家
 */
- (void)getBranchPromediums:(NSInteger )branchID andNextUrl:(NSString *)nextUrl;

@end
