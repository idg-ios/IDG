//
//  CXIMSocketModel.h
//  SDIMLib
//
//  Created by cheng on 16/8/6.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CXIMMessage;

/** 类型类型 */
typedef NS_ENUM(NSInteger, CXIMSocketType) {
    /** web端 */
    CXIMSocketTypeWeb = 1,
    /** Android端 */
    CXIMSocketTypeAndroid = 2,
    /** iOS端 */
    CXIMSocketTypeIOS = 3
};

/** 消息的类型 */
typedef NS_ENUM(NSInteger, CXIMProtocolType) {
    /** 单聊 */
    CXIMProtocolTypeSingleChat = 0,
    /** 单聊响应 */
    CXIMProtocolTypeSingleChatRes = 1,
    /** 群聊 */
    CXIMProtocolTypeGroupChat = 2,
    /** 群聊响应 */
    CXIMProtocolTypeGroupChatRes = 3,
    /** 登录 */
    CXIMProtocolTypeLogin = 5,
    /** 登录响应 */
    CXIMProtocolTypeLoginRes = 6,
    /** 心跳 */
    CXIMProtocolTypeHearbeat = 7,
    /** 心跳响应 */
    CXIMProtocolTypeHearbeatRes = 8,
    /** 离线消息 */
    CXIMProtocolTypeOffline = 9,
    /** 离线消息响应 */
    CXIMProtocolTypeOfflineRes = 10,
    /** 应答 */
    CXIMProtocolTypeResponde = 12,
    /** 应答响应 */
    CXIMProtocolTypeRespondeRes = 13,
    /** 点推 */
    CXIMProtocolTypePeer = 14,
    /** 点推响应 */
    CXIMProtocolTypePeerRes = 15,
    /** 群推 */
    CXIMProtocolTypeGroup = 16,
    /** 群推响应 */
    CXIMProtocolTypeGroupRes = 17,
    /** 通话 */
    CXIMProtocolTypeCall = 19,
    /** 通话响应 */
    CXIMProtocolTypeCallRes = 20,
    /** 对方不在线 */
    CXIMProtocolTypeAwayRes = 21,
    /** 已读回执 */
    CXIMProtocolTypeReadAsk = 23,
    /** 已读回执响应 */
    CXIMProtocolTypeReadAskRes = 24
};

/** socket模型 */
@interface CXIMSocketModel : NSObject

/** 校验码 */
@property(nonatomic, assign) NSInteger crcCode;
/** 消息的ID */
@property(nonatomic, copy) NSString *messageId;
/** 消息的类型 */
@property(nonatomic, assign) CXIMProtocolType type;
/** 媒体类型 */
@property(nonatomic, assign) NSInteger mediaType;
/** 优先级 */
@property(nonatomic, assign) NSInteger priority;
/** 发送人 */
@property(nonatomic, copy) NSString *from;
/** 接收人 */
@property(nonatomic, copy) NSString *to;
/** 群组ID */
@property(nonatomic, copy) NSString *groupId;
/** 密码 */
@property(nonatomic, copy) NSString *password;
/** 连接类型 */
@property(nonatomic, assign) CXIMSocketType socketType;
/** 附加属性 */
@property(nonatomic, strong) NSDictionary<NSString *, id> *attachment;
/** 消息体 */
//@property(nonatomic, copy) NSString *body;
@property(nonatomic, strong) id textMsg;

// 辅助属性
@property(nonatomic, copy, readonly) NSString *jsonString;

/** 初始化方法 */
- (instancetype)initWithMessage:(CXIMMessage *)message;

/** 离线消息初始化 */
- (instancetype)initWithOfflineMessages:(NSArray<NSString *> *)messageIds;

/** 请求离线消息的模型 */
- (instancetype)initWithOfflineMessageRequest;

@end
