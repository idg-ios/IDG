//
//  CXDDXVoiceMeetingDetailViewController.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDDXVoiceMeetingDetailViewController.h"
#import "PlayerManager.h"
#import "RecorderManager.h"
#import "UIImageView+EMWebCache.h"
#import "YYModel.h"
#import "UIView+Category.h"
#import "SDUploadFileModel.h"
#import "HttpTool.h"
#import "CXDDXVoiceMeetingDetailModel.h"
#import "YYModel.h"
#import "CXDDXVoiceModel.h"
#import "SDPermissionsDetectionUtils.h"
#import "CXDDXMeetingDetailInfoViewController.h"
#import "CXIDGVoiceMeetingCellTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

#define kHeadViewLeftSpace 15.0

#define kHeadViewTopSpace 10.0

#define kConferenceUserNameLabelLeftSpace 10.0

#define kConferenceUserNameLabelFontSize 17.0

#define kConferenceCreateTimeLabelFontSize 15.0

#define kConferenceCreateTimeLabelTextColor (RGBACOLOR(153.0, 153.0, 153.0, 1.0))

#define kConferenceCreateTimeLabelWidth 170.0

#define kConferenceUserJobLabelTopSpace 6.0

#define kConferenceUserJobLabelFontSize 14.0

#define kConferenceCreateNumberLabelFontSize 15.0

#define kHeadViewWidth (kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize)

#define kConferenceUserJobLabelBottomSpace 10.0

#define kConferenceTopViewMiddleLineLeftSpace 3.0

#define kConferenceTopViewMiddleLineHeight 1.0

#define kConferenceTitleLabelTopSpace 44.0

#define kConferenceTitleLabelWidth 200.0

#define kConferenceTitleLabelFontSize 17.0

#define kConferenceAutoPlayLabelTopSpace 11.0

#define kConferenceAutoPlayBtnTopMoveSpace 8.0

#define kConferenceAutoPlayBtnRightSpace 120.0

#define kConferenceAutoPlayBtnWidth 100.0

#define kConferenceAutoPlayBtnHeight 14.0

#define kConferenceTopAutoPlayLabelFontSize 14.0

#define kConferenceTopAutoPlayLabelWidth 200.0

#define kConferenceTopAutoPlayLabelRightSpace 10.0

#define kConferenceTopViewBottomLineHeight 2.0

#define kConferenceTopViewHeight (kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize + kConferenceUserJobLabelBottomSpace + kConferenceTopViewMiddleLineHeight + kConferenceTitleLabelTopSpace + kConferenceTitleLabelFontSize +  kConferenceTitleLabelTopSpace + kConferenceTopViewBottomLineHeight)

#define kBottomRecordBackViewHeight 46.0

#define kBottomRecordButtonLeftSpace 30.0

#define kBottomRecordButtonTopSpace 5.0

#define kRecordTipImageViewWidth 150.0

#define kHasRecordPermission ([SDPermissionsDetectionUtils checkCanRecordFree])

//13位时间戳
#define kTimestamp ((long long)([[NSDate date] timeIntervalSince1970] * 1000))

// 公共
#define CXIM_DOCUMENT_DIR NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

/** 语音会议目录 */
#define CXIM_VOICEMEETING_DIR [CXIM_DOCUMENT_DIR stringByAppendingPathComponent:@"voiceMeeting"]

/** 语音会议本地语音目录 */
#define CXIM_VOICEMEETING_LOCAL_VOICE_DIR @"/Documents/voiceMeeting/"

#define kGetVoiceModelArrayInterval 3.0

@interface CXDDXVoiceMeetingDetailViewController ()<RecordingDelegate, PlayingDelegate, UITableViewDelegate, UITableViewDataSource, NSURLSessionDownloadDelegate>

