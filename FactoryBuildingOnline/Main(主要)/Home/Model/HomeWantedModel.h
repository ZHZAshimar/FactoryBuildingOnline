//
//  HomeWantedModel.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/30.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeContacterModel.h"
#import "HomeFactoryModel.h"

@interface HomeWantedModel : NSObject

/// 信息id
@property (nonatomic, assign) NSInteger id;
/// 需要更新的信息id
@property (nonatomic, assign) NSInteger update_id;
/// 需要删除的信息id
@property (nonatomic, assign) NSInteger delete_id;
/// 信息的修改时间
@property (nonatomic, strong) NSString *update_time;
/// contacter 联系人ID 用于关联 联系人表
@property (nonatomic, strong) HomeContacterModel *ctModel;
/// 浏览量
@property (nonatomic, assign) NSInteger view_count;
/// 发布人的id
@property (nonatomic, assign) NSInteger owner_id;
/// 工厂ID 用于关联 厂房详情的表
@property (nonatomic, strong) HomeFactoryModel *ftModel;
/// 是否被收藏
@property (nonatomic, assign) BOOL isCollect;
/// 信息的发布时间
@property (nonatomic, strong) NSString *created_time;
/// 下一页的请求连接 也就是上拉加载更多的连接
@property (nonatomic, strong) NSString *nextURL;

/**
 *  初始化
 *
 *  @prama dictionary 字典
 *  @return self
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  插入数据库
 *
 *  @prama WantedMessageModel
 *  @return BOOL
 */
+ (BOOL)insertWantedMessageModel:(HomeWantedModel *)homeWantedModel;

/**
 *  多表插入数据库
 *
 *  @param wmModel WantedMessageModel
 *  @param ctModel ContacterModel
 *  @param ftModel FactoryModel
 *
 */
+ (void)insertOfMoreTable:(HomeWantedModel *)wmModel andContacterModel:(HomeContacterModel *)ctModel andeFactoryModel:(HomeFactoryModel *)ftModel;

/*
 * 从数据库拿数据 10条
 */
+ (NSMutableArray *)findTenDataWithPage:(int)page addMore:(int)dataCount;
@end
