//
//  SDChatViewControllerChange.m
//  SDIMApp
//
//  Created by wtz on 16/3/10.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import "SDIMChatViewController.h"
#import "ChatMoreView.h"
#import "RecorderManager.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerManager.h"
#import "SDChattingCell.h"
#import "Masonry.h"
#import "UIView+Category.h"
#import "SDPermissionsDetectionUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>
//表情
#import "DXFaceView.h"

#import "SDMenuView.h"
#import "SDMyLocationViewController.h"
#import "SDChatManager.h"
#import "SDIMGroupInfoViewController.h"
#import "SDIMVoiceAndVideoCallViewController.h"
#import "SDUserCurrentLocation.h"
#import "CXIMHelper.h"
#import "SDContactsDetailController.h"
#import "SDIMPersonInfomationViewController.h"
#import "MJRefresh.h"
#import "IBActionSheet.h"
#import "HttpTool.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import "CXLoaclDataManager.h"
#import "TZImagePickerController.h"
#import "CXForwardSelectContactsViewController.h"
#import "CXIDGBackGroundViewUtil.h"
#import "SDSelectMemberViewController.h"
//#import "CXMultiplayerVideoViewController.h"
#import "UIImageView+WebCache.h"


// 消息每次加载的条数
#define kMessageLoadLimit 15
// 表情键盘的高度
#define kHeightOfEmoji 200
// 录音文件名
#define kRecordAudioFileName @"Voice.spx"
// 录音文件路径
#define kRecordAudioFilePath ([([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]) stringByAppendingPathComponent:kRecordAudioFileName])
// 动画时长 
#define kAnimationDuration .25

#define kHasRecordPermission ([SDPermissionsDetectionUtils checkCanRecordFree])

#define kDuration 10.0
#define kTrans Screen_Width/kDuration/60.0
#define kLittleVideoViewHeight Screen_Width

#define kChatMoreViewHeight (self.isGroupChat ? 98 : 188)
//#define kChatMoreViewHeight 188
// 定位间隔(sec)
#define kLocateInterval 60.0

typedef NS_ENUM(NSInteger,VideoStatus){
    //拍摄结束
    VideoStatusEnded = 0,
    //拍摄开始
    VideoStatusStarted
};


@interface SDIMChatViewController()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ChatMoreViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RecordingDelegate,SDChattingCellDelegate,AVCaptureFileOutputRecordingDelegate,DXFaceDelegate,CXIMGroupDelegate, CXIMChatDelegate,SDMyLocationViewControllDelegate,SDMyLocationViewControllDelegate,SDMenuViewDelegate,UIAlertViewDelegate,IBActionSheetDelegate,TZImagePickerControllerDelegate>
{
    UIView *joinViewOpen;
    UIView *joinView;
    UIButton *cancel;
    UIButton *joinButton;
    UIScrollView *headerImageScrollView;
    NSMutableArray *membersArray;
    UILabel *videoMemberNumber;
}
@property (nonatomic,strong) UITableView *tableView;

// 底部操作栏
@property (nonatomic,strong) UIView *toolView;
// 文本输入
@property (nonatomic,strong) UITextView *textView;
// 文本框底部线条
@property (nonatomic,strong) UIView *textViewBottomLine;
// 底部操作栏左边按钮（麦克风/键盘）
@property (nonatomic,strong) UIButton *toolViewVoiceBtn;
// 麦克风录音
@property (nonatomic,strong) UIButton *toolViewRecordBtn;
// 更多
@property (nonatomic,strong) UIButton *toolViewMoreBtn;
// 表情
@property (nonatomic,strong) UIButton *toolViewFaceBtn;
// 更多
@property (nonatomic,strong) ChatMoreView *moreView;

// 消息
@property (nonatomic,strong) NSMutableArray *messages;

// 图片选择器
@property (nonatomic,strong) UIImagePickerController *imagePicker;

// 录音提示
@property (nonatomic,strong) UIImageView *recordTipImageView;

// 刷新控件
@property (nonatomic,strong) UIRefreshControl *refreshControl;

// 删除聊天记录确认view
@property (nonatomic,strong) UIView *deleteRecordConfirmView;

// 遮盖view
@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,strong) RecorderManager *recordManager;

// 约束
@property (nonatomic,strong) MASConstraint *toolViewBottomConstaint;
@property (nonatomic,strong) MASConstraint *tableViewTopConstraint;

@property (nonatomic,strong) NSMutableDictionary *cellHeights;

/**
 *  定位用的timer
 */
@property (nonatomic, strong) NSTimer *locateTimer;

/**
 *  定位用的工具类
 */
@property (nonatomic, strong) SDUserCurrentLocation *locationMgr;

/**
 *  获取到的位置信息（获取失败时为nil）
 */
@property (nonatomic, strong) CXIMLocationInfo *currentLocation;

//小视频－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

//小视频后面整个屏幕覆盖黑色的BgView
@property (nonatomic,strong) UIView * bgView;

//小视频整个View
@property (nonatomic,strong) UIView * videoView;

//录制的进度条View，最短3秒，最长10秒
@property (nonatomic,strong) UIView * progressView;

//录制小视频取消提示Label
@property (nonatomic,strong) UILabel * cancleLabel;

//按住开始录制Button
@property (nonatomic,strong) UILabel * tapBtn;

//聚焦光圈
@property (nonatomic,strong) UIView *focusCircle;

//按住拍按钮的背景View
@property (nonatomic,strong) UIView * tapBtnBackView;

//拍摄结束和开始的类型
@property (nonatomic) VideoStatus status;

//CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器
@property (nonatomic,strong) CADisplayLink *link;

//_canSave是一个BOOL，YES表示没有上滑取消，可以压缩发送，NO表示不可以上滑发送
@property (nonatomic) BOOL canSave;

@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDevice * videoDevice;
@property (nonatomic,strong) AVCaptureDevice * audioDevice;
@property (nonatomic,strong) AVCaptureDeviceInput * videoInput;
@property (nonatomic,strong) AVCaptureDeviceInput * audioInput;
@property (nonatomic,strong) AVCaptureMovieFileOutput * movieOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

//小视频－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－



/**
 *  表情的附加页面
 */
@property (strong, nonatomic) DXFaceView *faceView;

@property (nonatomic,strong) SDRootTopView *rootTopView;
/// 选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
@property (nonatomic, strong) UIButton* selectedButton;

/** 模板cell */
@property ( strong) SDChattingCell *templateCell;

/** 当前会话人是否是客服 */
@property (nonatomic) BOOL chatterIsKefu;

/** 是否显示上滑取消图片 */
@property (nonatomic) BOOL showCancleRecordImage;

/** 是否显示阅后即焚的键盘 */
@property (nonatomic) BOOL showBurnAfterReadingToolView;

/** 阅后即焚的叉子取消按钮 */
@property (nonatomic, strong) UIButton* cancleBurnAfterReadingButton;

/** 阅后即焚的的图片菜单按钮 */
@property (nonatomic, strong) UIButton* burnAfterReadingImageSelectListButton;

/** 是否能看到对方的定位 */
@property (nonatomic) BOOL canSeeLocation;

@end


@implementation SDIMChatViewController
-(NSMutableDictionary *)cellHeights{
    if (_cellHeights == nil) {
        _cellHeights = [NSMutableDictionary dictionary];
    }
    return _cellHeights;
}
#pragma mark - 懒加载
-(ChatMoreView *)moreView{
    if (_moreView == nil) {
        _moreView = [[ChatMoreView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kChatMoreViewHeight + kTabbarSafeBottomMargin) AndChatMoreViewType:self.isGroupChat?ChatMoreViewGroupType:ChatMoreViewNotGroupType];
        _moreView.backgroundColor = [UIColor whiteColor];
        _moreView.delegate = self;
    }
    return _moreView;
}

-(DXFaceView *)faceView{
    if (_faceView == nil) {
        _faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeightOfEmoji + kTabbarSafeBottomMargin)];
        _faceView.delegate = self;
        self.faceView.backgroundColor = [UIColor lightGrayColor];
    }
    return _faceView;
}

-(UIButton *)toolViewRecordBtn{
    if (_toolViewRecordBtn == nil) {
        _toolViewRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _toolViewRecordBtn.hidden = YES;
        _toolViewRecordBtn.backgroundColor = [UIColor clearColor];
        _toolViewRecordBtn.layer.cornerRadius = 3;
        _toolViewRecordBtn.layer.borderColor = kColorWithRGB(170, 170, 170).CGColor;
        _toolViewRecordBtn.layer.borderWidth = 1;
        [_toolViewRecordBtn setTitleColor:kColorWithRGB(170, 170, 170) forState:UIControlStateNormal];
        [_toolViewRecordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_toolViewRecordBtn addTarget:self action:@selector(toolViewRecordBtnTouchDown) forControlEvents:UIControlEventTouchDown];
        [_toolViewRecordBtn addTarget:self action:@selector(toolViewRecordBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_toolViewRecordBtn addTarget:self action:@selector(toolViewRecordBtnTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_toolViewRecordBtn addTarget:self action:@selector(toolViewRecordBtnTouchExit) forControlEvents:UIControlEventTouchDragExit];
        [self.toolView insertSubview:_toolViewRecordBtn aboveSubview:self.textView];
        [_toolViewRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(self.textView);
        }];
    }
    return _toolViewRecordBtn;
}

-(UIImagePickerController *)imagePicker{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

-(UIImageView *)recordTipImageView{
    if (_recordTipImageView == nil) {
        _recordTipImageView = [[UIImageView alloc] init];
        _recordTipImageView.image = [UIImage imageNamed:@"newvoiceChatImage001"];
        _recordTipImageView.highlightedImage = [UIImage imageNamed:@"newvoiceChatImage001"];
        _recordTipImageView.hidden = YES;
        _recordTipImageView.frame = CGRectMake((Screen_Width - 150)/2, (Screen_Height - 150)/2 + 10, 150, 150);
        [self.view addSubview:_recordTipImageView];
    }
    return _recordTipImageView;
}

//如果弹出聊天记录确认删除View则需要覆盖一层coverView
-(UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.hidden = YES;
        //        _coverView.backgroundColor = RGBA(0, 0, 0, .3);
        _coverView.backgroundColor = [UIColor grayColor];
        [self.navigationController.view addSubview:_coverView];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navigationController.view);
        }];
    }
    return _coverView;
}

//初始化删除聊天记录确认View
-(UIView *)deleteRecordConfirmView{
    if (_deleteRecordConfirmView == nil) {
        _deleteRecordConfirmView = [[UIView alloc] init];
        _deleteRecordConfirmView.backgroundColor = [UIColor whiteColor];
        _deleteRecordConfirmView.hidden = YES;
        [self.navigationController.view insertSubview:_deleteRecordConfirmView aboveSubview:self.coverView];
        [_deleteRecordConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.navigationController.view).multipliedBy(.8);
            make.height.mas_equalTo(130);
            make.center.equalTo(self.navigationController.view);
        }];
        
        // 标题
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        title.numberOfLines = 0;
        title.text = [NSString stringWithFormat:@"确定删除和%@的聊天记录吗",self.chatterDisplayName];
        title.textAlignment = NSTextAlignmentLeft;
        [_deleteRecordConfirmView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_deleteRecordConfirmView).offset(15);
            make.leading.equalTo(_deleteRecordConfirmView).offset(15);
            make.trailing.equalTo(_deleteRecordConfirmView).offset(-15);
        }];
        
        // 确认按钮
        UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ensureBtn.titleLabel.font = title.font;
        [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [ensureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [ensureBtn addTarget:self action:@selector(deleteRecordsConfirmViewEnsureBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_deleteRecordConfirmView addSubview:ensureBtn];
        [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(_deleteRecordConfirmView).offset(-15);
        }];
        
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.titleLabel.font = title.font;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(deleteRecordsConfirmViewCancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_deleteRecordConfirmView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ensureBtn);
            make.trailing.equalTo(ensureBtn.mas_leading).offset(-25);
        }];
        
    }
    return _deleteRecordConfirmView;
}

