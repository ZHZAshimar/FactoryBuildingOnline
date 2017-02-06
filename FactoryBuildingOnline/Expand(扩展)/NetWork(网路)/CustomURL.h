//
//  CustomURL.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/11.
//  Copyright © 2016年 XFZY. All rights reserved.
//

//#ifndef CustomURL_h
//#define CustomURL_h

#define IOS_DEBUG 1

#if IOS_DEBUG
    // 正式环境
//    #define URL_HOST @"http://192.168.0.143:8000/api/v1/"
    #define URL_HOST @"http://116.62.44.204:8000/api/v1/"  // 阿里云服务器
//    #define URL_HOST @"http://45.76.69.192:8000/api/v1/"
//    #define URL_HOST @"http://192.168.0.113:8000/api/v1/"
#else
    // 测试服务器
//    #define URL_HOST @"http://192.168.0.113:8000/api/v1/"// 本地服务器
//    #define URL_HOST @"http://45.76.69.192:8000/api/v1/"  线上服务器
    #define URL_HOST @"http://116.62.44.204:8000/api/v1/"  // 阿里云服务器
//    #define URL_HOST @"http://192.168.0.143:8000/api/v1/"

#endif /* CustomURL_h */

/**
 *  用户登录
 *
 *  @return
 */
#define URL_POST_LOGIN @"user/"

/**
 *  用户注册
 *
 *  @return
 */
#define URL_POST_REGISTER @"users/"

/**
 *  发布厂房
 *
 *  @return
 */
#define URL_POST_PUBLISH  @"wantedmessages/"

/**
 *  获取厂房信息
 *
 *  @return
 */
#define URL_GET_WANTEDMESSAGE  @"wantedmessages/recommend"

/**
 *  搜索招租信息
 *
 *  @return
 */
#define URL_GET_SEARCH  @"search"

/**
 *  获取相关的搜索内容
 *
 *  @return
 */
#define URL_GET_SEARCH_CONTENTS  @"search/contents/"

/**
 *  根据城市id筛选,地图找房用到的地理位置信息  /factorypois/district/{city_id}
 *
 *  @return
 */
#define URL_GET_Factorypois @"factorypois/district/"


/**
 *  获取当前登录用户发布的文章
 *
 *  @return
 */
#define URL_GET_PUBLICATIONS @"user/publications/"

/**
 *  获取用户收藏的业主信息
 *
 *  @return
 */
#define URL_GET_COLLECTIONS @"user/collections/wantedmessages/"

/**
 *  获取用户收藏的经纪人信息
 *
 *  @return
 */
#define URL_GET_BROKERS_COLLECTIONS @"user/collections/promediummessages/"
/**
 *  获取短信验证码 smses
 *
 *  @return
 */
#define URL_GET_SMSES @"smses/"

/**
 *  获取当前登陆用户的信息 user
 *
 *  @return
 */
#define URL_GET_USERINFO @"user/"

/**
 *  GET /promediums 获取专家的信息
 *
 *  @return
 */
#define URL_GET_PROMEDIUMS @"promediums/"

/**
 *  POST 举报用户发布的信息
 *
 *  @return
 */
#define URL_POST_FEEDBACKS_WANTEDMESSAGE @"feedbacks/wantedmessage/"

/**
 *  POST 需求信息资源
 *
 *  @return
 */
#define URL_POST_NEEDEDMESSAGE @"neededmessages/"

/**
 *  GET 获取排名前三的中介信息
 *
 *  @return
 */
#define URL_GET_PROMEDIUMS_TOP  @"promediums/top"

/**
 *  GET 获取对应分店的专家
 *  /promediums/branches/{branch_id}
 *  @return
 */
#define URL_GET_PROMEDIUMS_AREA  @"promediums/branches/"

/**
 *  GET 获取分店
 *  /branches
 *  @return
 */
#define URL_GET_BRANCHES  @"branches"
