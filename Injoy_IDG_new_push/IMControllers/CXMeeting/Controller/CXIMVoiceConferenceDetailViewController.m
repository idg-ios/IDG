//
//  CXIMVoiceConferenceDetailViewController.m
//  InjoyCRM
//
//  Created by wtz on 16/8/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXIMVoiceConferenceDetailViewController.h"
#import "CXIMVoiceConferenceInfomationViewController.h"
#import "CXIMVoiceOperation.h"
#import "CXRecordView.h"
#import "PlayerManager.h"
#import "RecorderManager.h"
#import "SDContactsDetailController.h"
#import "SDDataBaseHelper.h"
#import "SDSocketCacheManager.h"
#import "SDVoiceManager.h"
#import "SDWebSocketManager.h"
#import "SDWebSocketModel.h"
#import "UIImageView+EMWebCache.h"
#import "YYModel.h"
#import "CXIMHelper.h"
#import "UIView+Category.h"
#import <AVFoundation/AVFoundation.h>

#define kBottomViewHeight 220

#define kTitleLeftSpace 35

#define kTitleTopSpace 15

#define kTitleMiddleSpace 5

#define kHeadImageViewWidth 85

#define kTitleFont 18

#define kProgressViewLeftLabelLeftSpace 15

#define kTouchDownSpeakTipLabelTop 20

#define kRecordPressBtnWidth 70

#define kRecordPressBtnAndTouchDownSpeakTipLabelSpace 22

#define kStartProgressLabelLeftSpace 20

#define kStartProgressLabelRightSpace 20

@interface CXIMVoiceConferenceDetailViewController()<UIAlertViewDelegate, CXIMChatDelegate, RecordingDelegate, PlayingDelegate, CXIMVoiceOperationDelegate>

/// 主题
@property (strong, nonatomic) UILabel* subjectLabel;
/// 创建人
@property (strong, nonatomic) UILabel* ownerLabel;
/// 时间
@property (strong, nonatomic) UILabel* createTimeLabel;
/// 头像
@property (strong, nonatomic) UIImageView* userHeadImageView;
/// 当前讲话的用户
@property (strong, nonatomic) UILabel* currentSpeakingUserLabel;
/// 讲话提示
@property (strong, nonatomic) UILabel* speakTipLabel;
/// 语音提示
@property (strong, nonatomic) UILabel* voiceTipLabel;
/// 录音按钮
@property (strong, nonatomic) UIButton* recordPressBtn;
/// 进度条起点
@property (strong, nonatomic) UILabel* startProgressLabel;
/// 进度条终点
@property (strong, nonatomic) UILabel* endProgressLabel;
/// 语音进度条
@property (strong, nonatomic) UIProgressView* voiceProgressView;
/// 顶部View
@property (strong, nonatomic) UIView* topView;
/// 下方View
@property (strong, nonatomic) UIView* downView;
/// 是否完成播放语音
@property (nonatomic) BOOL isFinish;
/// 播放按钮是否选中
@property (nonatomic) BOOL isSelect;
/// 是否有暂停
@property (nonatomic) BOOL isPause;
/// 导航条
@property (strong, nonatomic) SDRootTopView* rootTopView;
/// 录制还是播放
@property (assign, nonatomic) VoiceConferenceType currentType;
/// 语音会议信息
@property (strong, nonatomic) CXGroupInfo* groupDetailInfo;
/// 录音视图
@property (strong, nonatomic) CXRecordView* recordView;
/// 播放队列
@property (strong, nonatomic) NSOperationQueue* myQueue;
/// 播放一个提示音
@property (strong, nonatomic) AVAudioPlayer* ringPlayer;
/// 刷新播放进度条的定时器
@property (strong, nonatomic) NSTimer* timer;
/// 数据源
@property (strong, nonatomic) NSArray* dataSourceArr;
/// 进度条百分比
@property (nonatomic) double proValue;
/// 用来判断是否在当前页面
@property (nonatomic) BOOL isInCurrentViewController;

@end

@implementation CXIMVoiceConferenceDetailViewController

static NSString* observeKeyPath = @"operations";

#pragma mark - 初始化
- (instancetype)initWithVoiceConferenceType:(VoiceConferenceType)type groupInfo:(CXGroupInfo*)groupInfo
{
    if (self = [super init]) {
        self.currentType = type;
        self.groupDetailInfo = groupInfo;
        self.proValue = 0.0;
    }
    return self;
}