// 录音机
-(RecorderManager *)recordManager{
    if (_recordManager == nil) {
        _recordManager = [RecorderManager sharedManager];
        _recordManager.delegate = self;
        _recordManager.filename = kRecordAudioFilePath;
    }
    return _recordManager;
}

- (NSTimer *)locateTimer {
    if (_locateTimer == nil) {
        _locateTimer = [NSTimer scheduledTimerWithTimeInterval:kLocateInterval target:self selector:@selector(locateTimerFire) userInfo:nil repeats:YES];
        _locateTimer.fireDate = [NSDate distantFuture];
    }
    return _locateTimer;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(232.0, 232.0, 232.0, 1.0);
    
    self.recordTipImageView.hidden = YES;

    if(self.isGroupChat){
        self.canSeeLocation = NO;
        [self setUpViewController];
    }else{
        NSString *url = [NSString stringWithFormat:@"%@sysuser/isLeader", urlPrefix];
        NSMutableDictionary * params = @{}.mutableCopy;
        NSString * myCode = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT].code;
        NSString * otherCode = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:self.chatter].code;
        [params setValue:myCode forKey:@"myCode"];
        [params setValue:otherCode forKey:@"otherCode"];
        __weak __typeof(self)weakSelf = self;
//        [self showHudInView:self.view hint:nil];
        [HttpTool postWithPath:url params:params success:^(id JSON) {
            if ([JSON[@"status"] integerValue] == 200) {
                [weakSelf hideHud];
                if([JSON[@"data"] integerValue] == 2){
                    self.canSeeLocation = NO;
                }else{
                    self.canSeeLocation = YES;
                }
                [self setUpViewController];
                
            }else{
                [weakSelf hideHud];
                self.canSeeLocation = NO;
                [self setUpViewController];
            }
        } failure:^(NSError *error) {
            [weakSelf hideHud];
            self.canSeeLocation = NO;
            [self setUpViewController];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([CXIMService sharedInstance].socketManager.state != CXIMSocketState_OPEN){
        [[CXIMService sharedInstance].socketManager reconnectWithCompletion:^(NSError *error) {
            
        }];
    }
    
    [self sendViewWillAppearBlockMethod];
}

- (void)sendViewWillAppearBlockMethod {
    [self.textView resignFirstResponder];
    //在这里判断当前的接收人是否是客服
    //    NSMutableArray *kefuArray = [[SDDataBaseHelper shareDB] getKeFuArr];
    NSMutableArray *kefuArray = [[[CXLoaclDataManager sharedInstance]getKefuArray] mutableCopy];
    for(SDCompanyUserModel * user in kefuArray){
        if([user.hxAccount isEqualToString:self.chatter]){
            self.chatterIsKefu = YES;
            break;
        }
    }
    if(self.searchMessage || self.superSearchMessages){
        [self scrollToTop];
    }
    [self scrollToScrollMessage];
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * messageDeleteTimeCountDic = [[ud objectForKey:[NSString stringWithFormat:@"Message_Delete_Time_Count_Dic_%@_%@",VAL_HXACCOUNT,self.chatter]] mutableCopy ] ?: @{}.mutableCopy;
    if(messageDeleteTimeCountDic && [messageDeleteTimeCountDic count] >0){
        if(_burnMessagesAfterReadTimer){
            [_burnMessagesAfterReadTimer invalidate];
            _burnMessagesAfterReadTimer = nil;
        }
        _burnMessagesAfterReadTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(burnMessagesAfterReadTimerWork) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_burnMessagesAfterReadTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSMutableArray * readedMessagesIDs = [self getReadedMessagesIDs];
    if(readedMessagesIDs && [readedMessagesIDs count] > 0){
        [[CXIMService sharedInstance].chatManager sendMessageReadAskForChatter:self.chatter messageIds:readedMessagesIDs];
    }
    [[CXIMService sharedInstance].chatManager setMessagesReadedForChatter:self.chatter];
}

// 退出界面时停止播放
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[PlayerManager sharedManager] stopPlaying];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[CXIMService sharedInstance].chatManager removeDelegate:self];
    [[CXIMService sharedInstance].groupManager removeDelegate:self];
}

#pragma mark - 提示
- (void)showMessage:(NSString *)msg {
    //显示提示信息
    UIView* view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 20.f;
    hud.yOffset = IS_IPHONE_5 ? 200.f : 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}


-(void)setupTopView{
    self.rootTopView = [self getRootTopView];
    
    [self.rootTopView setNavTitle:self.chatterDisplayName];
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(back)];
    
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add"] addTarget:self action:@selector(addBtnEvent:)];
}

-(void)back{
    [self.locateTimer invalidate];
    self.locateTimer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addBtnEvent:(UIButton *)sender{
    _selectedButton = sender;
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        NSArray* dataArray;
        NSArray* imageArray;
        if(self.chatterIsKefu){
            dataArray = @[ (self.isGroupChat ? @"会话信息" : @"清除信息")];
            imageArray = @[ self.isGroupChat ? @"menu_contact" : @"menu_delete"];
        }else{
            dataArray = @[ (self.isGroupChat ? @"会话信息" : @"清除信息")];
            imageArray = @[ self.isGroupChat ? @"menu_contact" : @"menu_delete" ];
        }
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    else {
        [_selectMemu removeFromSuperview];
    }
}

- (NSMutableArray *)getReadedMessagesIDs
{
    NSArray * messages = [[CXIMService sharedInstance].chatManager getUnreadMessagesForChatter:self.chatter];
    NSMutableArray * readedMessages = [[NSMutableArray alloc] initWithCapacity:0];
    for (CXIMMessage * message in messages) {
        if(message.type == CXIMProtocolTypeSingleChat && [message.receiver isEqualToString:VAL_HXACCOUNT] && (message.body.type == CXIMMessageContentTypeText || message.body.type == CXIMMessageContentTypeImage || message.body.type == CXIMMessageContentTypeLocation) && ![message.ext[@"isBurnAfterRead"] isEqualToString:@"1"]){
            [readedMessages addObject:message.ID];
        }
    }
    return readedMessages;
}

- (void)openBurnAfterRead
{
    self.toolViewMoreBtn.hidden = YES;
    self.showBurnAfterReadingToolView = YES;
    self.cancleBurnAfterReadingButton.hidden = NO;
    self.toolViewFaceBtn.hidden = YES;
    self.burnAfterReadingImageSelectListButton.hidden = NO;
    
    [self.toolViewVoiceBtn setImage:[UIImage imageNamed:@"burnAfterReadVoiceBtn"] forState:UIControlStateNormal];
    [self.toolViewVoiceBtn setImage:[UIImage imageNamed:@"burnAfterReadKeyboardBtn"] forState:UIControlStateSelected];
    
    self.textViewBottomLine.backgroundColor = [UIColor redColor];
    
    self.toolViewRecordBtn.layer.borderColor = kColorWithRGB(255, 0, 0).CGColor;
    
    [self.toolViewRecordBtn setTitleColor:kColorWithRGB(134, 134, 134) forState:UIControlStateNormal];
    
    self.toolViewMoreBtn.selected = NO;
    [self setVoiceInputOn:NO];
    self.textView.inputView = nil;
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    _selectedButton.selected = NO;
    [_selectMemu removeFromSuperview];
    
    if (cardID == 0) {
        if (self.isGroupChat == NO) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除聊天记录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 10003;
            [alert show];
        }
        else {
            SDIMGroupInfoViewController * groupInfoNewViewController = [[SDIMGroupInfoViewController alloc] initSDIMGroupInfoViewControllerWithGroupId:self.chatter];
            [self.navigationController pushViewController:groupInfoNewViewController animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
            
        }
    }
    else {
    }
}

#pragma mark - 有新消息就layout
//-(void)viewDidLayoutSubviews{
////    [self.tableView reloadData];
////    if(_messages.count > 0){
////        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
////    }
//}

- (void)scrollToScrollMessage
{
    //    if(self.scrollMessage){
    //        NSInteger index = 0;
    //        for(CXIMMessage * message in _messages){
    //            if([self.scrollMessage.sendTime isEqual:message.sendTime]){
    //                break;
    //            }
    //            index++;
    //        }
    //        NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
    //        if (row > 0) {
    //            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    //        }
    //    }
}

#pragma mark - 注册通知
-(void)registerNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChangeGroupNameNotification:) name:changeIMGroupNameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteGroupHistoryMessageReloadMessage) name:deleteGroupHistoryChatMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refetchMessages) name:CXIM_RefetchMessages_Notification object:nil];
}

#pragma mark - 通知
- (void)receiveChangeGroupNameNotification:(NSNotification *)noti {
    CXGroupInfo *groupInfo = noti.userInfo[@"groupInfo"];
    [self.rootTopView setNavTitle:groupInfo.groupName];
}

- (void)deleteGroupHistoryMessageReloadMessage
{
    [_messages removeAllObjects];
    [self fetchMessages];
}

#pragma mark - CXIMService代理方法
-(void)CXIMService:(CXIMService *)service didSendMessageSuccess:(CXIMMessage *)message{
    //    CXIMMessage *message = noti.userInfo[@"message"];
    // 是当前会话
    if([message.receiver isEqualToString:self.chatter]){
        [_messages removeAllObjects];
        [self fetchMessages];
        [self scrollToBottom];
    }
}

-(void)CXIMService:(CXIMService *)service didReceiveChatMessage:(CXIMMessage *)message{
    // 清空未读消息状态
    //    [[CXIMService sharedInstance].chatManager setMessageReadedForChatter:self.chatter];
    if([message.sender isEqualToString:self.chatter]){
        NSMutableArray * readedMessagesIDs = [self getReadedMessagesIDs];
        if(readedMessagesIDs && [readedMessagesIDs count] > 0){
            [[CXIMService sharedInstance].chatManager sendMessageReadAskForChatter:self.chatter messageIds:readedMessagesIDs];
        }
        [[CXIMService sharedInstance].chatManager setMessagesReadedForChatter:self.chatter];
    }
    [self.messages removeAllObjects];
    [self fetchMessages];
    [self scrollToBottom];
}

- (void)CXIMService:(CXIMService *)service didReceiveReadAsksOfChatter:(NSString *)chatter messages:(NSArray<CXIMMessage *> *)messages {
    if([chatter isEqualToString:self.chatter]){
        //        NSMutableArray * readedMessagesIDs = [self getReadedMessagesIDs];
        //        if(readedMessagesIDs && [readedMessagesIDs count] > 0){
        //            [[CXIMService sharedInstance].chatManager sendMessageReadAskForChatter:self.chatter messageIds:readedMessagesIDs];
        //        }
        [self.messages removeAllObjects];
        [self fetchMessages];
    }
}

