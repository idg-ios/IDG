////
////  CXMultiplayerVideoViewController.m
////  InjoyIDG
////
////  Created by HelloIOS on 2018/7/18.
////  Copyright © 2018年 Injoy. All rights reserved.
////
//
//#import "CXMultiplayerVideoViewController.h"
//#import "UIImageView+EMWebCache.h"
//#import <MediaPlayer/MediaPlayer.h>
//#import "CXIMHelper.h"
////------------------webrtc头文件---------------
//#import "RTCICEServer.h"
//#import "RTCICECandidate.h"
//#import "RTCICEServer.h"
//#import "RTCMediaConstraints.h"
//#import "RTCMediaStream.h"
//#import "RTCPair.h"
//#import "RTCPeerConnection.h"
//#import "RTCPeerConnectionDelegate.h"
//#import "RTCPeerConnectionFactory.h"
//#import "RTCSessionDescription.h"
//#import "RTCVideoRenderer.h"
//#import "RTCVideoCapturer.h"
//#import "RTCVideoTrack.h"
//#import "RTCAudioTrack.h"
//#import "RTCSessionDescriptionDelegate.h"
//#import "RTCEAGLVideoView.h"
//
//#import <AVFoundation/AVFoundation.h>
//
//#import "WebRTCHelper.h"
//#import "Masonry.h"
//#import "UIImageView+WebCache.h"
//#import "CXVideoPlayView.h"
//#import "SDSelectMemberViewController.h"
//#import "UIView+YYAdd.h"
//
//
//#define KVedioWidth Screen_Width/5
//#define KVedioHeight Screen_Height/5
//
////接听和静音还有免提按钮之间的间距
//#define kButtonSpacing ((Screen_Width - 210)/4)
//#define kButtonWidth 70
//#define kButtonHeight 95
//
//#define moreTime 30
////一行最多显示5个
//#define maxLineCount 5
//
//@interface CXMultiplayerVideoViewController ()<WebRTCHelperDelegate,SDSelectMemberDelegect,UIAlertViewDelegate>
//{
//    //本地摄像头追踪
//    RTCVideoTrack<RTCVideoRenderer> *_localVideoTrack;
//    //远程的视频追踪
//    NSMutableDictionary *_remoteVideoTracks;
//    int time;
//}
////取消和拒绝按钮
//@property (nonatomic, strong) UIButton *hangUpBtn;
//
////接听按钮
//@property (nonatomic, strong) UIButton *answerBtn;
//
////静音按钮
//@property (nonatomic, strong) UIButton * muteBtn;
//
////免提按钮
//@property (nonatomic, strong) UIButton * handsfreeBtn;
////摄像头切换
//@property (nonatomic, strong) UIButton *camareChange;
////是否打开摄像头
//@property (nonatomic, strong) UIButton *camareOpen;
////时间Label
//@property (nonatomic, strong) UILabel *timeLabel;
////计时器
//@property (nonatomic, strong) NSTimer *timer;
////超时计时器
//@property (nonatomic, strong) NSTimer *csTimer;
////语音通话的响铃
//@property (nonatomic, strong) AVAudioPlayer* ringPlayer;
///** 已加入房间的成员 */
//@property (nonatomic, strong) NSMutableArray<CXGroupMember *> *joinArray;
///** 发起者的头像，用于被邀请的时候显示 */
//@property (nonatomic, strong) UIImageView *fromHeaderImage;
///** 发起者的昵称，用于被邀请的时候显示 */
//@property (nonatomic, strong) UILabel *fromNickName;
///** 本地视频流 */
//@property (nonatomic, strong) RTCEAGLVideoView *localVideoView;
//
////后面的session是指这个属性
//@property (nonatomic,retain)AVCaptureSession *session;
//@end
//
//@implementation CXMultiplayerVideoViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.backgroundColor = kColorWithRGB(34, 35, 40);
//    _remoteVideoTracks = [NSMutableDictionary dictionary];
//    self.joinArray = [NSMutableArray array];
//    [WebRTCHelper sharedInstance].delegate = self;
//    //免提
//    [WebRTCHelper sharedInstance].audioPlayMode = SDMediaCallAudioPlayModeLoudSpeaker;
//    
//    
//    time = 0;
//    [self loadTopView];
//    [self loadSubView];
//    [self sendIMAction];
//    
//    self.csTimer = [NSTimer scheduledTimerWithTimeInterval:moreTime target:self selector:@selector(moreTimeAction) userInfo:nil repeats:NO];
//    
//}
//
//-(void)sendIMAction{
//    if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {//如果是发送方
//        //把群组的成员的imAccount拼接成字符串
//        NSString *memberString = nil;
//        for (int i = 0;i<self.memberArray.count;i++) {
//            CXGroupMember *member =self.memberArray[i];
//            //通过imaccount获取用户的昵称和头像
//            SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:member.userId];
//            member.name = userModel.nickName;
//            member.icon = userModel.icon;
//            
//            //拼接IMAccount
//            if (memberString.length == 0) {
//                memberString = [NSString stringWithFormat:@"%@",member.userId];
//            }else{
//                memberString = [NSString stringWithFormat:@"%@,%@",memberString,member.userId];
//            }
//        }
//        
//        //每一个用户发送邀请
//        [self sendInvitationWithArray:self.memberArray memberString:memberString];
//        
//        
//        [self connectAction];
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChangeAction) userInfo:nil repeats:YES];
//    }else{
//        for (int i = 0;i<self.memberArray.count;i++) {
//            CXGroupMember *member =self.memberArray[i];
//            //通过imaccount获取用户的昵称和头像,因为接收方是只收到被邀请用户的IMAccount，所以要通过id去查找，发送方不需要，发送方进来的时候有获取到这些内容
//            SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:member.userId];
//            member.name = userModel.name;
//            member.icon = userModel.icon;
//        }
//        
//        
//        
//        if (!self.isJoin) {
//            //接电话时显示来电人的头像和名称
//            SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:self.owner.userId];
//            self.owner.name = userModel.name;
//            self.owner.icon = userModel.icon;
//            
//            [self.fromHeaderImage setImageWithURL:[NSURL URLWithString:self.owner.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
//            self.fromNickName.text = self.owner.name;
//        }else{
//            [self answerBtnTapped];
//        }
//        
//
//    }
//    [self beginRing];
//}
//
////发送邀请
//-(void)sendInvitationWithArray:(NSMutableArray<CXGroupMember *> *) array memberString:(NSString *)memberString{
//    static int i = 0;
//    CXGroupMember *member = array[i];
//    if (i < array.count) {
//        if (![member.userId isEqualToString:VAL_HXACCOUNT]) {//过滤掉自己，自己不用发送
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//                [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:CXIMMediaCallStatusRequest receiver:member.userId RoomId:self.roomId DRCallOwner:self.owner.userId DRCallMembers:memberString];
//                
//                [self sendInvitationWithArray:array memberString:memberString];
//            });
//            
//            
//            
//        }else{
//            [self sendInvitationWithArray:array memberString:memberString];
//        }
//    }
//    i++;
//}
//
//
////连接
//- (void)connectAction
//{
//    //添加通话人员的头像显示
//    for (int i = 0;i<self.memberArray.count;i++) {
//        CXGroupMember *member = self.memberArray[i];
//        CXVideoPlayView *videoPlayView = [[CXVideoPlayView alloc] init];
//        videoPlayView.tag = i+50;
//        videoPlayView.frame = CGRectMake(KVedioWidth*(i%maxLineCount), KVedioHeight*(i/maxLineCount)+navHigh, KVedioWidth, KVedioHeight);
//        [videoPlayView.headerImage setImageWithURL:[NSURL URLWithString:member.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
//        [self.view addSubview:videoPlayView];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTouchAction:)];
//        [videoPlayView addGestureRecognizer:tap];
//        videoPlayView.userInteractionEnabled = YES;
//    }
//    
//    
//    [self stopRing];
//    [[WebRTCHelper sharedInstance] connectServer:@"impush.chinacloudapp.cn" port:@"3000" room:self.roomId];
//    
//}
//CGRect rect;
//BOOL isTouch;
//-(void)videoTouchAction:(UITapGestureRecognizer *)tap{
//    
//    CXVideoPlayView *view = (CXVideoPlayView *)tap.view;
//    [self.view addSubview:view];
//    isTouch = !isTouch;
//    if (isTouch) {
//        rect = view.frame;
//        [UIView animateWithDuration:1 animations:^{
//            view.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Width);
//            view.videoPlay.frame = CGRectMake(0, 0, Screen_Width, Screen_Width);
//            
//        }];
//    }else{
//        [UIView animateWithDuration:1 animations:^{
//            view.frame = rect;
//            view.videoPlay.frame = CGRectMake(0, 0, KVedioWidth, KVedioHeight);
//        }];
//    }
//    
//}
//
//#pragma mark - WebRTCHelperDelegate
//- (void)webRTCHelper:(WebRTCHelper *)webRTChelper setLocalStream:(RTCMediaStream *)stream userId:(NSString *)userId
//{
//    
//    for (int i = 0; i < self.memberArray.count; i++) {
//        CXGroupMember *member =self.memberArray[i];
//        NSString *imaccount = [[WebRTCHelper sharedInstance] getIMAccountWithSocketId:userId];
//        if ([imaccount isEqualToString:member.userId]) {
//            [self.joinArray addObject:member];
//            
//            self.camareOpen.hidden = NO;
//            self.camareChange.hidden = NO;
//            
//            [_localVideoTrack removeRenderer:_localVideoTrack];
//            [_localVideoView removeFromSuperview];
//            
//            CXVideoPlayView *videoPlayView = [self.view viewWithTag:i+50];
//            videoPlayView.tipsLabel.text = nil;
//            _localVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, KVedioWidth, KVedioHeight)];
//            //标记本地的摄像头
//            
////            localVideoView.tag = 100;
//            videoPlayView.userId = @"self";
//            _localVideoTrack = [stream.videoTracks lastObject];
//            [_localVideoTrack addRenderer:_localVideoView];
//            videoPlayView.videoPlay = _localVideoView;
//            [videoPlayView addSubview:_localVideoView];
//            
//            if (!self.isVideo) {
//                [[WebRTCHelper sharedInstance].localVideoTrack setEnabled:NO];
//                videoPlayView.videoPlay.hidden = YES;
//            }else{
//                [[WebRTCHelper sharedInstance].localVideoTrack setEnabled:YES];
//                videoPlayView.videoPlay.hidden = NO;
//            }
//            
//            break;
//        }
//    }
//    
//    
//    
//    NSLog(@"setLocalStream");
//}
//- (void)webRTCHelper:(WebRTCHelper *)webRTChelper addRemoteStream:(RTCMediaStream *)stream userId:(NSString *)userId
//{
//    //缓存起来
//    if(stream.videoTracks && [stream.videoTracks count] > 0){
//        [_remoteVideoTracks setObject:[stream.videoTracks lastObject] forKey:userId];
////        [self _refreshRemoteView:userId];
//        RTCVideoTrack *remoteTrack = [stream.videoTracks lastObject];
//        
//        [self addVideoWithUser:userId videoTrack:remoteTrack];
//    }
//    NSLog(@"addRemoteStream");
//    
//}
//
//- (void)webRTCHelper:(WebRTCHelper *)webRTChelper closeWithUserId:(NSString *)userId
//{
//    //移除对方视频追踪
//    [_remoteVideoTracks removeObjectForKey:userId];
//    if (_remoteVideoTracks.count == 0) {
//        [self hangupBtnTapped];
//    }
////    [self _refreshRemoteView:userId];
//    [self deleteVideoWithUser:userId];
//    NSLog(@"closeWithUserId");
//}
//#pragma mark - 添加删除视频
////其他人加入房间时添加视频控件
//-(void)addVideoWithUser:(NSString *)userId videoTrack:(RTCVideoTrack *)remoteTrack{
//    NSString *imaccount = [[WebRTCHelper sharedInstance] getIMAccountWithSocketId:userId];
//    for (int i = 0; i<self.memberArray.count; i++) {
//        CXGroupMember *member = self.memberArray[i];
//        
//        if ([imaccount isEqualToString:member.userId]) {
//            [self.joinArray addObject:member];
//            CXVideoPlayView *videoPlayView = [self.view viewWithTag:i+50];
//            videoPlayView.tipsLabel.text = nil;
//            videoPlayView.userId = userId;
//            RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, KVedioWidth, KVedioHeight)];
//            [remoteTrack addRenderer:remoteVideoView];
//            videoPlayView.videoPlay = remoteVideoView;
//            [videoPlayView addSubview:remoteVideoView];
//            
//            
//        }
//    }
//    
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
//        videoPlayView.frame = CGRectMake(KVedioWidth*((self.memberArray.count-1)%maxLineCount), KVedioHeight*((self.memberArray.count-1)/maxLineCount)+navHigh, KVedioWidth, KVedioHeight);
//        videoPlayView.userId = userId;
//        [videoPlayView.headerImage setImageWithURL:[NSURL URLWithString:member.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
//        RTCEAGLVideoView *remoteVideoView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, KVedioWidth, KVedioHeight)];
//        [remoteTrack addRenderer:remoteVideoView];
//        videoPlayView.videoPlay = remoteVideoView;
//        [videoPlayView addSubview:remoteVideoView];
//        [self.view addSubview:videoPlayView];
//    }
//    
//    
//    [self stopRing];
//}
////其他人离开房间时删除视频控件
//-(void)deleteVideoWithUser:(NSString *)userId{
//    for (int i = 0; i<self.memberArray.count; i++) {
//        CXGroupMember *member = self.memberArray[i];
//        NSString *imaccount = [[WebRTCHelper sharedInstance] getIMAccountWithSocketId:userId];
//        if ([imaccount isEqualToString:member.userId]) {
//            [self.joinArray removeObject:member];
//            CXVideoPlayView *videoPlayView = [self.view viewWithTag:i+50];
//            [videoPlayView removeFromSuperview];
//        }
//    }
//    
//}
////判断进入的人是否是自己邀请的人
//-(BOOL)isMemberAeeayContentWithUserId:(NSString *)userId{
//    for (CXGroupMember *member in self.memberArray) {
//        if ([member.userId isEqualToString:userId]) {
//            return YES;
//        }
//    }
//    return NO;
//}
//
////
//-(void)loadTopView{
//    SDRootTopView *topView = [self getRootTopView];
//    topView.backgroundColor = [UIColor clearColor];
//    
//    
//    [topView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(goBack)];
//    [topView setUpRightBarItemImage:[UIImage imageNamed:@"add"] addTarget:self action:@selector(addMember)];
//}
//
//-(void)goBack{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前正在通话，离开则会挂断，是否离开？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
//    
//}
//
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 1) {
//        [self hangupBtnTapped];
//    }
//}
///** 再次添加 */
//-(void)addMember{
//    SDSelectMemberViewController *vc = [[SDSelectMemberViewController alloc] init];
//    vc.groupId = self.roomId;
//    vc.isTwoSelect = YES;
//    vc.internalSelectedUsers = self.memberArray;
//    vc.delegate = self;
////    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
//    
//}
//
//
///** 加载子控件 */
//-(void)loadSubView{
//    //取消或者拒绝按钮
//    if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
//        [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.bottom.equalTo(self.view).mas_offset(-20-kTabbarSafeBottomMargin);
//            make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
//        }];
//    }else{
//        self.hangUpBtn.frame = CGRectMake(kButtonSpacing, Screen_Height - 170, 70, 95);
//        [self.hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view).mas_offset(kButtonSpacing);
//            make.bottom.equalTo(self.view).mas_offset(-120-kTabbarSafeBottomMargin);
//            make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
//        }];
//    }
//    
//    //接听按钮
//    [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view).mas_equalTo(-kButtonSpacing);
//        make.bottom.equalTo(self.view).mas_equalTo(-120-kTabbarSafeBottomMargin);
//        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
//    }];
//    
//    
//    //静音按钮
//    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).mas_offset(kButtonSpacing);
//        make.bottom.equalTo(self.view).mas_offset(-120-kTabbarSafeBottomMargin);
//        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
//    }];
//    
//    
//    //免提按钮
//    [self.handsfreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.right.equalTo(self.view).mas_equalTo(-kButtonSpacing);
//        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(self.view).mas_equalTo(-120-kTabbarSafeBottomMargin);
//        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
//    }];
//    
//    //计时
//    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view).mas_equalTo(-120-kButtonHeight-20-kTabbarSafeBottomMargin);
//        make.height.equalTo(@20);
//    }];
//    
//    //打开摄像头
//    [self.camareOpen mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.muteBtn);
//        make.right.equalTo(self.view).mas_offset(-30);
//        make.size.mas_equalTo(CGSizeMake(kButtonWidth, kButtonHeight));
//    }];
//    
//    //镜头切换
//    [self.camareChange mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.right.equalTo(self.view).mas_offset(-30);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//        make.centerX.equalTo(self.camareOpen);
//        make.centerY.equalTo(self.hangUpBtn);
//    }];
//    
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    //释放定时器
//    [self.timer invalidate];
//    self.timer = nil;
//    time = 0;
//    
//    [self.csTimer invalidate];
//    self.csTimer = nil;
//    
//    [[WebRTCHelper sharedInstance] exitRoom];
//}
//
//#pragma mark - 按钮事件（镜头切换，挂断，接听，静音，打开摄像头，免提）
///** 摄像头切换 */
//-(void)camareChangeAction:(UIButton *)sender{
//    
////    [self swapFrontAndBackCameras];
//    sender.selected = !sender.selected;
//    [[WebRTCHelper sharedInstance] camareChangeWithPreferringPosition:sender.selected?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront];
//}
//
////取消挂断方法
//- (void)hangupBtnTapped
//{
//    //释放定时器
//    [self.timer invalidate];
//    self.timer = nil;
//    time = 0;
//    
//    
//    [self.csTimer invalidate];
//    self.csTimer = nil;
//    
//    [[WebRTCHelper sharedInstance] exitRoom];
//    if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
//        if (self.isJoin) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }else{
//            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        }
//        
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    
//}
//
////接听方法
//-(void)answerBtnTapped{
//    [self connectAction];
//    [self.fromHeaderImage removeFromSuperview];
//    [self.fromNickName removeFromSuperview];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChangeAction) userInfo:nil repeats:YES];
//    
//    self.muteBtn.hidden = NO;
//    self.handsfreeBtn.hidden = NO;
//    self.answerBtn.hidden = YES;
//    
//    [self.hangUpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(self.view).mas_offset(-20-kTabbarSafeBottomMargin);
//        make.size.mas_offset(CGSizeMake(kButtonWidth, kButtonHeight));
//    }];
//    
//}
//
////静音方法
//-(void)muteBtnSelected{
//    _muteBtn.selected = !_muteBtn.selected;
//    if (_muteBtn.selected) {
//        [[WebRTCHelper sharedInstance].localAudioTrack setEnabled:NO];
//    }
//    else {
//        [[WebRTCHelper sharedInstance].localAudioTrack setEnabled:YES];
//    }
//    
//}
///** 打开摄像头 */
//-(void)camareOpenAction:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [[WebRTCHelper sharedInstance].localVideoTrack setEnabled:NO];
//        _localVideoView.hidden = YES;
//        self.camareChange.hidden = YES;
//        [sender setImage:[UIImage imageNamed:@"camare_close.jpg"] forState:UIControlStateNormal];
//        
//    }else{
//        [[WebRTCHelper sharedInstance].localVideoTrack setEnabled:YES];
//        _localVideoView.hidden = NO ;
//        self.camareChange.hidden = NO;
//        [sender setImage:[UIImage imageNamed:@"camare_open.jpg"] forState:UIControlStateNormal];
//    }
//}
////免提方法
//-(void)handsfreeBtnSelected{
//    _handsfreeBtn.selected = !_handsfreeBtn.selected;
//    if (_handsfreeBtn.selected) {
//        [WebRTCHelper sharedInstance].audioPlayMode = SDMediaCallAudioPlayModeLoudSpeaker;
//    }
//    else {
//        [WebRTCHelper sharedInstance].audioPlayMode = SDMediaCallAudioPlayModeEarphone;
//    }
//}
//
//#pragma mark - 懒加载
//-(UIImageView *)fromHeaderImage{
//    if (!_fromHeaderImage) {
//        _fromHeaderImage = [[UIImageView alloc] init];
//        _fromHeaderImage.frame = CGRectMake(Screen_Width/3, navHigh, Screen_Width/3, Screen_Width/3);
//        [self.view addSubview:_fromHeaderImage];
//    }
//    return _fromHeaderImage;
//}
//
//-(UILabel *)fromNickName{
//    if (_fromNickName) {
//        _fromNickName = [[UILabel alloc] init];
//        _fromNickName.frame = CGRectMake(0, Screen_Width/3+navHigh, Screen_Width, 20);
//        _fromNickName.textAlignment = NSTextAlignmentCenter;
//        _fromNickName.textColor = [UIColor whiteColor];
//        [self.view addSubview:_fromNickName];
//    }
//    return _fromNickName;
//}
//
//-(UIButton *)hangUpBtn{
//    if (!_hangUpBtn) {
//        _hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
//        [_hangUpBtn setBackgroundImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateHighlighted];
//        [_hangUpBtn addTarget:self action:@selector(hangupBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_hangUpBtn];
//    }
//    return _hangUpBtn;
//}
//
//-(UIButton *)answerBtn{
//    if (!_answerBtn) {
//        _answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
//            _answerBtn.hidden = YES;
//        }else{
//            _answerBtn.hidden = NO;
//        }
//        [_answerBtn setBackgroundImage:[UIImage imageNamed:@"answer"] forState:UIControlStateNormal];
//        [_answerBtn setBackgroundImage:[UIImage imageNamed:@"answer"] forState:UIControlStateHighlighted];
//        [_answerBtn addTarget:self action:@selector(answerBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_answerBtn];
//    }
//    
//    return _answerBtn;
//}
//
//-(UIButton *)muteBtn{
//    if (!_muteBtn) {
//        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
//            _muteBtn.hidden = NO;
//        }else{
//            _muteBtn.hidden = YES;
//        }
//        [_muteBtn setBackgroundImage:[UIImage imageNamed:@"silent_connect"] forState:UIControlStateNormal];
//        [_muteBtn setBackgroundImage:[UIImage imageNamed:@"silent_connect_select"] forState:UIControlStateSelected];
//        [_muteBtn addTarget:self action:@selector(muteBtnSelected) forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:_muteBtn];
//    }
//    
//    return _muteBtn;
//}
//
//-(UIButton *)handsfreeBtn{
//    if (!_handsfreeBtn) {
//        _handsfreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _handsfreeBtn.selected = VAL_ENABLE_LOUD_SPEAKER;
//        if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender) {
//            _handsfreeBtn.hidden = NO;
//        }else{
//            _handsfreeBtn.hidden = YES;
//        }
//        _handsfreeBtn.frame = CGRectMake(kButtonSpacing*3 + 70*2, Screen_Height - 170, 70, 95);
//        [_handsfreeBtn setBackgroundImage:[UIImage imageNamed:@"handsfree"] forState:UIControlStateNormal];
//        [_handsfreeBtn setBackgroundImage:[UIImage imageNamed:@"handsfree_select"] forState:UIControlStateSelected];
//        [_handsfreeBtn addTarget:self action:@selector(handsfreeBtnSelected) forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:_handsfreeBtn];
//    }
//    return _handsfreeBtn;
//}
//
//-(UILabel *)timeLabel{
//    if (!_timeLabel) {
//        _timeLabel = [[UILabel alloc] init];
//        _timeLabel.textColor = [UIColor whiteColor];
//        _timeLabel.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:_timeLabel];
//    }
//    return _timeLabel;
//}
//
//-(UIButton *)camareChange{
//    if (!_camareChange) {
//        _camareChange = [UIButton buttonWithType:UIButtonTypeCustom];
////        [_camareChange setTitle:@"切换" forState:UIControlStateNormal];
//        [_camareChange setBackgroundImage:[UIImage imageNamed:@"annex_carame_n"] forState:UIControlStateNormal];
//        [_camareChange setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_camareChange addTarget:self action:@selector(camareChangeAction:) forControlEvents:UIControlEventTouchUpInside];
//        _camareChange.hidden = YES;
//        [self.view addSubview:_camareChange];
//    }
//    
//    return _camareChange;
//}
//
//-(UIButton *)camareOpen{
//    if (!_camareOpen) {
//        _camareOpen = [UIButton buttonWithType:UIButtonTypeCustom];
////        [_camareOpen setTitle:@"摄像头打开" forState:UIControlStateNormal];
//        [_camareOpen setImage:[UIImage imageNamed:@"camare_open.jpg"] forState:UIControlStateNormal];
//        [_camareOpen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_camareOpen addTarget:self action:@selector(camareOpenAction:) forControlEvents:UIControlEventTouchUpInside];
//        _camareOpen.hidden = YES;
//        [self.view addSubview:_camareOpen];
//    }
//    return _camareOpen;
//}
//
//
//#pragma mark - SDSelectMemberDelegate
//-(void)getTwoSelectMemberArray:(NSMutableArray *)memberArray{
//    
//    int l = self.memberArray.count%maxLineCount;//列数
//    int h = (int)self.memberArray.count/maxLineCount;//行数
//    for (int i = self.memberArray.count; i < memberArray.count; i++) {
//        
//        CXGroupMember *member = memberArray[i];
//        CXVideoPlayView *videoPlayView = [[CXVideoPlayView alloc] init];
//        videoPlayView.tag = i+50;
//        videoPlayView.frame = CGRectMake(KVedioWidth*(l%maxLineCount), KVedioHeight*(h/maxLineCount)+navHigh, KVedioWidth, KVedioHeight);
//        [videoPlayView.headerImage setImageWithURL:[NSURL URLWithString:member.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"]];
//        [self.view addSubview:videoPlayView];
//        
//    }
//    
//    NSString *memberString = nil;
//    for (int i = 0;i<memberArray.count;i++) {
//        CXGroupMember *member =memberArray[i];
//        //通过imaccount获取用户的昵称和头像
//        SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:member.userId];
//        member.name = userModel.nickName;
//        member.icon = userModel.icon;
//        
//        //拼接IMAccount
//        if (memberString.length == 0) {
//            memberString = [NSString stringWithFormat:@"%@",member.userId];
//        }else{
//            memberString = [NSString stringWithFormat:@"%@,%@",memberString,member.userId];
//        }
//        
//    }
//    
//    for (int i = (int)self.memberArray.count ; i < memberArray.count; i++) {
//        CXGroupMember *member = memberArray[i];
//        [[CXIMService sharedInstance].chatManager sendMediaCallResponseWithType:self.audioOrVideoType status:CXIMMediaCallStatusRequest receiver:member.userId RoomId:self.roomId DRCallOwner:self.owner.userId DRCallMembers:memberString];
//    }
//    
//    self.memberArray = memberArray;
//    [self.csTimer invalidate];
//    self.csTimer  = nil;
//    self.csTimer = [NSTimer scheduledTimerWithTimeInterval:moreTime target:self selector:@selector(moreTimeAction) userInfo:nil repeats:NO];
//}
//
//#pragma mark - 响铃响铃事件
////开始响铃
//- (void)beginRing
//{
//    if(VAL_ENABLE_MAKE_SOUND){
//        if(self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender || (self.senderOrReceiveType == SDIMSenderOrReceiveTypeReceive && VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION)){
//            [_ringPlayer stop];
//            
//            NSString* musicPath;
//            NSURL* url;
//            if (self.senderOrReceiveType == SDIMSenderOrReceiveTypeReceive) {
//                //接听别人来电时提醒声音
//                musicPath = [[NSBundle mainBundle] pathForResource:@"receiveCallSong" ofType:@"mp3"];
//                url = [[NSURL alloc] initFileURLWithPath:musicPath];
//            }
//            else {
//                //拨打语音电话时提醒声音
//                musicPath = [[NSBundle mainBundle] pathForResource:@"sendCallSong" ofType:@"mp3"];
//                url = [[NSURL alloc] initFileURLWithPath:musicPath];
//            }
//            
//            if(_ringPlayer){
//                _ringPlayer = nil;
//            }
//            _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//            [_ringPlayer setVolume:1];
//            _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
//            if ([_ringPlayer prepareToPlay]) {
//                [_ringPlayer play]; //播放
//            }
//        }
//    }
//}
//
////结束响铃
//- (void)stopRing
//{
//    if(VAL_ENABLE_MAKE_SOUND){
//        if(self.senderOrReceiveType == SDIMSenderOrReceiveTypeSender || (self.senderOrReceiveType == SDIMSenderOrReceiveTypeReceive && VAL_ENABLE_GET_NEW_MESSAGE_NOTIFICATION)){
//            [_ringPlayer stop];
//        }
//    }
//}
//
//#pragma mark - 定时器事件
//-(void)moreTimeAction{
//    
//    
//    if (_remoteVideoTracks.count == 0) {
//        //30秒后如果没人进房间就退出
//        [self hangupBtnTapped];
//    }else{
//        
//        //30秒后如果有人进房间就把没进房间的人去掉，并且给连接上的视频重新排位置
//        int l = 0;//列数
//        int h = 0;//行数
//        int maxCount = 5;//一行5列
//        for (int i = 0; i < self.memberArray.count; i++) {
//            CXVideoPlayView *videoPlayView = [self.view viewWithTag:i+50];
//            NSLog(@"---------------%li",(long)videoPlayView.tag);
//            NSLog(@"%@",videoPlayView);
//            if (![_remoteVideoTracks valueForKey:videoPlayView.userId] && ![videoPlayView.userId isEqualToString:@"self"]) {
//                [videoPlayView removeFromSuperview];
//            }else{
//                [UIView animateWithDuration:0.5 animations:^{
//                    videoPlayView.frame = CGRectMake(KVedioWidth*l, KVedioHeight*h+navHigh, KVedioWidth, KVedioHeight);
//                }];
//                videoPlayView.tag = l+h*5+50;
//                l++;
//                if (l%maxCount==0) {
//                    h++;
//                }
//            }
//        }
//        self.memberArray = self.joinArray;
//    }
//}
//
//-(void)timeChangeAction{
//    
//    time++;
//    self.timeLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i",(time/60/60)%60,(time/60)%60,time%60];
//}
//
////获取摄像头-->前/后
//- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
//{
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
//    AVCaptureDevice *captureDevice = devices.firstObject;
//    
//    for ( AVCaptureDevice *device in devices ) {
//        if ( device.position == position ) {
//            captureDevice = device;
//            break;
//        }
//    }
//    
//    return captureDevice;
//}
//
//#pragma mark - 前后摄像头切换
//- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
//{
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    for (AVCaptureDevice *device in devices )
//        if ( device.position == position )
//            return device;
//    return nil;
//}
//
//- (void)swapFrontAndBackCameras {
//    // Assume the session is already running
//    
//    NSArray *inputs =self.session.inputs;
//    for (AVCaptureDeviceInput *input in inputs ) {
//        AVCaptureDevice *device = input.device;
//        if ( [device hasMediaType:AVMediaTypeVideo] ) {
//            AVCaptureDevicePosition position = device.position;
//            AVCaptureDevice *newCamera =nil;
//            AVCaptureDeviceInput *newInput =nil;
//            
//            if (position ==AVCaptureDevicePositionFront)
//                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
//            else
//                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
//            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
//            
//            // beginConfiguration ensures that pending changes are not applied immediately
//            [self.session beginConfiguration];
//            
//            [self.session removeInput:input];
//            [self.session addInput:newInput];
//            
//            // Changes take effect once the outermost commitConfiguration is invoked.
//            [self.session commitConfiguration];
//            break;
//        }
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
