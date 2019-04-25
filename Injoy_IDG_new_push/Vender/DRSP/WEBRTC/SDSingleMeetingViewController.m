//
//  SDSingleMeetingViewController.m
//  SDIMApp
//
//  Created by wtz on 2018/8/24.
//  Copyright © 2018年 Rao. All rights reserved.
//

#import "SDSingleMeetingViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SDWebRTCHelper.h"
#import "Masonry.h"

//接听和静音还有免提按钮之间的间距
#define kButtonSpacing ((Screen_Width - 210)/4)
//本地视频画面的宽度
#define kLocalViewHeight (kLocalViewWidth*(Screen_Height/Screen_Width))
//本地视频画面的高度
#define kLocalViewWidth 70.0

#define kButtonWidth 70
#define kButtonHeight 95

// 声音播放模式
typedef NS_ENUM(NSInteger,SDMediaCallAudioPlayMode){
    //使用扬声器播放声音
    SDMediaCallAudioPlayModeLoudSpeaker,
    //使用听筒播放声音
    SDMediaCallAudioPlayModeEarphone
};


@interface SDSingleMeetingViewController ()<SDWebRTCHelperDelegate, RTCEAGLVideoViewDelegate,CXIMChatDelegate>

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

//摄像头切换
@property (nonatomic, strong) UIButton *camareChange;
//是否打开摄像头
@property (nonatomic, strong) UIButton *camareOpen;
//时间Label
@property (nonatomic, strong) UILabel *timeLabel;

//显示连接状态的Label，第一步，发起方发送请求，发起方显示“正在等待对方接受邀请..”；第二步，接受方收到请求，显示“邀请你进行语音／视频通话”；第三步，接受方点击接听按钮，发起方和接受方显示“正在连接..”；第四步，连接成功，显示内容为语音通话的时间，格式如：00:58；
@property (nonatomic,strong) UILabel *connectionStatusLabel;

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


@property (nonatomic, strong) RTCVideoTrack * localVideoTrack; /**< 本地摄像头追踪 */

@property (nonatomic, strong) NSMutableDictionary <NSString *, RTCVideoTrack *> *remoteVideoTracks; /**< 远程的视频追踪 */

@end

@implementation SDSingleMeetingViewController

#pragma mark - 生命周期
-(instancetype)initWithInitiateOrAcceptCallType:(SDIMInitiateOrAcceptCallType)type
{
    if (self = [super init]) {
        self.initiateOrAcceptCallType = type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
        [self _setupForChat];
    }
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
}

