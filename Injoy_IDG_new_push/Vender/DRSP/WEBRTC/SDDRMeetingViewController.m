//
//  SDDRMeetingViewController.m
//  SDIMApp
//
//  Created by wtz on 2018/8/25.
//  Copyright © 2018年 Rao. All rights reserved.
//

#import "SDDRMeetingViewController.h"
#import "SDWebRTCHelper.h"
#import <WebRTC/WebRTC.h>

//------------------webrtc头文件---------------
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "CXVideoPlayView.h"
#import "SDSelectMemberViewController.h"
#import "UIView+YYAdd.h"


#define KVideoWidth Screen_Width/5
#define KVideoHeight Screen_Height/5

//接听和静音还有免提按钮之间的间距
#define kButtonSpacing ((Screen_Width - 210)/4)
#define kButtonWidth 70
#define kButtonHeight 95

#define moreTime 30
//一行最多显示5个
#define maxLineCount 5

// 声音播放模式
typedef NS_ENUM(NSInteger,SDMediaCallAudioPlayMode){
    //使用扬声器播放声音
    SDMediaCallAudioPlayModeLoudSpeaker,
    //使用听筒播放声音
    SDMediaCallAudioPlayModeEarphone
};

@interface SDDRMeetingViewController ()<SDWebRTCHelperDelegate, RTCEAGLVideoViewDelegate,UIAlertViewDelegate,CXIMChatDelegate>
{
    //本地摄像头追踪
    RTCVideoTrack<RTCVideoRenderer> *_localVideoTrack;
    //远程的视频追踪
    NSMutableDictionary *_remoteVideoTracks;
    int time;
    RTCEAGLVideoView *localView;
    NSString *memberString;
    //是否已接通
    BOOL isConnect;
}
@property (nonatomic, strong) SDRootTopView *rootTopView;
//声音播放模式
@property (nonatomic) SDMediaCallAudioPlayMode audioPlayMode;

@property (nonatomic, strong) RTCVideoTrack *localVideoTrack; /**< 本地摄像头追踪 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, RTCVideoTrack *> *remoteVideoTracks; /**< 远程的视频追踪 */

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
//计时器
@property (nonatomic, strong) NSTimer *timer;
//超时计时器
@property (nonatomic, strong) NSTimer *csTimer;
//语音通话的响铃
@property (nonatomic, strong) AVAudioPlayer* ringPlayer;
/** 已加入房间的成员 */
@property (nonatomic, strong) NSMutableArray<CXGroupMember *> *joinArray;
/** 发起者的头像，用于被邀请的时候显示 */
@property (nonatomic, strong) UIImageView *fromHeaderImage;
/** 发起者的昵称，用于被邀请的时候显示 */
@property (nonatomic, strong) UILabel *fromNickName;
/** 本地视频流 */
@property (nonatomic, strong) RTCEAGLVideoView *localVideoView;

@property (nonatomic, strong) UIScrollView *videoPlayScrollView;
//后面的session是指这个属性
@property (nonatomic,retain)AVCaptureSession *session;

@end

@implementation SDDRMeetingViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kColorWithRGB(34, 35, 40);
    _remoteVideoTracks = [NSMutableDictionary dictionary];
    self.joinArray = [NSMutableArray array];
    [SDWebRTCHelper shareInstance].delegate = self;
//    [[CXIMService sharedInstance].chatManager addDelegate:self];
    time = 0;
    
    [self loadTopView];
    [self loadSubView];
    [self sendIMAction];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hangupBtnTapped) name:DRVideoOrAudioNoConnectButHangup object:nil];
}