/** 导航条 */
@property (strong, nonatomic) SDRootTopView* rootTopView;
/** 列表模型 */
@property (nonatomic, strong) CXDDXVoiceMeetingListModel * listModel;
/** 会议创建日期 */
@property (nonatomic, strong) NSString * conferenceCreateTime;
/** 会议创建NO. */
@property (nonatomic, strong) NSString * conferenceCreateNumber;
/** 会议议题 */
@property (nonatomic, strong) NSString * conferenceTitle;
/** 会议是否结束 */
@property (nonatomic, assign) CXDDXMeetingType type;
/** 语音会议顶部View */
@property (nonatomic, strong) UIView * conferenceTopView;
/** 语音会议底部View */
@property (nonatomic, strong) UIView * conferenceBottomView;
/** 语音会议顶部View的HeadView */
@property (nonatomic, strong) UIImageView * conferenceTopHeadImageView;
/** 语音会议顶部View的NameLabel */
@property (nonatomic, strong) UILabel * conferenceTopHeadNameLabel;
/** 语音会议顶部View的CreateTimeLabel */
@property (nonatomic, strong) UILabel * conferenceTopHeadCreateTimeLabel;
/** 语音会议顶部View的NumberLabel */
@property (nonatomic, strong) UILabel * conferenceTopNumberLabel;
/** 语音会议顶部View的MiddleLine */
@property (nonatomic, strong) UIView * conferenceTopMiddleLineView;
/** 语音会议顶部View的TitleLabel */
@property (nonatomic, strong) UILabel * conferenceTopTitleLabel;
/** 语音会议顶部View的自动播放开关Label */
@property (nonatomic, strong) UILabel * conferenceTopAutoPlayLabel;
/** 语音会议顶部View的自动播放开关 */
@property (nonatomic, strong) UISwitch * conferenceTopAutoPlaySwitch;
/** 语音会议顶部View的BottomLine */
@property (nonatomic, strong) UIView * conferenceTopBottomLineView;
/** 语音会议底部背景View */
@property (nonatomic, strong) UIView * bottomRecordBackView;
/** 语音会议底部录音按钮 */
@property (nonatomic, strong) UIButton * bottomRecordButton;
/** 是否显示上滑取消图片 */
@property (nonatomic) BOOL showCancleRecordImage;
/** 录音提示 */ 
@property (nonatomic, strong) UIImageView *recordTipImageView;
/** 录音机 */
@property (nonatomic, strong) RecorderManager *recordManager;
/** 语音会议详情Model */
@property (nonatomic, strong) CXDDXVoiceMeetingDetailModel * model;
/** 语音ModelArray */
@property (nonatomic, strong) NSMutableArray<CXDDXVoiceModel *> * voiceModelArray;
/** 语音会议记录tableView */
@property (nonatomic, strong) UITableView * tableView;
/** downloadTask */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/** completionBlock */
@property(nonatomic, copy) void(^completionBlock)(CXDDXVoiceModel *voiceModel, NSError *error);
/** progressBlock */
@property(nonatomic, copy) void(^progressBlock)(float);
/** 正在下载的voiceModel */
@property (nonatomic, strong) CXDDXVoiceModel * downloadingVoiceModel;
/** 自动播放获取新的语音会议消息的定时器 */
@property (nonatomic, strong) NSTimer * getVoiceModelArrayTimer;
/** 正在播放的VoiceModel的Index */
@property (nonatomic) NSInteger playingIndex;
/** 播放是否结束 */
@property (nonatomic) BOOL isPlayEnd;
/** 是否取消自动播放 */
@property (nonatomic) BOOL isCancleEnd;
/** cellHeights */
@property (nonatomic,strong) NSMutableDictionary *cellHeights;
/** 模板cell */
@property (nonatomic, strong) CXIDGVoiceMeetingSuperCellTableViewCell *templateCell;

@end

@implementation CXDDXVoiceMeetingDetailViewController

#pragma mark - LazyLoad
- (NSMutableDictionary *)cellHeights{
    if (_cellHeights == nil) {
        _cellHeights = [NSMutableDictionary dictionary];
    }
    return _cellHeights;
}

- (UIView *)conferenceTopView
{
    if(!_conferenceTopView){
        _conferenceTopView = [[UIView alloc] init];
        _conferenceTopView.backgroundColor = [UIColor whiteColor];
        _conferenceTopView.frame = CGRectMake(0, navHigh, Screen_Width, kConferenceTopViewHeight);
        self.conferenceTopHeadImageView.frame = CGRectMake(kHeadViewLeftSpace, kHeadViewTopSpace, kHeadViewWidth, kHeadViewWidth);
        self.conferenceTopHeadNameLabel.frame = CGRectMake(kHeadViewLeftSpace + kHeadViewWidth + kConferenceUserNameLabelLeftSpace, kHeadViewTopSpace + (kHeadViewWidth - kConferenceUserNameLabelFontSize)/2, Screen_Width - kConferenceCreateTimeLabelWidth, kConferenceUserNameLabelFontSize);
        self.conferenceTopHeadCreateTimeLabel.frame = CGRectMake(Screen_Width - kConferenceCreateTimeLabelWidth, kHeadViewTopSpace, kConferenceCreateTimeLabelWidth, kConferenceCreateTimeLabelFontSize);
        self.conferenceTopNumberLabel.frame = CGRectMake(Screen_Width - kConferenceCreateTimeLabelWidth, kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace, kConferenceCreateTimeLabelWidth, kConferenceCreateTimeLabelFontSize);
        self.conferenceTopMiddleLineView.frame = CGRectMake(kConferenceTopViewMiddleLineLeftSpace, kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize + kHeadViewTopSpace, Screen_Width - 2*kConferenceTopViewMiddleLineLeftSpace, kConferenceTopViewMiddleLineHeight);
        self.conferenceTopTitleLabel.frame = CGRectMake(kHeadViewLeftSpace, kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize + kHeadViewTopSpace + kConferenceTopViewMiddleLineHeight + kConferenceTitleLabelTopSpace, Screen_Width - 2*kHeadViewLeftSpace, kConferenceTitleLabelFontSize);
        self.conferenceTopBottomLineView.frame = CGRectMake(0, kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize + kHeadViewTopSpace + kConferenceTopViewMiddleLineHeight + kConferenceTitleLabelTopSpace + kConferenceTitleLabelFontSize + kConferenceTitleLabelTopSpace, Screen_Width, kConferenceTopViewBottomLineHeight);
        [self.view addSubview:_conferenceTopView];
    }
    return _conferenceTopView;
}

- (UIImageView *)conferenceTopHeadImageView
{
    if(!_conferenceTopHeadImageView){
        _conferenceTopHeadImageView = [[UIImageView alloc] init];
        _conferenceTopHeadImageView.layer.cornerRadius = kHeadViewWidth/2;
        _conferenceTopHeadImageView.layer.masksToBounds = YES;
        [self.conferenceTopView addSubview:_conferenceTopHeadImageView];
    }
    return _conferenceTopHeadImageView;
}

