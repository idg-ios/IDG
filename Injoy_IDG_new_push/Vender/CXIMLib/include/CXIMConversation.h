//
//  CXIMConversation.h
//  CXIMLib
//
//  Created by lancely on 1/27/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIMMessage.h"

@interface CXIMConversation : NSObject

/**
 *  会话id
 */
@property (nonatomic, assign) NSInteger ID;

/**
 * 会话人
 */
@property (nonatomic, copy) NSString *chatter;

/**
 *  消息类型
 */
@property (nonatomic, assign) CXIMMessageType type;

/**
 *  未读数量
 */
@property (nonatomic, assign) NSInteger unreadNumber;

/**
 *  会话的最后一条消息
 */
@property (nonatomic, strong) CXIMMessage *latestMessage;

/**
 *  是否是语音会议
 */
@property (nonatomic, assign) BOOL isVoiceConference;

@end