-(void)sendIMAction{
    if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {//如果是发送方
        //把群组的成员的imAccount拼接成字符串
        
        for (int i = 0;i<self.memberArray.count;i++) {
            CXGroupMember *member =self.memberArray[i];
            //通过imaccount获取用户的昵称和头像
            SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:member.userId];
            member.name = userModel.nickName;
            member.icon = userModel.icon;
            
            //拼接IMAccount
            if (memberString.length == 0) {
                memberString = [NSString stringWithFormat:@"%@",member.userId];
            }else{
                memberString = [NSString stringWithFormat:@"%@,%@",memberString,member.userId];
            }
        }
        
        //每一个用户发送邀请
        //        [self sendInvitationWithArray:self.]
        for (CXGroupMember *member in self.memberArray) {
            if (![member.userId isEqualToString:VAL_HXACCOUNT]) {//过滤掉自己，自己不用发送
                
                [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:CXIMMediaCallStatusRequest receiver:member.userId RoomId:self.roomId DRCallOwner:self.owner.userId DRCallMembers:memberString];
                
            }
        }
        
        [self connectAction];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChangeAction) userInfo:nil repeats:YES];
    }else{
        for (int i = 0;i<self.memberArray.count;i++) {
            CXGroupMember *member =self.memberArray[i];
            //通过imaccount获取用户的昵称和头像,因为接收方是只收到被邀请用户的IMAccount，所以要通过id去查找，发送方不需要，发送方进来的时候有获取到这些内容
            SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:member.userId];
            member.name = userModel.name;
            member.icon = userModel.icon;
        }
        
        
        
        if (!self.isJoin) {
            //接电话时显示来电人的头像和名称
            SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:self.owner.userId];
            self.owner.name = userModel.name;
            self.owner.icon = userModel.icon;
            
            [self.fromHeaderImage setImageWithURL:[NSURL URLWithString:self.owner.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
            self.fromNickName.text = self.owner.name;
        }else{
            [self answerBtnTapped];
        }
        
        
    }
    [self beginRing];
}


-(void)viewWillDisappear:(BOOL)animated{
    //释放定时器
    [self.timer invalidate];
    self.timer = nil;
    time = 0;
    
    [self.csTimer invalidate];
    self.csTimer = nil;
    
    
}

#pragma mark - 响铃响铃事件
//开始响铃
- (void)beginRing
{
    if(VAL_ENABLE_MAKE_SOUND){
        if(self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender || (self.senderOrReceiveType == SDIMSenderOrReceiveTypeReceive && VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION)){
            [_ringPlayer stop];
            
            NSString* musicPath;
            NSURL* url;
            if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeReceive) {
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
        if(self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender || (self.senderOrReceiveType == SDIMSenderOrReceiveTypeReceive && VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION)){
            [_ringPlayer stop];
        }
    }
}

#pragma mark - CXIMServiceDelegate
//接受到接受方的回应，发起方第一步结束
//发起方向接受方发起通话邀请，收到回应的方法，如果超过30秒未收到回应，则判断通话超时，关闭通话页面
-(void)CXIMService:(CXIMService *)service didReceiveMediaCallResponse:(NSDictionary *)response{
    //如果收到通话回应，则结束响铃
//    [self stopRing];
//
//    //如果收到通话回应，则关闭定时器
//    if(_timer){
//        [_timer invalidate];
//        _timer = nil;
//    }
    CXIMMediaCallStatus status = [response[@"status"] integerValue];
    
    switch (status) {
            // 表示发起方中断连接 接收方还没有接受和拒绝的时候
        case CXIMMediaCallStatusUserExit:
        {
            [self hangupBtnTapped];
            break;
        }
//            // 表示发起方和接收方正在通话 第三方请求时返回正忙的请求
//        case CXIMMediaCallStatusBusy:
//        {
////            [self hangupBtnTapped];
//            break;
//        }
//            
//            // 挂断
//        case CXIMMediaCallStatusHangup:
//        {
//            [self hangupBtnTapped];
//            break;
//        }
//            
//            // 发起请求
//        case CXIMMediaCallStatusRequest:
//        {
//            // APPDelegate中已经处理
//            break;
//        }
//            // 同意
//        case CXIMMediaCallStatusAgree:
//        {
//            [self stopRing];
//            if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender)
//            {
//                
//                self.timeLabel.text = @"正在连接..";
//                [self answerBtnTapped];
//            }
//            break;
//        }
//            // 不同意
//        case CXIMMediaCallStatusDisagree:
//        {
//            [self hangupBtnTapped];
//            break;
//        }
            
        default:
            break;
    }
}


#pragma mark - WebRTCHelperDelegate
- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper setLocalStream:(RTCMediaStream *)stream connectionID:(NSString *)connectionID
{
    BKLog(@"");
    for (int i = 0; i < self.memberArray.count; i++) {
        CXGroupMember *member =self.memberArray[i];
        NSString *imaccount = [[SDWebRTCHelper shareInstance] getIMAccountWithSocketId:connectionID];
        
        if ([imaccount isEqualToString:member.userId]) {
            [self.joinArray addObject:member];
            
            self.camareOpen.hidden = NO;
            self.camareChange.hidden = NO;
            
            [_localVideoTrack removeRenderer:localView];
            [_localVideoView removeFromSuperview];
            
            CXVideoPlayView *videoPlayView = [self.view viewWithTag:i+50];
            videoPlayView.tipsLabel.text = nil;
            videoPlayView.userId = imaccount;
            videoPlayView.backgroundColor = [UIColor redColor];
            localView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, videoPlayView.frame.size.width,videoPlayView.frame.size.height)];
            
            // 标记本地摄像头
            [localView setTag:10086];
            // FIXME: 实现本地/远程图像不被拉伸变形 201706201812 by king
//            [localView setDelegate:self];
            _localVideoTrack = [stream.videoTracks lastObject];
            videoPlayView.videoPlay = _localVideoView;
            [_localVideoTrack addRenderer:localView];
            [videoPlayView addSubview:localView];
        }
    }
}

- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper addRemoteStream:(RTCMediaStream *)stream connectionID:(NSString *)connectionID
{
    BKLog(@"connectionID:%@", connectionID);
    isConnect = YES;
    [_remoteVideoTracks setValue:[stream.videoTracks lastObject] forKey:connectionID];
//    [self _refreshRemoteView];
    RTCVideoTrack *remoteTrack = [stream.videoTracks lastObject];
    [self addVideoWithUser:connectionID videoTrack:remoteTrack];
}

-(void)addVideoWithUser:(NSString *)userId videoTrack:(RTCVideoTrack *)remoteTrack{
    NSString *imaccount = [[SDWebRTCHelper shareInstance] getIMAccountWithSocketId:userId];
    for (int i = 0; i<self.memberArray.count; i++) {
        CXGroupMember *member = self.memberArray[i];
        
        if ([imaccount isEqualToString:member.userId]) {
            [self.joinArray addObject:member];
            CXVideoPlayView *videoPlayView = [self.view viewWithTag:i+50];
            videoPlayView.tipsLabel.text = nil;
            videoPlayView.userId = userId;
            RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, KVideoWidth, KVideoHeight)];
//            [remoteVideoView setDelegate:self];
            [remoteTrack addRenderer:remoteVideoView];
            videoPlayView.videoPlay = remoteVideoView;
            [videoPlayView addSubview:remoteVideoView];
        }
    }
    
//    if (![self isMemberAeeayContentWithUserId:imaccount]) {
//        CXGroupMember *member = [[CXGroupMember alloc] init];
//        member.userId = imaccount;
//
//        SDCompanyUserModel *model = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:imaccount];
//        member.icon = model.icon;
//        member.name = model.name;
//        [self.memberArray addObject:member];
//
//        CXVideoPlayView *videoPlayView = [[CXVideoPlayView alloc] init];
//        videoPlayView.tipsLabel.text = nil;
//        videoPlayView.tag = (self.memberArray.count - 1)+50;
//        videoPlayView.frame = CGRectMake(KVideoWidth*((self.memberArray.count-1)%maxLineCount), KVideoHeight*((self.memberArray.count-1)/maxLineCount)+navHigh, KVideoWidth, KVideoHeight);
//        videoPlayView.userId = userId;
//        [videoPlayView.headerImage setImageWithURL:[NSURL URLWithString:member.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
//        RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, KVideoWidth, KVideoHeight)];
//        [remoteTrack addRenderer:remoteVideoView];
//        videoPlayView.videoPlay = remoteVideoView;
//        [videoPlayView addSubview:remoteVideoView];
//        [self.view addSubview:videoPlayView];
//    }
    
    
    
}

- (void)webRTCHelper:(SDWebRTCHelper *)webRTChelper removeConnection:(NSString *)connectionID
{
    BKLog(@"connectionID:%@", connectionID);
    [_remoteVideoTracks removeObjectForKey:connectionID];
//    [self _refreshRemoteView];
    [self deleteVideoWithUser:connectionID];
}

//其他人离开房间时删除视频控件
-(void)deleteVideoWithUser:(NSString *)userId{
    for (int i = 0; i<self.memberArray.count; i++) {
        CXGroupMember *member = self.memberArray[i];
        NSString *imaccount = [[SDWebRTCHelper shareInstance] getIMAccountWithSocketId:userId];
        if ([imaccount isEqualToString:member.userId]) {
            [self.joinArray removeObject:member];
            CXVideoPlayView *videoPlayView = [self.view viewWithTag:i+50];
            [videoPlayView removeFromSuperview];
        }
    }
    
}

