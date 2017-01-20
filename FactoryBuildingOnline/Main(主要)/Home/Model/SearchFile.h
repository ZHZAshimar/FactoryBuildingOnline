//
//  SearchFile.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/17.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchFile : NSObject

/**
 *  写入search数组文件
 *
 *  @param mArray 写入的数组
 *
 *  @return BooL  YES 写入成功 ， NO 写入失败
 */

+(BOOL)writeSearchFileArray:(NSMutableArray *)mArray;

/**
 *  读取search数组文件
 *
 *  @return NSArray
 */
+(NSArray *)readFileArray;

/**
 *  删除search数组文件
 *
 *  @return BooL  YES 删除成功 ， NO 删除失败
 */
+ (BOOL)deleteSearchFile;

@end