#pragma mark - 内部方法
- (void)setUpUI
{
    //标题
    self.view.backgroundColor = RGBACOLOR(22, 25, 32, 1.0);
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 35, Screen_Width, 20);
    titleLabel.text = @"通话";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if(self.audioOrVideoType == CXIMMediaCallTypeAudio){
        [self.view addSubview:titleLabel];
    }
    
    //头像
    _headImageView = [[UIImageView alloc] init];
    if(self.audioOrVideoType == CXIMMediaCallTypeAudio){
        _headImageView.frame = CGRectMake((Screen_Width - 135)/2, CGRectGetMaxY(titleLabel.frame) + 20, 135, 135);
    }else{
        _headImageView.frame = CGRectMake(15, 20 + 15, 80, 80);
    }
    _headImageView.layer.cornerRadius = 4;
    _headImageView.clipsToBounds = YES;
    //    NSString * icon = [[CXIMUtil sharedInstance]getUserAvatarUrlByAccount:self.chatter];
    //    [_headImageView sd_setImageWithURL:[NSURL URLWithString:icon ? icon : @""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
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
        _connectionStatusLabel.frame = CGRectMake(_chatterLabel.frame.origin.x, CGRectGetMaxY(_chatterLabel.frame)+ 15, _chatterLabel.frame.size.width, 18);
        _connectionStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    _connectionStatusLabel.font = [UIFont systemFontOfSize:18];
    _connectionStatusLabel.textColor = [UIColor whiteColor];
    _connectionStatusLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_connectionStatusLabel];
    
    
    
    
    //如果是发起方
    if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
        self.connectionStatusLabel.text = @"正在等待对方接受邀请..";
        //发起方第一步，发送通话邀请，等待接受方回应
        [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:CXIMMediaCallStatusRequest receiver:self.chatter RoomId:nil DRCallOwner:nil DRCallMembers:nil];
    }else{
        self.connectionStatusLabel.text = self.audioOrVideoType == CXIMMediaCallTypeAudio?@"邀请你进行语音通话..":@"邀请你进行视频通话..";
        _answerBtn.hidden = NO;
        
        
    }
    
    
    //取消或者拒绝按钮
    if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
        [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).mas_offset(-20-kTabbarSafeBottomMargin);
            make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
        }];
    }else{
//        self.hangUpBtn.frame = CGRectMake(kButtonSpacing, Screen_Height - 170, kButtonWidth, kButtonHeight);
        [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(kButtonSpacing);
            make.bottom.equalTo(self.view).mas_offset(-120-kTabbarSafeBottomMargin);
            make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
        }];
    }
    
    //接听按钮
    [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_equalTo(-kButtonSpacing);
        make.bottom.equalTo(self.view).mas_equalTo(-120-kTabbarSafeBottomMargin);
        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
    }];
    
    
    //静音按钮
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(kButtonSpacing);
        make.bottom.equalTo(self.view).mas_offset(-120-kTabbarSafeBottomMargin);
        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
    }];
    
    
    //免提按钮
    [self.handsfreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.right.equalTo(self.view).mas_equalTo(-kButtonSpacing);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_equalTo(-120-kTabbarSafeBottomMargin);
        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
    }];
    
    //计时
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_equalTo(-120-kButtonHeight-20-kTabbarSafeBottomMargin);
        make.height.equalTo(@20);
    }];
    
    //打开摄像头
    [self.camareOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteBtn);
        make.right.equalTo(self.view).mas_offset(-30);
        make.size.mas_equalTo(CGSizeMake(kButtonWidth, kButtonHeight));
    }];
    
    //镜头切换
    [self.camareChange mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.right.equalTo(self.view).mas_offset(-30);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.equalTo(self.camareOpen);
        make.centerY.equalTo(self.hangUpBtn);
    }];
}

