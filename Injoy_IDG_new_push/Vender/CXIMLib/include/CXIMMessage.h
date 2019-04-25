//
//  CXIMMessage.h
//  CXIMLib
//
//  Created by lancely on 1/26/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIMMessageBody.h"
#import "CXIMTextMessageBody.h"
#import "CXIMLocationMessageBody.h"
#import "CXIMSystemNotifyMessageBody.h"
#import "CXIMMediaCallMessageBody.h"
#import "CXIMLocationInfo.h"
#import "CXIMFileMessageBody.h"
#import "CXIMImageMessageBody.h"
#import "CXIMSocketModel.h"

/**
 * 聊天类型
 */
typedef NS_ENUM(NSInteger,CXIMMessageType){
    /** 单聊 0 */
    CXIMMessageTypeChat = CXIMProtocolTypeSingleChat,
    /** 群聊 2 */
    CXIMMessageTypeGroupChat = CXIMProtocolTypeGroupChat,
    /** 通话 19 */
    CXIMMessageTypeMediaCall = CXIMProtocolTypeCall,
    /** 已读回执 23 */
    CXIMMessageTypeReadAsk = CXIMProtocolTypeReadAsk
};

/**
 * 消息发送状态
 */
typedef NS_ENUM(NSInteger,CXIMMessageStatus){
    /** 发送中 */
    CXIMMessageStatusSending = 0,
    /** 发送成功 */
    CXIMMessageStatusSendSuccess = 1,
    /** 发送失败 */
    CXIMMessageStatusSendFailed = 2
};

/**
 *  阅读标记
 */
typedef NS_ENUM(NSInteger,CXIMMessageReadFlag) {
    /** 已读 */
    CXIMMessageReadFlagReaded = 0,
    /** 未读 */
    CXIMMessageReadFlagUnRead = 1,
    /** 无状态 */
    CXIMMessageReadFlagNoFlag = 99
};

@interface CXIMMessage : NSObject

/** 消息id */
@property(nonatomic, copy) NSString *ID;

/**
 *  消息类型 单聊/群聊...
 */
@property(nonatomic, assign) CXIMMessageType type;

/**
 *  发送人(id)
 */
@property(nonatomic, copy) NSString *sender;

/**
 *  接收人
 */
@property(nonatomic, copy) NSString *receiver;

/**
 *  消息体
 */
@property(nonatomic, strong) __kindof CXIMMessageBody *body;

/** 扩展字段 */
@property(nonatomic, copy) NSDictionary *ext;

/**
 *  消息状态
 */
@property(nonatomic, assign) CXIMMessageStatus status;

/**
 *  自己阅读状态
 */
@property(nonatomic, assign) CXIMMessageReadFlag readFlag;

/** 消息打开状态(主要针对阅后即焚的文字/语音/视频等消息) */
@property(nonatomic, assign) CXIMMessageReadFlag openFlag;

/** 对方阅读状态 */
@property(nonatomic, assign) CXIMMessageReadFlag readAsk;

/**
 *  发送时间 (时间戳)
 */
@property(nonatomic, strong) NSNumber *sendTime;

/** 格式化的时间 */
@property(nonatomic, copy, readonly) NSString *transformedTime;

/**
 *  实例化方法
 *
 *  @param chatter 聊天对象
 *  @param body    消息体
 *
 *  @return 消息对象
 */
- (instancetype)initWithChatter:(NSString *)chatter body:(__kindof CXIMMessageBody *)body;

/**
 *  下载文件
 *
 *  @param progressBlock   进度回调
 *  @param completionBlock 完成回调
 */
- (void)downloadFileWithProgress:(void(^)(float progress))progressBlock completion:(void(^)(CXIMMessage *message, NSError *error))completionBlock;

@end
