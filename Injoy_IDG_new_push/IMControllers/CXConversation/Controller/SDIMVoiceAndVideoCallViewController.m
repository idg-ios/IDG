//
//  SDIMCallViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/14.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMVoiceAndVideoCallViewController.h"
#import "UIImageView+EMWebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CXIMHelper.h"
//------------------webrtc头文件---------------
#import "RTCICEServer.h"
#import "RTCICECandidate.h"
#import "RTCICEServer.h"
#import "RTCMediaConstraints.h"
#import "RTCMediaStream.h"
#import "RTCPair.h"
#import "RTCPeerConnection.h"
#import "RTCPeerConnectionDelegate.h"
#import "RTCPeerConnectionFactory.h"
#import "RTCSessionDescription.h"
#import "RTCVideoRenderer.h"
#import "RTCVideoCapturer.h"
#import "RTCVideoTrack.h"
#import "RTCAudioTrack.h"
#import "RTCSessionDescriptionDelegate.h"
#import "RTCEAGLVideoView.h"
#import <AVFoundation/AVFoundation.h>
//------------------webrtc头文件---------------

/**
 RTCPeerConnection就是webrtc应用程序用来创建客户端连接和视频通讯的API.为了初始化这个过程 RTCPeerConnection有两个任务:
 
 　　1,确定本地媒体条件,如分辨率,编解码能力,这些需要在offer和answer中用到.
 
 　　2,取到应用程序所在机器的网络地址,即称作candidates.
 
 一旦上面这些东西确定了,他们将通过信令机制和远端进行交换.
 */

//信令服务器的地址
#define kICEServer_URL @"turn:imxl.myinjoy.cn:3478"
//信令服务器的账号
#define kICEServer_UserName @"ling"
//信令服务器的密码
#define kICEServer_Password @"ling1234"
//接听和静音还有免提按钮之间的间距
#define kButtonSpacing ((Screen_Width - 210)/4)
//本地视频画面的高度
//#define kLocalViewHeight (kLocalViewWidth*(Screen_Height/Screen_Width))
#define kLocalViewHeight (kLocalViewWidth*640/480)
//本地视频画面的宽度
#define kLocalViewWidth 70.0

// 声音播放模式
typedef NS_ENUM(NSInteger,SDMediaCallAudioPlayMode){
    //使用扬声器播放声音
    SDMediaCallAudioPlayModeLoudSpeaker,
    //使用听筒播放声音
    SDMediaCallAudioPlayModeEarphone
};

@interface SDIMVoiceAndVideoCallViewController()<RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate,CXIMChatDelegate>

//通话是否已经连接
@property (nonatomic) BOOL connected;

//声音播放模式
@property (nonatomic) SDMediaCallAudioPlayMode audioPlayMode;

//对方的昵称显示的Label
@property (nonatomic, strong) UILabel *chatterLabel;

//取消和拒绝按钮
@property (nonatomic, strong) UIButton *hangUpBtn;

//接听按钮
@property (nonatomic, strong) UIButton *answerBtn;

//静音按钮
@property (nonatomic, strong) UIButton * muteBtn;

//免提按钮
@property (nonatomic, strong) UIButton * handsfreeBtn;

//显示连接状态的Label，第一步，发起方发送请求，发起方显示“正在等待对方接受邀请..”；第二步，接受方收到请求，显示“邀请你进行语音／视频通话”；第三步，接受方点击接听按钮，发起方和接受方显示“正在连接..”；第四步，连接成功，显示内容为语音通话的时间，格式如：00:58；
@property (nonatomic,strong) UILabel *connectionStatusLabel;

//通话用的webrtc的类
@property (nonatomic, strong) RTCICEServer *iceServer;
@property (nonatomic, strong) RTCPeerConnectionFactory *pcFactory;
@property (nonatomic, strong) RTCPeerConnection *peerConnection;
@property (nonatomic, strong) RTCVideoTrack *localVideoTrack;
@property (nonatomic, strong) RTCVideoTrack *remoteVideoTrack;
@property (nonatomic, strong) RTCMediaConstraints *sdpConstraints;

@property (nonatomic, strong) RTCAudioTrack *localAudioTrack;
@property (nonatomic, strong) RTCAudioTrack *remoteAudioTrack;

//本地画面
@property (nonatomic, strong) RTCEAGLVideoView *localView;

//远程画面
@property (nonatomic, strong) RTCEAGLVideoView *remoteView;

//超时判断的定时器，作用是判断连接超时，如果30秒没收到响应，则退出该页面
@property (nonatomic, strong) NSTimer * timer;

