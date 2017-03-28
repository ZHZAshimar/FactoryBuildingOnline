//
//  NSString+Judge.m
//  FactoryBuildingOnline
//
//  Created by myios on 2016/10/24.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import "NSString+Judge.h"

@implementation NSString (Judge)

/// 判断 string 是否为纯数字
+ (BOOL)validatePureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

// 判断 string 是否为 邮箱格式
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    // 16.01.09 add the phone of 175****
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[5678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**
 *  字符串反转
 *  @return mString;
 */
- (NSString *)stringByReversed {
    
    NSMutableString *mString = [NSMutableString string];        // 初始化可变字符串
    for (NSUInteger i=self.length; i>0; i--) {               // 对时间戳的字符串进行反转
        [mString appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return mString;
}


// 获取字符串的宽度
+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//                        sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

/**
 *  带行距的文本计算高度
 *  @param string     文字的内容
 *  @param size       rect 的最大范围
 *  @param fontSize   字体的大小
 *  @param space      行距
 *
 *  @return height
 */

+ (CGFloat)getHeightOfAttributeRectWithStr:(NSString *)string andSize:(CGSize)size andFontSize:(CGFloat)fontSize andLineSpace:(CGFloat)space{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    [style setLineSpacing:space];
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:style};
    
    CGSize rectSize = [string boundingRectWithSize:size options:\
                       NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                    NSStringDrawingUsesFontLeading
                                        attributes:attribute context:nil].size;
    return rectSize.height;
    
}
/**
 *  字符 串转 数组
 *
 *  @param jsonString 字符串
 *
 *  @return NSDictionary
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString {
 
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        NSLog(@"json 转数组 解析失败 %@",error);
        
        // 此处遇到 NSJSONSerialization 抛出异常 - “Garbage at End”，
        // 大致原因是因为 含有JSON转换无法识别的字符。这里的string是加密过的，导致解密后的数据加了一些 “操作符”，我们需要把这些操作符给去掉
        // 下面代码将 所有控制符都会被替换成空字符
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        // 再将 string 装成 data 格式
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        // 将 data 装成字典
        array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    }
    return array;
}

/**
 *  字符串转字典
 *
 *  @param jsonString 字符串
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        NSLog(@"json解析失败 %@",error);
        
        error = nil;
        
        // 此处遇到 NSJSONSerialization 抛出异常 - “Garbage at End”，
        // 大致原因是因为 含有JSON转换无法识别的字符。这里的string是加密过的，导致解密后的数据加了一些 “操作符”，我们需要把这些操作符给去掉
        // 下面代码将 所有控制符都会被替换成空字符
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        // 再将 string 装成 data 格式
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        // 将 data 装成字典
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
    }
    return dic;
}

/**
 *  字典转字符串
 *
 *  @param dic 字典
 *
 *  @return NSString
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];    // 将 换行符去掉
    
    return string;
    
}
/**
 *  数组转字符串
 *
 *  @param array 数组
 *
 *  @return NSString
 */
+ (NSString *)arrayToJson:(NSArray *)array {
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

/**
 *  字符串 添加行距
 *
 *  @param string    要添加行距的string
 *  @param textWidth string 显示的宽度
 *  @param lineSpace 行距
 *
 *  @return NSAttributedString
 */
+(NSAttributedString *)attributedString:(NSString *)string andTextWidth:(CGFloat)textWidth andLineSpace:(CGFloat)lineSpace{
    
    // 创建 实例，传入string
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    // 创建 行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    // 设置行距
    [style setLineSpacing:lineSpace];
    
    [style setAlignment:NSTextAlignmentLeft];
    
    // 判断内容长度是否大于Label 内容宽度，如果不大于，则设置内容宽度为行宽（内容如果小于行宽，label长度太短，如果label有背景颜色，则影响布局效果）
    NSInteger length = textWidth;
    
    if (attStr.length < textWidth) {
        
        length = attStr.length;
    }
    // 根据给定长度style 设置 attStr 样式
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    
    return attStr;
}

/**
 *  计算时间差
 *
 *  @param timeStamp 传入时间戳
 *
 *  @return NSString 时间差距的表示方式
 */
+ (NSString *)getTimeFormatter:(NSString *)timeStamp {
    
    NSString *timeStr;
    
    NSTimeInterval cur_time = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval result = cur_time - [timeStamp doubleValue];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    if (result < 60) {
        timeStr = [NSString stringWithFormat:@"刚刚"];
    } else if (result >= 60 && result < 3600) {
        timeStr = [NSString stringWithFormat:@"%d分钟前",(int)result/60];
    } else if (result >= 60*60 && result < 60*60*24) {
        timeStr = [NSString stringWithFormat:@"%d小时前",(int)result/(60*60)];
    } else if (result >= 60*60*24 && result < 60*60*24*30) {
        timeStr = [NSString stringWithFormat:@"%d天前",(int)result/(60*60*24)];
    } else if (result >= 60*60*24*30 && result < 60*60*24*30*12) {
        timeStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:newDate]];
    } else {
        [dateFormatter setDateFormat:@"YYY年MM月dd日"];
        timeStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:newDate]];
    }
    return timeStr;
}
/**
 *  自定义时间格式
 *
 *  @param timeFormatter 时间格式
 *  @param date 传入时间date
 *
 *  @return 时间差距的表示方式
 */

+(NSString *)custemDateFormatter:(NSString *)timeFormatter withDate:(NSDate*)date{

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:timeFormatter];
    return  [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
}

+ (NSString *)getDateFormatter:(NSString *)timeFormatter withTimer:(NSTimeInterval)time {
    
    if (!time) {
        time = [[NSDate date] timeIntervalSince1970];
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateFormat:timeFormatter];
    
    NSString *timerStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
    
    return timerStr;
}

@end
