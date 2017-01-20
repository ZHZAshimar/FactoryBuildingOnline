//
//  ChineseString.h
//  PrimaryHealthCloudForDoctor
//
//  Created by Tom on 15/4/16.
//  Copyright (c) 2015年 Bos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "pinyin.h"

@interface ChineseString : NSObject
@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;
@property(retain,nonatomic)NSString * date;
@property(retain,nonatomic)NSString * name;
@property(retain,nonatomic)NSString * avator;
@property(retain,nonatomic)NSString * userID;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)dictArr forKey:(NSString*)key;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)dictArr forKey:(NSString*)key;
@end