#pragma mark - 懒加载
/// 数据源
- (NSArray*)dataSourceArr
{
    if (nil == _dataSourceArr) {
        NSString* chatter = self.groupDetailInfo.groupId;
        NSArray* tempArr = [[CXIMService sharedInstance].chatManager loadMessagesForChatter:chatter beforeTime:nil limit:LONG_MAX];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"body.type == %d", CXIMMessageContentTypeVoice];
        _dataSourceArr = [tempArr filteredArrayUsingPredicate:predicate];
    }
    return _dataSourceArr;
}

/// 播放一个提示音
- (AVAudioPlayer*)ringPlayer
{
    if (nil == _ringPlayer) {
        NSString* musicPath = [[NSBundle mainBundle] pathForResource:@"play_completed" ofType:@"mp3"];
        NSURL* url = [[NSURL alloc] initFileURLWithPath:musicPath];
        
        _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [_ringPlayer setVolume:1];
        _ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
    }
    return _ringPlayer;
}

/// 录音视图
- (CXRecordView*)recordView
{
    if (nil == _recordView) {
        _recordView = [[CXRecordView alloc] initWithFrame:CGRectMake(0, 220, 160, 160)];
        _recordView.center = CGPointMake([self.view center].x, [self.view center].y + 20);
    }
    return _recordView;
}

- (NSOperationQueue*)myQueue
{
    if (nil == _myQueue) {
        _myQueue = [[NSOperationQueue alloc] init];
        [_myQueue setMaxConcurrentOperationCount:1];
        [_myQueue addObserver:self forKeyPath:observeKeyPath options:0 context:NULL];
    }
    return _myQueue;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RecorderManager sharedManager] setDelegate:(id<RecordingDelegate>)self];
    [RecorderManager sharedManager].filename = @"Voice.spx";
    [[CXIMService sharedInstance].chatManager addDelegate:self];
//    [[SDWebSocketManager shareWebSocketManager] setDelegate:(id<SDWebSocketManagerDelegate>)self];
    
    [self setUpNavBar];
    [self setUpSubview];
    self.recordPressBtn.enabled = NO;
    __weak typeof(&*self) weakSelf = self;
    [[CXIMService sharedInstance].groupManager getGroupDetailInfoWithGroupId:self.groupDetailInfo.groupId completion:^(CXGroupInfo* group, NSError* error) {
        if (!error) {
            weakSelf.groupDetailInfo = group;
            NSArray* tempArr = [[CXIMService sharedInstance].chatManager loadMessagesForChatter:self.groupDetailInfo.groupId beforeTime:nil limit:LONG_MAX];
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"body.type == %d", CXIMMessageContentTypeVoice];
            NSArray * offlineMessages = [tempArr filteredArrayUsingPredicate:predicate];
            __block int index = 0;
            if(offlineMessages && [offlineMessages count] > 0){
                [weakSelf showHudInView:weakSelf.view hint:@"正在获取离线消息"];
                for(CXIMMessage * message in offlineMessages){
                    CXIMFileMessageBody *body = (CXIMFileMessageBody *)message.body;
                    if ([body isFileExist]) {
                        index++;
                        if(index == [offlineMessages count]){
                            [weakSelf hideHud];
                            self.recordPressBtn.enabled = YES;
                            if (self.currentType == playVoice) {
                                // 播放语音
                                [self firstStartLoadAudioMessages];
                            }
                        }
                    }
                    else {
                        [message downloadFileWithProgress:^(float progress) {
                            
                        } completion:^(CXIMMessage *message, NSError *error) {
                            index++;
                            if(index == [offlineMessages count]){
                                [weakSelf hideHud];
                                self.recordPressBtn.enabled = YES;
                                if (self.currentType == playVoice) {
                                    // 播放语音
                                    [self firstStartLoadAudioMessages];
                                }
                            }
                        }];
                    }
                }
            }else{
                self.recordPressBtn.enabled = YES;
                if (self.currentType == playVoice) {
                    // 播放语音
                    [self firstStartLoadAudioMessages];
                }
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isInCurrentViewController = YES;
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isInCurrentViewController = NO;
    
    if (self.currentType == playVoice) {
        /// 关闭定时器
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
        
        [self.myQueue cancelAllOperations];
        
        self.proValue = 0.f;
        self.voiceProgressView.progress = 0.f;
        self.userHeadImageView.hidden = YES;
        self.currentSpeakingUserLabel.hidden = YES;
        self.speakTipLabel.hidden = YES;
        self.recordView.hidden = YES;
        [self.recordPressBtn setSelected:NO];
        self.isSelect = NO;
        self.isFinish = YES;
    }
    
    [[PlayerManager sharedManager] stopPlaying];
    [[PlayerManager sharedManager].avAudioPlayer stop];
    [[PlayerManager sharedManager].decapsulator stopPlaying];
    [[PlayerManager sharedManager].decapsulator setDelegate:nil];
    [[PlayerManager sharedManager] setDelegate:nil];
    [self.ringPlayer stop];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
}

- (void)dealloc
{
    [[CXIMService sharedInstance].chatManager removeDelegate:self];
    [_myQueue removeObserver:self forKeyPath:observeKeyPath];
}

#pragma mark - setUpUI
/// 设置导航条
- (void)setUpNavBar
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"语音会议"];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    if (self.currentType == playVoice) {
        // 播放
        [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"voiceGroupInfo.png"] addTarget:self action:@selector(rightDetailBtnClick)];
    }
    else if (self.currentType == recordingVoice) {
        // 录制语音
        if ([self.groupDetailInfo.owner isEqualToString:VAL_HXACCOUNT]) {
            [self.rootTopView setUpRightBarItemTitle:@"结束" addTarget:self action:@selector(finishBtnEvent:)];
        }
    }
}