// 被移除当前群组
- (void)CXIMService:(CXIMService *)service didRemovedFromGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time {
    if(!self.isGroupChat) return;
    if ([groupId isEqualToString:self.chatter]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 键盘伸缩通知
-(void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [aValue CGRectValue].size.height;
    
    self.toolViewBottomConstaint.mas_equalTo(-height);
    [self setupTableViewTopConstant:navHigh - height];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)setupTableViewTopConstant:(CGFloat)constant {
    // 往上挪需要先判断tableview内容
    if (constant < 0) {
        CGFloat t = 66 * 2 + self.tableView.contentSize.height + fabs(constant) + 44;
        if (t > Screen_Height) {
            self.tableViewTopConstraint.mas_equalTo(-fabs(constant));
        }
    }
    else {
        self.tableViewTopConstraint.mas_equalTo(constant);
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    self.textView.inputView = nil;
    self.toolViewFaceBtn.selected = self.toolViewMoreBtn.selected = NO;
    self.toolViewBottomConstaint.mas_equalTo(-kTabbarSafeBottomMargin);
    [self setupTableViewTopConstant:navHigh];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 录音流程
// 录音按下
-(void)toolViewRecordBtnTouchDown
{
    self.recordTipImageView.image = [UIImage imageNamed:@"newvoiceChatImage001"];
    self.recordTipImageView.highlightedImage = [UIImage imageNamed:@"newvoiceChatImage001"];
    self.showCancleRecordImage = NO;
#if TARGET_IPHONE_SIMULATOR
    TTAlert(@"请使用真机");
    return;
#else
    if (!kHasRecordPermission) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有录音权限" message:@"您可以在“隐私设置”中开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.recordTipImageView.hidden = NO;
    [self.recordManager startRecording];
#endif
}

// 录音完毕
-(void)toolViewRecordBtnTouchUpInside
{
    [self.recordManager stopRecording];
    self.recordTipImageView.hidden = YES;
}

// 录音取消
-(void)toolViewRecordBtnTouchUpOutside
{
    [self.recordManager cancelRecording];
    self.recordTipImageView.hidden = YES;
}

- (void)toolViewRecordBtnTouchExit
{
    self.showCancleRecordImage = YES;
    self.recordTipImageView.image = [UIImage imageNamed:@"sendVoiceCancleImage"];
    self.recordTipImageView.highlightedImage = [UIImage imageNamed:@"sendVoiceCancleImage"];
}

//录音过程中图片的改变
- (void)levelMeterChanged:(float)levelMeter
{
    //    NSInteger volumn = levelMeter * 100;
    //    NSInteger imgNo = MAX(volumn / 5.0, 1);
    //    NSString *imgName = [NSString stringWithFormat:@"VoiceSearchFeedback%03ld",(long)imgNo];
    //    self.recordTipImageView.image = [UIImage imageNamed:imgName];
    
    if(!_showCancleRecordImage){
        NSInteger x = arc4random() % 7;
        NSString *imgName = [NSString stringWithFormat:@"newvoiceChatImage00%zd",x];
        self.recordTipImageView.image = [UIImage imageNamed:imgName];
    }
}

- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
    NSLog(@"录音完成-> 时间=%lf 文件位置-%@",interval,filePath);
    if (interval < 1.0) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            TTAlert(@"录音时间太短");
        });
    }
    else{
        NSNumber *size = @([[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize]);
        [self sendVoiceMessageWithPath:filePath length:@((int)interval) size:size];
    }
}

- (void)recordingTimeout
{
    [self toolViewRecordBtnTouchUpInside];
    TTAlert(@"录音已到最大时长");
}

//录音机停止采集声音
- (void)recordingStopped
{
    NSLog(@"recordingStopped");
}

- (void)recordingFailed:(NSString *)failureInfoString
{
    NSLog(@"recordingFailed");
}


#pragma mark - 初始化界面
- (void)setUpViewController
{
    self.chatterIsKefu = NO;
    
    self.showCancleRecordImage = NO;
    
    self.showBurnAfterReadingToolView = NO;
    
    if (VAL_ENABLE_GET_LOCATION) {
        self.locateTimer.fireDate = [NSDate distantPast];
    }
    [self setupTopView];
    self.title = self.chatterDisplayName;
    [[CXIMService sharedInstance].chatManager addDelegate:self];
    [[CXIMService sharedInstance].groupManager addDelegate:self];
    
    [CXIDGBackGroundViewUtil coverTextWithNoTagOnView:self.view Frame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) Text:VAL_USERNAME AndTextColor:RGBACOLOR(216.0, 216.0, 216.0, 1.0)];
    
    [self registerNotifications];
    [self createUI];
    if(self.isSecretLanguage){
        [self openBurnAfterRead];
    }
    
    //在这里判断当前的接收人是否是客服
    //    NSMutableArray *kefuArray = [[SDDataBaseHelper shareDB] getKeFuArr];
    NSMutableArray *kefuArray = [[[CXLoaclDataManager sharedInstance]getKefuArray] mutableCopy];
    for(SDCompanyUserModel * user in kefuArray){
        if([user.hxAccount isEqualToString:self.chatter]){
            self.chatterIsKefu = YES;
            break;
        }
    }
    
    if (self.chatterIsKefu) {
        CXIMMessage *kfWelcomeMessage = [[CXIMMessage alloc] init];
        kfWelcomeMessage.type = CXIMMessageTypeChat;
        kfWelcomeMessage.sender = self.chatter;
        kfWelcomeMessage.receiver = [CXIMService sharedInstance].chatManager.currentAccount;
        kfWelcomeMessage.body = [CXIMTextMessageBody bodyWithTextContent:@"您好，欢迎使用叮当享服务，服务时间：8:30-17:30（周一至周六），请问有什么可以帮您？"];
        kfWelcomeMessage.status = CXIMMessageStatusSendSuccess;
        kfWelcomeMessage.readFlag = CXIMMessageReadFlagReaded;
        kfWelcomeMessage.openFlag = CXIMMessageReadFlagReaded;
        kfWelcomeMessage.readAsk = CXIMMessageReadFlagReaded;
        [[CXIMService sharedInstance].chatManager saveMessageToDB:kfWelcomeMessage];
        [_messages removeAllObjects];
        [self fetchMessages];
    }
    
    
    
    joinView = [[UIView alloc] init];
    joinView.frame = CGRectMake(0, navHigh, Screen_Width, 30);
    joinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:joinView];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = CGRectMake(15, 5, 20, 20);
    image.image = [UIImage imageNamed:@"ZTIMG"];
    [joinView addSubview:image];
    
    videoMemberNumber = [[UILabel alloc] init];
    videoMemberNumber.frame = CGRectMake(CGRectGetMaxX(image.frame)+10, 5, 200, 20);
    videoMemberNumber.text = @"2人正在语音通话";
    [joinView addSubview:videoMemberNumber];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinAction:)];
    [joinView addGestureRecognizer:tap];
    
    joinViewOpen = [[UIView alloc] init];
    joinViewOpen.frame = joinView.frame;
//    joinViewOpen.frame = CGRectMake(0, navHigh, Screen_Width, 150);
    joinViewOpen.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:joinViewOpen];
    
    UILabel *joinOrNot = [[UILabel alloc] init];
    joinOrNot.frame = CGRectMake(0, 10, Screen_Width, 20);
    joinOrNot.textAlignment = NSTextAlignmentCenter;
    joinOrNot.text = @"是否加入语音通话";
    [joinViewOpen addSubview:joinOrNot];
    
    headerImageScrollView = [[UIScrollView alloc] init];
    headerImageScrollView.frame = CGRectMake(0, CGRectGetMaxY(joinOrNot.frame)+10, Screen_Width, 40);
    headerImageScrollView.contentSize = CGSizeMake(Screen_Width, 40);
//    headerImageScrollView.backgroundColor = [UIColor blueColor];
    [joinViewOpen addSubview:headerImageScrollView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *members = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@",self.chatter,VAL_Account]];
    if (members != nil && members.length != 0 && [members containsString:@","]) {
        membersArray = [NSMutableArray array];
        NSArray *membersUserIdArray = [members componentsSeparatedByString:@","];
        for (int i = 0; i < membersUserIdArray.count; i++) {
            CXGroupMember *member = [[CXGroupMember alloc] init];
            member.userId = membersUserIdArray[i];
            SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:membersUserIdArray[i]];
            member.icon = userModel.icon;
            member.name = userModel.name;
            [membersArray addObject:member];
            
            UIImageView *headerImageView = [[UIImageView alloc] init];
            headerImageView.frame = CGRectMake(10 + 50*i, 5, 40, 40);
            [headerImageView setImageWithURL:[NSURL URLWithString:userModel.icon]];
            headerImageView.layer.cornerRadius = 20;
            headerImageView.layer.masksToBounds = YES;
            [headerImageScrollView addSubview:headerImageView];
            
        }
        videoMemberNumber.text = [NSString stringWithFormat:@"%lu人正在通话",(unsigned long)membersUserIdArray.count];
    }else{
        joinView.hidden = YES;
        joinViewOpen.hidden = YES;
    }
    
    
    
    
    cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, Screen_Width/2, 40);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancel.layer.masksToBounds = YES;
    cancel.layer.borderWidth = 1;
    cancel.tag = 100;
    cancel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel addTarget:self action:@selector(joinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [joinViewOpen addSubview:cancel];
    
    joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinButton.frame = CGRectMake(Screen_Width/2, 0, Screen_Width/2, 40);
    [joinButton setTitle:@"加入" forState:UIControlStateNormal];
    [joinButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    joinButton.layer.masksToBounds = YES;
    joinButton.layer.borderWidth = 1;
    joinButton.tag = 101;
    joinButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    joinButton.backgroundColor = [UIColor whiteColor];
    [joinButton addTarget:self action:@selector(joinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [joinViewOpen addSubview:joinButton];
    joinViewOpen.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberWithInTheCall:) name:numberWithInTheCallNotification object:nil];
}

-(void)numberWithInTheCall:(NSNotification *)notifition{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *members = [defaults objectForKey:[NSString stringWithFormat:@"%@_%@",self.chatter,VAL_Account]];
    if (members != nil && members.length != 0 && [members containsString:@","]) {
        membersArray = [NSMutableArray array];
        NSArray *membersUserIdArray = [members componentsSeparatedByString:@","];
        for (int i = 0; i < membersUserIdArray.count; i++) {
            CXGroupMember *member = [[CXGroupMember alloc] init];
            member.userId = membersUserIdArray[i];
            SDCompanyUserModel *userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:membersUserIdArray[i]];
            member.icon = userModel.icon;
            member.name = userModel.name;
            [membersArray addObject:member];
            
            UIImageView *headerImageView = [[UIImageView alloc] init];
            headerImageView.frame = CGRectMake(10 + 50*i, 5, 40, 40);
            [headerImageView setImageWithURL:[NSURL URLWithString:userModel.icon]];
            headerImageView.layer.cornerRadius = 20;
            headerImageView.layer.masksToBounds = YES;
            [headerImageScrollView addSubview:headerImageView];
            
        }
        videoMemberNumber.text = [NSString stringWithFormat:@"%lu人正在通话",(unsigned long)membersUserIdArray.count];
        
        joinView.hidden = NO;
    }else{
        joinView.hidden = YES;
        joinViewOpen.hidden = YES;
    }
}



-(void)joinAction:(UITapGestureRecognizer *)tap{
    joinView.hidden = YES;
    joinViewOpen.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        joinViewOpen.frame = CGRectMake(0, navHigh, Screen_Width, 150);
        cancel.frame = CGRectMake(0, 110, Screen_Width/2, 40);
        joinButton.frame = CGRectMake(Screen_Width/2, 110, Screen_Width/2, 40);
    }];
}

-(void)joinButtonAction:(UIButton *)sender{
    if (sender.tag == 100) {
        
        [UIView animateWithDuration:0.2 animations:^{
            joinViewOpen.frame = joinView.frame;
            cancel.frame = CGRectMake(0, 0, Screen_Width/2, 40);
            joinButton.frame = CGRectMake(Screen_Width/2, 0, Screen_Width/2, 40);
        } completion:^(BOOL finished) {
            joinView.hidden = NO;
            joinViewOpen.hidden = YES;
        }];
        
    }else{
        
        CXGroupMember *member = [[CXGroupMember alloc] init];
        member.icon = VAL_Icon;
        member.name = VAL_USERNAME;
        member.userId = VAL_HXACCOUNT;
        [membersArray addObject:member];
        
//        CXMultiplayerVideoViewController *vc = [[CXMultiplayerVideoViewController alloc] init];
//        vc.memberArray = membersArray;
//        vc.roomId = self.chatter;
//        vc.isJoin = YES;
//        vc.senderOrReceiveType = SDIMSenderOrReceiveTypeReceive;
//        vc.audioOrVideoType = CXIMMediaCallTypeDRVideo;
//        //        SDRootNavigationController *nav = [[SDRootNavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)createUI{
    [self setRightTopBarButton];
    [self addBottomBar];
    [self addTalkLsitTable];
}

//设置顶部右面按钮
-(void)setRightTopBarButton
{
    // 群聊
    if (_isGroupChat) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar-group"] style:UIBarButtonItemStylePlain target:self action:@selector(groupInfoBtnTapped)];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar-delete"] style:UIBarButtonItemStylePlain target:self action:@selector(clearBtnTapped)];
    }
    
}

