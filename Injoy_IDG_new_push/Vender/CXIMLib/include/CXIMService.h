//
//  CXIMService.h
//  CXIMLib
//
//  Created by lancely on 1/22/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIM-Singleton.h"
#import "CXGroupInfo.h"
#import "CXIMConversation.h"
#import "CXIMCallRecord.h"
#import "CXIMCacheManager.h"
#import "CXIMGroupManager.h"
#import "CXIMChatManager.h"
#import "CXIMDataManager.h"
#import "CXUserInfo.h"
#import "CXIMSocketManager.h"
#import "CXIMTextMessageBody.h"
#import "CXIMImageMessageBody.h"
#import "CXIMVoiceMessageBody.h"
#import "CXIMVideoMessageBody.h"
#import "CXIMFileMessageBody.h"
#import "CXIMLocationMessageBody.h"
#import "CXIMMediaCallMessageBody.h"
#import "CXIMSystemNotifyMessageBody.h"
@class UIApplication;
#pragma mark - interface开始
@interface CXIMService : NSObject

singleton_interface(CXIMService)

@property (nonatomic, weak, readonly) CXIMSocketManager *socketManager;
@property (nonatomic, weak, readonly) CXIMCacheManager *cacheManager;
@property (nonatomic, weak, readonly) CXIMGroupManager *groupManager;
@property (nonatomic, weak, readonly) CXIMChatManager *chatManager;
@property (nonatomic, weak, readonly) CXIMDataManager *dataManager;


/** 初始化SDK */
- (void)initializeSDKWithOptions:(NSDictionary *)options;

/** APP进入后台 */
- (void)applicationDidEnterBackground:(UIApplication *)application;

/** APP将要从后台返回 */
- (void)applicationWillEnterForeground:(UIApplication *)application;

#pragma mark - 登录
/**
 *  登录
 *
 *  @param account  账号
 *  @param password 密码
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)loginWithAccount:(NSString *)account password:(NSString *)password completion:(void(^)(NSError *error))completionBlock;
/** 退出登录 */
- (void)logout;

@end