- (void)setUpSubview
{
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - kBottomViewHeight);
    self.topView.backgroundColor = SDVoiceConferenceGrayColor;
    [self.view addSubview:self.topView];
    
    UILabel * subjectTitleLabel = [[UILabel alloc] init];
    subjectTitleLabel.text = @"主   题：";
    subjectTitleLabel.textAlignment = NSTextAlignmentLeft;
    subjectTitleLabel.font = [UIFont systemFontOfSize:kTitleFont];
    [subjectTitleLabel sizeToFit];
    subjectTitleLabel.frame = CGRectMake(kTitleLeftSpace, kTitleTopSpace, subjectTitleLabel.size.width, kTitleFont);
    subjectTitleLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:subjectTitleLabel];
    
    self.subjectLabel = [[UILabel alloc] init];
    self.subjectLabel.text = self.groupDetailInfo.groupName;
    self.subjectLabel.frame = CGRectMake(CGRectGetMaxX(subjectTitleLabel.frame) + kTitleMiddleSpace, kTitleTopSpace, Screen_Width - CGRectGetMaxX(subjectTitleLabel.frame) - kTitleLeftSpace - kTitleMiddleSpace, kTitleFont);
    self.subjectLabel.textAlignment = NSTextAlignmentLeft;
    self.subjectLabel.font = [UIFont systemFontOfSize:kTitleFont];
    self.subjectLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.subjectLabel];
    
    UILabel * ownerTitleLabel = [[UILabel alloc] init];
    ownerTitleLabel.text = @"主持人：";
    ownerTitleLabel.textAlignment = NSTextAlignmentLeft;
    ownerTitleLabel.font = [UIFont systemFontOfSize:kTitleFont];
    [ownerTitleLabel sizeToFit];
    ownerTitleLabel.frame = CGRectMake(kTitleLeftSpace, CGRectGetMaxY(subjectTitleLabel.frame) + kTitleTopSpace, ownerTitleLabel.size.width, kTitleFont);
    ownerTitleLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:ownerTitleLabel];
    
    self.ownerLabel = [[UILabel alloc] init];
    self.ownerLabel.text = [CXIMHelper getRealNameByAccount:self.groupDetailInfo.owner];
    self.ownerLabel.frame = CGRectMake(CGRectGetMinX(self.subjectLabel.frame), CGRectGetMaxY(self.subjectLabel.frame) + kTitleTopSpace, Screen_Width - 2*kTitleLeftSpace - kTitleMiddleSpace, kTitleFont);
    self.ownerLabel.textAlignment = NSTextAlignmentLeft;
    self.ownerLabel.font = [UIFont systemFontOfSize:kTitleFont];
    self.ownerLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.ownerLabel];
    
    UILabel * createTimeTitleLabel = [[UILabel alloc] init];
    createTimeTitleLabel.text = @"时   间：";
    createTimeTitleLabel.textAlignment = NSTextAlignmentLeft;
    createTimeTitleLabel.font = [UIFont systemFontOfSize:kTitleFont];
    [createTimeTitleLabel sizeToFit];
    createTimeTitleLabel.frame = CGRectMake(kTitleLeftSpace, CGRectGetMaxY(ownerTitleLabel.frame) + kTitleTopSpace, createTimeTitleLabel.size.width, kTitleFont);
    createTimeTitleLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:createTimeTitleLabel];
    
    self.createTimeLabel = [[UILabel alloc] init];
    self.createTimeLabel.text = [self.groupDetailInfo.createTime substringToIndex:10];
    self.createTimeLabel.frame = CGRectMake(CGRectGetMinX(self.subjectLabel.frame), CGRectGetMaxY(self.ownerLabel.frame) + kTitleTopSpace, Screen_Width - 2*kTitleLeftSpace - kTitleMiddleSpace, kTitleFont);
    self.createTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.createTimeLabel.font = [UIFont systemFontOfSize:kTitleFont];
    self.createTimeLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.createTimeLabel];
    
    self.userHeadImageView = [[UIImageView alloc] init];
    self.userHeadImageView.frame = CGRectMake((Screen_Width - kHeadImageViewWidth)/2, CGRectGetMaxY(self.createTimeLabel.frame) + kTitleTopSpace, kHeadImageViewWidth, kHeadImageViewWidth);
    [self.topView addSubview:self.userHeadImageView];
    
    self.currentSpeakingUserLabel = [[UILabel alloc] init];
    self.currentSpeakingUserLabel.frame = CGRectMake(0, CGRectGetMaxY(self.userHeadImageView.frame) + kTitleTopSpace, Screen_Width, kTitleFont);
    self.currentSpeakingUserLabel.font = [UIFont systemFontOfSize:kTitleFont];
    self.currentSpeakingUserLabel.textAlignment = NSTextAlignmentCenter;
    self.currentSpeakingUserLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.currentSpeakingUserLabel];
    
    self.speakTipLabel = [[UILabel alloc] init];
    self.speakTipLabel.frame = CGRectMake(0, CGRectGetMaxY(self.currentSpeakingUserLabel.frame) + kTitleTopSpace, Screen_Width, kTitleFont);
    self.speakTipLabel.font = [UIFont systemFontOfSize:kTitleFont];
    self.speakTipLabel.textAlignment = NSTextAlignmentCenter;
    self.speakTipLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.speakTipLabel];
    
    self.downView = [[UIView alloc] init];
    self.downView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), Screen_Width, kBottomViewHeight);
    self.downView.backgroundColor = SDVoiceConferenceGrayColor;
    [self.view addSubview:self.downView];
    
    self.voiceTipLabel = [[UILabel alloc] init];
    self.voiceTipLabel.frame = CGRectMake(0, kTouchDownSpeakTipLabelTop, Screen_Width, kTitleFont);
    self.voiceTipLabel.text = @"按住说话";
    self.voiceTipLabel.textAlignment = NSTextAlignmentCenter;
    self.voiceTipLabel.textColor = [UIColor whiteColor];
    [self.downView addSubview:self.voiceTipLabel];
    
    self.recordPressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordPressBtn.frame = CGRectMake((Screen_Width - kRecordPressBtnWidth)/2, CGRectGetMaxY(self.voiceTipLabel.frame) + kRecordPressBtnAndTouchDownSpeakTipLabelSpace, kRecordPressBtnWidth, kRecordPressBtnWidth);
    [self.recordPressBtn setImage:[UIImage imageNamed:@"recordNormal"] forState:UIControlStateNormal];
    [self.recordPressBtn setImage:[UIImage imageNamed:@"recordPress"] forState:UIControlStateHighlighted];
    [self.downView addSubview:self.recordPressBtn];
    
    self.startProgressLabel = [[UILabel alloc] init];
    self.startProgressLabel.text = @"0:00";
    self.startProgressLabel.font = [UIFont systemFontOfSize:kTitleFont];
    [self.startProgressLabel sizeToFit];
    self.startProgressLabel.frame = CGRectMake(kStartProgressLabelLeftSpace, kTouchDownSpeakTipLabelTop, self.startProgressLabel.size.width, kTitleFont);
    self.startProgressLabel.textAlignment = NSTextAlignmentLeft;
    self.startProgressLabel.textColor = [UIColor whiteColor];
    self.startProgressLabel.backgroundColor = [UIColor clearColor];
    [self.downView addSubview:self.startProgressLabel];
    
    self.endProgressLabel = [[UILabel alloc] init];
    self.endProgressLabel.text = @"0:00";
    self.endProgressLabel.font = [UIFont systemFontOfSize:kTitleFont];
    [self.endProgressLabel sizeToFit];
    self.endProgressLabel.frame = CGRectMake(Screen_Width - kStartProgressLabelLeftSpace - self.endProgressLabel.size.width, kTouchDownSpeakTipLabelTop, self.endProgressLabel.size.width, kTitleFont);
    self.endProgressLabel.textAlignment = NSTextAlignmentLeft;
    self.endProgressLabel.textColor = [UIColor whiteColor];
    self.endProgressLabel.backgroundColor = [UIColor clearColor];
    [self.downView addSubview:self.endProgressLabel];
    
    self.voiceProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.voiceProgressView.frame = CGRectMake(CGRectGetMaxX(self.startProgressLabel.frame) + kStartProgressLabelRightSpace, kTouchDownSpeakTipLabelTop + kTitleFont/2 - 3, Screen_Width - kStartProgressLabelLeftSpace - self.endProgressLabel.size.width - (CGRectGetMaxX(self.startProgressLabel.frame) + kStartProgressLabelRightSpace) - kStartProgressLabelRightSpace, 6);
    [self.downView addSubview:self.voiceProgressView];
    
    
    if (self.currentType == playVoice) {
        // 播放语音
        self.downView.backgroundColor = SDVoiceConferenceGrayColor;
        self.voiceTipLabel.hidden = YES;
        self.startProgressLabel.hidden = NO;
        self.endProgressLabel.hidden = NO;
        self.voiceProgressView.hidden = NO;
        // 暂停和播放的图片
        [self.recordPressBtn setImage:[UIImage imageNamed:@"voiceConferencePlay"] forState:UIControlStateSelected];
        [self.recordPressBtn setImage:[UIImage imageNamed:@"voiceConferenceStop"] forState:UIControlStateNormal];
        [self.recordPressBtn setImage:[UIImage imageNamed:@"voiceConferenceStop"] forState:UIControlStateHighlighted];
        [self.recordPressBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (self.currentType == recordingVoice) {
        // 录制语音
        self.downView.backgroundColor = SDVoiceConferenceBlackColor;
        self.voiceTipLabel.hidden = NO;
        self.startProgressLabel.hidden = YES;
        self.endProgressLabel.hidden = YES;
        self.voiceProgressView.hidden = YES;
        [self.recordPressBtn setImage:[UIImage imageNamed:@"recordNormal"] forState:UIControlStateNormal];
        [self.recordPressBtn setImage:[UIImage imageNamed:@"recordPress"] forState:UIControlStateHighlighted];
        [self.recordPressBtn addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.recordPressBtn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self.recordPressBtn addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - navgationBarClick
- (void)rightDetailBtnClick
{
    CXIMVoiceConferenceInfomationViewController* infoVC = [[CXIMVoiceConferenceInfomationViewController alloc] initWithGroupDetailInfomation:self.groupDetailInfo];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)finishBtnEvent:(UIButton*)sender
{
    //结束语音会议
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"结束"]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"结束会议?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1001;
        [alertView show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 观察myQueue是否执行完
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if (object == self.myQueue &&
        [keyPath isEqualToString:observeKeyPath]) {
        if ([self.myQueue.operations count] == 0) {
            self.timer.fireDate = [NSDate distantFuture];
            [self.myQueue setSuspended:YES];
            self.proValue = 0.f;
            self.voiceProgressView.progress = 1.f;
            self.userHeadImageView.hidden = YES;
            self.currentSpeakingUserLabel.hidden = YES;
            self.speakTipLabel.hidden = YES;
            self.recordView.hidden = YES;
            [self.recordPressBtn setSelected:NO];
            self.isSelect = NO;
            self.isFinish = YES;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 内部方法
/// 开始播放语音
- (void)firstStartLoadAudioMessages
{
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        __strong typeof(&*weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf dataSourceArr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.recordPressBtn setSelected:YES];
                strongSelf.isSelect = YES;
                [strongSelf.voiceProgressView setProgress:0.f];
                [strongSelf loopAudioMessage];
            });
        }
    });
}

/// 循环读取语音信息
- (void)loopAudioMessage
{
    NSArray* arr = self.dataSourceArr;
    
    if ([arr count] == 0) {
        [self.recordPressBtn setSelected:NO];
        self.isSelect = NO;
        [self.voiceProgressView setProgress:0.f];
        [self.myQueue setSuspended:YES];
        return;
    }
    
    [self.myQueue setSuspended:NO];
    
    if ([self.dataSourceArr count]) {
        // 有多少条数据
        int totalTime = 0;
        
        for (CXIMMessage* message in arr) {
            if (message.body.type == CXIMMessageContentTypeVoice) {
                CXIMVoiceMessageBody* body = (CXIMVoiceMessageBody*)message.body;
                totalTime += [body.length intValue];
                
                CXIMVoiceOperation* voiceOperation = [[CXIMVoiceOperation alloc] initWithMessageModel:message];
                voiceOperation.voiceOperationDelegate = self;
                if ([self.myQueue.operations count]) {
                    [voiceOperation addDependency:[self.myQueue.operations lastObject]];
                }
                [self.myQueue addOperation:voiceOperation];
            }
        }
        
        NSString* endText = @"";
        
        int hour = totalTime / 3600;
        int m = (totalTime - hour * 3600) / 60;
        int s = totalTime - hour * 3600 - m * 60;
        
        if (hour > 0) {
            endText = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
        }
        else if (m > 0) {
            endText = [NSString stringWithFormat:@"%i:%i", m, s];
        }
        else {
            if (s < 10) {
                endText = [NSString stringWithFormat:@"0:0%i", s];
            }
            else {
                endText = [NSString stringWithFormat:@"0:%i", s];
            }
        }
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.endProgressLabel.text = endText;
                strongSelf.startProgressLabel.text = @"0:00";
                [strongSelf.voiceProgressView setProgress:0.f];
                
                [self.startProgressLabel sizeToFit];
                self.startProgressLabel.frame = CGRectMake(kStartProgressLabelLeftSpace, kTouchDownSpeakTipLabelTop, self.startProgressLabel.size.width, kTitleFont);
                [self.endProgressLabel sizeToFit];
                self.endProgressLabel.frame = CGRectMake(Screen_Width - kStartProgressLabelLeftSpace - self.endProgressLabel.size.width, kTouchDownSpeakTipLabelTop, self.endProgressLabel.size.width, kTitleFont);
                self.voiceProgressView.frame = CGRectMake(CGRectGetMaxX(self.startProgressLabel.frame) + kStartProgressLabelRightSpace, kTouchDownSpeakTipLabelTop + kTitleFont/2 - 3, Screen_Width - kStartProgressLabelLeftSpace - self.endProgressLabel.size.width - (CGRectGetMaxX(self.startProgressLabel.frame) + kStartProgressLabelRightSpace) - kStartProgressLabelRightSpace, 6);
            }
        });
        
        if (nil == _timer && totalTime > 0) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(changeProgress:) userInfo:[NSString stringWithFormat:@"%d", totalTime] repeats:YES];
        }
    }
}