//添加聊天记录table
- (void)addTalkLsitTable
{
    // 聊天记录table view
    self.tableView = [[UITableView alloc] init];
    //    [self.view addSubview:self.tableView];
    // 解决tableview往上滚动时遮住rootTopView的bug
    [self.view insertSubview:self.tableView belowSubview:[self getRootTopView]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolView.mas_top);
        make.leading.trailing.equalTo(self.view);
        self.tableViewTopConstraint = make.top.mas_equalTo(navHigh);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 15, 0);
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    if(self.superSearchMessages){
        [self fetchSuperSearchMessages];
    }else{
        if(self.searchMessage){
            [self fetchSearchMessages];
        }else{
            [self fetchMessages];
        }
    }
    [self scrollToBottom];
    
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    //只有超级搜索才需要上拉加载
    if(self.superSearchMessages){
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(pullUpLoadData)];
    }
    
    
    //    // 下拉刷新
    //    self.refreshControl = [[UIRefreshControl alloc] init];
    //    self.refreshControl.tintColor = [UIColor grayColor];
    //    [self.refreshControl addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
    //    [self.tableView addSubview:self.refreshControl];
}

//添加BottomBar
-(void)addBottomBar
{
    // 底部操作栏
    self.toolView = [[UIView alloc] init];
    self.toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        self.toolViewBottomConstaint = make.bottom.mas_equalTo(-kTabbarSafeBottomMargin);
    }];
    
    // 麦克风|键盘输入
    self.toolViewVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toolViewVoiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
    [self.toolViewVoiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
    [self.toolViewVoiceBtn addTarget:self action:@selector(microphoneTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.toolViewVoiceBtn];
    [self.toolViewVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.toolView).offset(8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.toolView);
    }];
    
    // 取消阅后即焚按钮
    self.cancleBurnAfterReadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleBurnAfterReadingButton setImage:[UIImage imageNamed:@"closeBurnAfterReadBtn"] forState:UIControlStateNormal];
    [self.cancleBurnAfterReadingButton setImage:[UIImage imageNamed:@"closeBurnAfterReadBtn"] forState:UIControlStateHighlighted];
    [self.cancleBurnAfterReadingButton addTarget:self action:@selector(cancleBurnAfterReadingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.cancleBurnAfterReadingButton.hidden = YES;
    [self.toolView addSubview:self.cancleBurnAfterReadingButton];
    [self.cancleBurnAfterReadingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.toolView).offset(-8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.toolView);
    }];
    
    // 更多
    self.toolViewMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toolViewMoreBtn setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
    [self.toolViewMoreBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
    [self.toolViewMoreBtn addTarget:self action:@selector(moreTapped) forControlEvents:UIControlEventTouchUpInside];
    self.toolViewMoreBtn.hidden = NO;
    [self.toolView addSubview:self.toolViewMoreBtn];
    [self.toolViewMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.toolView).offset(-8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.toolView);
    }];
    
    // 阅后即焚图片下拉选择菜单按钮
    self.burnAfterReadingImageSelectListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.burnAfterReadingImageSelectListButton setImage:[UIImage imageNamed:@"burnAfterReadImageSelectListBtn"] forState:UIControlStateNormal];
    [self.burnAfterReadingImageSelectListButton setImage:[UIImage imageNamed:@"burnAfterReadImageSelectListBtn"] forState:UIControlStateSelected];
    [self.burnAfterReadingImageSelectListButton addTarget:self action:@selector(burnAfterReadingImageSelectListButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.burnAfterReadingImageSelectListButton.hidden = YES;
    [self.toolView addSubview:self.burnAfterReadingImageSelectListButton];
    [self.burnAfterReadingImageSelectListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.toolViewMoreBtn.mas_leading).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.toolView);
    }];
    
    // 表情
    self.toolViewFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toolViewFaceBtn setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    [self.toolViewFaceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
    [self.toolViewFaceBtn addTarget:self action:@selector(faceTapped) forControlEvents:UIControlEventTouchUpInside];
    self.toolViewFaceBtn.hidden = NO;
    [self.toolView addSubview:self.toolViewFaceBtn];
    [self.toolViewFaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.toolViewMoreBtn.mas_leading).offset(-5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self.toolView);
    }];
    
    // 输入框
    self.textView = [[UITextView alloc] init];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.scrollEnabled = NO;
    self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    self.textView.enablesReturnKeyAutomatically = YES;
    [self.toolView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolView).offset(5);
        make.bottom.equalTo(self.toolView).offset(-5);
        make.leading.equalTo(self.toolViewVoiceBtn.mas_trailing).offset(5);
        make.trailing.equalTo(self.toolViewFaceBtn.mas_leading).offset(-5);
    }];
    
    // 底部线条
    self.textViewBottomLine = [[UIView alloc] init];
    self.textViewBottomLine.backgroundColor = kColorWithRGB(174, 174, 174);
    [self.toolView addSubview:self.textViewBottomLine];
    [self.textViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.leading.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_bottom);
        make.trailing.equalTo(self.toolViewFaceBtn);
    }];
}

#pragma mark - 导航栏右边按钮点击事件
//群组按钮点击
-(void)groupInfoBtnTapped
{
    //    CXGroupInfoNewViewController *groupInfoVC = [[CXGroupInfoNewViewController alloc] init];
    //    groupInfoVC.groupId = self.chatter;
    //    self.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:groupInfoVC animated:YES];
}

//清除聊天记录按钮点击
-(void)clearBtnTapped
{
    [self setDeleteRecordsConfirmViewDisplay:YES];
}

#pragma mark - BottomBar的三个按钮的点击事件
// 点击麦克风按钮
-(void)microphoneTapped
{
    self.toolViewVoiceBtn.selected = !self.toolViewVoiceBtn.selected;
    if (self.toolViewVoiceBtn.selected) {
        self.toolViewFaceBtn.selected = self.toolViewMoreBtn.selected = NO;
        [self.textView resignFirstResponder];
        [self setVoiceInputOn:YES];
    }
    else{
        // 文本模式
        [self setVoiceInputOn:NO];
        [self.textView becomeFirstResponder];
    }
}

// 点击表情按钮
-(void)faceTapped
{
    self.toolViewFaceBtn.selected = !self.toolViewFaceBtn.selected;
    if (self.toolViewFaceBtn.selected) {
        // 切换文本输入
        if (self.toolViewVoiceBtn.selected) {
            [self setVoiceInputOn:NO];
        }
        self.toolViewVoiceBtn.selected = self.toolViewMoreBtn.selected = NO;
        self.textView.inputView = self.faceView;
        
    }
    else{
        self.textView.inputView = nil;
    }
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
    if (self.toolViewFaceBtn.selected) {
        [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            self.toolViewBottomConstaint = make.bottom.mas_equalTo(-kTabbarSafeBottomMargin - kHeightOfEmoji);
        }];
    }
}

// 点击更多按钮
-(void)moreTapped
{
    self.toolViewMoreBtn.selected = !self.toolViewMoreBtn.selected;
    if (self.toolViewMoreBtn.selected) {
        // 切换文本输入
        if (self.toolViewVoiceBtn.selected) {
            [self setVoiceInputOn:NO];
        }
        self.toolViewVoiceBtn.selected = self.toolViewFaceBtn.selected = NO;
        self.textView.inputView = self.moreView;
    }
    else{
        self.textView.inputView = nil;
    }
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
    if (self.toolViewMoreBtn.selected) {
        [self.toolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            self.toolViewBottomConstaint = make.bottom.mas_equalTo(-kTabbarSafeBottomMargin - kChatMoreViewHeight);
        }];
    }
}