//记录通话时间的定时器，作用是从通话连接成功开始，每隔一秒刷新connectionStatusLabel
@property (nonatomic, strong) NSTimer * callTimeTimer;

//用来记录通话的时间
@property (nonatomic) NSInteger timeCount;

//是发起方还是接受方
@property (nonatomic) SDIMInitiateOrAcceptCallType initiateOrAcceptCallType;

//语音通话的响铃
@property (nonatomic, strong) AVAudioPlayer* ringPlayer;

//RTC服务器是否已经关闭
@property (nonatomic) BOOL rtcIsClosed;

//头像
@property (nonatomic, strong) UIImageView * headImageView;

//远程画面的高度
@property (nonatomic) CGFloat remoteViewHeight;

//远程画面的宽度
@property (nonatomic) CGFloat remoteViewWidth;

//是否是不在线提示
@property (nonatomic) BOOL showOffLineAttention;


@end

@implementation SDIMVoiceAndVideoCallViewController

#pragma mark - 生命周期
-(instancetype)initWithInitiateOrAcceptCallType:(SDIMInitiateOrAcceptCallType)type
{
    if (self = [super init]) {
        self.initiateOrAcceptCallType = type;
        self.showOffLineAttention = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initPeerConnection];
    [self beginRing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeCount = 0;
    
    [[CXIMService sharedInstance].chatManager addDelegate:self];
    
    [self setUpUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.audioOrVideoType == CXIMMediaCallTypeVideo) {
        [self.localVideoTrack addRenderer:self.localView];
    }
    //进入页面则启动定时器，如果30秒未收到通话回应则close该页面
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(timeOutClose)userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self close];
}

