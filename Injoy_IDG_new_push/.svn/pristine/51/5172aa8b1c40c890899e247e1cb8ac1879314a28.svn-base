//
//  CXIMChatManager.h
//  CXIMLib
//
//  Created by lancely on 7/18/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIMConversation.h"
#import "CXIMCallRecord.h"
#import "CXIM-Singleton.h"
#import "CXUserInfo.h"
#import "CXGroupInfo.h"
@class CXIMService;

typedef void(^SendMessageCompletionBlock)(CXIMMessage *message, NSError *error);

#pragma mark - protocol
@protocol CXIMChatDelegate <NSObject>

@optional

/**
 *  消息发送成功
 *
 *  @param service CXIMService对象
 *  @param message 消息
 */
- (void)CXIMService:(CXIMService *)service didSendMessageSuccess:(CXIMMessage *)message;

/**
 *  收到聊天消息
 *
 *  @param service CXIMService对象
 *  @param message 消息
 */
- (void)CXIMService:(CXIMService *)service didReceiveChatMessage:(CXIMMessage *)message;

/**
 *  被挤下线
 *
 *  @param service CXIMService对象
 */
- (void)CXIMServiceDidReceiveOfflineMessage:(CXIMService *)service;

/**
 *  收到通话消息
 *
 *  @param service CXIMService对象
 *  @param message 通话消息
 */
- (void)CXIMService:(CXIMService *)service didReceiveMediaCallMessage:(CXIMMessage *)message;

/**
 *  收到通话响应
 *
 *  @param service  CXIMService对象
 *  @param response 响应 (keys:@"from",@"status",@"type")
 */
- (void)CXIMService:(CXIMService *)service didReceiveMediaCallResponse:(NSDictionary *)response;

/**
 *  收到对方不在线的通话响应
 *
 *  @param service  CXIMService对象
 *  @param response 响应
 */
- (void)CXIMService:(CXIMService *)service didReceiveMediaCallOfflineResponse:(NSDictionary *)response;

/**
 *  收到已读回执
 *
 *  @param service    CXIMService对象
 *  @param chatter    会话人
 *  @param messageIds 消息
 */
- (void)CXIMService:(CXIMService *)service didReceiveReadAsksOfChatter:(NSString *)chatter messages:(NSArray<CXIMMessage *> *)messages;

@end


#pragma mark - interface
@interface CXIMChatManager : NSObject

singleton_interface(CXIMChatManager)

#pragma mark 会话相关
/**
 *  获取所有会话
 *
 *  @return 会话列表
 */
- (NSArray<CXIMConversation *> *)loadConversations;

/**
 *  移除会话
 *
 *  @param conversationId 会话id
 *
 *  @return 是否成功
 */
- (BOOL)removeConversationForId:(NSString *)conversationId;

/**
 *  根据聊挑人移除会话
 *
 *  @param chatter 聊天人
 *
 *  @return 是否成功
 */
- (BOOL)removeConversationForChatter:(NSString *)chatter;

/**
 *  移除所有会话
 *
 *  @return 是否成功
 */
- (BOOL)removeAllConversations;

/**
 *  根据消息id获取会话
 *
 *  @param messageId 消息id
 *
 *  @return 会话对象
 */
- (CXIMConversation *)loadConversationWithMessageId:(NSString *)messageId;

#pragma mark 消息相关
- (NSArray *)loadMessagesForChatter:(NSString *)chatter beforeTime:(NSNumber *)sendTime limit:(NSUInteger)limit;

- (NSArray *)loadMessagesForChatter:(NSString *)chatter afterTime:(NSNumber *)sendTime;

/**
 *  删除消息（不删除会话）
 *
 *  @param chatter 会话人
 *
 *  @return 是否成功
 */
- (BOOL)removeMessagesForChatter:(NSString *)chatter;

/**
 *  移除单条消息
 *
 *  @param messageId 消息id
 *
 *  @return 是否成功
 */
- (BOOL)removeMessageForId:(NSString *)messageId;

/**
 *  保存消息到数据库
 *
 *  @param message 消息对象
 *
 *  @return 是否成功
 */
- (BOOL)saveMessageToDB:(CXIMMessage *)message;

/**
 *  搜索消息
 *
 *  @param content 消息内容
 *
 *  @return 消息列表
 */
- (NSArray<CXIMMessage *> *)searchMessagesByContent:(NSString *)content;

/**
 *
 *  更新消息体
 *
 *  @param message 消息对象
 *
 *  @return 是否成功
 */
- (BOOL)updateMessageBody:(CXIMMessage *)message;

/**
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
 设置消息为已读

 @param chatter 会话人

 @return 是否成功
 */
- (BOOL)setMessagesReadedForChatter:(NSString *)chatter;

#pragma mark 通话记录相关
/**
 *  获取通话记录
 *
 *  @return 通话记录
 */
- (NSArray<CXIMCallRecord *> *)loadCallRecords;

/**
 *  移除通话记录
 *
 *  @param recordId 记录id
 *
 *  @return 是否成功
 */
- (BOOL)removeCallRecordForId:(NSNumber *)recordId;

/**
 *  删除所有通话记录
 *
 *  @return 是否成功
 */
- (BOOL)removeAllCallRecords;

/**
 *  根据chatter删除通话记录
 *
 *  @param chatter 聊天人
 *
 *  @return 是否成功
 */
- (BOOL)removeCallRecordsForChatter:(NSString *)chatter;

/**
 *  保存通话记录
 *
 *  @param record 通话记录
 *
 *  @return 是否成功
 */