- (void)cancleBurnAfterReadingButtonClick
{
    self.showBurnAfterReadingToolView = NO;
    self.toolViewMoreBtn.hidden = NO;
    self.toolViewMoreBtn.selected = NO;
    self.cancleBurnAfterReadingButton.hidden = YES;
    self.toolViewFaceBtn.hidden = NO;
    self.toolViewFaceBtn.selected = NO;
    self.burnAfterReadingImageSelectListButton.hidden = YES;
    
    [self.toolViewVoiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
    [self.toolViewVoiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
    
    self.textViewBottomLine.backgroundColor = kColorWithRGB(174, 174, 174);
    
    self.toolViewRecordBtn.layer.borderColor = kColorWithRGB(170, 170, 170).CGColor;
    
    [self.toolViewRecordBtn setTitleColor:kColorWithRGB(170, 170, 170) forState:UIControlStateNormal];
}

- (void)burnAfterReadingImageSelectListButtonClick
{
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
    
    IBActionSheet * sendTypeActionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"小视频", @"相册", nil];
    [sendTypeActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - 切换各种键盘
-(void)setVoiceInputOn:(BOOL)isOn{
    if (isOn) { // 语音
        self.textViewBottomLine.hidden = self.textView.hidden = YES;
        self.toolViewRecordBtn.hidden = NO;
    }
    else{ // 文本
        self.toolViewRecordBtn.hidden = YES;
        self.textView.hidden = self.textViewBottomLine.hidden = NO;
    }
}
#pragma mark - 发送消息
// 发送小视频
-(void)sendVideoMessageWithPath:(NSString *)filePath length:(NSNumber *)len size:(NSNumber *)size{
    CXIMMessage *message = [[CXIMMessage alloc] initWithChatter:self.chatter body:[CXIMVideoMessageBody bodyWithVideoPath:filePath]];
    message.type = self.isGroupChat ? CXIMMessageTypeGroupChat : CXIMMessageTypeChat;
    [self send:message completion:nil];
}

// 发送语音
-(void)sendVoiceMessageWithPath:(NSString *)filePath length:(NSNumber *)len size:(NSNumber *)size{
    CXIMMessage *message = [[CXIMMessage alloc] initWithChatter:self.chatter body:[CXIMVoiceMessageBody bodyWithVoicePath:filePath duration:len]];
    message.type = self.isGroupChat ? CXIMMessageTypeGroupChat : CXIMMessageTypeChat;
    [self send:message completion:nil];
}

// 发送文本消息
-(void)sendTextMessage{
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length <= 0) {
        return;
    }
    self.textView.text = @"";
    
    NSString *url = [NSString stringWithFormat:@"%@sensitive/check", urlPrefix];
    NSMutableDictionary * params = @{}.mutableCopy;
    [params setValue:text forKey:@"name"];
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            CXIMMessage *message = [[CXIMMessage alloc] initWithChatter:self.chatter body:[CXIMTextMessageBody bodyWithTextContent:JSON[@"data"]]];
            message.type = self.isGroupChat ? CXIMMessageTypeGroupChat : CXIMMessageTypeChat;
            [self send:message completion:nil];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

// 发送图片消息
-(void)sendImageMessage:(UIImage *)image{
    CXIMMessage *message = [[CXIMMessage alloc] initWithChatter:self.chatter body:[CXIMImageMessageBody bodyWithImage:image]];
    message.type = self.isGroupChat ? CXIMMessageTypeGroupChat : CXIMMessageTypeChat;
    [self send:message completion:nil];
}

#pragma mark - SDMyLocationViewControllDelegate
// 发送位置消息
- (void)sendAdress:(NSString *)adress
{
    if(adress == nil || (adress != nil && [adress length] < 1)){
        TTAlert(@"发送位置信息失败");
        return;
    }
    
    NSArray<NSString *> * strings = [adress componentsSeparatedByString:@","];
    if(strings != nil && [strings count] == 3){
        CXIMMessage *message = [[CXIMMessage alloc] initWithChatter:self.chatter body:[CXIMLocationMessageBody bodyWithLongitude:strings[1].doubleValue latitude:strings[2].doubleValue address:strings[0]]];
        message.type = self.isGroupChat ? CXIMMessageTypeGroupChat : CXIMMessageTypeChat;
        [self send:message completion:nil];
    }else{
        TTAlert(@"发送位置信息失败");
    }
}

// 发送消息
-(void)send:(CXIMMessage *)message completion:(SendMessageCompletionBlock)completionBlock{

    if([CXIMService sharedInstance].socketManager.state != CXIMSocketState_OPEN){
        [[CXIMService sharedInstance].socketManager reconnectWithCompletion:^(NSError *error) {
            [self sendMessageBlockMethodWithMessage:message completion:completionBlock];
        }];
    }else{
        [self sendMessageBlockMethodWithMessage:message completion:completionBlock];
    }
}

- (void)sendMessageBlockMethodWithMessage:(CXIMMessage *)message completion:(SendMessageCompletionBlock)completionBlock {
    //如果接收方是客服，则把个人用户信息加入消息的扩展字段ext中
    NSMutableDictionary *ext = @{}.mutableCopy;
    if(self.chatterIsKefu){
        SDCompanyUserModel * userModel = [CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]];
        userModel.hxAccount = userModel.imAccount;
        NSDictionary* extDict = @{ @"icon" : userModel.icon?userModel.icon:@"",
                                   @"realName" : userModel.realName?userModel.realName:@"",
                                   @"sex" : userModel.sex && [userModel.sex isKindOfClass:[NSString class]]?userModel.sex:@"",
                                   @"dpName" : userModel.dpName?userModel.dpName:@"",
                                   @"job" : userModel.job?userModel.job:@"",
                                   @"userType" : [userModel.userType stringValue]?[userModel.userType stringValue]:@"",
                                   @"email" : userModel.email?userModel.email:@"",
                                   @"telephone" : userModel.telephone?userModel.telephone:@"",
                                   @"userId" : [userModel.userId stringValue]?[userModel.userId stringValue]:@"",
                                   @"hxAccount" : userModel.hxAccount?userModel.hxAccount:@"",
                                   @"account" : userModel.account?userModel.account:@""
                                   };
        ext[@"userInfo"] = extDict;
    }
    if (self.currentLocation) {
        ext[@"location"] = self.currentLocation;
    }
    
    if(self.showBurnAfterReadingToolView){
        ext[@"isBurnAfterRead"] = @"1";
        ext[@"burnAfterReadTime"] = @"10";
    }
    
    message.ext = ext;
    
    //如果是超级搜索，在发送消息之后直接显示最新的消息
    if(self.superSearchMessages){
        self.superSearchMessages = nil;
        [_messages removeAllObjects];
        [self.tableView removeFooter];
    }
    
    
    [[CXIMService sharedInstance].chatManager sendMessage:message onProgress:nil completion:^(CXIMMessage *message, NSError *error) {
        NSLog(@"%@",message);
        
        NSString * url;
        NSMutableDictionary * params = @{}.mutableCopy;
        if(message.type == CXIMProtocolTypeSingleChat){
            url = [NSString stringWithFormat:@"%@im/chat/push", urlPrefix];
            [params setValue:message.receiver forKey:@"toImAccount"];
        }else if(message.type == CXIMProtocolTypeGroupChat){
            url = [NSString stringWithFormat:@"%@im/chat/group/push", urlPrefix];
            CXGroupInfo * group = [[CXIMService sharedInstance].groupManager loadGroupForId:message.receiver];
            NSMutableString *content = [[NSMutableString alloc] init];
            if (group.members.count == 1) {
                [content appendString:group.members.firstObject.userId];
            } else if (group.members.count > 1) {
                for(CXGroupMember * member in group.members){
                    [content appendString:[NSString stringWithFormat:@",%@",member.userId]];
                }
                [params setValue:[content substringFromIndex:1] forKey:@"toImAccounts"];
            }else{
                return;
            }
        }
        [params setValue:[NSString stringWithFormat:@"%zd",message.body.type] forKey:@"type"];
        if(message.body.type == CXIMMessageContentTypeText){
            CXIMTextMessageBody * body = (CXIMTextMessageBody *)message.body;
            [params setValue:body.textContent forKey:@"text"];
        }else if(message.body.type == CXIMMessageContentTypeImage){
            CXIMImageMessageBody * body = (CXIMImageMessageBody *)message.body;
            [params setValue:body.remoteUrl forKey:@"text"];
        }else if(message.body.type == CXIMMessageContentTypeVoice){
            CXIMVoiceMessageBody * body = (CXIMVoiceMessageBody *)message.body;
            [params setValue:body.remoteUrl forKey:@"text"];
        }else if(message.body.type == CXIMMessageContentTypeVideo){
            CXIMVideoMessageBody * body = (CXIMVideoMessageBody *)message.body;
            [params setValue:body.remoteUrl forKey:@"text"];
        }else if(message.body.type == CXIMMessageContentTypeFile){
            CXIMFileMessageBody * body = (CXIMFileMessageBody *)message.body;
            [params setValue:body.remoteUrl forKey:@"text"];
        }else if(message.body.type == CXIMMessageContentTypeLocation || message.body.type == CXIMMessageContentTypeMediaCall || message.body.type == CXIMMessageContentTypeSystemNotify){
            [params setValue:@"" forKey:@"text"];
        }
        
        [HttpTool postWithPath:url params:params success:^(id JSON) {
            if ([JSON[@"status"] integerValue] == 200) {
                
            }else{
                TTAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
        
    }];
    [self.messages addObject:message];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self scrollToBottom];
}


#pragma mark - BottomBar更多View的点击事件
-(void)chatMoreView:(ChatMoreView *)moreView didTapButtonWithType:(ChatMoreViewButtonType)type{
    switch (type) {
            // 图片
        case ChatMoreViewButtonTypePhoto:
        {
            BOOL canOpenImagePicker = [SDPermissionsDetectionUtils checkImagePickerFree];
            if(canOpenImagePicker){
                [self pushTZImagePickerController];
//                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                [self presentViewController:self.imagePicker animated:YES completion:nil];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有权限访问您的照片" message:@"您可以在“隐私设置”中开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
            break;
            // 位置
        case ChatMoreViewButtonTypeLocation:
        {
            BOOL canGetLocation = [SDPermissionsDetectionUtils checkGetLocationFree];
            if(canGetLocation){
                self.hidesBottomBarWhenPushed = YES;
                //地图地位功能
                SDMyLocationViewController* myLoaclVc = [[SDMyLocationViewController alloc] init];
                myLoaclVc.delegate = self;
                [self.navigationController pushViewController:myLoaclVc animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"需要您在隐私设置中开启定位服务才能发送位置信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
            // 照相机
        case ChatMoreViewButtonTypeCamera:
        {
#if TARGET_IPHONE_SIMULATOR
            TTAlert(@"模拟器不支持照相机");
#else
            BOOL canPickImage = [SDPermissionsDetectionUtils checkMediaFree];
            if(canPickImage){
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有权限拍摄照片" message:@"您可以在“隐私设置”中开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
#endif
        }
            break;
            
            // 视频
        case ChatMoreViewButtonTypeVideo:
        {
#if TARGET_IPHONE_SIMULATOR
            TTAlert(@"模拟器不支持照视频");
#else
            BOOL canPickImage = [SDPermissionsDetectionUtils checkMediaFree];
            if(!kHasRecordPermission && !canPickImage){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音和视频权限" message:@"您可以在“隐私设置”中开启语音和视频权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            else if (!kHasRecordPermission) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音权限" message:@"您可以在“隐私设置”中开启语音权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            else if(!canPickImage){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有视频权限" message:@"您可以在“隐私设置”中开启视频权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }else{
                
                    [self.textView resignFirstResponder];
                    //添加小视频View
                    [self addLittteVideoPickView];
                
                
                break;
            }
#endif
        }
            break;
            // 语音通话
        case ChatMoreViewButtonTypeAudioCall:
            if (!kHasRecordPermission) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音权限" message:@"您可以在“隐私设置”中开启语音权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }else{
                
                if (self.isGroupChat) {
                    SDSelectMemberViewController *vc = [[SDSelectMemberViewController alloc] init];
                    vc.isVideo = NO;
                    vc.groupId = self.chatter;
                    [self presentViewController:vc animated:YES completion:nil];
                    
                }else{
                    SDIMVoiceAndVideoCallViewController * videoCallController = [[SDIMVoiceAndVideoCallViewController alloc] initWithInitiateOrAcceptCallType:SDIMCallInitiateType];
                    videoCallController.audioOrVideoType= CXIMMediaCallTypeAudio;
                    videoCallController.chatter = self.chatter;
                    videoCallController.chatterDisplayName = self.chatterDisplayName;
                    [self presentViewController:videoCallController animated:YES completion:nil];
                }
            }
            break;
            // 视频通话
        case ChatMoreViewButtonTypeVideoCall:
        {
            BOOL canPickImage = [SDPermissionsDetectionUtils checkMediaFree];
            if(!kHasRecordPermission && !canPickImage){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音和视频权限" message:@"您可以在“隐私设置”中开启语音和视频权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            else if (!kHasRecordPermission) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音权限" message:@"您可以在“隐私设置”中开启语音权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            else if(!canPickImage){
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有视频权限" message:@"您可以在“隐私设置”中开启视频权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }else{
                
                if (self.isGroupChat) {
                    SDSelectMemberViewController *vc = [[SDSelectMemberViewController alloc] init];
                    vc.isVideo = YES;
                    vc.groupId = self.chatter;
                    [self presentViewController:vc animated:YES completion:nil];

                }else{
                    SDIMVoiceAndVideoCallViewController * videoCallController = [[SDIMVoiceAndVideoCallViewController alloc] initWithInitiateOrAcceptCallType:SDIMCallInitiateType];
                    videoCallController.audioOrVideoType= CXIMMediaCallTypeVideo;
                    videoCallController.chatter = self.chatter;
                    videoCallController.chatterDisplayName = self.chatterDisplayName;
                    [self presentViewController:videoCallController animated:YES completion:nil];
                }
                
            }
            
        }
            break;
            // 阅后即焚
        case ChatMoreViewButtonTypeBurnAfterReading:
        {
            [self openBurnAfterRead];
        }
            break;
        default:
            break;
    }
}


#pragma mark- 小视频

//添加小视频
- (void)addLittteVideoPickView
{
    _canSave = NO;
    if(_bgView){
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    _bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height - navHigh);
    _bgView.backgroundColor = [UIColor lightGrayColor];
    _bgView.alpha = 0;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTapView)];
    [_bgView addGestureRecognizer:tap];
    
    if(_videoView){
        [_videoView removeFromSuperview];
        _videoView = nil;
    }
    _videoView = [[UIView alloc] init];
    _videoView.backgroundColor = [UIColor whiteColor];
    _videoView.frame = CGRectMake(0 , Screen_Height - kLittleVideoViewHeight - 65, Screen_Width, kLittleVideoViewHeight);
    _videoView.clipsToBounds = YES;
    _videoView.layer.cornerRadius = 0;
    _videoView.alpha = 0;
    UITapGestureRecognizer *singleTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.delaysTouchesBegan = YES;
    UITapGestureRecognizer *doubleTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.delaysTouchesBegan = YES;
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [_videoView addGestureRecognizer:singleTapGesture];
    [_videoView addGestureRecognizer:doubleTapGesture];
    
    if(_cancleLabel){
        [_cancleLabel removeFromSuperview];
        _cancleLabel = nil;
    }
    _cancleLabel = [[UILabel alloc] init];
    _cancleLabel.alpha = 0;
    _cancleLabel.frame = CGRectMake(0, CGRectGetMaxY(_videoView.frame) - 30, Screen_Width, 16);
    _cancleLabel.textColor = [UIColor greenColor];
    _cancleLabel.textAlignment = NSTextAlignmentCenter;
    _cancleLabel.text = @"上滑取消";
    _cancleLabel.font = [UIFont systemFontOfSize:16];
    _cancleLabel.backgroundColor = [UIColor clearColor];
    
    if(_tapBtnBackView){
        [_tapBtnBackView removeFromSuperview];
        _tapBtnBackView = nil;
    }
    _tapBtnBackView = [[UIView alloc] init];
    _tapBtnBackView.alpha = 0;
    _tapBtnBackView.frame = CGRectMake(0, CGRectGetMaxY(_videoView.frame), Screen_Width, 65);
    _tapBtnBackView.backgroundColor = [UIColor blackColor];
    
    if(_progressView){
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
    _progressView = [[UIView alloc] init];
    _progressView.alpha = 0;
    _progressView.frame = CGRectMake(0, CGRectGetMaxY(_videoView.frame), Screen_Width, 2);
    _progressView.backgroundColor = [UIColor redColor];
    
    if(_tapBtn){
        [_tapBtn removeFromSuperview];
        _tapBtn = nil;
    }
    _tapBtn = [[UILabel alloc] init];
    _tapBtn.alpha = 0;
    _tapBtn.frame = CGRectMake((Screen_Width - 70)/2, CGRectGetMaxY(_videoView.frame) + 5, 70, 50);
    _tapBtn.text = @"按住拍";
    _tapBtn.font = [UIFont systemFontOfSize:18];
    _tapBtn.textAlignment = NSTextAlignmentCenter;
    _tapBtn.backgroundColor = [UIColor clearColor];
    _tapBtn.textColor = [UIColor greenColor];
    _tapBtn.enabled = NO;
    
    
    [self.view addSubview:_bgView];
    [self.view addSubview:_videoView];
    [self.view addSubview:_cancleLabel];
    [self.view addSubview:_tapBtnBackView];
    [self.view addSubview:_progressView];
    [self.view addSubview:_tapBtn];
    [UIView animateWithDuration:0.4
                     animations:^{
                         _bgView.alpha = 0.2;
                         _videoView.alpha = 1.0;
                         _cancleLabel.alpha = 0;
                         _progressView.alpha = 0;
                         _tapBtnBackView.alpha = 1.0;
                         _tapBtn.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [self setupAVCaptureInfo];
                     }];
    
}

//点击黑色区域会从父视图中删除小视频View
- (void)hideTapView
{
    [self quit];
    [_bgView removeFromSuperview];
    _bgView = nil;
    [_videoView removeFromSuperview];
    _videoView = nil;
    [_cancleLabel removeFromSuperview];
    _cancleLabel = nil;
    [_progressView removeFromSuperview];
    _progressView = nil;
    [_tapBtnBackView removeFromSuperview];
    _tapBtnBackView = nil;
    [_tapBtn removeFromSuperview];
    _tapBtn = nil;
}

- (void)setupAVCaptureInfo
{
    [self addSession];
    [_captureSession beginConfiguration];
    [self addVideo];
    [self addAudio];
    [self addPreviewLayer];
    [_captureSession commitConfiguration];
    
    //开启会话-->注意,不等于开始录制
    [_captureSession startRunning];
    _tapBtn.enabled = YES;
}

- (void)addSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    //注意,这个地方设置的模式/分辨率大小将影响你后面拍摄照片/视频的大小,
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
}

- (void)addVideo
{
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    
    [self addVideoInput];
    [self addMovieOutput];
}

- (void)addVideoInput
{
    NSError *videoError;
    
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&videoError];
    if (videoError) {
        NSLog(@"---- 取得摄像头设备时出错 ------ %@",videoError);
        return;
    }
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    
}

- (void)addMovieOutput
{
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    if ([_captureSession canAddOutput:_movieOutput]) {
        [_captureSession addOutput:_movieOutput];
        AVCaptureConnection *captureConnection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];
        // 视频稳定设置
        if ([captureConnection isVideoStabilizationSupported]) {
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
                captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
        }
        
        captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
    }
}

//获取摄像头-->前/后
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (void)addAudio
{
    NSError *audioError;
    // 添加一个音频输入设备
    _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //  音频输入对象
    _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:_audioDevice error:&audioError];
    if (audioError) {
        NSLog(@"取得录音设备时出错 ------ %@",audioError);
        return;
    }
    // 将音频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_audioInput]) {
        [_captureSession addInput:_audioInput];
    }
}

- (void)addPreviewLayer
{
    [self.view layoutIfNeeded];
    
    //创建一个坐标View,用来定位相机预览图层
    UIView * zuobiaoView = [[UIView alloc] init];
    zuobiaoView.frame = CGRectMake(0, CGRectGetMinY(_videoView.frame), Screen_Width, Screen_Width*640/480);
    
    
    // 通过会话 (AVCaptureSession) 创建预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _captureVideoPreviewLayer.frame = zuobiaoView.layer.bounds;
    // 如果预览图层和视频方向不一致,可以修改这个
    _captureVideoPreviewLayer.connection.videoOrientation = [_movieOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
    _captureVideoPreviewLayer.position = CGPointMake(_videoView.size.width*0.5,_videoView.size.height*0.5);
    
    // 显示在视图表面的图层
    CALayer *layer = self.videoView.layer;
    layer.masksToBounds = true;
    [self.view layoutIfNeeded];
    [layer addSublayer:_captureVideoPreviewLayer];
    
}

-(void)singleTap:(UITapGestureRecognizer *)tapGesture{
    
    NSLog(@"单击");
    
    CGPoint point= [tapGesture locationInView:self.videoView];
    //将UI坐标转化为摄像头坐标,摄像头聚焦点范围0~1
    CGPoint cameraPoint= [_captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    //光圈动画
    [self setFocusCursorAnimationWithPoint:point];
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        //聚焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            NSLog(@"聚焦模式修改为%zd",AVCaptureFocusModeContinuousAutoFocus);
        }else{
            NSLog(@"聚焦模式修改失败");
        }
        
        //聚焦点的位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:cameraPoint];
        }
        //曝光模式
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }else{
            NSLog(@"曝光模式修改失败");
        }
        
        //曝光点的位置
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:cameraPoint];
        }
    }];
}

