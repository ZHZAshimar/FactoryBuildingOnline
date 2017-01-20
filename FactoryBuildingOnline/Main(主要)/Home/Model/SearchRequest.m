//
//  SearchRequest.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/25.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SearchRequest.h"
#import "RequestMessage.h"
#import "HomeRequest.h"

@implementation SearchRequest

/**
 *  搜索接口的数据请求
 *
 *  @param searchKey 搜索的关键字
 */
- (void)searchRequestNetWork:(NSString *)searchKey {

    
    [HTTPREQUEST_SINGLE getRequestWithService:URL_GET_SEARCH andParameters:@{@"key":searchKey} isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        NSLog(@"response = %@",response);
        
        if ([response[@"erro_code"] intValue] != 200) {
            
            self.errorMsgBlock(response[@"erro_msg"]);  // 错误信息回调
            return ;
        }
        
        NSMutableArray *mArr = response[@"searchResult"];
        
        self.dataBlock(mArr);
        
    } failure:^(RequestManager *manager, NSError *error) {
        [MBProgressHUD showError:@"网络出现点小问题💔" ToView:nil];
    }];
    
}
/**
 *  获取相关的搜索内容
 *
 *  @param searchResultDic 进行搜索的dic
 */
- (void)getSearchContentsWithContentID:(NSDictionary *)searchResultDic {
    
    [HTTPREQUEST_SINGLE getRequestWithService:[NSString stringWithFormat:@"%@%@",URL_GET_SEARCH_CONTENTS,searchResultDic[@"content"]] andParameters:nil isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showAutoMessage:response[@"erro_msg"] ToView:nil];
            return;
        }
        NSMutableArray *mArr = [NSMutableArray array];
        
        NSMutableArray *resultArr = [NSMutableArray array];
        if ([searchResultDic[@"type"] intValue] == 1) {   // 业主
            
            mArr = response[@"wantedMessage"];
            
            resultArr = [HomeRequest dealWithHomeDatabase:mArr andNextURL:response[@"next"] isWriteDB:NO];
            
        } else {    // 专家
            resultArr = [HomeRequest dealWithBrokerDatabase:response isWriteDB:NO];
        }
        self.dataBlock(resultArr);
        
    } failure:^(RequestManager *manager, NSError *error) {
        
//        [MBProgressHUD showAutoMessage:@"" ToView:]
        
    }];
    
}

/**
 *  获取nexturl 的内容
 *  @param url next 的url
 *  @param dataType 数据类型
 */
- (void)getSearchWithURL:(NSString *)url andDataType:(NSString *)dataType{
    
    [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:url andParameters:nil success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showAutoMessage:response[@"erro_msg"] ToView:nil];
            return;
        }
        NSMutableArray *mArr = [NSMutableArray array];
        
        NSMutableArray *resultArr = [NSMutableArray array];
        if ([dataType intValue] == 1) {   // 业主
            
            mArr = response[@"wantedMessage"];
            
            resultArr = [HomeRequest dealWithHomeDatabase:mArr andNextURL:response[@"next"] isWriteDB:NO];
            
        } else {    // 专家
            mArr = response[@"proMediumMessage"];
            
            resultArr = [HomeRequest dealWithBrokerDatabase:response isWriteDB:NO];
        }
        self.dataBlock(resultArr);
        
    } failure:^(RequestManager *manager, NSError *error) {
        
    }];
    
}
/**
 *  获取经纪人的基本信息
 *
 *  @param ownID 经纪人ID
 */
- (void)getBrokerInfoWithOWNID:(NSInteger)ownID {
    
    [HTTPREQUEST_SINGLE getRequestWithService:[NSString stringWithFormat:@"%@%@",URL_POST_REGISTER,@(ownID)] andParameters:nil isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        
        if ([response[@"erro_code"] intValue] != 200) {
            [MBProgressHUD showAutoMessage:response[@"erro_msg"] ToView:nil];
            return;
        }
        
        NSDictionary *brokerInfo = response[@"userPublic"];
        
        self.infoBlock(brokerInfo);
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"获取发布人信息失败：%@",error);
    }];
}

@end