- (void)changeProgress:(NSTimer*)timer
{
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        float totalTime = [[timer userInfo] floatValue];
        float totalLength = CGRectGetWidth(self.voiceProgressView.frame);
        if (weakSelf.proValue >= totalLength) {
            weakSelf.proValue = 0.f;
            [weakSelf.voiceProgressView setProgress:1.f animated:YES];
            [timer setFireDate:[NSDate distantFuture]];
        }
        else {
            [weakSelf.voiceProgressView setProgress:weakSelf.proValue / totalLength animated:YES];
        }
        weakSelf.proValue += (totalLength / totalTime) * 0.099;
    });
}

- (void)playVoice:(UIButton*)sender
{
    self.isSelect = !self.isSelect;
    sender.selected = self.isSelect;
    if (self.isSelect) {
        [self startPlayVoice];
    }
    else {
        [self endPlayVoice];
    }
}

/// 开始播放声音
- (void)startPlayVoice
{
    if ([self.dataSourceArr count] == 0) {
        return;
    }
    [_timer setFireDate:[NSDate distantPast]];
    [self.myQueue setSuspended:NO];
    if (self.isPause == NO) {
        [[PlayerManager sharedManager].decapsulator play];
    }
    else {
        [[PlayerManager sharedManager].decapsulator playWhenPausePlaying];
    }
    
    self.isPause = NO;
    
    if (self.isFinish) {
        __weak typeof(&*self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.voiceProgressView setProgress:0.f];
            self.proValue = 0.f;
        });
        
        [self loopAudioMessage];
        self.isFinish = NO;
    }
}