//开始响铃
- (void)beginRing
{
    [_ringPlayer stop];
    
    NSString* musicPath;
    NSURL* url;
    if (self.initiateOrAcceptCallType == SDIMCallAcceptType) {
        //接听别人来电时提醒声音
        musicPath = [[NSBundle mainBundle] pathForResource:@"receiveRing" ofType:@"mp3"];
        url = [[NSURL alloc] initFileURLWithPath:musicPath];
    }
    else {
        //拨打语音电话时提醒声音
        musicPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3"];
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

//结束响铃
- (void)stopRing
{
    [_ringPlayer stop];
}

- (void)timeOutClose
{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)close{
    [self stopRing];
    
    self.timeCount = 0;
    
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    if(self.callTimeTimer){
        [self.callTimeTimer invalidate];
        self.callTimeTimer = nil;
    }

    [[CXIMService sharedInstance].chatManager removeDelegate:self];
    [self exitBtnClick];
}

//此方法用于设置播放模式
-(void)setAudioPlayMode:(SDMediaCallAudioPlayMode)audioPlayMode{
    _audioPlayMode = audioPlayMode;
    // 录音+扬声器播放
    if (_audioPlayMode == SDMediaCallAudioPlayModeLoudSpeaker) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        
    }
    // 录音+听筒播放
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
    NSString * seconds = second > 9 ? [NSString stringWithFormat:@"%ld",(long)second] : [NSString stringWithFormat:@"0%ld",(long)second];
    
    NSInteger minute = _timeCount/60;
    NSString * minutes = minute > 9 ? [NSString stringWithFormat:@"%ld",(long)minute] : [NSString stringWithFormat:@"0%ld",(long)minute];
    
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
            [self stopRing];
            [self exitBtnClick];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            // 表示发起方和接收方正在通话 第三方请求时返回正忙的请求
        case CXIMMediaCallStatusBusy:
        {
            [self stopRing];
            [self exitBtnClick];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
            // 挂断
        case CXIMMediaCallStatusHangup:
        {
            [self stopRing];
            [self exitBtnClick];
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
            [self stopRing];
            if (self.initiateOrAcceptCallType == SDIMCallInitiateType)
            {
                
                self.connectionStatusLabel.text = @"正在连接..";
                [self _setupForChat];
            }
            break;
        }
            // 不同意
        case CXIMMediaCallStatusDisagree:
        {
            [self stopRing];
            [self exitBtnClick];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 交互
// 点击接听
//接受方第一步，点击接听
- (void)answerBtnTapped{
    [self stopRing];
    [self _setupForChat];
    
    self.connectionStatusLabel.text = @"正在连接..";
    
//    _hangUpBtn.frame = CGRectMake(kButtonSpacing*2 + 70, Screen_Height - 170, 70, 95);
    
//    [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
//    [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateHighlighted];
    
    //如果30秒内点击接听，则取消定时器，如果30秒内未点击接听，则判断超时
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    
    self.muteBtn.hidden = NO;
    self.handsfreeBtn.hidden = NO;
    self.answerBtn.hidden = YES;
    self.camareOpen.hidden = NO;
    self.camareChange.hidden = NO;
    [self.hangUpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-20-kTabbarSafeBottomMargin);
        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
    }];
    
    //接受方第二步，接受方发送是否接听的回应给发起方
    [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:CXIMMediaCallStatusAgree receiver:self.chatter RoomId:nil DRCallOwner:nil DRCallMembers:nil];
}

//接受方第一步，点击挂断
- (void)hangupBtnTapped{
    [self stopRing];
    
    CXIMMediaCallStatus status;
    if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
        status = self.connected ? CXIMMediaCallStatusHangup : CXIMMediaCallStatusUserExit;
    }
    else{
        status = self.connected ? CXIMMediaCallStatusHangup : CXIMMediaCallStatusDisagree;
    }
    
    //接受方第二步，接受方发送是否接听的回应给发起方
    [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:(status) receiver:self.chatter RoomId:nil DRCallOwner:nil DRCallMembers:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self exitBtnClick];
}

//静音按钮被点击
- (void)muteBtnSelected
{
    _muteBtn.selected = !_muteBtn.selected;
    RTCAudioTrack *audioTrack = [SDWebRTCHelper shareInstance].audioTrack;
    if (_muteBtn.selected) {
        [audioTrack setIsEnabled:NO];
    }
    else {
        [audioTrack setIsEnabled:YES];
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

/** 打开摄像头 */
-(void)camareOpenAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    RTCMediaStream *localStream = [SDWebRTCHelper shareInstance].localStream;
    RTCVideoTrack *videoTrack = [SDWebRTCHelper shareInstance].videoTrack;
    if (sender.selected) {
//        [[WebRTCHelper sharedInstance].localVideoTrack setEnabled:NO];
//        _localVideoView.hidden = YES;
//        [localStream removeVideoTrack:videoTrack];
        [videoTrack setIsEnabled:NO];
        self.camareChange.hidden = YES;
        [sender setImage:[UIImage imageNamed:@"camare_close.jpg"] forState:UIControlStateNormal];
        
    }else{
//        [[WebRTCHelper sharedInstance].localVideoTrack setEnabled:YES];
//        _localVideoView.hidden = NO ;
//        [localStream addVideoTrack:videoTrack];
        [videoTrack setIsEnabled:YES];
        self.camareChange.hidden = NO;
        [sender setImage:[UIImage imageNamed:@"camare_open.jpg"] forState:UIControlStateNormal];
    }
}

/** 摄像头切换 */
-(void)camareChangeAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;

    [[SDWebRTCHelper shareInstance] camareChangeWithIsBackCamare:sender.selected];
}

#pragma mark - private method
- (void)_setupForChat
{
    SDWebRTCHelper *webRTCHelper = [SDWebRTCHelper shareInstance];
    // 修改为自己的本地服务器地址
    //roomId暂时好像只能是数字,暂定用发起者userId加上产品ID比如(IDG这个产品ID是000)接受者userId
    [webRTCHelper connect:@"impush.chinacloudapp.cn" port:@"3000" room:@"2323232000222"]; // bossking10086.iok.la
    [webRTCHelper setDelegate:self];
    
    if (!_remoteVideoTracks) {
        _remoteVideoTracks = [NSMutableDictionary dictionary];
    }
}

- (void)_refreshRemoteView
{
    NSArray *views = self.view.subviews;
    
    for (NSInteger i = 0; i < [views count]; i++) {
        UIView *view = [views objectAtIndex:i];
        
        if ([view isKindOfClass:[RTCEAGLVideoView class]]) {
            // 本地的视频View和关闭按钮不做处理
            if (view.tag == 10086 ||view.tag == 10000) {
                continue;
            }
            
            // 其他的移除
            [view removeFromSuperview];
        }
    }
    
    __block int column = 1;
    __block int row = 0;
    // 再去添加
    [_remoteVideoTracks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, RTCVideoTrack *remoteTrack, BOOL * _Nonnull stop) {
        RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 20, Screen_Width, Screen_Height)];
        // FIXME: 实现本地/远程图像不被拉伸变形 201706201812 by king
        [remoteVideoView setDelegate:self];
        [remoteTrack addRenderer:remoteVideoView];
        [self.view addSubview:remoteVideoView];
        [self.view insertSubview:remoteVideoView atIndex:0];
        
        //列加1
        column++;
        //一行多余3个在起一行
        if (column > 4) {
            row ++;
            column = 0;
        }
    }];
    
    _connectionStatusLabel.frame = CGRectMake(0, CGRectGetMinY(_answerBtn.frame) - 15 - 20, Screen_Width, 20);
    _connectionStatusLabel.textAlignment = NSTextAlignmentCenter;
    
    self.handsfreeBtn.hidden = NO;
    
    self.muteBtn.hidden = NO;
    
    if (self.initiateOrAcceptCallType == SDIMCallAcceptType) {
        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateHighlighted];
    }
}

