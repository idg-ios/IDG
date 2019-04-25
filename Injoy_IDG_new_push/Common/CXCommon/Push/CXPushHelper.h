//
//  CXPushHelper.h
//  SDMarketingManagement
//
//  Created by lancely on 6/14/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXPushHelper : NSObject

/** 有新的未读 */
+ (BOOL)haveNew:(NSString *)typeParam, ...;

/** 处理已读 */
+ (void)haveRead:(NSString *)typeParam, ...;

+ (NSInteger)getUnreadCount;

+ (void)updateDeviceToken;

+ (void)sendBadgeToServer;

/**
 获取我的审批总数量
 @return return value description
 */
+(NSInteger)getMyApprove;
@end