/// 结束播放声音
- (void)endPlayVoice
{
    if ([self.dataSourceArr count] == 0) {
        return;
    }
    
    self.userHeadImageView.hidden = YES;
    self.currentSpeakingUserLabel.hidden = YES;
    self.speakTipLabel.hidden = YES;
    self.recordView.hidden = YES;
    
    self.isPause = YES;
    
    [_timer setFireDate:[NSDate distantFuture]];
    [[PlayerManager sharedManager].decapsulator pausePlaying];
    // 暂停队列
    [self.myQueue setSuspended:YES];
}

- (void)recordButtonTouchDown
{
    [self.view addSubview:self.recordView];
    [self.view bringSubviewToFront:self.recordView];
    [self.recordView recordButtonTouchDown];
    [self.recordPressBtn setHighlighted:YES];
    self.recordView.hidden = NO;
    self.userHeadImageView.hidden = YES;
    self.currentSpeakingUserLabel.hidden = YES;
    self.speakTipLabel.hidden = YES;
    
    [RecorderManager sharedManager].delegate = self;
    [[RecorderManager sharedManager] startRecording];
}

- (void)recordButtonTouchUpOutside
{
    [self.recordView removeFromSuperview];
    [self.currentSpeakingUserLabel setText:@""];
    [self.recordPressBtn setHighlighted:NO];
    [self.recordView recordButtonTouchUpOutside];
    [[RecorderManager sharedManager] cancelRecording];
}

