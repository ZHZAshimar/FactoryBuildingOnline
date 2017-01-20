//
//  SearchVCCollectionView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/16.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TAP_SEARCH_HISTORY) (NSString *searchStr);    // 点击标签的回调

typedef void(^DELETEFILE)(BOOL flag);                       // 删除按钮的回调

typedef void(^FACTORYDETAIL)(NSDictionary *dic);                             // 厂房详情

@interface SearchVCCollectionView : UICollectionView 

/// 搜索拿到的数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *keyStr;

/// 搜索记录的tag 数组
@property (nonatomic, strong) NSArray *historyArray;
/// 点击标签的回调
@property (nonatomic, copy) TAP_SEARCH_HISTORY tapSearch;
/// 删除按钮的回调
@property (nonatomic, copy) DELETEFILE deleteFile;
/// 厂房详情
@property (nonatomic, copy) FACTORYDETAIL factoryDetail;

@end