- (void)dealloc
{
    [self close];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 内部方法
- (void)setUpUI
{
    if(self.audioOrVideoType == CXIMMediaCallTypeVideo){
        //远程视频画面
        if(self.remoteView){
            [self.remoteView removeFromSuperview];
            self.remoteView = nil;
        }
        self.remoteView = [[RTCEAGLVideoView alloc] init];
        if (self.initiateOrAcceptCallType == SDIMCallAcceptType) {
            //远程画面的分辨率
            _remoteViewWidth = self.displaySize.width;
            _remoteViewHeight = self.displaySize.height;
            if(Screen_Height/Screen_Width >= _remoteViewHeight/_remoteViewWidth){
                self.remoteView.frame = CGRectMake(-(Screen_Height*_remoteViewWidth/_remoteViewHeight - Screen_Width)/2, 0, Screen_Height*_remoteViewWidth/_remoteViewHeight, Screen_Height);
            }else{
                self.remoteView.frame = CGRectMake(0, -(Screen_Width*_remoteViewHeight/_remoteViewWidth - Screen_Height)/2, Screen_Width, Screen_Width*_remoteViewHeight/_remoteViewWidth);
            }
        }
        self.remoteView.hidden = YES;
        [self.view addSubview:self.remoteView];
        
        //本地视频画面
        if(self.localView){
            [self.localView removeFromSuperview];
            self.localView = nil;
        }
        self.localView = [[RTCEAGLVideoView alloc] init];
        
        if(Screen_Height/Screen_Width >= 640/480){
            self.localView.frame = CGRectMake(-(Screen_Height*480/640 - Screen_Width)/2, 0, Screen_Height*480/640, Screen_Height);
        }else{
            self.localView.frame = CGRectMake(0, -(Screen_Width*640/480 - Screen_Height)/2, Screen_Width, Screen_Width*640/480);
        }
        
        [self.view addSubview:self.localView];
        
    }
    
    //标题
    self.view.backgroundColor = RGBACOLOR(22, 25, 32, 1.0);
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 22, Screen_Width, 46);
    titleLabel.text = @"通话";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = RGBACOLOR(0, 69, 40, 1.0);
    if(self.audioOrVideoType == CXIMMediaCallTypeAudio){
        [self.view addSubview:titleLabel];
    }
    
    if(self.audioOrVideoType == CXIMMediaCallTypeAudio){
        UIView * bottomColorView = [[UIView alloc] init];
        bottomColorView.frame = CGRectMake(0, Screen_Height - 20, Screen_Width, 20);
        bottomColorView.backgroundColor = RGBACOLOR(0, 69, 40, 1.0);
        [self.view addSubview:bottomColorView];
    }
    
    //头像
    _headImageView = [[UIImageView alloc] init];
    if(self.audioOrVideoType == CXIMMediaCallTypeAudio){
        if(Screen_Height < 481){
            _headImageView.frame = CGRectMake((Screen_Width - 135)/2, CGRectGetMaxY(titleLabel.frame) + 20, 135, 135);
        }else{
            _headImageView.frame = CGRectMake((Screen_Width - 135)/2, CGRectGetMaxY(titleLabel.frame) + 70, 135, 135);
        }
    }else{
        _headImageView.frame = CGRectMake(15, 20 + 15, 80, 80);
    }
    _headImageView.layer.cornerRadius = 4;
    _headImageView.clipsToBounds = YES;
    NSString * icon = [CXIMHelper getUserAvatarUrlByIMAccount:self.chatter];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:icon ? icon : @""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.view addSubview:_headImageView];
    
    //对方的昵称Label
    if(self.chatterLabel){
        [self.chatterLabel removeFromSuperview];
        self.chatterLabel = nil;
    }
    _chatterLabel = [[UILabel alloc] init];
    if(self.audioOrVideoType == CXIMMediaCallTypeAudio){
        _chatterLabel.frame = CGRectMake(0, CGRectGetMaxY(_headImageView.frame) + 20, Screen_Width, 25);
        _chatterLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        _chatterLabel.frame = CGRectMake( 15 + 80 + 15,20 + 15, Screen_Width - (15 + 80 + 15) - 15, 25);
        _chatterLabel.textAlignment = NSTextAlignmentLeft;
    }
    _chatterLabel.text = self.chatterDisplayName;
    _chatterLabel.backgroundColor = [UIColor clearColor];
    _chatterLabel.textColor = [UIColor whiteColor];
    _chatterLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:_chatterLabel];
    
    //通话状态Label
    if(_connectionStatusLabel){
        [self.connectionStatusLabel removeFromSuperview];
        self.connectionStatusLabel = nil;
    }
    _connectionStatusLabel = [[UILabel alloc] init];
    if(self.audioOrVideoType == CXIMMediaCallTypeAudio){
        _connectionStatusLabel.frame = CGRectMake(0, CGRectGetMaxY(_chatterLabel.frame)+ 15, Screen_Width, 20);
        _connectionStatusLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        _connectionStatusLabel.frame = CGRectMake(_chatterLabel.frame.origin.x, CGRectGetMaxY(_headImageView.frame) - 18, _chatterLabel.frame.size.width, 18);
        _connectionStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    _connectionStatusLabel.font = [UIFont systemFontOfSize:18];
    _connectionStatusLabel.textColor = [UIColor whiteColor];
    _connectionStatusLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_connectionStatusLabel];
    
    
    //取消或者拒绝按钮
    if(_hangUpBtn){
        [_hangUpBtn removeFromSuperview];
        _hangUpBtn = nil;
    }
    _hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hangUpBtn.frame = CGRectMake(kButtonSpacing*2 + 70, Screen_Height - 170, 70, 95);
    _hangUpBtn.hidden = NO;
    [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
    [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateHighlighted];
    [_hangUpBtn addTarget:self action:@selector(hangupBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hangUpBtn];
    
    
    //接听按钮
    if(_answerBtn){
        [_answerBtn removeFromSuperview];
        _answerBtn = nil;
    }
    _answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _answerBtn.frame = CGRectMake(Screen_Width - kButtonSpacing - 70, Screen_Height - 170, 70, 95);
    _answerBtn.hidden = YES;
    [_answerBtn setBackgroundImage:[UIImage imageNamed:@"answer"] forState:UIControlStateNormal];
    [_answerBtn setBackgroundImage:[UIImage imageNamed:@"answer"] forState:UIControlStateHighlighted];
    [_answerBtn addTarget:self action:@selector(answerBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_answerBtn];
    
    
    //静音按钮
    if(_muteBtn){
        [_muteBtn removeFromSuperview];
        _muteBtn = nil;
    }
    _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _muteBtn.frame = CGRectMake(kButtonSpacing, Screen_Height - 170, 70, 95);
    _muteBtn.hidden = YES;
    [_muteBtn setBackgroundImage:[UIImage imageNamed:@"silent_connect"] forState:UIControlStateNormal];
    [_muteBtn setBackgroundImage:[UIImage imageNamed:@"silent_connect_select"] forState:UIControlStateSelected];
    [_muteBtn addTarget:self action:@selector(muteBtnSelected) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_muteBtn];
    
    
    //免提按钮
    if(_handsfreeBtn){
        [_handsfreeBtn removeFromSuperview];
        _handsfreeBtn = nil;
    }
    _handsfreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _handsfreeBtn.selected = VAL_ENABLE_LOUD_SPEAKER;
    _handsfreeBtn.hidden = YES;
    _handsfreeBtn.frame = CGRectMake(kButtonSpacing*3 + 70*2, Screen_Height - 170, 70, 95);
    [_handsfreeBtn setBackgroundImage:[UIImage imageNamed:@"handsfree"] forState:UIControlStateNormal];
    [_handsfreeBtn setBackgroundImage:[UIImage imageNamed:@"handsfree_select"] forState:UIControlStateSelected];
    [_handsfreeBtn addTarget:self action:@selector(handsfreeBtnSelected) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_handsfreeBtn];
    
    //如果是发起方
    if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
        self.connectionStatusLabel.text = @"正在等待对方接受邀请..";
        //发起方第一步，发送通话邀请，等待接受方回应
        [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:CXIMMediaCallStatusRequest receiver:self.chatter];
    }else{
        self.connectionStatusLabel.text = self.audioOrVideoType == CXIMMediaCallTypeAudio?@"邀请你进行语音通话..":@"邀请你进行视频通话..";
        _answerBtn.hidden = NO;
        _hangUpBtn.frame = CGRectMake(kButtonSpacing, Screen_Height - 170, 70, 95);
        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuseCall"] forState:UIControlStateNormal];
        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuseCall"] forState:UIControlStateHighlighted];
    }
}

//开始响铃
- (void)beginRing
{
    if(VAL_ENABLE_MAKE_SOUND){
        if(self.initiateOrAcceptCallType == SDIMCallInitiateType || (self.initiateOrAcceptCallType == SDIMCallAcceptType && VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION)){
            [_ringPlayer stop];
            
            NSString* musicPath;
            NSURL* url;
            if (self.initiateOrAcceptCallType == SDIMCallAcceptType) {
                //接听别人来电时提醒声音
                musicPath = [[NSBundle mainBundle] pathForResource:@"receiveCallSong" ofType:@"mp3"];
                url = [[NSURL alloc] initFileURLWithPath:musicPath];
            }
            else {
                //拨打语音电话时提醒声音
                musicPath = [[NSBundle mainBundle] pathForResource:@"sendCallSong" ofType:@"mp3"];
                url = [[NSURL alloc] initFileURLWithPath:musicPath];
            }
            
            if(_ringPlayer){
                _ringPlayer = nil;
            }
            _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [_ringPlayer setVolume:1];
            _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
            if ([_ringPlayer prepareToPlay]) {
                [_ringPlayer play]; //播放
            }
        }
    }
}

//结束响铃
- (void)stopRing
{
    if(VAL_ENABLE_MAKE_SOUND){
        if(self.initiateOrAcceptCallType == SDIMCallInitiateType || (self.initiateOrAcceptCallType == SDIMCallAcceptType && VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION)){
            [_ringPlayer stop];
        }
    }
}

- (void)timeOutClose
{
    self.showOffLineAttention = YES;
    if(self.initiateOrAcceptCallType == SDIMCallInitiateType){
        [[UIApplication sharedApplication].keyWindow makeToast:@"暂时无人接听，请稍后再拨!" duration:2 position:@"center"];
    }else{
        CXIMCallRecord * unReceivedCallRecord = [CXIMCallRecord recordWithChatter:_chatter type:CXIMCallRecordTypeIn status:CXIMCallRecordStatusFailed time:self.receiveCallTime];
        unReceivedCallRecord.responded = NO;
        [[CXIMService sharedInstance].chatManager saveCallRecord:unReceivedCallRecord];
        [[NSNotificationCenter defaultCenter] postNotificationName:receiveTimeOutCallNotification object:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)close{
    [self stopRing];
    
    self.timeCount = 0;
    
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.localVideoTrack) {
        [self.localVideoTrack removeRenderer:self.localView];
        self.localVideoTrack = nil;
    }
    if (self.remoteVideoTrack) {
        [self.remoteVideoTrack removeRenderer:self.remoteView];
        self.remoteVideoTrack = nil;
    }
    if (self.peerConnection) {
        if(!_rtcIsClosed){
            [self.peerConnection close];
        }
        self.peerConnection = nil;
    }
    if(self.callTimeTimer){
        [self.callTimeTimer invalidate];
        self.callTimeTimer = nil;
    }
    
    [RTCPeerConnectionFactory deinitializeSSL];
    
    [[CXIMService sharedInstance].chatManager removeDelegate:self];
}

-(void)initPeerConnection{
    NSString *videoEnable = self.audioOrVideoType == CXIMMediaCallTypeAudio ? @"false" : @"true";
    self.sdpConstraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
                           @[
                             [[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"],
                             [[RTCPair alloc] initWithKey:@"OfferToReceiveVideo" value:videoEnable]
                             ]
                                                                optionalConstraints: nil];
    
    self.iceServer = [[RTCICEServer alloc] initWithURI:[NSURL URLWithString:kICEServer_URL] username:kICEServer_UserName password:kICEServer_Password];
    [RTCPeerConnectionFactory initializeSSL];
    self.pcFactory = [[RTCPeerConnectionFactory alloc] init];
    
    //发起方第二个任务第一步，发起方创建RTCPeerConnection对象时设置了onicecandidate handler,hander被调用当candidates找到了的时候
    RTCMediaConstraints *mediaConstraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
                                             @[
                                               [[RTCPair alloc] initWithKey:@"maxHeight" value:@"640"],
                                               [[RTCPair alloc] initWithKey:@"minHeight" value:@"640"],
                                               [[RTCPair alloc] initWithKey:@"maxWidth" value:@"480"],
                                               [[RTCPair alloc] initWithKey:@"minWidth" value:@"480"],
                                               [[RTCPair alloc] initWithKey:@"maxFrameRate" value:@"30"],
                                               [[RTCPair alloc] initWithKey:@"minFrameRate" value:@"30"]] optionalConstraints:nil];
    
    
    _peerConnection = [self.pcFactory peerConnectionWithICEServers:@[self.iceServer] constraints:mediaConstraints delegate:self];
    
    //添加Stream
    RTCMediaStream *localStream = [self.pcFactory mediaStreamWithLabel:@"ARDAMS"];
    RTCAudioTrack *audioTrack = [self.pcFactory audioTrackWithID:@"ARDAMSa0"];
    self.localAudioTrack = audioTrack;
    [localStream addAudioTrack:audioTrack];
    
    if(self.audioOrVideoType == CXIMMediaCallTypeVideo){
        AVCaptureDevice *device;
        for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] ) {
            if (captureDevice.position == AVCaptureDevicePositionFront) {
                device = captureDevice;
                break;
            }
        }
        if (device) {
            RTCVideoSource *videoSource;
            RTCVideoCapturer *capturer = [RTCVideoCapturer capturerWithDeviceName:device.localizedName];
            //            videoSource = [self.pcFactory videoSourceWithCapturer:capturer constraints:mediaConstraints];
            videoSource = [self.pcFactory videoSourceWithCapturer:capturer constraints:[[RTCMediaConstraints alloc] init]];
            RTCVideoTrack *videoTrack = [self.pcFactory videoTrackWithID:@"ARDAMSv0" source:videoSource];
            self.localVideoTrack = videoTrack;
            [localStream addVideoTrack:videoTrack];
        }
    }
    
    [_peerConnection addStream:localStream];
    self.rtcIsClosed = NO;
}

