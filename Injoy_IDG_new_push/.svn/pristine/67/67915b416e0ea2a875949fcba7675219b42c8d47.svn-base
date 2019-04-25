//
//  WebRTCHelper.h
//  WebScoketTest
//
//  Created by 涂耀辉 on 17/3/1.
//  Copyright © 2017年 涂耀辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "RTCMediaStream.h"
#import "RTCPeerConnectionFactory.h"
#import "RTCPeerConnection.h"
#import "RTCPair.h"
#import "RTCMediaConstraints.h"
#import "RTCAudioTrack.h"
#import "RTCVideoTrack.h"
#import "RTCVideoCapturer.h"
#import "RTCSessionDescription.h"
#import "RTCSessionDescriptionDelegate.h"
#import "RTCEAGLVideoView.h"
#import "RTCICEServer.h"
#import "RTCVideoSource.h"
#import "RTCAVFoundationVideoSource.h"
#import "RTCICECandidate.h"
#import <AVFoundation/AVFoundation.h>

@protocol WebRTCHelperDelegate;

@interface WebRTCHelper : NSObject<SRWebSocketDelegate>

// 声音播放模式
typedef NS_ENUM(NSInteger,SDMediaCallAudioPlayMode){
    //使用扬声器播放声音
    SDMediaCallAudioPlayModeLoudSpeaker,
    //使用听筒播放声音
    SDMediaCallAudioPlayModeEarphone
};

//本地声音流,暴漏出来设置静音与否用
@property (nonatomic, strong) RTCAudioTrack *localAudioTrack;
//本地视频流,暴漏出来设置摄像头与否打开
@property (nonatomic, strong) RTCVideoTrack *localVideoTrack;

//声音播放模式
@property (nonatomic) SDMediaCallAudioPlayMode audioPlayMode;

+ (instancetype)sharedInstance;

@property (nonatomic, weak)id<WebRTCHelperDelegate> delegate;

-(NSString *)getIMAccountWithSocketId:(NSString *)socketId;
-(void)camareChangeWithPreferringPosition:(AVCaptureDevicePosition)position;
/**
 *  与服务器建立连接
 *
 *  @param server 服务器地址
    @pram  port   端口号
 *  @param room   房间号
 */
- (void)connectServer:(NSString *)server port:(NSString *)port room:(NSString *)room;
/**
 *  退出房间
 */
- (void)exitRoom;
@end

@protocol WebRTCHelperDelegate <NSObject>

@optional
- (void)webRTCHelper:(WebRTCHelper *)webRTChelper setLocalStream:(RTCMediaStream *)stream userId:(NSString *)userId;
- (void)webRTCHelper:(WebRTCHelper *)webRTChelper addRemoteStream:(RTCMediaStream *)stream userId:(NSString *)userId;
- (void)webRTCHelper:(WebRTCHelper *)webRTChelper closeWithUserId:(NSString *)userId;

@end
