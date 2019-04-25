//
// Created by lancely on 2/24/16.
// Copyright (c) 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIM-Singleton.h"
#import "CXIMMessage.h"
#import "CXIMConversation.h"
#import "CXGroupInfo.h"
#import "CXIMCallRecord.h"

@class RKFMDatabase;

@interface CXIMDataManager : NSObject

singleton_interface(CXIMDataManager)

#pragma mark - 初始化
/**
 *  需要时初始化数据库
 *
 *  @param account 账号
 *
 *  @return 是否成功
 */
- (BOOL)initDatabaseIfNeed:(NSString *)account;

/**
 *  释放
 */
- (void)dispose;

#pragma mark - 会话
/**
 *  创建会话
 *
 *  @param chatter     聊天人
 *  @param displayName 显示名称
 *  @param type 聊天类型
 *
 *  @return 会话
 */
- (CXIMConversation *)createConversationForChatter:(NSString *)chatter displayName:(NSString *)displayName type:(CXIMMessageType)type;

/**
 *  获取会话列表
 *
 *  @return 会话列表
 */
- (NSArray *)loadConversations;

/**
 *  移除会话
 *
 *  @param conversationId 会话id
 *
 *  @return 是否成功
 */
- (BOOL)removeConversationForId:(NSString *)conversationId;

/**
 *  获取会话
 *
 *  @param chatter 聊天人
 *
 *  @return 是否成功
 */
- (CXIMConversation *)loadConversationForChatter:(NSString *)chatter;

/**
 *  移除会话（包括消息）
 *
 *  @param chatter 聊天对象
 *
 *  @return 是否成功
 */
- (BOOL)removeConversationForChatter:(NSString *)chatter;

/** 移除所有会话 */
- (BOOL)removeAllConversations;

/**
 *  通过消息id获取会话
 *
 *  @param messageId 消息id
 *
 *  @return 会话对象
 */
- (CXIMConversation *)loadConversationWithMessageId:(NSString *)messageId;

#pragma mark - 消息
/**
 *  @author lancely, 16-06-12 10:06:04
 *
 *  更新消息体
 *
 *  @param message 消息对象
 *
 *  @return 是否成功
 */
- (BOOL)updateMessageBody:(CXIMMessage *)message;

/**
 *  保存消息
 *
 *  @param message 消息对象
 *
 *  @return 是否成功
 */
- (BOOL)saveMessage:(CXIMMessage *)message;

/**
 *  删除单条消息
 *
 *  @param messageId 消息id
 *
 *  @return 是否成功
 */
- (BOOL)removeMessageForId:(NSString *)messageId;

/**
 *  获取消息记录
 *
 *  @param chatter  聊天对象
 *  @param sendTime 发送时间
 *  @param limit    获取条数
 *
 *  @return 消息记录
 */
- (NSArray *)loadMessagesForChatter:(NSString *)chatter beforeTime:(NSNumber *)sendTime limit:(NSUInteger)limit;

/**
 *  获取消息记录
 *
 *  @param chatter  聊天对象
 *  @param sendTime 发送时间
 *
 *  @return 消息记录
 */
- (NSArray *)loadMessagesForChatter:(NSString *)chatter afterTime:(NSNumber *)sendTime;

/**
 *  设置消息状态
 *
 *  @param status    状态
 *  @param messageId 消息id
 *  @param sendTime  发送时间
 *
 *  @return 是否成功
 */
/**
 *  设置消息状态为成功
 *
 *  @param status          状态
 *  @param localMessageId  本地消息id
 *  @param serverMessageId 服务器消息id
 *  @param serverSendTime  服务器消息时间
 *
 *  @return 是否成功
 */
- (BOOL)setMessageStatusSendSuccessForlocalMessageId:(NSString *)localMessageId serverMessageId:(NSString *)serverMessageId serverSendTime:(NSNumber *)serverSendTime;

- (BOOL)setMessageStatusSendFailedForId:(NSString *)messageId;

/**
 *  设置消息为已读
 *
 *  @param chatter 聊天对象
 *  @param msgIds  已读消息
 *
 *  @return 是否成功
 */
- (BOOL)setMessagesReadedForChatter:(NSString *)chatter;


/**
 设置消息为已打开状态

 @param chatter 聊天对象
 @param msgIds  已打开的消息

 @return 是否成功
 */
- (BOOL)setMessagesOpenedForChatter:(NSString *)chatter msgIds:(NSArray<NSString *> *)msgIds;

