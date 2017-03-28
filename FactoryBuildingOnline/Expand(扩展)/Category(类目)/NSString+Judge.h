//
//  NSString+Judge.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/24.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Judge)

+ (BOOL)validatePureNumandCharacters:(NSString *)string;    // 判断是否为纯文字

+ (BOOL)validateMobile:(NSString *)mobile;                  // 判断是否为手机号

+ (BOOL)validateEmail:(NSString *)email;                    // 判断 string 是否为 邮箱格式

/*
 *  字符串反转
 *  @return mString;
 */
- (NSString *)stringByReversed;

+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;     //获取字符串的宽度
/**
 *  带行距的文本计算高度
 *  @param string     文字的内容
 *  @param size       rect 的最大范围
 *  @param fontSize   字体的大小
 *  @param space      行距
 *
 *  @return height
 */

+ (CGFloat)getHeightOfAttributeRectWithStr:(NSString *)string andSize:(CGSize)size andFontSize:(CGFloat)fontSize andLineSpace:(CGFloat)space;

/**
 *  字符 串转 数组
 *
 *  @param jsonString 字符串
 *
 *  @return NSDictionary
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;

/**
  *  字符串 转 字典
  *
  *  @param jsonString 字符串
  *
  *  @return NSDictionary
  */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  字典 转 字符串
 *
 *  @param dic 字典
 *
 *  @return NSString
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  数组 转 字符串
 *
 *  @param array 数组
 *
 *  @return NSString
 */
+ (NSString *)arrayToJson:(NSArray *)array;

/**
 *  字符串 添加行距
 *
 *  @param string    要添加行距的string
 *  @param textWidth string 显示的宽度
 *  @param lineSpace 行距
 *
 *  @return NSAttributedString
 */
+(NSAttributedString *)attributedString:(NSString *)string andTextWidth:(CGFloat)textWidth andLineSpace:(CGFloat)lineSpace;



/**
 *  计算时间差
 *
 *  @param timeStamp 传入时间戳
 *
 *  @return NSString 时间差距的表示方式
 */
+ (NSString *)getTimeFormatter:(NSString *)timeStamp;



+ (NSString *)getDateFormatter:(NSString *)timeFormatter withTimer:(NSTimeInterval)time;

/**
 *  自定义时间格式
 *
 *  @param timeFormatter 时间格式
 *  @param date 传入时间date
 *
 *  @return 时间差距的表示方式
 */

+(NSString *)custemDateFormatter:(NSString *)timeFormatter withDate:(NSDate*)date;
@end
