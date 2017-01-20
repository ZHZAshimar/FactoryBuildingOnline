//
//  User.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/18.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *password;

@end