#pragma mark - RTCEAGLVideoViewDelegate
- (void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size
{
    BKLog(@"videoView.tag:%zd size:%@", videoView.tag, NSStringFromCGSize(size));
    
    if (size.width > 0 && size.height > 0) {
        // Aspect fill remote video into bounds.
        CGRect bounds = videoView.bounds;
        CGRect videoFrame = AVMakeRectWithAspectRatioInsideRect(size, videoView.bounds);
        CGFloat scale = 1;
        
        if (videoFrame.size.width > videoFrame.size.height) {
            // Scale by height.
            scale = bounds.size.height / videoFrame.size.height;
        } else {
            // Scale by width.
            scale = bounds.size.width / videoFrame.size.width;
        }
        
        videoFrame.size.height *= scale;
        videoFrame.size.width *= scale;
        [videoView setBounds:(CGRect){0, 0, videoFrame.size.width, videoFrame.size.height}];
        [videoView setCenter:(CGPoint){videoView.center.x + (videoFrame.size.width - bounds.size.width) * 0.5, videoView.center.y + (videoFrame.size.height - bounds.size.height) * 0.5}];
    }
}

#pragma mark - selector
- (IBAction)clickBtnForChat:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[SDWebRTCHelper shareInstance] close];
    }];
}

#pragma mark - private method
- (void)connectAction
{
    //添加通话人员的头像显示
    for (int i = 0;i<self.memberArray.count;i++) {
        CXGroupMember *member = self.memberArray[i];
        CXVideoPlayView *videoPlayView = [[CXVideoPlayView alloc] init];
        videoPlayView.tag = i+50;
        videoPlayView.frame = CGRectMake(KVideoWidth*(i%maxLineCount), KVideoHeight*(i/maxLineCount), KVideoWidth, KVideoHeight);
        [videoPlayView.headerImage setImageWithURL:[NSURL URLWithString:member.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
        [self.videoPlayScrollView addSubview:videoPlayView];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTouchAction:)];
//        [videoPlayView addGestureRecognizer:tap];
//        videoPlayView.userInteractionEnabled = YES;
        self.videoPlayScrollView.contentSize = CGSizeMake(Screen_Width, videoPlayView.bottom);
    }
    
    SDWebRTCHelper *webRTCHelper = [SDWebRTCHelper shareInstance];
    // 修改为自己的本地服务器地址
    [webRTCHelper connect:@"impush.chinacloudapp.cn" port:@"3000" room:self.roomId]; // bossking10086.iok.la
    
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
        RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(column * KVideoWidth, 20, KVideoWidth, KVideoHeight)];
        // FIXME: 实现本地/远程图像不被拉伸变形 201706201812 by king
        [remoteVideoView setDelegate:self];
        [remoteTrack addRenderer:remoteVideoView];
        [self.view addSubview:remoteVideoView];
        
        //列加1
        column++;
        //一行多余3个在起一行
        if (column > 4) {
            row ++;
            column = 0;
        }
    }];
    
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

#pragma mark - UI

-(void)loadTopView{
    SDRootTopView *topView = [self getRootTopView];
    topView.backgroundColor = [UIColor clearColor];
    self.rootTopView = topView;
    
    [topView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(goBack)];
    [topView setUpRightBarItemImage:[UIImage imageNamed:@"add"] addTarget:self action:@selector(addMember)];
}

/** 加载子控件 */
-(void)loadSubView{
    //取消或者拒绝按钮
    if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
        [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).mas_offset(-20-kTabbarSafeBottomMargin);
            make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
        }];
    }else{
        self.hangUpBtn.frame = CGRectMake(kButtonSpacing, Screen_Height - 170, 70, 95);
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
    
    [self.videoPlayScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.rootTopView.mas_bottom);
        make.bottom.equalTo(self.timeLabel.mas_top);
    }];
    
}

#pragma mark - 点击方法交互
/** 返回-弹窗 */
-(void)goBack{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前正在通话，离开则会挂断，是否离开？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
//弹窗代理方法
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self hangupBtnTapped];
    }
}

/** 摄像头切换 */
-(void)camareChangeAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    [[SDWebRTCHelper shareInstance] camareChangeWithIsBackCamare:sender.selected];
}

//取消挂断方法
- (void)hangupBtnTapped
{
    //释放定时器
    [self.timer invalidate];
    self.timer = nil;
    time = 0;
    
    
    [self.csTimer invalidate];
    self.csTimer = nil;
    if (!isConnect) {
        for (CXGroupMember *member in self.memberArray) {
            if (![member.userId isEqualToString:VAL_HXACCOUNT]) {//过滤掉自己，自己不用发送
                if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
                    //接受方第二步，接受方发送是否接听的回应给发起方
                    [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:CXIMMediaCallStatusUserExit receiver:member.userId RoomId:self.roomId DRCallOwner:self.owner.userId DRCallMembers:memberString];
                }
                
            }
        }
    }
    
    
    [[SDWebRTCHelper shareInstance] close];
    if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
        if (self.isJoin) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//接听方法
