//
//  GetVersionk.h
//  FactoryBuildingOnline
//
//  Created by 郑惠珠 on 2017/2/22.
//  Copyright © 2017年 XFZY. All rights reserved.
//  版本检测

#import <Foundation/Foundation.h>

typedef void (^GetVersionBlook)(NSDictionary *dic);

@interface GetVersion : NSObject

@property (nonatomic, strong)GetVersionBlook block;

@property (nonatomic, strong) NSString *versionStr;

/*
 *  通过AppStore 更新版本
 */
- (void)appStoreUpdateVersion;


@end