- (void)recordButtonTouchUpInside
{
    [self.recordView removeFromSuperview];
    self.currentSpeakingUserLabel.text = @"";
    [self.recordPressBtn setHighlighted:NO];
    [self.recordView recordButtonTouchUpInside];
    [[RecorderManager sharedManager] stopRecording];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 1001) {
        NSString* btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([btnTitle isEqualToString:@"确定"]) {
            SDWebSocketModel* socketModel = [[SDWebSocketModel alloc] init];
            socketModel.groupId = self.groupDetailInfo.groupId;
            socketModel.mediaType = 1;
            NSDictionary* params = @{ @"groupId" : self.groupDetailInfo.groupId };
            NSDictionary* resultParams = @{ voicemeeting_socket : params };
            socketModel.textMsg = resultParams;
            socketModel.type = [NSNumber numberWithInt:push];
            NSMutableString* toStr = [[NSMutableString alloc] init];
            NSArray* members = [self.groupDetailInfo.members valueForKey:@"userId"];
            for (NSString* hxAccount in members) {
                [toStr appendFormat:@"%@,", hxAccount];
            }
            socketModel.to = [toStr substringToIndex:toStr.length - 1];
//            [[SDWebSocketManager shareWebSocketManager] sendMessage:socketModel];
            NSString* groupID = self.groupDetailInfo.groupId;
            [[SDVoiceManager sharedVoiceManager] saveValue:@YES key:groupID];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

#pragma mark - SDWebSocketManagerDelegate
- (void)webSocketManager:(CXIMSocketManager*)webSocketManager didReceiveMessage:(id)message
{
    if ([message isKindOfClass:[NSDictionary class]]) {
        [[SDVoiceManager sharedVoiceManager] saveValue:@YES key:[message valueForKey:@"groupId"]];
        if ([[self.groupDetailInfo owner] isEqualToString:VAL_HXACCOUNT]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"会议已经结束!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = 1000;
            [alertView show];
        }
    }
}

#pragma mark - CXIMServiceDelegate
- (void)CXIMService:(CXIMService*)service didReceiveChatMessage:(CXIMMessage*)message;
{
    if (CXIMMessageContentTypeVoice == message.body.type) {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [message downloadFileWithProgress:^(float progress) {
                    
                }
                                       completion:^(CXIMMessage* message, NSError* error) {
                                           if (!error)
                                               [strongSelf receiveMessage:message];
                                       }];
            }
        });
    }
}

