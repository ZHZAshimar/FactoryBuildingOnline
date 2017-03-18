//
//  PickerView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2017/3/18.
//  Copyright © 2017年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SELECTSTRBLOCK)(NSString *selectStrBlock) ;

@interface PickerView : UIView

@property (nonatomic, strong) NSArray *dataSource;  // 数据源

@property (nonatomic, copy) SELECTSTRBLOCK selectStrBlock;  // 选中的文字的回调

@end
