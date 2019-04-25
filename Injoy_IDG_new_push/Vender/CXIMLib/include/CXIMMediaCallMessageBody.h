//
//  CXIMMediaCallMessageBody.h
//  CXIMLib
//
//  Created by lancely on 3/2/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "CXIMMessageBody.h"

typedef NS_ENUM(NSInteger,CXIMMediaCallType){
    CXIMMediaCallTypeAudio = 0, // 语音通话
    CXIMMediaCallTypeVideo = 1 // 视频通话
};

typedef NS_ENUM(NSInteger,CXIMMediaCallStatus){
    CXIMMediaCallStatusUserExit = 100, // 表示发起方中断连接 接收方还没有接受和拒绝的时候
    CXIMMediaCallStatusBusy = 101, // 表示发起方和接收方正在通话 第三方请求时返回正忙的请求
    CXIMMediaCallStatusHangup = 102, // 挂断
    CXIMMediaCallStatusRequest = 103, // 发起请求
    CXIMMediaCallStatusAgree = 104, // 同意
    CXIMMediaCallStatusDisagree = 105 // 拒绝
};

@interface CXIMMediaCallMessageBody : CXIMMessageBody

//@property (nonatomic,assign) CXIMMediaCallType type;
@property (nonatomic,copy) NSString *event;
@property (nonatomic,copy) NSDictionary *data;

//+ (instancetype)bodyWithType:(CXIMMediaCallType)type event:(NSString *)event data:(NSDictionary *)data;
+ (instancetype)bodyWithEvent:(NSString *)event data:(NSDictionary *)data;

@end
