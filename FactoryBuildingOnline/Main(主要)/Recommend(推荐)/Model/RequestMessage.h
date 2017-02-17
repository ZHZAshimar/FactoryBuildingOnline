//
//  RequestMessage.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/22.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestMessageDelegate <NSObject>


- (void)refreshView:(NSMutableArray *)mArray;
- (void)requestError;
@end


typedef void(^REQUESTDATABLOCK) (NSDictionary *response); // 用于收藏的回调

@interface RequestMessage : NSObject

@property (nonatomic, assign) id<RequestMessageDelegate>delegate;
//
@property (nonatomic, copy) REQUESTDATABLOCK datablock;

/**
 *  第一次加载界面
 *
 *  @param haveViewData 界面的data 是否有值
 */
- (void)firstGetDataState:(BOOL)haveViewData;

/**
 *  下拉加载更多
 */
- (void)requestNetWithPage:(int)page;

/**
 *  上拉加载更多  从数据库中获取除了界面显示的信息外的10条，
 *
 *  @param count 界面的data 的个数
 */
- (void)requestSQLTogetModeData:(int)count;

/**
 *  筛选请求数据
 *
 *  @param mDic 传一个字典
 */
- (void)requestNetWithDic:(NSMutableDictionary *)mDic isShowActivity:(BOOL)showActivity;

/**
 *  通过 next url 获取数据
 *
 *  @param url 界面的data 的个数
 */
- (void)requestNestURL:(NSString *)url;

/**
 *  请求回来的数据进行处理
 *
 *  @param response     response
 *  @param wmArr        response中wantedMessage
 *  @param isWriteSQL   是否加入数据库
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *) dealWithDatabase:(NSDictionary*)response andArray:(NSArray *)wmArr andWriteSQL:(BOOL)isWriteSQL;

/**
 *  请求收藏接口 收藏 取消收藏，查看收藏状态
 *
 *  @param factoryID  厂房id
 *  @param type       请求方式  0：get 1:post 2:delete
 
 */
- (void) collectionRequestWithID:(int)factoryID andRequestType:(int)type;

/**
 *  获取发布人的基本信息
 *
 *  @param publisherID  发布人id
 */
- (void) getPublisherInfomation :(NSString *)publisherID;

/**
 *  获取历史记录  path My 页面
 *
 */
- (void)getHistoryData;

@end
