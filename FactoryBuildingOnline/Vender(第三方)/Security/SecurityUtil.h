//
//  SecurityUtil.h
//  Smile
//
//  Created by 蒲晓涛 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject 

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;

+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - AES加密
//将string转成带密码的data
+ (NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key ;
//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data app_key:(NSString*)key ;

/**
 *  AES 加密 128   CBC   no padding
 *
 *  @param plainText 输入要加密的string
 *  @param gkey (16位) 加密的key 与解密的key 是对应的
 *  @param gIv  （16位）可修改
 *  @return NSString
 */
+(NSString *)AES128Encrypt:(NSString *)plainText andKey:(NSString *)gkey andIV:(NSString *)gIv;

/**
 *  AES 解密 128  CBC   no padding
 *
 *  @param decryText 输入要解密的string
 *  @param gkey (16位) 加密的key 与解密的key 是对应的
 *  @param gIv （16位）可修改
 *  @return NSString
 */
+(NSString *)AES128Decrypt:(NSString *)decryText andKey:(NSString *)gkey andIV:(NSString *)gIv;


+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text;
@end