- (UILabel *)conferenceTopHeadNameLabel
{
    if(!_conferenceTopHeadNameLabel){
        _conferenceTopHeadNameLabel = [[UILabel alloc] init];
        _conferenceTopHeadNameLabel.font = [UIFont systemFontOfSize:kConferenceUserNameLabelFontSize];
        _conferenceTopHeadNameLabel.textAlignment = NSTextAlignmentLeft;
        _conferenceTopHeadNameLabel.backgroundColor = [UIColor clearColor];
        _conferenceTopHeadNameLabel.textColor = [UIColor blackColor];
        [self.conferenceTopView addSubview:_conferenceTopHeadNameLabel];
    }
    return _conferenceTopHeadNameLabel;
}

- (UILabel *)conferenceTopHeadCreateTimeLabel
{
    if(!_conferenceTopHeadCreateTimeLabel){
        _conferenceTopHeadCreateTimeLabel = [[UILabel alloc] init];
        _conferenceTopHeadCreateTimeLabel.font = [UIFont systemFontOfSize:kConferenceCreateTimeLabelFontSize];
        _conferenceTopHeadCreateTimeLabel.textAlignment = NSTextAlignmentLeft;
        _conferenceTopHeadCreateTimeLabel.backgroundColor = [UIColor clearColor];
        _conferenceTopHeadCreateTimeLabel.textColor = kConferenceCreateTimeLabelTextColor;
        [self.conferenceTopView addSubview:_conferenceTopHeadCreateTimeLabel];
    }
    return _conferenceTopHeadCreateTimeLabel;
}

- (UILabel *)conferenceTopNumberLabel
{
    if(!_conferenceTopNumberLabel){
        _conferenceTopNumberLabel = [[UILabel alloc] init];
        _conferenceTopNumberLabel.font = [UIFont systemFontOfSize:kConferenceCreateNumberLabelFontSize];
        _conferenceTopNumberLabel.textAlignment = NSTextAlignmentLeft;
        _conferenceTopNumberLabel.backgroundColor = [UIColor clearColor];
        _conferenceTopNumberLabel.textColor = kConferenceCreateTimeLabelTextColor;
        [self.conferenceTopView addSubview:_conferenceTopNumberLabel];
    }
    return _conferenceTopNumberLabel;
}

- (UIView *)conferenceTopMiddleLineView
{
    if(!_conferenceTopMiddleLineView){
        _conferenceTopMiddleLineView = [[UIView alloc] init];
        _conferenceTopMiddleLineView.backgroundColor = RGBACOLOR(218.0, 218.0, 218.0, 1.0);
        [self.conferenceTopView addSubview:_conferenceTopMiddleLineView];
    }
    return _conferenceTopMiddleLineView;
}

- (UILabel *)conferenceTopTitleLabel
{
    if(!_conferenceTopTitleLabel){
        _conferenceTopTitleLabel = [[UILabel alloc] init];
        _conferenceTopTitleLabel.font = [UIFont systemFontOfSize:kConferenceTitleLabelFontSize];
        _conferenceTopTitleLabel.textAlignment = NSTextAlignmentLeft;
        _conferenceTopTitleLabel.backgroundColor = [UIColor clearColor];
        _conferenceTopTitleLabel.textColor = [UIColor blackColor];
        [self.conferenceTopView addSubview:_conferenceTopTitleLabel];
    }
    return _conferenceTopTitleLabel;
}

- (UILabel *)conferenceTopAutoPlayLabel
{
    if(!_conferenceTopAutoPlayLabel){
        _conferenceTopAutoPlayLabel = [[UILabel alloc] init];
        _conferenceTopAutoPlayLabel.text = @"自动播放";
        _conferenceTopAutoPlayLabel.font = [UIFont systemFontOfSize:kConferenceTopAutoPlayLabelFontSize];
        _conferenceTopAutoPlayLabel.textAlignment = NSTextAlignmentRight;
        _conferenceTopAutoPlayLabel.backgroundColor = [UIColor clearColor];
        _conferenceTopAutoPlayLabel.textColor = [UIColor blackColor];
        [self.conferenceTopView addSubview:_conferenceTopAutoPlayLabel];
    }
    return _conferenceTopAutoPlayLabel;
}

- (UISwitch *)conferenceTopAutoPlaySwitch
{
    if(!_conferenceTopAutoPlaySwitch){
        _conferenceTopAutoPlaySwitch = [[UISwitch alloc] init];
        _conferenceTopAutoPlaySwitch.on = NO;
        [_conferenceTopAutoPlaySwitch addTarget:self action:@selector(conferenceTopAutoPlaySwitchSwichChanged) forControlEvents:UIControlEventValueChanged];
        [self.conferenceTopView addSubview:_conferenceTopAutoPlaySwitch];
    }
    return _conferenceTopAutoPlaySwitch;
}

- (UIView *)conferenceTopBottomLineView
{
    if(!_conferenceTopBottomLineView){
        _conferenceTopBottomLineView = [[UIView alloc] init];
        _conferenceTopBottomLineView.backgroundColor = RGBACOLOR(215.0, 215.0, 215.0, 1.0);
        [self.conferenceTopView addSubview:_conferenceTopBottomLineView];
    }
    return _conferenceTopBottomLineView;
}

- (UIView *)bottomRecordBackView
{
    if(!_bottomRecordBackView){
        _bottomRecordBackView = [[UIView alloc] init];
        _bottomRecordBackView.backgroundColor = RGBACOLOR(244.0, 244.0, 246.0, 1.0);
        _bottomRecordBackView.frame = CGRectMake(0, Screen_Height - kBottomRecordBackViewHeight, Screen_Width, kBottomRecordBackViewHeight);
        self.bottomRecordButton.frame = CGRectMake(kBottomRecordButtonLeftSpace, kBottomRecordButtonTopSpace, Screen_Width - 2*kBottomRecordButtonLeftSpace, kBottomRecordBackViewHeight - 2*kBottomRecordButtonTopSpace);
        [self.view addSubview:_bottomRecordBackView];
    }
    return _bottomRecordBackView;
}

