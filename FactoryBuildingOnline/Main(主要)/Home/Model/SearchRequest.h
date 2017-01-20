//
//  SearchRequest.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SearchRequestBlock) (NSMutableArray *dataArray);

typedef void (^SearchErrorMsgBlock)(NSString *errorMsg);

typedef void(^BrokerInfoBlock) (NSDictionary *dic);

@interface SearchRequest : NSObject

/// 请求到的数据 回调更新界面
@property (nonatomic, copy) SearchRequestBlock dataBlock;

/// 错误信息回调
@property (nonatomic, copy) SearchErrorMsgBlock errorMsgBlock;

/// 经纪人的基本信息 回调更新界面
@property (nonatomic, copy) BrokerInfoBlock infoBlock;


/**
 *  搜索接口的数据请求
 *
 *  @param searchKey 搜索的关键字
 */
- (void)searchRequestNetWork:(NSString *)searchKey;

/**
 *  获取相关的搜索内容
 *
 *  @param searchResultDic 进行搜索的dic
 */
- (void)getSearchContentsWithContentID:(NSDictionary *)searchResultDic;

/**
 *  获取nexturl 的内容
 *  @param url next 的url
 *  @param dataType 数据类型
 */
- (void)getSearchWithURL:(NSString *)url andDataType:(NSString *)dataType;

/**
 *  获取经纪人的基本信息
 *
 *  @param ownID 经纪人ID
 */
- (void)getBrokerInfoWithOWNID:(NSInteger)ownID;

@end