//更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [_videoInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁,意义是---进行修改期间,先锁定,防止多处同时修改
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [_captureSession beginConfiguration];
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        [_captureSession commitConfiguration];
    }
}

//光圈动画
-(void)setFocusCursorAnimationWithPoint:(CGPoint)point{
    self.focusCircle.center = point;
    self.focusCircle.transform = CGAffineTransformIdentity;
    self.focusCircle.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCircle.transform=CGAffineTransformMakeScale(0.5, 0.5);
        self.focusCircle.alpha = 0.0;
    }];
}

//设置焦距
-(void)doubleTap:(UITapGestureRecognizer *)tapGesture{
    
    NSLog(@"双击");
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        if (captureDevice.videoZoomFactor == 1.0) {
            CGFloat current = 1.5;
            if (current < captureDevice.activeFormat.videoMaxZoomFactor) {
                [captureDevice rampToVideoZoomFactor:current withRate:10];
            }
        }else{
            [captureDevice rampToVideoZoomFactor:1.0 withRate:10];
        }
    }];
}

//光圈
- (UIView *)focusCircle{
    if (!_focusCircle) {
        UIView *focusCircle = [[UIView alloc] init];
        focusCircle.frame = CGRectMake(0, 0, 100, 100);
        focusCircle.layer.borderColor = [UIColor orangeColor].CGColor;
        focusCircle.layer.borderWidth = 2;
        focusCircle.layer.cornerRadius = 50;
        focusCircle.layer.masksToBounds =YES;
        _focusCircle = focusCircle;
        [self.videoView addSubview:focusCircle];
    }
    return _focusCircle;
}

#pragma mark touchs
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL condition = [self isInBtnRect:point];
    
    if (condition) {
        [self isFitCondition:condition];
        [self startAnimation];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL condition = [self isInBtnRect:point];
    
    [self isFitCondition:condition];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    BOOL condition = [self isInBtnRect:point];
    /*
     结束时候有两种情况算录制成功
     1.抬手时,录制时长 > 3/10总时长
     2.录制进度条完成时,就算手指超出按钮范围也算录制成功 -- 此时 end 方法不会调用,因为用户手指还在屏幕上,所以直接代码调用录制成功的方法,将控制器切换
     */
    if (condition) {
        if (self.progressView.size.width < Screen_Width * 7/10 || self.progressView.size.width == Screen_Width) {
            //录制完成
            _canSave = YES;
        }else{
            TTAlert(@"最短录制时间为3秒,请重新录制");
        }
    }
    
    [self stopAnimation];
}

- (BOOL)isInBtnRect:(CGPoint)point
{
    CGFloat x = point.x;
    CGFloat y = point.y;
    return  (x>CGRectGetMinX(_tapBtn.frame) && x<=CGRectGetMaxX(_tapBtn.frame)) && (y>CGRectGetMinY(_tapBtn.frame) && y<=CGRectGetMaxY(_tapBtn.frame));
}

- (void)isFitCondition:(BOOL)condition
{
    if (condition) {
        self.cancleLabel.text = @"上滑取消";
        self.cancleLabel.backgroundColor = [UIColor clearColor];
        self.cancleLabel.textColor = [UIColor greenColor];
    }else{
        self.cancleLabel.text = @"松手取消录制";
        self.cancleLabel.backgroundColor = [UIColor clearColor];
        self.cancleLabel.textColor = [UIColor greenColor];
    }
}

- (void)startAnimation
{
    if (self.status == VideoStatusEnded) {
        _canSave = NO;
        _bgView.userInteractionEnabled = NO;
        self.status = VideoStatusStarted;
        [UIView animateWithDuration:0.5 animations:^{
            self.cancleLabel.alpha = self.progressView.alpha = 1.0;
            self.tapBtn.alpha = 0.0;
            self.tapBtn.transform = CGAffineTransformMakeScale(2.0, 2.0);
        } completion:^(BOOL finished) {
            [self stopLink];
            [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }];
    }
}

- (void)stopAnimation{
    if (self.status == VideoStatusStarted) {
        self.status = VideoStatusEnded;
        
        [self stopLink];
        [self stopRecord];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.cancleLabel.alpha = self.progressView.alpha = 0.0;
            self.tapBtn.alpha = 1.0;
            self.tapBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            _progressView.frame = CGRectMake(0, CGRectGetMaxY(_videoView.frame), Screen_Width, 2);
            _bgView.userInteractionEnabled = YES;
        }];
    }
    
}

- (CADisplayLink *)link
{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh:)];
        [self startRecord];
    }
    return _link;
}

- (void)stopLink
{
    _link.paused = YES;
    [_link invalidate];
    _link = nil;
}

- (void)refresh:(CADisplayLink *)link
{
    if (self.progressView.width <= 0) {
        self.progressView.width = 0;
        _progressView.frame = CGRectMake((Screen_Width - _progressView.size.width)/2, CGRectGetMaxY(_videoView.frame), _progressView.size.width, 2);
        [self stopAnimation];
        return;
    }
    if(_progressView){
        //_progressView.width每秒减去10分之一
        CGFloat width = self.progressView.size.width;
        width -=kTrans;
        if(width <= 0){
            width = 0;
        }
        _progressView.frame = CGRectMake((Screen_Width - width)/2, CGRectGetMaxY(_videoView.frame), width, 2);
    }
    
}

- (NSURL *)outPutFileURL
{
    NSString *videoDirecory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"media/unCutVideos"];
    BOOL isDir = false;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:videoDirecory isDirectory:&isDir];
    if (!(isDir && isDirExist)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:videoDirecory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [NSString stringWithFormat:@"%lld.mp4",@([[NSDate date] timeIntervalSince1970] * 1000).longLongValue];
    NSString *localURL = [videoDirecory stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:localURL];
}

- (void)removeAllUnCutVideos
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *videoDirecory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"media/unCutVideos"];
        BOOL isDir = false;
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:videoDirecory isDirectory:&isDir];
        if (isDir && isDirExist) {
            [[NSFileManager defaultManager] removeItemAtPath:videoDirecory error:nil];
        }
    });
}

- (void)startRecord
{
    [_movieOutput startRecordingToOutputFileURL:[self outPutFileURL] recordingDelegate:self];
}

- (void)stopRecord
{
    // 取消视频拍摄
    [_movieOutput stopRecording];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"---- 开始录制 ----");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"---- 录制结束 --- ");
    if(_canSave || (_progressView && self.progressView.size.width == 0)){
        if(_progressView){
            _progressView.frame = CGRectMake( 0, CGRectGetMaxY(_videoView.frame), Screen_Width, 2);
        }
        [self hideTapView];
        [self collapseAll];
        //裁切压缩视频为480*480
        [self mergeAndExportVideosAtFileURL:outputFileURL];
    }else{
        if(_progressView){
            _progressView.frame = CGRectMake( 0, CGRectGetMaxY(_videoView.frame), Screen_Width, 2);
        }
        //删除
        [self removeAllUnCutVideos];
    }
}