- (BOOL)saveCallRecord:(CXIMCallRecord *)record;

/**
 *  设置通话记录已响应
 *
 *  @param recordId 记录id
 *
 *  @return 是否成功
 */
- (BOOL)setCallRecordResponded:(NSNumber *)recordId;

#pragma mark - 媒体通话

- (void)sendMediaCallResponseWithType:(CXIMMediaCallType)type status:(CXIMMediaCallStatus)status receiver:(NSString *)receiver;
- (void)sendMediaCallOfferWithType:(CXIMMediaCallType)type receiver:(NSString *)receiver sdp:(NSDictionary *)sdp;
- (void)sendMediaCallCandidateWithType:(CXIMMediaCallType)type receiver:(NSString *)receiver candidateInfo:(NSDictionary *)candidateInfo;
- (void)sendMediaCallAnswerWithType:(CXIMMediaCallType)type receivr:(NSString *)receiver sdp:(NSDictionary *)sdp;

#pragma mark 服务器通信


/**
 *  发送消息
 *
 *  @param message         消息对象
 *  @param completionBlock 回调
 */
- (void)sendMessage:(CXIMMessage *)message onProgress:(void(^)(float))progress completion:(SendMessageCompletionBlock)completionBlock;

/**
 *  重发消息
 *
 *  @param message 消息对象
 */
- (void)resendMessage:(CXIMMessage *)message;

/**
 *  收到服务器消息
 *
 *  @param message 服务器返回的消息体
 */
- (void)receiveServerMessage:(NSString *)message;

/** 请求离线消息 */
- (void)requestOfflineMessage;

/**
 *  发送消息已读回执
 *
 *  @param chatter 会话人
 */
- (void)sendMessageReadAskForChatter:(NSString *)chatter messageIds:(NSArray<NSString *> *)messageIds;

/**
 *  获取公司成员
 *
 *  @param companyId       公司id
 *  @param completionBlock 回调
 */
- (void)getUsersWithCompanyId:(NSString *)companyId completion:(void(^)(NSArray<CXUserInfo *> *users, NSError *error))completionBlock;

#pragma mark 搜索
/**
 *  根据关键字和page从服务器获取相应的通话记录
 *
 *  @param keyArray 搜索关键字：IM帐号数组，格式:[xxx,xxx]
 *
 *  @param page 服务器通话记录的页码数
 *
 *  @return 通话记录数组
 */
- (void)getCallRecordsWithSearchKeyArray:(NSArray *)keyArray AndPageNumber:(NSInteger)page completion:(void (^)(NSArray<CXIMCallRecord *> *records, NSString *currentPage, NSError *error))completionBlock;

/**
 *  根据关键字和page从服务器获取相应的语音会议
 *
 *  @param key 搜索关键字
 *
 *  @param page 服务器语音会议的页码数
 *
 *  @return 语音会议数组
 */
- (void)getVoiceConferencesWithSearchKey:(NSString *)key AndPageNumber:(NSInteger)page completion:(void (^)(NSArray<CXGroupInfo *> *groups, NSString *currentPage, NSError *error))completionBlock;


/**
 *  根据关键字和选择的人以及page从服务器获取相应的聊天记录列表
 *
 *  @param key 搜索关键字
 *
 *  @param chatter 聊天对象IM帐号
 *
 *  @param type 类型:2=群聊, !2=单聊
 *
 *  @param page 服务器聊天的页码数
 *
 *  @return 聊天记录数组
 */
- (void)getChatMessagesWithSearchKey:(NSString *)key Chatter:(NSString *)chatter Type:(CXIMMessageType)type AndPageNumber:(NSInteger)page completion:(void (^)(NSArray<CXIMMessage *> *messages, NSString *currentPage, NSError *error))completionBlock;

/**
 *  根据单聊对象IM帐号,lastTime,type以及page从服务器获取相应的聊天记录详情
 *
 *  @param lastTime 最后一条消息的时间戳
 *
 *  @param chatter 聊天对象IM帐号
 *
 *  @param type 类型:2=上拉, !2=下拉
 *
 *  @param page 服务器通话记录的页码数
 *
 *  @return 聊天记录数组
 */
- (void)getSingleChatMessagesWithLastTime:(NSNumber *)lastTime Chatter:(NSString *)chatter Type:(NSInteger)type AndPageNumber:(NSInteger)page completion:(void (^)(NSArray<CXIMMessage *> *messages, NSString *currentPage, NSError *error))completionBlock;

/**
 *  根据群组groupid,lastTime,type,all以及page从服务器获取相应的聊天记录详情
 *
 *  @param lastTime 最后一条消息的时间戳
 *
 *  @param chatter 聊天对象IM帐号
 *
 *  @param type 类型:2=上拉, !2=下拉
 *
 *  @param all 是否查全部，默认是否
 *
 *  @param page 服务器通话记录的页码数
 *
 *  @return 聊天记录数组
 */
- (void)getGroupChatMessagesWithLastTime:(NSNumber *)lastTime Chatter:(NSString *)chatter Type:(NSInteger)type LoadAll:(BOOL)all AndPageNumber:(NSInteger)page completion:(void (^)(NSArray<CXIMMessage *> *messages, NSString *currentPage, NSError *error))completionBlock;

#pragma mark 代理处理
- (void)addDelegate:(id<CXIMChatDelegate>)delegate;

- (void)removeDelegate:(id<CXIMChatDelegate>)delegate;

#pragma mark - 属性
/** 当前账号 */
@property (nonatomic, copy, readonly) NSString *currentAccount;

@end
