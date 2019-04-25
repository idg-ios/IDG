//
//  CXIMVoiceMessageBody.h
//  SDIMLib
//
//  Created by cheng on 16/8/5.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIMFileMessageBody.h"

/** 语音消息体 */
@interface CXIMVoiceMessageBody : CXIMFileMessageBody

/** 语音是否已读 */
@property (nonatomic, assign, getter=isVoiceReaded) BOOL voiceReaded;

/**
 *  语音消息体的初始化方法
 *
 *  @param voicePath 语音路径
 *  @param duration  时长
 *
 *  @return 语音消息体
 */
+ (instancetype)bodyWithVoicePath:(NSString *)voicePath duration:(NSNumber *)duration;

@end
