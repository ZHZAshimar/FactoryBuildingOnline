//
//  ExpertHomeRequest.m
//  FactoryBuildingOnline
//
//  Created by myios on 2017/2/6.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import "ExpertHomeRequest.h"
#import "PromediumsModel.h"     // 专家的model
#import "BrancheModel.h"


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
    
        [MBProgressHUD hideHUD];
        
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
        [MBProgressHUD hideHUD];
        [self dealWithBranchData:response];
    } failure:^(RequestManager *manager, NSError *error) {
        NSLog(@"分店资源数据请求错误：%@",error.debugDescription);
        [MBProgressHUD hideHUD];
    }];
    
}

- (void)dealWithBranchData:(NSDictionary *)response {
    
//    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *tmpArr = response[@"branches"];
    
    for (int i = 0; i < tmpArr.count; i++) {
        
        NSDictionary *tmpDic = @{@"branchID":tmpArr[i][@"id"],@"name":tmpArr[i][@"name"]};
        
        BrancheModel *model = [[BrancheModel alloc] initWithDictionary:tmpDic];
        
        [BrancheModel insertWithBranchModel:model];
        
    }
    
}
/**
 *  获取对应分店的专家
 */
- (void)getBranchPromediums:(NSInteger )branchID andNextUrl:(NSString *)nextUrl{
    
    NSDictionary *emptyDic = [NSDictionary dictionary];
    
    if (nextUrl.length >= 1) {  // 当nexturl 有值时，则请求nextURL 的内容
        
        [HTTPREQUEST_SINGLE getRequestWithURLReturnDic:nextUrl andParameters:nil andShouldToken:NO success:^(RequestManager *manager, NSDictionary *response) {
            
            self.bpBlock(response);
            
        } failure:^(RequestManager *manager, NSError *error) {
            self.bpBlock(emptyDic);
        }];
        
    } else {
    
        NSString *url = [NSString stringWithFormat:@"%@%ld",URL_GET_PROMEDIUMS_AREA,branchID];
        
        [HTTPREQUEST_SINGLE getRequestWithService:url andParameters:nil isShowActivity:YES success:^(RequestManager *manager, NSDictionary *response) {
            
            NSLog(@"%@",response);
            
            self.bpBlock(response);
            
        } failure:^(RequestManager *manager, NSError *error) {
            self.bpBlock(emptyDic);
        }];
    }
}

@end
