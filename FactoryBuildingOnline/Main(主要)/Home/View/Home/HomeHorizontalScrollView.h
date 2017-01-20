//
//  HomeHorizontalScrollView.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/29.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TAPPROMEDIUSBLOCK) (NSDictionary *blockDic);

@interface HomeHorizontalScrollView : UIView

@property (nonatomic, assign) NSInteger indexSegment;

@property (nonatomic, strong) NSDictionary *brokerDic;

@property (nonatomic, copy) TAPPROMEDIUSBLOCK tapPromediusBlock;

- (id)initWithFrame:(CGRect)frame index:(NSUInteger)index;

@end
