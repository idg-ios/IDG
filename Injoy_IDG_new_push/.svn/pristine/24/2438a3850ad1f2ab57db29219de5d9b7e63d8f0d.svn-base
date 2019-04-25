//
//  SDWebRTCHelper.h
//  SDIMApp
//
//  Created by wtz on 2018/8/25.
//  Copyright © 2018年 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/WebRTC.h>


@class SDWebRTCHelper;
@class RTCMediaStream;

@protocol SDWebRTCHelperDelegate <NSObject>

@optional
- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper setLocalStream:(RTCMediaStream *)stream connectionID:(NSString *)connectionID;
- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper addRemoteStream:(RTCMediaStream *)stream connectionID:(NSString *)connectionID;
- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper removeConnection:(NSString *)connectionID;

@end

@interface SDWebRTCHelper : NSObject
@property (nonatomic, strong) RTCMediaStream *localStream; /**< 本地流 */
@property (nonatomic, strong) RTCVideoTrack *videoTrack;/** 视频流 */
@property (nonatomic, strong) RTCAudioTrack *audioTrack; /** 音频流 */
@property (nonatomic, weak) id <SDWebRTCHelperDelegate> delegate;

+ (instancetype)shareInstance;

- (void)connect:(NSString *)host port:(NSString *)port room:(NSString *)room;
- (void)close;
/** 前后摄像头切换 */
-(void)camareChangeWithIsBackCamare:(BOOL)isBackCamare;
-(NSString *)getIMAccountWithSocketId:(NSString *)socketId;
@end

