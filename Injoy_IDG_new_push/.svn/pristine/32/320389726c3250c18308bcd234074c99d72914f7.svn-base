//
//  LCVoice.m
//  LCVoiceHud
//
//  Created by 郭历成 on 13-6-21.
//  Contact titm@tom.com
//  Copyright (c) 2013年 Wuxiantai Developer Team.(http://www.wuxiantai.com) All rights reserved.
//

#import "LCVoice.h"
#import "LCVoiceHud.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - <DEFINES>

#define WAVE_UPDATE_FREQUENCY   0.05

#pragma mark - <CLASS> LCVoice

@interface LCVoice () <AVAudioRecorderDelegate>
{
    NSTimer * timer_;
    
    LCVoiceHud * voiceHud_;
}

@property(nonatomic,retain) AVAudioRecorder * recorder;

@end

@implementation LCVoice

-(void) dealloc{
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
    self.recordPath = nil;
    
    
}

#pragma mark - Publick Function

-(void)startRecordWithPath:(NSString *)path
{    
//    NSError * err = nil;
//    
//	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//	[audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
//	[audioSession setActive:YES error:&err];
//	
//	 NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 44100.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 2], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];
//
//	self.recordPath = path;
//	NSURL * url = [NSURL fileURLWithPath:self.recordPath];
//	
//	err = nil;
//	
//	NSData * audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
//    
//	if(audioData)
//	{
//		NSFileManager *fm = [NSFileManager defaultManager];
//		[fm removeItemAtPath:[url path] error:&err];
//	}
//	
//	err = nil;
//    
//    if(self.recorder){[self.recorder stop];self.recorder = nil;}
//    
//	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&err];
//	
//	[_recorder setDelegate:self];
//	[_recorder prepareToRecord];
//	_recorder.meteringEnabled = YES;
    
    self.recordPath = path;
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:11025.0] ,AVSampleRateKey,
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数默认 16
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,//通道的数目
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端是内存的组织方式
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];//采样信号是整数还是浮点数
    NSFileManager *filemanage=[NSFileManager defaultManager];
    [filemanage removeItemAtURL:[NSURL URLWithString:self.recordPath] error:nil];
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.recordPath] settings:recordSetting error:nil];
    _recorder.delegate=self;
    [_recorder prepareToRecord];
    [_recorder record];
    
    self.recordTime = 0;
    [self resetTimer];
    [_recorder record];
    
	timer_ = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    
    [self showVoiceHudOrHide:YES];

}

-(void) stopRecordWithCompletionBlock:(void (^)())completion
{    
    dispatch_async(dispatch_get_main_queue(),completion);

    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self.recorder stop];
    [self resetTimer];
    [self showVoiceHudOrHide:NO];
}

#pragma mark - Timer Update

- (void)updateMeters {
    
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    
    if (voiceHud_)
    {
        /*  发送updateMeters消息来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        
        if (_recorder) {
            [_recorder updateMeters];
        }
    
        float peakPower = [_recorder averagePowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    
        [voiceHud_ setProgress:peakPowerForChannel];
    }
}

#pragma mark - Helper Function

-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
    
    if (voiceHud_) {
        [voiceHud_ hide];
        voiceHud_ = nil;
    }
    
    if (yesOrNo) {
        
        voiceHud_ = [[LCVoiceHud alloc] init];
        [voiceHud_ show];
        
    }else{
        
    }
}

-(void) resetTimer
{    
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

-(void) cancelRecording
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;    
}

- (void)cancelled {
    
    [self showVoiceHudOrHide:NO];
    [self resetTimer];
    [self cancelRecording];
}

#pragma mark - LCVoiceHud Delegate

-(void) LCVoiceHudCancelAction
{
    [self cancelled];
}

@end
