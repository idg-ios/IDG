//
//  CXIMVoiceConferenceDDXDetailViewController.h
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

typedef NS_ENUM(NSInteger,VoiceConferenceType){
    /// 录制语音
    recordingVoice = 1,
    /// 播放语音
    playVoice = 2
};

@interface CXIMVoiceConferenceDDXDetailViewController : SDRootViewController

- (instancetype)initWithVoiceConferenceType:(VoiceConferenceType)type groupInfo:(CXGroupInfo*)groupInfo;

@end
