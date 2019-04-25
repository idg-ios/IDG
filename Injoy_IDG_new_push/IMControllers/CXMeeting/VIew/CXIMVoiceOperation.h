//
//  CXIMVoiceOperation.h
//  SDMarketingManagement
//
//  Created by Rao on 16/4/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXIMMessage.h"
#import <Foundation/Foundation.h>

@protocol CXIMVoiceOperationDelegate <NSObject>
@optional
/// 播放语音
- (void)playMessage:(CXIMMessage*)message;
/// 停止播放
- (void)playStoped;
@end

@interface CXIMVoiceOperation : NSOperation
- (instancetype)initWithMessageModel:(CXIMMessage*)model;
@property (weak, nonatomic) id<CXIMVoiceOperationDelegate> voiceOperationDelegate;
@end
