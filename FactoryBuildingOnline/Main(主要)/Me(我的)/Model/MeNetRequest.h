//
//  MeNetRequest.h
//  FactoryBuildingOnline
//
//  Created by myios on 2016/12/8.
//  Copyright © 2016年 XFZY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AVATARIMAGEBLOCK) (BOOL flag);    // 用于修改头像的block回调
typedef void(^UPDATEPWDBLOCK) (BOOL flag);    // 用于修改头像的block回调

@interface MeNetRequest : NSObject

@property ( nonatomic, copy) AVATARIMAGEBLOCK avatarBlock;

@property (nonatomic, copy) UPDATEPWDBLOCK psdBlock;   

/**
 *  获取图片的七牛token
 *
 *  @param image 要上传的图片
 */
- (void)getImageTokenToPushQN:(UIImage *)image;

/**
 *  获取用户的基本信息
 *
 *  @param updateType : 1.更新头像2.更新用户名3.更新密码
 *
 */

- (void)getUserInfoAfterUpdateData:(NSInteger)updateType;

/**
 *  修改用户的基本信息
 *
 *  @param value 修改的值
 *  @param updateType : 1.更新头像2.更新用户名3.更新密码
 *  @param getUserInfo 是否获取用户基本信息
 */
- (void)updateUserAvater:(NSString *)value andUpdateType:(NSInteger)updateType getUserInfo:(BOOL)getUserInfo;

@end