-(void)answerBtnTapped{
    [self connectAction];
    [self stopRing];
    [self.fromHeaderImage removeFromSuperview];
    [self.fromNickName removeFromSuperview];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChangeAction) userInfo:nil repeats:YES];
    
    self.muteBtn.hidden = NO;
    self.handsfreeBtn.hidden = NO;
    self.answerBtn.hidden = YES;
    
    [self.hangUpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-20-kTabbarSafeBottomMargin);
        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
    }];
    
}

-(void)timeChangeAction{
    
    time++;
    self.timeLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i",(time/60/60)%60,(time/60)%60,time%60];
}

//静音方法
-(void)muteBtnSelected{
    _muteBtn.selected = !_muteBtn.selected;
    RTCAudioTrack *audioTrack = [SDWebRTCHelper shareInstance].audioTrack;
    if (_muteBtn.selected) {
        [audioTrack setIsEnabled:NO];
    }
    else {
        [audioTrack setIsEnabled:YES];
    }
    
}
/** 打开摄像头 */
-(void)camareOpenAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    RTCVideoTrack *videoTrack = [SDWebRTCHelper shareInstance].videoTrack;
    if (sender.selected) {
        [videoTrack setIsEnabled:NO];
        self.camareChange.hidden = YES;
        [sender setImage:[UIImage imageNamed:@"camare_close.jpg"] forState:UIControlStateNormal];
        
    }else{
        [videoTrack setIsEnabled:YES];
        self.camareChange.hidden = NO;
        [sender setImage:[UIImage imageNamed:@"camare_open.jpg"] forState:UIControlStateNormal];
    }
}
//免提方法
-(void)handsfreeBtnSelected{
    _handsfreeBtn.selected = !_handsfreeBtn.selected;
    if (_handsfreeBtn.selected) {
        self.audioPlayMode = SDMediaCallAudioPlayModeLoudSpeaker;
    }
    else {
        self.audioPlayMode = SDMediaCallAudioPlayModeEarphone;
    }
}

#pragma mark - 懒加载
-(UIImageView *)fromHeaderImage{
    if (!_fromHeaderImage) {
        _fromHeaderImage = [[UIImageView alloc] init];
        _fromHeaderImage.frame = CGRectMake(Screen_Width/3, navHigh, Screen_Width/3, Screen_Width/3);
        [self.view addSubview:_fromHeaderImage];
    }
    return _fromHeaderImage;
}

-(UILabel *)fromNickName{
    if (_fromNickName) {
        _fromNickName = [[UILabel alloc] init];
        _fromNickName.frame = CGRectMake(0, Screen_Width/3+navHigh, Screen_Width, 20);
        _fromNickName.textAlignment = NSTextAlignmentCenter;
        _fromNickName.textColor = [UIColor whiteColor];
        [self.view addSubview:_fromNickName];
    }
    return _fromNickName;
}

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

-(UIButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
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

-(UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
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

-(UIButton *)handsfreeBtn{
    if (!_handsfreeBtn) {
        _handsfreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _handsfreeBtn.selected = VAL_ENABLE_LOUD_SPEAKER;
        if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
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

-(UIButton *)camareChange{
    if (!_camareChange) {
        _camareChange = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_camareChange setTitle:@"切换" forState:UIControlStateNormal];
        [_camareChange setBackgroundImage:[UIImage imageNamed:@"annex_carame_n"] forState:UIControlStateNormal];
        [_camareChange setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_camareChange addTarget:self action:@selector(camareChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        _camareChange.hidden = YES;
        [self.view addSubview:_camareChange];
    }
    
    return _camareChange;
}

-(UIButton *)camareOpen{
    if (!_camareOpen) {
        _camareOpen = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_camareOpen setTitle:@"摄像头打开" forState:UIControlStateNormal];
        [_camareOpen setImage:[UIImage imageNamed:@"camare_open.jpg"] forState:UIControlStateNormal];
        [_camareOpen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_camareOpen addTarget:self action:@selector(camareOpenAction:) forControlEvents:UIControlEventTouchUpInside];
        _camareOpen.hidden = YES;
        [self.view addSubview:_camareOpen];
    }
    return _camareOpen;
}

- (UIScrollView *)videoPlayScrollView{
    if (!_videoPlayScrollView) {
        _videoPlayScrollView = [[UIScrollView alloc] init];
        _videoPlayScrollView.backgroundColor = [UIColor clearColor];
        _videoPlayScrollView.bounces = YES;
        [self.view addSubview:_videoPlayScrollView];
    }
    return _videoPlayScrollView;
}

@end