- (UIButton *)bottomRecordButton
{
    if(!_bottomRecordButton){
        _bottomRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomRecordButton.backgroundColor = [UIColor redColor];
        _bottomRecordButton.backgroundColor = [UIColor clearColor];
        _bottomRecordButton.layer.cornerRadius = 3;
        _bottomRecordButton.layer.borderColor = kColorWithRGB(170, 170, 170).CGColor;
        _bottomRecordButton.layer.borderWidth = 1;
        [_bottomRecordButton setTitleColor:kColorWithRGB(170, 170, 170) forState:UIControlStateNormal];
        [_bottomRecordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_bottomRecordButton addTarget:self action:@selector(toolViewRecordBtnTouchDown) forControlEvents:UIControlEventTouchDown];
        [_bottomRecordButton addTarget:self action:@selector(toolViewRecordBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_bottomRecordButton addTarget:self action:@selector(toolViewRecordBtnTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_bottomRecordButton addTarget:self action:@selector(toolViewRecordBtnTouchExit) forControlEvents:UIControlEventTouchDragExit];
        [self.bottomRecordBackView addSubview:_bottomRecordButton];
    }
    return _bottomRecordButton;
}

- (UIImageView *)recordTipImageView{
    if (!_recordTipImageView) {
        _recordTipImageView = [[UIImageView alloc] init];
        _recordTipImageView.image = [UIImage imageNamed:@"newvoiceChatImage001"];
        _recordTipImageView.highlightedImage = [UIImage imageNamed:@"newvoiceChatImage001"];
        _recordTipImageView.hidden = YES;
        _recordTipImageView.contentMode = UIViewContentModeScaleToFill;
        _recordTipImageView.frame = CGRectMake((Screen_Width - kRecordTipImageViewWidth)/2, (Screen_Height - kRecordTipImageViewWidth)/2 + 10, kRecordTipImageViewWidth, kRecordTipImageViewWidth);
        [self.view addSubview:_recordTipImageView];
    }
    return _recordTipImageView;
}

- (RecorderManager *)recordManager{
    if (_recordManager == nil) {
        _recordManager = [RecorderManager sharedManager];
        _recordManager.delegate = self;
    }
    return _recordManager;
}

- (CXDDXVoiceMeetingDetailModel *)model{
    if(!_model){
        _model = [[CXDDXVoiceMeetingDetailModel alloc] init];
    }
    return _model;
}

- (NSMutableArray<CXDDXVoiceModel *> *)voiceModelArray{
    if(!_voiceModelArray){
        _voiceModelArray = @[].mutableCopy;
    }
    return _voiceModelArray;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        [self.view insertSubview:_tableView belowSubview:[self getRootTopView]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = RGBACOLOR(232.0, 232.0, 232.0, 1.0);
        self.view.backgroundColor = RGBACOLOR(232.0, 232.0, 232.0, 1.0);
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSTimer *)getVoiceModelArrayTimer {
    if (_getVoiceModelArrayTimer == nil) {
        _getVoiceModelArrayTimer = [NSTimer scheduledTimerWithTimeInterval:kGetVoiceModelArrayInterval target:self selector:@selector(getVoiceModelArrayTimerFire) userInfo:nil repeats:YES];
        _getVoiceModelArrayTimer.fireDate = [NSDate distantPast];
    }
    return _getVoiceModelArrayTimer;
}

#pragma mark - 生命周期
- (instancetype)initWithCXDDXVoiceMeetingListModel:(CXDDXVoiceMeetingListModel*)listModel
{
    if (self = [super init]) {
        self.listModel = listModel;
        self.showCancleRecordImage = NO;
        self.isPlayEnd = YES;
        self.isCancleEnd = YES;
        // 创建目录
        BOOL success = YES;
        success = success && [self createDirectory:CXIM_VOICEMEETING_DIR];
        NSAssert(success, @"create directory failed");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDDXVoiceMeetingDetailData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChangeTitleNotification:) name:changeCXDDXMeetingTitleNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.downloadTask) {
        NSLog(@"cancel download task");
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
    [self closeGetVoiceModelArrayTimer];
    [[PlayerManager sharedManager] stopPlaying];
    [PlayerManager sharedManager].delegate = nil;
    self.isCancleEnd = YES;
}

-(void)dealloc
{
    [self closeGetVoiceModelArrayTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通知
- (void)receiveChangeTitleNotification:(NSNotification *)noti {
    NSString *title = noti.userInfo[@"title"];
    self.model.vedioMeetModel.title = title;
    self.conferenceTopTitleLabel.text = [NSString stringWithFormat:@"议题：%@",self.model.vedioMeetModel.title];
}

#pragma mark - 私有方法
- (BOOL)hasHadCXDDXVoiceModel:(CXDDXVoiceModel *)model
{
    if(self.voiceModelArray && [self.voiceModelArray count] > 0){
        for(CXDDXVoiceModel * messageModel in self.voiceModelArray){
            if([messageModel.eid integerValue] == [model.eid integerValue]){
                return YES;
            }
        }
    }
    return NO;
}

- (void)getVoiceModelArrayTimerFire
{
    NSString *url = [NSString stringWithFormat:@"%@vedioMeet/record/list/%zd/forward", urlPrefix,[self.model.vedioMeetModel.eid integerValue]];
    NSMutableDictionary * params = @{}.mutableCopy;
    [params setValue:self.model.vedioMeetModel.eid forKey:@"bid"];
    if(self.voiceModelArray && [self.voiceModelArray count] > 0){
        [params setValue:[self.voiceModelArray lastObject].eid forKey:@"limitId"];
    }
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            NSArray * array = [NSArray yy_modelArrayWithClass:CXDDXVoiceModel.class json:JSON[@"data"][@"data"]];
            NSArray<CXDDXVoiceModel *> * sortedArray = [self sortVoiceMeetingArrayWithArray:array];
            [self sortVoiceMeetingArray];
            NSInteger i = 0;
            for (; i < [sortedArray count]; i++) {
                [self downloadFileWithCXDDXVoiceModel:sortedArray[i] WithProgress:^(float progress) {
                    
                } completion:^(CXDDXVoiceModel * voiceModel, NSError * error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(![self hasHadCXDDXVoiceModel:voiceModel]){
                            [self.voiceModelArray addObject:voiceModel];
                            self.conferenceTopAutoPlayLabel.frame = CGRectMake(Screen_Width - kConferenceTopAutoPlayLabelRightSpace - kConferenceTopAutoPlayLabelWidth, kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize + kHeadViewTopSpace + kConferenceTopViewMiddleLineHeight + kConferenceTitleLabelTopSpace + kConferenceTitleLabelFontSize + kConferenceAutoPlayLabelTopSpace, kConferenceTopAutoPlayLabelWidth, kConferenceTopAutoPlayLabelFontSize);
                            self.conferenceTopAutoPlaySwitch.frame = CGRectMake(Screen_Width - kConferenceAutoPlayBtnRightSpace, kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize + kHeadViewTopSpace + kConferenceTopViewMiddleLineHeight + kConferenceTitleLabelTopSpace + kConferenceTitleLabelFontSize + kConferenceAutoPlayLabelTopSpace - kConferenceAutoPlayBtnTopMoveSpace, kConferenceAutoPlayBtnWidth, kConferenceAutoPlayBtnHeight);
                            NSMutableArray *indexPaths = [NSMutableArray array];
                            NSInteger count = [self.voiceModelArray count]-1;
                            [indexPaths addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                            [self.tableView beginUpdates];
                            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                            [self.tableView endUpdates];
                            if(self.isPlayEnd && self.conferenceTopAutoPlaySwitch.on){
                                [self loopPlayMeetingMessageFromIndex:count];
                            }
                        }
                    });
                }];
            }
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (BOOL)createDirectory:(NSString *)directory {
    BOOL isDir = false;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDir];
    if (!(isDir && isDirExist)) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

- (void)sortVoiceMeetingArray
{
    if(self.voiceModelArray && [self.voiceModelArray count] > 0){
        NSComparator cmptr = ^(CXDDXVoiceModel * message1, CXDDXVoiceModel * message2){
            if ([message1.eid integerValue] > [message2.eid integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([message1.eid integerValue] < [message2.eid integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        self.voiceModelArray = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:self.voiceModelArray] sortedArrayUsingComparator:cmptr]];
    }
}

- (NSArray<CXDDXVoiceModel *> *)sortVoiceMeetingArrayWithArray:(NSArray<CXDDXVoiceModel *> *)array
{
    if(array && [array count] > 0){
        NSComparator cmptr = ^(CXDDXVoiceModel * message1, CXDDXVoiceModel * message2){
            if ([message1.eid integerValue] > [message2.eid integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([message1.eid integerValue] < [message2.eid integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray * newArray = [[NSArray arrayWithArray:array] sortedArrayUsingComparator:cmptr];
        return newArray;;
    }
    return nil;
}

- (void)closeGetVoiceModelArrayTimer
{
    [self.getVoiceModelArrayTimer invalidate];
    self.getVoiceModelArrayTimer = nil;
}

- (void)tableViewAllCellsRemoveAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for(NSInteger i = 0;i<[self.voiceModelArray count] ;i++){
            CXIDGVoiceMeetingCellTableViewCell * cell = (CXIDGVoiceMeetingCellTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(cell){
                [cell reloadImageView];
            }
        }
    });
}

- (void)conferenceTopAutoPlaySwitchSwichChanged
{
    [[PlayerManager sharedManager] stopPlaying];
    [self tableViewAllCellsRemoveAnimation];
    if(self.conferenceTopAutoPlaySwitch.on){
        self.isCancleEnd = NO;
        [self loopPlayMeetingMessageFromIndex:self.playingIndex];
    }else{
        [[PlayerManager sharedManager] stopPlaying];
        self.isCancleEnd = YES;
    }
}

- (void)selectMeetingMessageOnIndex:(NSInteger)index
{
    if(self.isCancleEnd){
        self.isPlayEnd = NO;
        // 文件名
        NSString *fileName = [NSString stringWithFormat:@"%zd.spx", [self.voiceModelArray[index].eid integerValue]];
        // 文件路径
        NSString * filePath = [CXIM_VOICEMEETING_DIR stringByAppendingPathComponent:fileName];
        [[PlayerManager sharedManager] playAudioWithFileName:filePath playerType:(DDSpeaker) delegate:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //这里延时操作为了图片可以动
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CXIDGVoiceMeetingCellTableViewCell * cell = (CXIDGVoiceMeetingCellTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                if(cell){
                    [cell voiceImageViewActive];
                }
            });
        });
    }else{
        [self pausePlayVoice];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isCancleEnd = NO;
            [self tableViewAllCellsRemoveAnimation];
            [self loopPlayMeetingMessageFromIndex:index];
        });
    }
}

- (void)pausePlayVoice
{
    [[PlayerManager sharedManager] stopPlaying];
}

- (void)continuePlayVoice
{
    [self loopPlayMeetingMessageFromIndex:self.playingIndex];
}

- (void)setVoiceMeetingData{
    [self.conferenceTopHeadImageView sd_setImageWithURL:[NSURL URLWithString:(self.model.vedioMeetModel.icon && ![self.model.vedioMeetModel.icon isKindOfClass:[NSNull class]])?self.model.vedioMeetModel.icon:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    self.conferenceTopHeadNameLabel.text = self.model.vedioMeetModel.ygName;
    self.conferenceTopHeadCreateTimeLabel.text = [NSString stringWithFormat:@"日期：%@",self.model.vedioMeetModel.createTime];
    self.conferenceTopNumberLabel.text = [NSString stringWithFormat:@"NO.：%@",self.model.vedioMeetModel.serNo];
    self.conferenceTopTitleLabel.text = [NSString stringWithFormat:@"议题：%@",self.model.vedioMeetModel.title];
}

- (void)loopPlayMeetingMessageFromIndex:(NSInteger)index
{
    if(!self.isCancleEnd){
        [self playMeetingMessageWithIndex:index];
    }
}

- (void)playMeetingMessageWithIndex:(NSInteger)index
{
    if(!self.isCancleEnd){
        self.playingIndex = index;
        NSArray<CXDDXVoiceModel *> * voiceArray = self.voiceModelArray.copy;
        if(self.playingIndex >= [voiceArray count]){
            NSLog(@"播放完成，第%zd条",self.playingIndex - 1);
            self.isPlayEnd = YES;
            return;
        }
        self.isPlayEnd = NO;
        // 文件名
        NSString *fileName = [NSString stringWithFormat:@"%zd.spx", [voiceArray[index].eid integerValue]];
        // 文件路径
        NSString * filePath = [CXIM_VOICEMEETING_DIR stringByAppendingPathComponent:fileName];
        [[PlayerManager sharedManager] playAudioWithFileName:filePath playerType:(DDSpeaker) delegate:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [self tableViewAllCellsRemoveAnimation];
            //这里延时操作为了图片可以动
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CXIDGVoiceMeetingCellTableViewCell * cell = (CXIDGVoiceMeetingCellTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                if(cell && !self.isCancleEnd){
                    [cell voiceImageViewActive];
                }
            });
        });
    }
}

- (void)loadDDXVoiceMeetingDetailData
{
    NSString *url = [NSString stringWithFormat:@"%@vedioMeet/detail/%zd", urlPrefix,[self.listModel.eid integerValue]];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    [HttpTool getWithPath:url params:nil success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            [weakSelf hideHud];
            self.model.ccList = [NSArray yy_modelArrayWithClass:CXDDXVoiceMeetingDetailUserModel.class json:JSON[@"data"][@"ccList"]];
            self.model.vedioMeetModel = [CXDDXVoiceMeetingDetailVedioMeetModel yy_modelWithDictionary:JSON[@"data"][@"vedioMeet"]];
            if([self.model.vedioMeetModel.isEnd integerValue] == 1){
                self.type = CXDDXMeetingNotEndType;
            }else{
                self.type = CXDDXMeetingIsEndType;
            }
            [self setVoiceMeetingData];
            
            //这里获取所有的历史数据
            NSString *url = [NSString stringWithFormat:@"%@vedioMeet/record/list/%zd/all", urlPrefix,[self.model.vedioMeetModel.eid integerValue]];
            NSMutableDictionary * params = @{}.mutableCopy;
            [params setValue:self.model.vedioMeetModel.eid forKey:@"bid"];
            [self showHudInView:self.view hint:nil];
            [HttpTool postWithPath:url params:params success:^(id JSON) {
                [weakSelf hideHud];
                if ([JSON[@"status"] integerValue] == 200) {
                    NSArray * array = [NSArray yy_modelArrayWithClass:CXDDXVoiceModel.class json:JSON[@"data"]];
                    self.voiceModelArray = array.mutableCopy;
                    [self sortVoiceMeetingArray];
                    [self downLoadVoiceMeetingMessageWithIndex:0];
                    [self setUpNavBar];
                    [self setUpSubview];
                }else{
                    TTAlert(JSON[@"msg"]);
                }
            } failure:^(NSError *error) {
                [weakSelf hideHud];
                CXAlert(KNetworkFailRemind);
            }];
        }else{
            [weakSelf hideHud];
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)downLoadVoiceMeetingMessageWithIndex:(NSInteger)newIndex
{
    if(self.voiceModelArray && [self.voiceModelArray count] > 0){
        __block NSInteger index;
        if(newIndex){
            index = newIndex;
        }else{
            index = 0;
        }
        [self downloadFileWithCXDDXVoiceModel:self.voiceModelArray[index] WithProgress:^(float progress) {
            
        } completion:^(CXDDXVoiceModel * voiceModel, NSError * error) {
            index++;
            if([voiceModel.eid integerValue] == [[self.voiceModelArray lastObject].eid integerValue]){
                [self addVoiceLsitTable];
                self.conferenceTopAutoPlayLabel.frame = CGRectMake(Screen_Width - kConferenceTopAutoPlayLabelRightSpace - kConferenceTopAutoPlayLabelWidth, kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize + kHeadViewTopSpace + kConferenceTopViewMiddleLineHeight + kConferenceTitleLabelTopSpace + kConferenceTitleLabelFontSize + kConferenceAutoPlayLabelTopSpace, kConferenceTopAutoPlayLabelWidth, kConferenceTopAutoPlayLabelFontSize);
                self.conferenceTopAutoPlaySwitch.frame = CGRectMake(Screen_Width - kConferenceAutoPlayBtnRightSpace, kHeadViewTopSpace + kConferenceUserNameLabelFontSize + kConferenceUserJobLabelTopSpace + kConferenceUserJobLabelFontSize + kHeadViewTopSpace + kConferenceTopViewMiddleLineHeight + kConferenceTitleLabelTopSpace + kConferenceTitleLabelFontSize + kConferenceAutoPlayLabelTopSpace - kConferenceAutoPlayBtnTopMoveSpace, kConferenceAutoPlayBtnWidth, kConferenceAutoPlayBtnHeight);
                return;
            }
            [self downLoadVoiceMeetingMessageWithIndex:index];
        }];
    }else{
        [self addVoiceLsitTable];
    }
}

- (CXIMMessage *)changeCXDDXVoiceModelToCXIMMessageWithCXDDXVoiceModel:(CXDDXVoiceModel *)model
{
    CXIMMessage * message = [[CXIMMessage alloc] init];
    message.type = CXIMProtocolTypeGroupChat;
    message.ID = model.eid.stringValue;
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsContactsDicWithUserId:[model.ygId integerValue]];
    message.sender = userModel.imAccount;
    message.receiver = [CXIMService sharedInstance].chatManager.currentAccount;
    CXIMVoiceMessageBody *body = [[CXIMVoiceMessageBody alloc] init];
    NSString * fileName = [NSString stringWithFormat:@"%zd.spx", [model.eid integerValue]];
    NSString * filePath = [CXIM_VOICEMEETING_DIR stringByAppendingPathComponent:fileName];
    NSString * localFilePath = [CXIM_VOICEMEETING_LOCAL_VOICE_DIR stringByAppendingPathComponent:fileName];
    body.localUrl = localFilePath;
    body.name = [filePath lastPathComponent];
    body.length = model.length;
    NSNumber *size = @([[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize]);
    body.size = size;
    message.body = body;
    message.sendTime = @(kTimestamp);
    message.status = CXIMMessageStatusSendSuccess;
    message.readFlag = CXIMMessageReadFlagReaded;
    message.openFlag = CXIMMessageReadFlagReaded;
    message.readAsk = CXIMMessageReadFlagReaded;
    return message;
}

#pragma mark - setUpUI
- (void)setUpNavBar
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"语音会议"];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"voiceGroupInfo.png"] addTarget:self action:@selector(rightDetailBtnClick)];
}

- (void)setUpSubview
{
    if(self.type == CXDDXMeetingNotEndType){
        self.conferenceTopView.hidden = NO;
        self.bottomRecordBackView.hidden = NO;
    }else{
        self.conferenceTopView.hidden = NO;
    }
}

- (void)addVoiceLsitTable
{
    if(self.type == CXDDXMeetingNotEndType){
        self.tableView.frame = CGRectMake(0, navHigh + kConferenceTopViewHeight, Screen_Width, Screen_Height - navHigh - kConferenceTopViewHeight -  kBottomRecordBackViewHeight);
        [self getVoiceModelArrayTimer];
    }else{
        self.tableView.frame = CGRectMake(0, navHigh + kConferenceTopViewHeight, Screen_Width, Screen_Height - navHigh - kConferenceTopViewHeight);
    }
}

#pragma mark - navgationBarClick
- (void)rightDetailBtnClick
{
    CXDDXMeetingDetailInfoViewController * meetingDetailInfoViewControlle = [[CXDDXMeetingDetailInfoViewController alloc] initWithCXDDXVoiceMeetingDetailModel:self.model];
    [self.navigationController pushViewController:meetingDetailInfoViewControlle animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - 录音流程
// 录音按下
-(void)toolViewRecordBtnTouchDown
{
    [self pausePlayVoice];
    self.showCancleRecordImage = NO;
    _recordTipImageView.image = [UIImage imageNamed:@"newvoiceChatImage001"];
    _recordTipImageView.highlightedImage = [UIImage imageNamed:@"newvoiceChatImage001"];
#if TARGET_IPHONE_SIMULATOR
    [self.recordManager startRecording];
    self.recordTipImageView.hidden = NO;
#else
    if (!kHasRecordPermission) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有录音权限" message:@"您可以在“隐私设置”中开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self.recordManager startRecording];
    self.recordTipImageView.hidden = NO;
#endif
}

// 录音完毕
-(void)toolViewRecordBtnTouchUpInside
{
    [self.recordManager stopRecording];
    self.recordTipImageView.hidden = YES;
    [self continuePlayVoice];
}

// 录音取消
-(void)toolViewRecordBtnTouchUpOutside
{
    [self.recordManager cancelRecording];
    self.recordTipImageView.hidden = YES;
    [self continuePlayVoice];
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

// 发送语音
-(void)sendVoiceMessageWithPath:(NSString *)filePath length:(NSNumber *)len size:(NSNumber *)size{
    NSMutableDictionary * params = @{}.mutableCopy;
    NSData *voiceData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *soundName = [dateFormatter stringFromDate:[NSDate date]];
    SDUploadFileModel *model = [[SDUploadFileModel alloc] init];
    model.fileName = [NSString stringWithFormat:@"%@.spx", soundName];
    model.fileData = voiceData;
    model.mimeType = @"sound/amr";
    model.duration = [NSString stringWithFormat:@"%f", [len doubleValue]];
    [params setValue:self.model.vedioMeetModel.eid forKey:@"bid"];
    [params setValue:VAL_USERID forKey:@"ygId"];
    [params setValue:@(3) forKey:@"type"];
    [params setValue:len forKey:@"length"];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    NSDictionary *files = @{
                            @"files": @[model]
                            };
    [HttpTool multipartPostWithPath:[NSString stringWithFormat:@"%@vedioMeet/record/save",urlPrefix] params:params files:files success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            [weakSelf hideHud];
            [self getVoiceModelArrayTimer];
        }
        else{
            [weakSelf hideHud];
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        TTAlert(KNetworkFailRemind);
    }];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXDDXVoiceModel * model = self.voiceModelArray[indexPath.row];
    CXIMMessage *message = [self changeCXDDXVoiceModelToCXIMMessageWithCXDDXVoiceModel:model];
    NSString *ID;
    ID = [CXIDGVoiceMeetingSuperCellTableViewCell identifierForContentType:message.body.type];
    self.templateCell = [CXIDGVoiceMeetingSuperCellTableViewCell createCellForIdentifier:ID];
    self.templateCell.indexPath = indexPath;
    NSInteger compareTime = 0;
    if(indexPath.row == 0){
        compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
    }
    else{
        CXDDXVoiceModel * lastModel = self.voiceModelArray[indexPath.row - 1];
        CXIMMessage *lastMessage = [self changeCXDDXVoiceModelToCXIMMessageWithCXDDXVoiceModel:lastModel];
        compareTime = [lastMessage sendTime].integerValue;
    }
    self.templateCell.compareTime = compareTime;
    self.templateCell.tableView = tableView;
    self.templateCell.message = message;
    return self.templateCell.cellHeight + 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.voiceModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID;
    CXDDXVoiceModel * model = self.voiceModelArray[indexPath.row];
    CXIMMessage *message = [self changeCXDDXVoiceModelToCXIMMessageWithCXDDXVoiceModel:model];
    ID = [CXIDGVoiceMeetingSuperCellTableViewCell identifierForContentType:message.body.type];
    CXIDGVoiceMeetingSuperCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [CXIDGVoiceMeetingSuperCellTableViewCell createCellForIdentifier:ID];
    }
    cell.isNotNeedShowReadOrUnRead = NO;
    cell.indexPath = indexPath;
    NSInteger compareTime = 0;
    if(indexPath.row == 0){
        compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
    }
    else{
        CXDDXVoiceModel * lastModel = self.voiceModelArray[indexPath.row - 1];
        CXIMMessage *lastMessage = [self changeCXDDXVoiceModelToCXIMMessageWithCXDDXVoiceModel:lastModel];
        compareTime = [lastMessage sendTime].integerValue;
    }
    cell.compareTime = compareTime;
    cell.tableView = tableView;
    cell.message = message;
    self.cellHeights[indexPath] = @(cell.cellHeight);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self tableViewAllCellsRemoveAnimation];
    NSLog(@"点击了第%zd行",indexPath.row);
    [self selectMeetingMessageOnIndex:indexPath.row];
}

#pragma mark - 下载CXDDXVoiceModel
- (void)downloadFileWithCXDDXVoiceModel:(CXDDXVoiceModel *)voiceModel WithProgress:(void (^)(float))progressBlock completion:(void (^)(CXDDXVoiceModel *, NSError *))completionBlock {
    self.downloadingVoiceModel = voiceModel;
    self.progressBlock = progressBlock;
    self.completionBlock = completionBlock;
    if([self isFileExist]){
        if (self.completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionBlock(self.downloadingVoiceModel, nil);
            });
        }
    }else{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:voiceModel.content]];
        self.downloadTask = [session downloadTaskWithRequest:request];
        [self.downloadTask resume];
    }
}