/**
 *  更新已读回执（对方已读）
 *
 *  @param chatter 会话人
 *  @param msgIds  已读消息
 *
 *  @return 是否成功
 */
- (BOOL)setMessagesReadedAskForChatter:(NSString *)chatter msgIds:(NSArray<NSString *> *)msgIds;

/**
 *  清除消息（但不清除会话）
 *
 *  @param chatter 聊天对象
 *
 *  @return 是否成功
 */
- (BOOL)removeMessagesForChatter:(NSString *)chatter;

/**
 *  搜索消息
 *
 *  @param content 内容
 *
 *  @return 结果
 */
- (NSArray<CXIMMessage *> *)searchMessagesByContent:(NSString *)content;

/**
 *  @author lancely, 16-06-13 16:06:12
 *
 *  获取会话人最后一条消息
 *
 *  @param chatter 会话人
 *
 *  @return 消息对象
 */
- (CXIMMessage *)getLatestMessageFromChatter:(NSString *)chatter;

/**
 *  获取所有未读消息
 *
 *  @param chatter 会话人
 *
 *  @return 未读消息
 */
- (NSArray<CXIMMessage *> *)getUnreadMessagesForChatter:(NSString *)chatter;

/**
 *  根据消息id获取消息
 *
 *  @param messageId 消息id
 *
 *  @return 消息对象
 */
- (CXIMMessage *)getMessageById:(NSString *)messageId;

#pragma mark - 群组
/**
 *  从数据库获取群组信息
 *
 *  @return 群组信息
 */
- (NSArray<CXGroupInfo *> *)loadGroupsFromDB;

- (BOOL)saveGroups:(NSArray *)groups;

/**
 *  保存群组信息
 *
 *  @param group 群组信息
 *
 *  @return 是否成功
 */
- (BOOL)saveGroup:(CXGroupInfo *)group;

/**
 *  获取群组信息
 *
 *  @param groupId 群组id
 *
 *  @return 群组信息
 */
- (CXGroupInfo *)loadGroupForId:(NSString *)groupId;

/**
 *  删除群组
 *
 *  @param groupId 群组id
 *
 *  @return 是否成功
 */
- (BOOL)removeGroupForId:(NSString *)groupId;

/**
 *  更新群组名称
 *
 *  @param groupName 新的群组名称
 *  @param groupId   群组id
 *
 *  @return 是否成功
 */
- (BOOL)updateGroupName:(NSString *)groupName forId:(NSString *)groupId;

/**
 *  屏蔽群
 *
 *  @param groupId 群组id
 *
 *  @return 是否成功
 */
- (BOOL)shieldGroupForId:(NSString *)groupId;

/**
 *  解除屏蔽群
 *
 *  @param groupId 群组id
 *
 *  @return 是否成功
 */
- (BOOL)unshieldGroupForId:(NSString *)groupId;

/**
 *  获取屏蔽列表
 *
 *  @return 屏蔽列表(groupId数组)
 */
- (NSArray<NSString *> *)loadShieldList;

/**
 *  添加群成员
 *
 *  @param newMembers 新成员
 *  @param groupId    群组id
 *
 *  @return 是否成功
 */
- (BOOL)addMembers:(NSArray<CXGroupMember *> *)newMembers forGroup:(NSString *)groupId;

/**
 *  移除群成员
 *
 *  @param membersId 要移除的群成员id数组
 *  @param groupId   群组id
 *
 *  @return 是否成功
 */
- (BOOL)removeMembers:(NSArray<NSString *> *)membersId forGroup:(NSString *)groupId;

#pragma mark - 通话
/**
 *  获取通话记录
 *
 *  @return 通话记录
 */
- (NSArray<CXIMCallRecord *> *)loadCallRecords;

/**
 *  保存通话记录
 *
 *  @param record 通话记录
 *
 *  @return 是否成功
 */
- (BOOL)saveCallRecord:(CXIMCallRecord *)record;

/**
 *  移除通话记录
 *
 *  @param recordId 记录id
 *
 *  @return 是否成功
 */
- (BOOL)removeCallRecordForId:(NSNumber *)recordId;

/**
 *  设置通话记录已响应
 *
 *  @param recordId 记录id
 *
 *  @return 是否成功
 */
- (BOOL)setCallRecordResponded:(NSNumber *)recordId;

#pragma mark - 属性
@property (nonatomic, strong) RKFMDatabase *db;

@end