#pragma mark - RecordingDelegate
- (void)recordingFinishedWithFileName:(NSString*)filePath time:(NSTimeInterval)interval;
{
    NSLog(@"录音完成-> 时间=%lf 文件位置-%@", interval, filePath);
    if (interval < 1.0) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            TTAlert(@"录音时间太短");
        });
    }
    else {
        unsigned long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
        [self sendVoiceMessageWithPath:filePath length:@((int)interval) size:[NSNumber numberWithUnsignedLongLong:size]];
        
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf playVoiceAction:VAL_HXACCOUNT];
            }
        });
        
        if(self.isInCurrentViewController){
            // 录制完成之后要重新播放语音
            [[PlayerManager sharedManager] playAudioWithFileName:filePath
                                                      playerType:DDSpeaker
                                                        delegate:self];
        }
    }
}

#pragma mark - event
/// 收到信息播放语音
- (void)playReceiveMessage:(CXIMMessage*)message
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf playVoiceAction:message.sender];
        }
    });
}

/// 收到信息播放语音
- (void)receiveMessage:(CXIMMessage*)message
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf playVoiceAction:message.sender];
        }
    });
    
    CXIMVoiceMessageBody* messageBody = (CXIMVoiceMessageBody*)[message body];
    // 播放语音
    NSLog(@"length:👉👉👉%@ size:👉👉👉%@", messageBody.length, messageBody.size);
    if(self.isInCurrentViewController){
        [[PlayerManager sharedManager] playAudioWithFileName:[NSHomeDirectory() stringByAppendingPathComponent:messageBody.localUrl]
                                                  playerType:DDSpeaker
                                                    delegate:self];
    }
}

