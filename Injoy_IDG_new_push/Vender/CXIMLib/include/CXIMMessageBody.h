//
//  CXIMMessageBody.h
//  CXIMLib
//
//  Created by lancely on 2/18/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 内容类型
 */
typedef NS_ENUM(NSInteger,CXIMMessageContentType){
    CXIMMessageContentTypeText = 1, // 文字
    CXIMMessageContentTypeImage = 2, // 图片
    CXIMMessageContentTypeVoice = 3, // 声音
    CXIMMessageContentTypeVideo = 4, // 视频
    CXIMMessageContentTypeFile = 5, // 文件
    CXIMMessageContentTypeLocation = 6, // 位置
    CXIMMessageContentTypeMediaCall = 20, // 语音通话 / 视频通话
    CXIMMessageContentTypeSystemNotify = 99, // 通知
};

/**
 *  基类
 */
@interface CXIMMessageBody : NSObject

/** 消息体类型 */
@property(nonatomic, assign, readonly) CXIMMessageContentType type;

@end