- (void)exitBtnClick{
    [[SDWebRTCHelper shareInstance] close];
}

#pragma mark - SDWebRTCHelperDelegate
- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper setLocalStream:(RTCMediaStream *)stream
{
    BKLog(@"");
    RTCEAGLVideoView *localView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(Screen_Width - 15 - kLocalViewWidth, 20 + 15, kLocalViewWidth, kLocalViewHeight)];
    // 标记本地摄像头
    [localView setTag:10086];
    // FIXME: 实现本地/远程图像不被拉伸变形 201706201812 by king
    [localView setDelegate:self];
    _localVideoTrack = [stream.videoTracks lastObject];
    [_localVideoTrack addRenderer:localView];
    [self.view addSubview:localView];
}

- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper addRemoteStream:(RTCMediaStream *)stream connectionID:(NSString *)connectionID
{
    [self stopRing];
    self.connected = YES;
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(wself.audioOrVideoType == CXIMMediaCallTypeVideo){
            
            _headImageView.hidden = YES;
            
            _chatterLabel.hidden = YES;
        
        }
        
        _connectionStatusLabel.frame = CGRectMake(0, CGRectGetMinY(_answerBtn.frame) - 15 - 20, Screen_Width, 20);
        _connectionStatusLabel.textAlignment = NSTextAlignmentCenter;
        
        self.handsfreeBtn.hidden = NO;
        
        self.muteBtn.hidden = NO;
        
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

    BKLog(@"connectionID:%@", connectionID);
    [_remoteVideoTracks setValue:[stream.videoTracks lastObject] forKey:connectionID];
    [self _refreshRemoteView];
}

- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper removeConnection:(NSString *)connectionID
{
    BKLog(@"connectionID:%@", connectionID);
    [_remoteVideoTracks removeObjectForKey:connectionID];
    [self _refreshRemoteView];
}