/// 播放语音.录音以后.
- (void)playVoiceAction:(NSString*)imAccount
{
    self.recordView.hidden = YES;
    self.userHeadImageView.hidden = NO;
    self.currentSpeakingUserLabel.hidden = NO;
    self.speakTipLabel.hidden = NO;
    SDCompanyUserModel* userModel = [[SDDataBaseHelper shareDB] getUserByhxAccount:imAccount];
    NSString* senderName = [userModel realName];
    self.currentSpeakingUserLabel.text = senderName;
    self.speakTipLabel.text = @"正在讲话...";
    self.userHeadImageView.layer.cornerRadius = 10.f;
    self.userHeadImageView.layer.masksToBounds = YES;
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", (userModel.icon&&![userModel.icon isKindOfClass:[NSNull class]]&&userModel.icon.length) ? userModel.icon : @""]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
}

/// 发送语音
- (void)sendVoiceMessageWithPath:(NSString*)filePath length:(NSNumber*)len size:(NSNumber*)size
{
    CXIMMessage* message = [[CXIMMessage alloc] initWithChatter:self.groupDetailInfo.groupId body:[CXIMVoiceMessageBody bodyWithVoicePath:filePath duration:len]];
    message.type = CXIMMessageTypeGroupChat;
    [[CXIMService sharedInstance].chatManager sendMessage:message onProgress:nil completion:^(CXIMMessage* message, NSError* error) {
        if (error) {
            NSLog(@"👉👉👉发送语音失败👉👉👉,error:%@",error);
        }
    }];
}

#pragma mark - PlayingDelegate
- (void)playingStoped;
{
    if ([self.ringPlayer prepareToPlay]) {
        [self.ringPlayer play];
    }
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            self.recordView.hidden = NO;
            self.userHeadImageView.hidden = YES;
            self.currentSpeakingUserLabel.hidden = YES;
            self.speakTipLabel.hidden = YES;
            strongSelf.recordView.hidden = YES;
        }
    });
}

#pragma mark - CXIMVoiceOperationDelegate
- (void)playStoped
{
    if ([self.ringPlayer prepareToPlay]) {
        [self.ringPlayer play];
    }
    self.recordView.hidden = NO;
    self.userHeadImageView.hidden = YES;
    self.currentSpeakingUserLabel.hidden = YES;
    self.speakTipLabel.hidden = YES;
    self.recordView.hidden = YES;
}

- (void)playMessage:(CXIMMessage*)message
{
    if (message.body.type == CXIMMessageContentTypeVoice) {
        [self playReceiveMessage:message];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