#pragma mark - NSURLSessionDownloadDelegate
/** 下载完成 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // 文件名
    NSString *fileName = [NSString stringWithFormat:@"%zd.spx", [self.downloadingVoiceModel.eid integerValue]];
    // 文件路径
    NSString * filePath = [CXIM_VOICEMEETING_DIR stringByAppendingPathComponent:fileName];
    NSError *saveError;
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:&saveError];
    // 保存成功
    if (!saveError) {
        
    }
    if (self.completionBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completionBlock(self.downloadingVoiceModel, saveError);
        });
    }
}

/** 下载进度 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (self.progressBlock) {
        float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
        if (self.progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressBlock(progress);
            });
        }
    }
}

/** 断点续传 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
  
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        if (self.completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.completionBlock) self.completionBlock(self.downloadingVoiceModel, error);
            });
        }
    }
}

- (BOOL)isFileExist{
    // 文件名
    NSString *fileName = [NSString stringWithFormat:@"%zd.spx", [self.downloadingVoiceModel.eid integerValue]];
    // 文件路径
    NSString * filePath = [CXIM_VOICEMEETING_DIR stringByAppendingPathComponent:fileName];
    BOOL isDir;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
    return exist && (!isDir);
}

#pragma mark - PlayingDelegate
- (void)playingStoped
{
    NSLog(@"%zd播放结束",self.playingIndex);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self tableViewAllCellsRemoveAnimation];
        if(!self.isCancleEnd){
            self.playingIndex++;
            [self loopPlayMeetingMessageFromIndex:self.playingIndex];
        }
    });
}

@end
