//
//  SearchFile.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/11/17.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "SearchFile.h"

@implementation SearchFile
/**
 *  写入search数组文件
 *
 *  @param mArray 写入的数组
 *
 *  @return BooL  YES 写入成功 ， NO 写入失败
 */

+(BOOL)writeSearchFileArray:(NSMutableArray *)mArray
{
    NSLog(@"writeFileArray\n");
    //新建userinfomation数组用来存一些信息
    NSArray *writeArr = mArray;
    
    //把writeArr这个数组存入程序指定的一个文件里
    if ([writeArr writeToFile:[SearchFile documentsPath:@"searchText.txt"] atomically:YES]) {
        
        NSLog(@"保存成功！");
        return YES;
    } else {
        return NO;
        NSLog(@"保存失败");
        
    }
}
/// 读取文件
+(NSArray *)readFileArray
{
    NSLog(@"readfile........\n");
    //dataPath 表示当前目录下指定的一个文件 data.plist
    //NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    //filePath 表示程序目录下指定文件
    NSString *filePath = [SearchFile documentsPath:@"searchText.txt"];
    //从filePath 这个指定的文件里读
    NSArray *searchArr = [NSArray arrayWithContentsOfFile:filePath];
    
    return searchArr;
}
/**
 *  写入search数组文件
 *
 *  @return BooL  YES 删除成功 ， NO 删除失败
 */
+ (BOOL)deleteSearchFile {
    
    //filePath 表示程序目录下指定文件
    NSString *filePath = [SearchFile documentsPath:@"searchText.txt"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    BOOL flag = [manager removeItemAtPath:filePath error:&error];
    
    if (flag) {
        NSLog(@"删除成功");
        return YES;
    } else {
        NSLog(@"删除失败");
        return NO;
    }
    
}

+(NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"documentPath = %@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
