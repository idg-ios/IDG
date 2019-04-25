//
//  CXIMHelper.h
//  SDMarketingManagement
//
//  Created by lancely on 4/21/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCompanyUserModel.h"

@interface CXIMHelper : NSObject

/**
 *  通过IM账号数组获取群组用户模型数组
 *
 *  @param imAccount数组
 *
 *  @return 群组用户模型数组
 */
+ (NSArray<CXGroupMember *> *)getGroupMembersByIMAcocountArray:(NSArray<NSString *> *)imAccountArray;
/**
 *  通过IM账号获取群组用户模型
 *
 *  @param imAccount
 *
 *  @return 群组用户模型
 */
+ (CXGroupMember *)getGroupMemberByIMAcocount:(NSString *)imAccount;
/**
 *  通过账号获取用户模型
 *
 *  @param userId userId
 *
 *  @return 用户模型
 */
+ (SDCompanyUserModel*)getUserByUserId:(NSInteger)userId;

/**
 *  通过账号获取用户模型
 *
 *  @param account IM账号
 *
 *  @return 用户模型
 */
+ (SDCompanyUserModel *)getUserByIMAccount:(NSString *)account;

/**
 *  通过账号获取真实姓名
 *
 *  @param account IM账号
 *
 *  @return 真实姓名
 */
+ (NSString *)getRealNameByAccount:(NSString *)account;

/**
 *  获取用户头像地址
 *
 *  @param account IM账号
 *
 *  @return 用户头像地址
 */
+ (NSString *)getUserAvatarUrlByIMAccount:(NSString *)account;
/**
 *  获取群组头像图片
 *
 *  @param aGroup 群组对象
 *
 *  @return 群组头像图片
 */
+ (UIImage*)getImageFromGroup:(CXGroupInfo*)aGroup;

/**
 *  用户id数组转模型数组
 *
 *  @param userIdArray 用户id数组
 *
 *  @return 模型数组
 */
+ (NSArray<SDCompanyUserModel *> *)userIdArrayToModelArray:(NSArray<NSNumber *> *)userIdArray;

/**
 *  IM账号数组转模型数组
 *
 *  @param imAccountArray IM账号数组
 *
 *  @return 模型数组
 */
+ (NSArray<SDCompanyUserModel *> *)imAccountArrayToModelArray:(NSArray<NSString *> *)imAccountArray;

/**
 *  获取群组头像图片
 *
 *  @param conversation 会话对象
 *
 *  @return 群组头像图片
 */
+ (UIImage*)getGroupHeadImageFromConversation:(CXIMConversation *)conversation;

/**
 *  获取用户头像地址
 *
 *  @param message message对象
 *
 *  @return 用户头像地址
 */
+ (NSString *)getUserAvatarUrlByIMMessage:(CXIMMessage *)message;

/**
 *  获取群组头像图片
 *
 *  @param conversation 会话对象
 *
 *  @return 群组头像图片
 */
+ (UIImage*)getGroupHeadImageFromMessage:(CXIMMessage *)message;

/**
 是否系统群
 
 @param groupId 群组id
 @return 是否是系统群
 */
+ (BOOL)isSystemGroup:(NSString *)groupId;

/**
 *  获取语音会议头像图片
 *
 *  @param iconString 语音会议头像url
 *
 *  @param count 语音会议人数
 *
 *  @return 语音会议头像图片
 */
+ (UIImage*)getImageFromVoiceMeetingIconString:(NSString*)iconString AndMeetingMemberCount:(NSInteger)count;

@end