//获取视频第一帧的截图方法
- (UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

//小视频剪切压缩方法
- (void)mergeAndExportVideosAtFileURL:(NSURL *)localUrl
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        
        CGSize renderSize = CGSizeMake(0, 0);
        
        NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
        
        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
        
        CMTime totalDuration = kCMTimeZero;
        
        //先去assetTrack 也为了取renderSize
        NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
        NSMutableArray *assetArray = [[NSMutableArray alloc] init];
        
        AVAsset *asset = [AVAsset assetWithURL:localUrl];
        [assetArray addObject:asset];
        if([asset tracksWithMediaType:AVMediaTypeVideo] == nil || ([[asset tracksWithMediaType:AVMediaTypeVideo] count] < 1)){
            dispatch_async(dispatch_get_main_queue(), ^{
                TTAlert(@"录制失败,请重新录制");
                [self removeAllUnCutVideos];
            });
            return ;
        }
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        [assetTrackArray addObject:assetTrack];
        
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
        
        CGFloat renderW = MIN(renderSize.width, renderSize.height);
        
        for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
            
            AVAsset *asset = [assetArray objectAtIndex:i];
            AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
            
            AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            if([asset tracksWithMediaType:AVMediaTypeAudio] == nil || ([[asset tracksWithMediaType:AVMediaTypeAudio] count] < 1)){
                dispatch_async(dispatch_get_main_queue(), ^{
                    TTAlert(@"录制失败,请重新录制");
                    [self removeAllUnCutVideos];
                });
                return ;
            }
            
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                 atTime:totalDuration
                                  error:nil];
            
            AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            
            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetTrack
                                 atTime:totalDuration
                                  error:&error];
            
            //fix orientationissue
            AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            
            totalDuration = CMTimeAdd(totalDuration, asset.duration);
            
            CGFloat rate;
            rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
            
            CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
            layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
            layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
            
            [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
            [layerInstruciton setOpacity:0.0 atTime:totalDuration];
            
            //data
            [layerInstructionArray addObject:layerInstruciton];
        }
        NSString *videoDirecory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"media/videos"];
        BOOL isDir = false;
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:videoDirecory isDirectory:&isDir];
        if (!(isDir && isDirExist)) {
            [[NSFileManager defaultManager] createDirectoryAtPath:videoDirecory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *fileName = [NSString stringWithFormat:@"%lld.mp4",@([[NSDate date] timeIntervalSince1970] * 1000).longLongValue];
        NSString *localURL = [videoDirecory stringByAppendingPathComponent:fileName];
        //get save path
        NSURL *mergeFileURL = [NSURL fileURLWithPath:localURL];
        //export
        AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
        mainInstruciton.layerInstructions = layerInstructionArray;
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = @[mainInstruciton];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        mainCompositionInst.renderSize = CGSizeMake(480, 480);
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
        exporter.videoComposition = mainCompositionInst;
        exporter.outputURL = mergeFileURL;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeAllUnCutVideos];
                //这里写后面的操作
                NSLog(@"压缩完成");
                unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfFileSystemForPath:localURL error:nil] fileSize];
                [self sendVideoMessageWithPath:localURL length:@(0) size:@(fileSize)];
            });
        }];
    });
}

//这个在完全退出小视频时调用
- (void)quit
{
    [_captureSession stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self quit];
    if (self.selectMemu) {
        [self.selectMemu removeFromSuperview];
        self.selectMemu = nil;
    }
    self.searchMessage = nil;
    self.superSearchMessages = nil;
}

#pragma mark 图片选择控制器 协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        //如果是图片
        if([mediaType isEqualToString:@"public.image"]){
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            [self sendImageMessage:image];
        }
    }];
}

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.isStatusBarDefault = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        NSLog(@"%@",photos);
        for(UIImage * photo in photos){
            [self sendImageMessage:photo];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - textView协议方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self sendTextMessage];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

#pragma makr - 删除聊天记录view点击事件
//删除聊天记录View的取消按钮点击事件
-(void)deleteRecordsConfirmViewCancelBtnTapped
{
    [self setDeleteRecordsConfirmViewDisplay:NO];
}

//删除聊天记录View的确认按钮点击事件
-(void)deleteRecordsConfirmViewEnsureBtnTapped{
    [self setDeleteRecordsConfirmViewDisplay:NO];
    //    BOOL success = [[CXIMService sharedInstance] removeConversationForChatter:self.chatter];
    BOOL success = [[CXIMService sharedInstance].chatManager removeMessagesForChatter:self.chatter];
    if (success) {
        [self.messages removeAllObjects];
        [self.tableView reloadData];
    }
    else{
        TTAlert(@"删除失败");
    }
}

//确定是否显示删除聊天记录View和CoverView
-(void)setDeleteRecordsConfirmViewDisplay:(BOOL)needShow
{
    self.deleteRecordConfirmView.hidden = self.coverView.hidden = !needShow;
}