//这里根据图像来调整变形,应该是在不变形的前提下,根据图像来调整比如不变形是900* 800,可以显示为屏幕宽度,屏幕高度,只显示一部分按照900缩小
#pragma mark - RTCEAGLVideoViewDelegate
- (void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size
{
    BKLog(@"videoView.tag:%zd size:%@", videoView.tag, NSStringFromCGSize(size));
    
//    if (size.width > 0 && size.height > 0) {
//        // Aspect fill remote video into bounds.
//        CGRect bounds = videoView.bounds;
//        CGRect videoFrame = AVMakeRectWithAspectRatioInsideRect(size, videoView.bounds);
//        CGFloat scale = 1;
//
//        if (videoFrame.size.width > videoFrame.size.height) {
//            // Scale by height.
//            scale = bounds.size.height / videoFrame.size.height;
//        } else {
//            // Scale by width.
//            scale = bounds.size.width / videoFrame.size.width;
//        }
//
//        videoFrame.size.height *= scale;
//        videoFrame.size.width *= scale;
//        [videoView setBounds:(CGRect){0, 0, videoFrame.size.width, videoFrame.size.height}];
//        [videoView setCenter:(CGPoint){videoView.center.x + (videoFrame.size.width - bounds.size.width) * 0.5, videoView.center.y + (videoFrame.size.height - bounds.size.height) * 0.5}];
//    }
}

#pragma mark - 懒加载
//取消和拒绝按钮
-(UIButton *)hangUpBtn{
    if (!_hangUpBtn) {
        _hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateHighlighted];
        [_hangUpBtn addTarget:self action:@selector(hangupBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_hangUpBtn];
    }
    return _hangUpBtn;
}
//接收按钮
-(UIButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
            _answerBtn.hidden = YES;
        }else{
            _answerBtn.hidden = NO;
        }
        [_answerBtn setBackgroundImage:[UIImage imageNamed:@"answer"] forState:UIControlStateNormal];
        [_answerBtn setBackgroundImage:[UIImage imageNamed:@"answer"] forState:UIControlStateHighlighted];
        [_answerBtn addTarget:self action:@selector(answerBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_answerBtn];
    }
    
    return _answerBtn;
}
//静音
-(UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
            _muteBtn.hidden = NO;
        }else{
            _muteBtn.hidden = YES;
        }
        [_muteBtn setBackgroundImage:[UIImage imageNamed:@"silent_connect"] forState:UIControlStateNormal];
        [_muteBtn setBackgroundImage:[UIImage imageNamed:@"silent_connect_select"] forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(muteBtnSelected) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_muteBtn];
    }
    
    return _muteBtn;
}
//免提
-(UIButton *)handsfreeBtn{
    if (!_handsfreeBtn) {
        _handsfreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _handsfreeBtn.selected = VAL_ENABLE_LOUD_SPEAKER;
        if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
            _handsfreeBtn.hidden = NO;
        }else{
            _handsfreeBtn.hidden = YES;
        }
        _handsfreeBtn.frame = CGRectMake(kButtonSpacing*3 + 70*2, Screen_Height - 170, 70, 95);
        [_handsfreeBtn setBackgroundImage:[UIImage imageNamed:@"handsfree"] forState:UIControlStateNormal];
        [_handsfreeBtn setBackgroundImage:[UIImage imageNamed:@"handsfree_select"] forState:UIControlStateSelected];
        [_handsfreeBtn addTarget:self action:@selector(handsfreeBtnSelected) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_handsfreeBtn];
    }
    return _handsfreeBtn;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}
//摄像头切换
-(UIButton *)camareChange{
    if (!_camareChange) {
        _camareChange = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_camareChange setTitle:@"切换" forState:UIControlStateNormal];
        [_camareChange setBackgroundImage:[UIImage imageNamed:@"annex_carame_n"] forState:UIControlStateNormal];
        [_camareChange setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_camareChange addTarget:self action:@selector(camareChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
            _camareChange.hidden = NO;
        }else{
            _camareChange.hidden = YES;
        }
        [self.view addSubview:_camareChange];
    }
    
    return _camareChange;
}
//打开摄像头
-(UIButton *)camareOpen{
    if (!_camareOpen) {
        _camareOpen = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_camareOpen setTitle:@"摄像头打开" forState:UIControlStateNormal];
        [_camareOpen setImage:[UIImage imageNamed:@"camare_open.jpg"] forState:UIControlStateNormal];
        [_camareOpen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_camareOpen addTarget:self action:@selector(camareOpenAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.initiateOrAcceptCallType == SDIMCallInitiateType) {
            _camareOpen.hidden = NO;
        }else{
            _camareOpen.hidden = YES;
        }
        [self.view addSubview:_camareOpen];
    }
    return _camareOpen;
}


@end
