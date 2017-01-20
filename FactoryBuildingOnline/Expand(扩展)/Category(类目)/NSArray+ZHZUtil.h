//
//  NSArray+ZHZUtil.h
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/5.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZHZUtil)

/*!
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */

- (id)objectAtIndexCheck:(NSUInteger)index;

@end