#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.textView.text;
    
    if (!isDelete && str.length > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        if (chatText.length >= 2)
        {
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([self.faceView stringIsFace:subStr]) {
                self.textView.text = [chatText substringToIndex:chatText.length-2];
                return;
            }
        }
        
        if (chatText.length > 0) {
            self.textView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    
}
- (void)sendFace
{
    NSString *chatText = self.textView.text;
    if (chatText.length > 0) {
        [self sendTextMessage];
    }
}


#pragma mark - 表情和更多View是否展示的各种判断
//点击table隐藏所有
-(void)tableViewTapped
{
    [self collapseAll];
    if (self.selectMemu) {
        [self.selectMemu removeFromSuperview];
        self.selectMemu = nil;
    }
}

#pragma mark - SDChattingCellDelegate
- (void)chattingCell:(SDChattingCell *)cell didTapMenuItem:(SDChattingCellMenuItem)item message:(CXIMMessage *)message{
    switch (item) {
            // 复制
        case SDChattingCellMenuItemCopy:
        {
            CXIMTextMessageBody *textBody = (CXIMTextMessageBody *)message.body;
            [UIPasteboard generalPasteboard].string = textBody.textContent;
            break;
        }
            // 删除
        case SDChattingCellMenuItemDelete:
        {
            [[CXIMService sharedInstance].chatManager removeMessageForId:message.ID];
            [self.messages removeAllObjects];
            [self fetchMessages];
            break;
        }
        case SDChattingCellMenuItemForward:
        {
            CXForwardSelectContactsViewController *forwardSelectContactsViewController = [[CXForwardSelectContactsViewController alloc] init];
            forwardSelectContactsViewController.message = message;
            [self.navigationController pushViewController:forwardSelectContactsViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)chattingCell:(SDChattingCell *)cell didTapSendFailedBtn:(void *)null {
    if ([cell.message.body isKindOfClass:CXIMFileMessageBody.class]) {
        CXIMFileMessageBody *body = (CXIMFileMessageBody *)cell.message.body;
        body.localUrl = body.fullLocalPath;
    }
    [[CXIMService sharedInstance].chatManager resendMessage:cell.message];
    [self.messages removeAllObjects];
    [self fetchMessages];
}

- (void)chattingCell:(SDChattingCell *)cell didTapAvatar:(void *)null
{
    if([VAL_UserType integerValue] == 3){
        if(cell.isFromSelf){
            SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
            pivc.canPopViewController = YES;
            pivc.imAccount = VAL_HXACCOUNT;
            [self.navigationController pushViewController:pivc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }else{
            SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
            pivc.imAccount = self.chatter;
            pivc.canPopViewController = YES;
            [self.navigationController pushViewController:pivc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
    }else{
        __block SDCompanyUserModel *userModel = [CXIMHelper getUserByIMAccount:cell.message.sender];
        
        if([userModel.imAccount isEqualToString:VAL_HXACCOUNT]){
            SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
            pivc.canPopViewController = YES;
            pivc.imAccount = userModel.imAccount;
            [self.navigationController pushViewController:pivc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }else{
            if(![[CXLoaclDataManager sharedInstance] checkIsFriendWithUserModel:userModel] && self.isGroupChat){
                //搜索人
                NSString *url = [NSString stringWithFormat:@"%@sysuser/getSysUser/%@", urlPrefix,userModel.imAccount];
                __weak __typeof(self)weakSelf = self;
//                [self showHudInView:self.view hint:nil];
                [HttpTool getWithPath:url params:nil success:^(id JSON) {
                    [weakSelf hideHud];
                    NSDictionary *jsonDict = JSON;
                    if ([jsonDict[@"status"] integerValue] == 200) {
                        if(JSON[@"data"]){
                            userModel = [SDCompanyUserModel yy_modelWithDictionary:JSON[@"data"]];
                            userModel.hxAccount = userModel.imAccount;
                            userModel.realName = userModel.name;
                        }
                        SDIMAddFriendsDetailsViewController * addFriendsDetailsViewController = [[SDIMAddFriendsDetailsViewController alloc] init];
                        addFriendsDetailsViewController.userModel = userModel;
                        [weakSelf.navigationController pushViewController:addFriendsDetailsViewController animated:YES];
                        if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                            weakSelf.navigationController.interactivePopGestureRecognizer.delegate = nil;
                        }
                    }else{
                        TTAlert(JSON[@"msg"]);
                    }
                } failure:^(NSError *error) {
                    [weakSelf hideHud];
                    CXAlert(KNetworkFailRemind);
                }];
            }else{
                SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
                pivc.imAccount = userModel.imAccount;
                pivc.canPopViewController = YES;
                [self.navigationController pushViewController:pivc animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }
        }
    }
}

- (void)chattingCell:(SDChattingCell *)cell didStartBurnMessagesAfterReadTimer:(void *)null
{
    if(_burnMessagesAfterReadTimer){
        [_burnMessagesAfterReadTimer invalidate];
        _burnMessagesAfterReadTimer = nil;
    }
    _burnMessagesAfterReadTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(burnMessagesAfterReadTimerWork) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_burnMessagesAfterReadTimer forMode:NSRunLoopCommonModes];
    
}

#pragma mark - 阅后即焚
- (void)burnMessagesAfterReadTimerWork
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * messageDeleteTimeCountDic = [[ud objectForKey:[NSString stringWithFormat:@"Message_Delete_Time_Count_Dic_%@_%@",VAL_HXACCOUNT,self.chatter]] mutableCopy ] ?: @{}.mutableCopy;
    NSMutableDictionary * enumDic = [[NSMutableDictionary alloc] initWithDictionary:messageDeleteTimeCountDic];
    if(messageDeleteTimeCountDic && [messageDeleteTimeCountDic count] >0){
        [enumDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            NSInteger deleteTime = [obj integerValue] - 1;
            if(deleteTime <= 0){
                BOOL deleteMessageSuccessful = [[CXIMService sharedInstance].chatManager removeMessageForId:key];
                if(deleteMessageSuccessful){
                    NSLog(@"阅后即焚删除%@消息成功",key);
                    [messageDeleteTimeCountDic removeObjectForKey:key];
                    if(messageDeleteTimeCountDic == nil || [messageDeleteTimeCountDic count] == 0){
                        [ud removeObjectForKey:[NSString stringWithFormat:@"Message_Delete_Time_Count_Dic_%@_%@",VAL_HXACCOUNT,self.chatter]];
                    }
                }else{
                    NSLog(@"阅后即焚删除%@消息失败",key);
                }
            }else{
                [messageDeleteTimeCountDic setObject:[NSString stringWithFormat:@"%zd",deleteTime] forKey:key];
                [ud setObject:messageDeleteTimeCountDic forKey:[NSString stringWithFormat:@"Message_Delete_Time_Count_Dic_%@_%@",VAL_HXACCOUNT,self.chatter]];
            }
            [ud synchronize];
            [self fetchBurnAfterMessages];
        }];
    }else{
        if(_burnMessagesAfterReadTimer){
            [_burnMessagesAfterReadTimer invalidate];
            _burnMessagesAfterReadTimer = nil;
        }
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXIMMessage *message = _messages[indexPath.row];
    
    NSString *ID;
    if(message.body.type == CXIMMessageContentTypeText && message.ext[@"shareDic"]){
        ID = @"SDChattingShareCell";
    }else{
        ID = [SDChattingCell identifierForContentType:message.body.type];
    }
    SDChattingCell *c = [SDChattingCell createCellForIdentifier:ID];
    c.indexPath = indexPath;
    NSInteger compareTime = 0;
    if(indexPath.row == 0){
        compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
    }
    else{
        compareTime = [(CXIMMessage *)_messages[indexPath.row - 1] sendTime].integerValue;
    }
    c.compareTime = compareTime;
    c.tableView = tableView;
    c.message = message;
    return c.cellHeight + 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID;
    
    CXIMMessage *message = _messages[indexPath.row];
    if(message.body.type == CXIMMessageContentTypeText && message.ext[@"shareDic"]){
        ID = @"SDChattingShareCell";
    }else{
        ID = [SDChattingCell identifierForContentType:message.body.type];
    }
    SDChattingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [SDChattingCell createCellForIdentifier:ID];
        cell.delegate = self;
    }
    if(self.superSearchMessages){
        cell.isNotNeedShowReadOrUnRead = YES;
    }else{
        cell.isNotNeedShowReadOrUnRead = NO;
    }
    
    cell.indexPath = indexPath;
    NSInteger compareTime = 0;
    if(indexPath.row == 0){
        compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
    }
    else{
        compareTime = [(CXIMMessage *)_messages[indexPath.row - 1] sendTime].integerValue;
    }
    cell.compareTime = compareTime;
    cell.canSeeLocation = self.canSeeLocation;
    cell.tableView = tableView;
    cell.message = message;
    self.cellHeights[indexPath] = @(cell.cellHeight);
    return cell;
}

-(void)collapseAll{
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self collapseAll];
    if (self.selectMemu) {
        [self.selectMemu removeFromSuperview];
        self.selectMemu = nil;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10003){
        if (buttonIndex == 1) {
            // 删除消息
            [_messages removeAllObjects];
            [[CXIMService sharedInstance].chatManager removeMessagesForChatter:self.chatter];
            [self fetchMessages];
        }
    }else if(alertView.tag == 10004 || alertView.tag == 10005){
        if (buttonIndex == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    }
}

#pragma mark - IBActionSheetDelegate
- (void)actionSheet:(IBActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
#if TARGET_IPHONE_SIMULATOR
        TTAlert(@"模拟器不支持照视频");
#else
        BOOL canPickImage = [SDPermissionsDetectionUtils checkMediaFree];
        if(!kHasRecordPermission && !canPickImage){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音和视频权限" message:@"您可以在“隐私设置”中开启语音和视频权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if (!kHasRecordPermission) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音权限" message:@"您可以在“隐私设置”中开启语音权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if(!canPickImage){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有视频权限" message:@"您可以在“隐私设置”中开启视频权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }else{
            [self.textView resignFirstResponder];
            //添加小视频View
            [self addLittteVideoPickView];
        }
#endif
    }else if(buttonIndex == 1){
        BOOL canOpenImagePicker = [SDPermissionsDetectionUtils checkImagePickerFree];
        if(canOpenImagePicker){
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有权限访问您的照片" message:@"您可以在“隐私设置”中开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark - 下拉刷新
-(void)loadMore
{
    //如果是超级搜索聊天记录，则上拉加载后面20条聊天记录，下拉加载前面20条聊天记录
    if(self.superSearchMessages){
        [self sortMessages];
        CXIMMessage * lastMessage = [self.superSearchMessages firstObject];
        if(self.isGroupChat){
            [[CXIMService sharedInstance].chatManager getGroupChatMessagesWithLastTime:lastMessage.sendTime Chatter:self.chatter Type:2 LoadAll:NO AndPageNumber:1 completion:^(NSArray<CXIMMessage *> *messages, NSString *currentPage, NSError *error) {
                [self sortMessages];
                if(_messages && [_messages count] > 0){
                    self.scrollMessage = [_messages firstObject];
                }
                NSMutableArray * msgs = [[NSMutableArray alloc] initWithArray:_messages];
                for(CXIMMessage * msg in messages){
                    for(CXIMMessage * message in msgs){
                        if([message.sendTime isEqual:msg.sendTime]){
                            [_messages removeObject:message];
                        }
                    }
                }
                [_messages addObjectsFromArray:messages];
                
                [self sortMessages];
                
                [self.tableView reloadData];
                
                [self scrollToScrollMessage];
                [_tableView.legendHeader endRefreshing];
            }];
        }else{
            [[CXIMService sharedInstance].chatManager getSingleChatMessagesWithLastTime:lastMessage.sendTime Chatter:self.chatter Type:2 AndPageNumber:1 completion:^(NSArray<CXIMMessage *> *messages, NSString *currentPage, NSError *error) {
                [self sortMessages];
                if(_messages && [_messages count] > 0){
                    self.scrollMessage = [_messages firstObject];
                }
                
                NSMutableArray * msgs = [[NSMutableArray alloc] initWithArray:_messages];
                for(CXIMMessage * msg in messages){
                    for(CXIMMessage * message in msgs){
                        if([message.sendTime isEqual:msg.sendTime]){
                            [_messages removeObject:message];
                        }
                    }
                }
                [_messages addObjectsFromArray:messages];
                [self sortMessages];
                
                [self.tableView reloadData];
                
                [self scrollToScrollMessage];
                [_tableView.legendHeader endRefreshing];
            }];
        }
    }else{
        [self fetchMessages];
    }
}

#pragma mark - 上拉加载
- (void)pullUpLoadData
{
    if(self.superSearchMessages){
        [self sortMessages];
        CXIMMessage * lastMessage = [_messages lastObject];
        if(self.isGroupChat){
            [[CXIMService sharedInstance].chatManager getGroupChatMessagesWithLastTime:lastMessage.sendTime Chatter:self.chatter Type:1 LoadAll:NO AndPageNumber:1 completion:^(NSArray<CXIMMessage *> *messages, NSString *currentPage, NSError *error) {
                [self sortMessages];
                if(_messages && [_messages count] > 0){
                    self.scrollMessage = [_messages firstObject];
                }
                
                NSMutableArray * msgs = [[NSMutableArray alloc] initWithArray:_messages];
                for(CXIMMessage * msg in messages){
                    for(CXIMMessage * message in msgs){
                        if([message.sendTime isEqual:msg.sendTime]){
                            [_messages removeObject:message];
                        }
                    }
                }
                [_messages addObjectsFromArray:messages];
                [self sortMessages];
                
                [self.tableView reloadData];
                
                [self scrollToScrollMessage];
                [_tableView.legendFooter endRefreshing];
            }];
        }else{
            [[CXIMService sharedInstance].chatManager getSingleChatMessagesWithLastTime:lastMessage.sendTime Chatter:self.chatter Type:1 AndPageNumber:1 completion:^(NSArray<CXIMMessage *> *messages, NSString *currentPage, NSError *error) {
                [self sortMessages];
                if(_messages && [_messages count] > 0){
                    self.scrollMessage = [_messages firstObject];
                }
                
                NSMutableArray * msgs = [[NSMutableArray alloc] initWithArray:_messages];
                for(CXIMMessage * msg in messages){
                    for(CXIMMessage * message in msgs){
                        if([message.sendTime isEqual:msg.sendTime]){
                            [_messages removeObject:message];
                        }
                    }
                }
                [_messages addObjectsFromArray:messages];
                [self sortMessages];
                
                [self.tableView reloadData];
                
                [self scrollToScrollMessage];
                [_tableView.legendFooter endRefreshing];
            }];
        }
    }
}

#pragma mark - 获取数据
// 获取阅后即焚历史消息
-(void)fetchBurnAfterMessages{
    NSNumber *topMessageSendTime;
    NSArray *arr = [[CXIMService sharedInstance].chatManager loadMessagesForChatter:self.chatter beforeTime:topMessageSendTime limit:[_messages.copy count]];
    [_messages removeAllObjects];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(CXIMMessage *msg1, CXIMMessage *msg2) {
        return msg1.sendTime.longLongValue > msg2.sendTime.longLongValue ? NSOrderedAscending : NSOrderedDescending;
    }];
    [arr enumerateObjectsUsingBlock:^(CXIMMessage *obj, NSUInteger idx, BOOL *stop) {
        [_messages insertObject:obj atIndex:0];
    }];
    [self.tableView reloadData];
    [_tableView.legendHeader endRefreshing];
    //    [self.refreshControl endRefreshing];
}

// 获取历史消息
-(void)fetchMessages{
    NSNumber *topMessageSendTime;
    if (_messages && _messages.count > 0) {
        topMessageSendTime = [(CXIMMessage *)_messages[0] sendTime];
    }
    else{
        _messages = [NSMutableArray array];
    }
    NSArray *arr = [[CXIMService sharedInstance].chatManager loadMessagesForChatter:self.chatter beforeTime:topMessageSendTime limit:kMessageLoadLimit];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(CXIMMessage *msg1, CXIMMessage *msg2) {
        return msg1.sendTime.longLongValue > msg2.sendTime.longLongValue ? NSOrderedAscending : NSOrderedDescending;
    }];
    [arr enumerateObjectsUsingBlock:^(CXIMMessage *obj, NSUInteger idx, BOOL *stop) {
        [_messages insertObject:obj atIndex:0];
    }];
    [self.tableView reloadData];
    [_tableView.legendHeader endRefreshing];
    //    [self.refreshControl endRefreshing];
}

// 获取搜索历史消息
-(void)fetchSearchMessages{
    NSNumber *topMessageSendTime;
    if (_messages && _messages.count > 0) {
        topMessageSendTime = [(CXIMMessage *)_messages[0] sendTime];
    }
    else{
        _messages = [NSMutableArray array];
    }
    
    NSArray *arr = [[CXIMService sharedInstance].chatManager loadMessagesForChatter:self.chatter afterTime:self.searchMessage.sendTime];
    //    if(!arr || [arr count] < kMessageLoadLimit){
    //        arr = [[CXIMService sharedInstance].chatManager loadMessagesForChatter:self.chatter beforeTime:topMessageSendTime limit:kMessageLoadLimit];
    //    }
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(CXIMMessage *msg1, CXIMMessage *msg2) {
        return msg1.sendTime.longLongValue > msg2.sendTime.longLongValue ? NSOrderedAscending : NSOrderedDescending;
    }];
    [arr enumerateObjectsUsingBlock:^(CXIMMessage *obj, NSUInteger idx, BOOL *stop) {
        [_messages insertObject:obj atIndex:0];
    }];
    [self.tableView reloadData];
}

//获取超级搜索的消息
- (void)fetchSuperSearchMessages
{
    _messages = [NSMutableArray arrayWithArray:self.superSearchMessages];
    [self sortMessages];
    if(_messages && [_messages count] > 0){
        self.scrollMessage = [_messages firstObject];
    }
    [self.tableView reloadData];
}

- (void)sortMessages
{
    if(_messages && [_messages count] > 0){
        NSComparator cmptr = ^(CXIMMessage * message1, CXIMMessage * message2){
            if ([message1.sendTime longLongValue] > [message2.sendTime longLongValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([message1.sendTime longLongValue] < [message2.sendTime longLongValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        _messages = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:_messages] sortedArrayUsingComparator:cmptr]];
    }
}

- (void)refetchMessages {
    [self.messages removeAllObjects];
    [self fetchMessages];
}

#pragma mark - 滚动到底部
- (void)scrollToBottom {
    NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
    if (row > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

- (void)scrollToTop {
    NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
    if (row > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

#pragma mark - 定位
- (void)locateTimerFire {
    __weak typeof(self) wself = self;
    self.locationMgr = [[SDUserCurrentLocation alloc] initWithSignIn];
    //    self.locationMgr.signSuccess = ^(NSString *location)
    //    {
    //        // 北京市东城区广场西侧路,116.402967,39.912947
    //        NSArray<NSString *> *locationInfo = [location componentsSeparatedByString:@","];
    //        NSString *address = locationInfo[0];
    //        double lon = locationInfo[1].doubleValue;
    //        double lat = locationInfo[2].doubleValue;
    //        wself.currentLocation = [CXIMLocationInfo infoWithLongitude:lon latitude:lat address:address];
    //    };
    self.locationMgr.detailCallback = ^(CLLocationCoordinate2D location, NSString *address) {
        wself.currentLocation = [CXIMLocationInfo infoWithLongitude:location.longitude latitude:location.latitude address:address];
    };
    
    self.locationMgr.signFail = ^
    {
        wself.currentLocation = nil;
    };
}

#pragma mark - TZImagePickerControllerDelegate
// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    return YES;
}

@end
