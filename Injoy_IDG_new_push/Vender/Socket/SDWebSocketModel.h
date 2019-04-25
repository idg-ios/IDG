//
//  SDWebSocketModel.h
//  SDMarketingManagement
//
//  Created by Rao on 15/12/11.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MessageType {
    singleChat = 0, //单聊
    singleChat_response = 1,
    groupChat = 2, //群聊
    groupChat_response = 3,
    push = 14, // 点推
    push_response = 15,
    groupPush = 16, // 群推
    groupPush_response = 17,
    login = 5, //登录
    login_respone = 6,
    heartbeat = 7, //心跳
    heartbeat_respone = 8,
    answer = 12, //应答
    answer_respone = 13,
    offlineMessage = 9, //离线消息
    offlineMessage_respone = 10

} MessageType;

@interface SDWebSocketModel : NSObject

/// 校验码 0xabef0101
@property (assign, nonatomic) int crcCode;
/// 消息的id
@property (strong, nonatomic) NSString* messageId;
/// 消息类型
@property (strong, nonatomic) NSNumber* type;
/// 发送人
@property (copy, nonatomic) NSString* from;
/// 接收人
@property (copy, nonatomic) NSString* to;
/// 群组id
@property (copy, nonatomic) NSString* groupId;
/// 密码
@property (copy, nonatomic) NSString* password;
/// 连接类型
@property (assign, nonatomic) int socketType;
/// 消息体
@property (strong, nonatomic) id textMsg;

/// 媒体类型(必填)
@property (assign, nonatomic) int mediaType;

@end
