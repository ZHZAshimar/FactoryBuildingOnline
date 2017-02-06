//
//  ExpertHomeRequest.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/6.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ExpertHomeRequest.h"
#import "PromediumsModel.h"     // 专家的model

@implementation ExpertHomeRequest
/**
 *  请求专家前三名
 */
- (void)getPromediumsTOP {
    
    [HTTPREQUEST_SINGLE getRequestWithService:URL_GET_PROMEDIUMS_TOP andParameters:nil isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
        
        [MBProgressHUD hideHUD];
        
        NSLog(@"专家前三名：%@",response);
        if ([response[@"erro_code"] intValue] != 200) {
            
            [MBProgressHUD showError:response[@"erro_msg"] ToView:nil];
            return ;
            
        }
        
        NSArray *array = response[@"proMedium"];
        for (int i = 0 ; i < array.count; i++) {
            NSDictionary *tmpDic = array[i];
            
            NSDictionary *promediumsDic = @{@"promediumsID":@([tmpDic[@"id"] integerValue]),
                                            @"branch":tmpDic[@"branch"],
                                            @"realName":tmpDic[@"real_name"],
                                            @"workYear":tmpDic[@"year_experience"],
                                            @"avatar":tmpDic[@"avatar"],
                                            @"phoneNum":tmpDic[@"phone_num"]
                                            };
            PromediumsModel *model = [[PromediumsModel alloc] initWithDictionary:promediumsDic];
            
            [PromediumsModel insertPromediumsModel:model];
        }
        
        self.promediumsBlock(YES);
        
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"%@",error.debugDescription);
        self.promediumsBlock(YES);
    }];
}

/**
 *  请求分店资源
 */
- (void)getPromediumsArea {
    
    [HTTPREQUEST_SINGLE getRequestWithService:URL_GET_BRANCHES andParameters:nil isShowActivity:NO success:^(RequestManager *manager, NSDictionary *response) {
        NSLog(@"%@",response);
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"分店资源数据请求错误：%@",error.debugDescription);
    }];
    
}

@end
