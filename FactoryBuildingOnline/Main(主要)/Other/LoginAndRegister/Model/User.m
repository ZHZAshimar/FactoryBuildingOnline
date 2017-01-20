//
//  User.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "User.h"

@implementation User

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_userName forKey:@"_userName"];
    [aCoder encodeObject:_password forKey:@"_password"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"_userName"];
        self.password = [aDecoder decodeObjectForKey:@"_password"];
    }
    
    return self;
}

@end
