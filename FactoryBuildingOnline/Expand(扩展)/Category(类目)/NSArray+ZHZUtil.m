//
//  NSArray+ZHZUtil.m
//  FactoryBuildingOnline
//
//  Created by myios on 16/10/5.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "NSArray+ZHZUtil.h"

@implementation NSArray (ZHZUtil)

- (id)objectAtIndexCheck:(NSUInteger)index {

    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