//此方法用于设置播放模式
-(void)setAudioPlayMode:(SDMediaCallAudioPlayMode)audioPlayMode{
    _audioPlayMode = audioPlayMode;
    //录音+扬声器播放
    if (_audioPlayMode == SDMediaCallAudioPlayModeLoudSpeaker) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        
    }
    //录音+听筒播放
    else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

//每隔一秒刷新一次ceconnectionStatusLabel
- (void)referenCeconnectionStatusLabel
{
    _timeCount++;
    //_timeCount是语音通话持续的秒数，转换成00:00格式
    NSInteger second = _timeCount%60;
    NSString * seconds = second > 9 ? [NSString stringWithFormat:@"%zd",second] : [NSString stringWithFormat:@"0%zd",second];
    
    NSInteger minute = _timeCount/60;
    NSString * minutes = minute > 9 ? [NSString stringWithFormat:@"%zd",minute] : [NSString stringWithFormat:@"0%zd",minute];
    
    NSString * callTime = [NSString stringWithFormat:@"%@:%@",minutes,seconds];
    _connectionStatusLabel.text = callTime;
}

#pragma mark - CXIMServiceDelegate
//接受到接受方的回应，发起方第一步结束
//发起方向接受方发起通话邀请，收到回应的方法，如果超过30秒未收到回应，则判断通话超时，关闭通话页面
-(void)CXIMService:(CXIMService *)service didReceiveMediaCallResponse:(NSDictionary *)response{
    //如果收到通话回应，则结束响铃
    [self stopRing];
    
    //如果收到通话回应，则关闭定时器
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    CXIMMediaCallStatus status = [response[@"status"] integerValue];
    
    switch (status) {
            // 表示发起方中断连接 接收方还没有接受和拒绝的时候
        case CXIMMediaCallStatusUserExit:
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"对方取消了通话请求!" duration:2 position:@"center"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            // 表示发起方和接收方正在通话 第三方请求时返回正忙的请求
        case CXIMMediaCallStatusBusy:
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"对方正在通话中，请稍候再拨!" duration:2 position:@"center"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
            // 挂断
        case CXIMMediaCallStatusHangup:
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"对方取消了通话请求!" duration:2 position:@"center"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
            // 发起请求
        case CXIMMediaCallStatusRequest:
        {
            // APPDelegate中已经处理
            break;
        }
            // 同意
        case CXIMMediaCallStatusAgree:
        {
            //远程画面的分辨率
            _remoteViewWidth = [response[@"screen_width"] floatValue];
            _remoteViewHeight = [response[@"screen_height"] floatValue];
            if(Screen_Height/Screen_Width >= _remoteViewHeight/_remoteViewWidth){
                if(_remoteViewWidth && _remoteViewHeight){
                    self.remoteView.frame = CGRectMake(-(Screen_Height*_remoteViewWidth/_remoteViewHeight - Screen_Width)/2, 0, Screen_Height*_remoteViewWidth/_remoteViewHeight, Screen_Height);
                    
                }else{
                    self.remoteView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
                }
                
            }else{
                if(_remoteViewWidth && _remoteViewHeight){
                    self.remoteView.frame = CGRectMake(0, -(Screen_Width*_remoteViewHeight/_remoteViewWidth - Screen_Height)/2, Screen_Width, Screen_Width*_remoteViewHeight/_remoteViewWidth);
                }else{
                    self.remoteView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
                }
            }
            if (self.initiateOrAcceptCallType == SDIMCallInitiateType)
            {
                self.connectionStatusLabel.text = @"正在连接..";
                //发起方第二步，创建offer(即SDP会话描述)
                [self.peerConnection createOfferWithDelegate:self constraints:self.sdpConstraints];
            }
            break;
        }
            // 不同意
        case CXIMMediaCallStatusDisagree:
        {
            [[UIApplication sharedApplication].keyWindow makeToast:@"对方拒绝了您的通话请求!" duration:2 position:@"center"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

-(void)CXIMService:(CXIMService *)service didReceiveMediaCallOfflineResponse:(NSDictionary *)response
{
    //如果收到通话回应，则结束响铃
    [self stopRing];
    
    //如果收到通话回应，则关闭定时器
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    self.showOffLineAttention = YES;
    if(self.initiateOrAcceptCallType == SDIMCallInitiateType){
        [[UIApplication sharedApplication].keyWindow makeToast:@"对方不在线，请稍后再拨!" duration:2 position:@"center"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)CXIMService:(CXIMService *)service didReceiveMediaCallMessage:(CXIMMessage *)message
{
    //接受方第二个任务第一步，接受方收到来自发起方的candidate消息的时候,他调用方法addIceCandidate(),添加candidate到远端描述里面
    CXIMMediaCallMessageBody *body = (CXIMMediaCallMessageBody *)message.body;
    if([body.event isEqualToString:@"_ice_candidate"]){
        NSDictionary *candidateInfo = body.data[@"candidate"];
        NSString *sdpMid = candidateInfo[@"sdpMid"];
        NSInteger sdpMLineIndex = [candidateInfo[@"sdpMLineIndex"] integerValue];
        NSString *sdp = candidateInfo[@"candidate"];
        RTCICECandidate *candidate = [[RTCICECandidate alloc] initWithMid:sdpMid index:sdpMLineIndex sdp:sdp];
        [self.peerConnection addICECandidate:candidate];
    }
    //发起方第五步，发起方收到接受方的answer，发起方根据answer设置本地描述
    else if([body.event isEqualToString:@"_answer"]){
        NSDictionary *sdp = body.data[@"sdp"];
        RTCSessionDescription *remoteSdp = [[RTCSessionDescription alloc] initWithType:sdp[@"type"] sdp:sdp[@"sdp"]];
        [self.peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:remoteSdp];
    }
    //接受方第三步，接受方根据接受到的发起方的offer设置本地描述
    else if ([body.event isEqualToString:@"_offer"]){
        NSDictionary *sdp = body.data[@"sdp"];
        RTCSessionDescription *remoteSdp = [[RTCSessionDescription alloc] initWithType:sdp[@"type"] sdp:sdp[@"sdp"]];
        [self.peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:remoteSdp];
    }
}

#pragma mark - RTCSessionDescriptionDelegate代理方法
//发起方第三步，成功创建offer之后，根据offer设置本地描述
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp
                 error:(NSError *)error{
    if(error){
//        NSLog(@"%@",error);
        return;
    }
    [peerConnection setLocalDescriptionWithDelegate:self sessionDescription:sdp];
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection
didSetSessionDescriptionWithError:(NSError *)error{
    if (error) {
//        NSLog(@"%@",error.userInfo[@"error"]);
        return;
    }
    //发起方第四步，创建本地信令描述成功后，发送本地offer给接受方
    if (peerConnection.signalingState == RTCSignalingHaveLocalOffer) {
        NSDictionary *sdp = @{
                              @"type":peerConnection.localDescription.type,
                              @"sdp":peerConnection.localDescription.description
                              };
        [[CXIMService sharedInstance].chatManager sendMediaCallOfferWithType:CXIMMediaCallTypeVideo receiver:self.chatter sdp:sdp];
    }
    //接受方第四步，接受方创建本地描述成功后，创建answer
    else if(peerConnection.signalingState == RTCSignalingHaveRemoteOffer){
        [peerConnection createAnswerWithDelegate:self constraints:self.sdpConstraints];
    }
    //接受方第五步，接受方创建answer成功后，会根据answer创建本地描述，创建本地描述成功后发送answer给发起方
    //发起方第六步，发起方根据answer设置本地描述成功后，此时第一个任务（确定本地媒体条件）完成
    else if(peerConnection.signalingState == RTCSignalingStable){
        if(self.initiateOrAcceptCallType == SDIMCallAcceptType){
            NSDictionary *sdp = @{
                                  @"type":peerConnection.localDescription.type,
                                  @"sdp":peerConnection.localDescription.description
                                  };
            [[CXIMService sharedInstance].chatManager sendMediaCallAnswerWithType:CXIMMediaCallTypeVideo receivr:self.chatter sdp:sdp];
        }
    }
}

#pragma mark - RTCPeerConnection代理方法
// Triggered when the SignalingState changed.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
 signalingStateChanged:(RTCSignalingState)stateChanged{
    switch (stateChanged) {
        case RTCSignalingStable:
            NSLog(@"RTCSignalingStable");
            break;
        case RTCSignalingHaveLocalOffer:
            NSLog(@"RTCSignalingHaveLocalOffer");
            break;
        case RTCSignalingHaveLocalPrAnswer:
            NSLog(@"RTCSignalingHaveLocalPrAnswer");
            break;
        case RTCSignalingHaveRemoteOffer:
            NSLog(@"RTCSignalingHaveRemoteOffer");
            break;
        case RTCSignalingHaveRemotePrAnswer:
            NSLog(@"RTCSignalingHaveRemotePrAnswer");
            break;
        case RTCSignalingClosed:
            NSLog(@"RTCSignalingClosed");
            break;
        default:
            break;
    }
}

// Triggered when media is received on a new stream from remote peer.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
           addedStream:(RTCMediaStream *)stream{
    NSLog(@"%s",__func__);
    self.remoteAudioTrack = stream.audioTracks.lastObject;
    if(self.audioOrVideoType == CXIMMediaCallTypeVideo){
        self.remoteVideoTrack = stream.videoTracks.lastObject;
        [self.remoteVideoTrack addRenderer:self.remoteView];
    }
}

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
         removedStream:(RTCMediaStream *)stream{
    NSLog(@"%s",__func__);
}

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection{
    NSLog(@"%s",__func__);
}

// Called any time the ICEConnectionState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
  iceConnectionChanged:(RTCICEConnectionState)newState{
    //发起方第二个任务第三步，连接成功或失败
    //接受方第二个任务第二步，连接成功或失败
    
    // 连接成功
    if(newState == RTCICEConnectionConnected){
        self.connected = YES;
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(wself.audioOrVideoType == CXIMMediaCallTypeVideo){
                
                _headImageView.hidden = YES;
                
                _chatterLabel.hidden = YES;
                
                _remoteView.hidden = NO;
                
                _localView.frame = CGRectMake(Screen_Width - 15 - kLocalViewWidth, 20 + 15, kLocalViewWidth, kLocalViewHeight);
            }
            
            _connectionStatusLabel.frame = CGRectMake(0, CGRectGetMinY(_hangUpBtn.frame) - 15 - 20, Screen_Width, 20);
            _connectionStatusLabel.textAlignment = NSTextAlignmentCenter;
            
            wself.handsfreeBtn.hidden = NO;
            
            wself.muteBtn.hidden = NO;
            
            if (wself.initiateOrAcceptCallType == SDIMCallAcceptType) {
                [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
                [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateHighlighted];
            }
            
            
            if(_handsfreeBtn.selected){
                self.audioPlayMode = SDMediaCallAudioPlayModeLoudSpeaker;
            }else{
                self.audioPlayMode = SDMediaCallAudioPlayModeEarphone;
            }
            
            //这里要开始计时了
            wself.connectionStatusLabel.text = @"00:00";
            //每隔一秒就刷新一次ceconnectionStatusLabel
            if(_callTimeTimer){
                [_callTimeTimer invalidate];
                _callTimeTimer = nil;
            }
            _callTimeTimer = [NSTimer timerWithTimeInterval:1.0 target:wself selector:@selector(referenCeconnectionStatusLabel)userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_callTimeTimer forMode:NSDefaultRunLoopMode];
            
        });
    }
    // 连接失败
    else if (newState == RTCICEConnectionFailed || newState == RTCICEConnectionDisconnected || newState == RTCICEConnectionClosed){
        if(newState == RTCICEConnectionClosed){
            self.rtcIsClosed = YES;
        }
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [wself dismissViewControllerAnimated:YES completion:nil];
            NSString * message;
            if(newState == RTCICEConnectionClosed && !self.showOffLineAttention){
                message = [NSString stringWithFormat:@"通话结束"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }else if(newState == RTCICEConnectionClosed && self.showOffLineAttention){
                
            }else{
                message = [NSString stringWithFormat:@"您的网络不稳定"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
        });
    }
    NSLog(@"%s ---  %d",__func__,newState);
}

// Called any time the ICEGatheringState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
   iceGatheringChanged:(RTCICEGatheringState)newState{
    NSLog(@"%s -%d",__func__,newState);
}

// New Ice candidate have been found.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
       gotICECandidate:(RTCICECandidate *)candidate{
    NSLog(@"%s",__func__);
    NSDictionary *candidateInfo = @{
                                    @"sdpMid":candidate.sdpMid,
                                    @"sdpMLineIndex":@(candidate.sdpMLineIndex),
                                    @"candidate":candidate.sdp
                                    };
    //发起方第二个任务第二步，当被candidate找到了就发送给接受方
    [[CXIMService sharedInstance].chatManager sendMediaCallCandidateWithType:self.audioOrVideoType receiver:self.chatter candidateInfo:candidateInfo];
}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didOpenDataChannel:(RTCDataChannel*)dataChannel{
    NSLog(@"%s",__func__);
}

#pragma mark - 交互
//接受方第一步，点击接听
- (void)answerBtnTapped{
    [self stopRing];
    
    _answerBtn.hidden = YES;
    
    self.connectionStatusLabel.text = @"正在连接..";
    
    _hangUpBtn.frame = CGRectMake(kButtonSpacing*2 + 70, Screen_Height - 170, 70, 95);
    
    [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
    [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateHighlighted];
    
    //如果30秒内点击接听，则取消定时器，如果30秒内未点击接听，则判断超时
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    
    //接受方第二步，接受方发送是否接听的回应给发起方
    [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:CXIMMediaCallStatusAgree receiver:self.chatter];
}

//接受方第一步，点击挂断
- (void)hangupBtnTapped
{
    [self stopRing];
    
    CXIMMediaCallStatus status;
    if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
        status = self.connected ? CXIMMediaCallStatusHangup : CXIMMediaCallStatusUserExit;
    }
    else{
        status = self.connected ? CXIMMediaCallStatusHangup : CXIMMediaCallStatusDisagree;
    }
    
    //接受方第二步，接受方发送是否接听的回应给发起方
    [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:(status) receiver:self.chatter];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//静音按钮被点击
- (void)muteBtnSelected
{
    _muteBtn.selected = !_muteBtn.selected;
    if (_muteBtn.selected) {
        [self.localAudioTrack setEnabled:NO];
        [self.remoteAudioTrack setEnabled:NO];
    }
    else {
        [self.localAudioTrack setEnabled:YES];
        [self.remoteAudioTrack setEnabled:YES];
    }
}

//免提按钮被点击
- (void)handsfreeBtnSelected
{
    _handsfreeBtn.selected = !_handsfreeBtn.selected;
    if (_handsfreeBtn.selected) {
        self.audioPlayMode = SDMediaCallAudioPlayModeLoudSpeaker;
    }
    else {
        self.audioPlayMode = SDMediaCallAudioPlayModeEarphone;
    }
}


@end


