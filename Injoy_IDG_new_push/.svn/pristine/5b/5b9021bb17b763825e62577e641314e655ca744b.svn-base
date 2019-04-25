//
//  CXProjectCollaborationFormViewController.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/31.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXProjectCollaborationFormViewController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXERPAnnexView.h"
#import "HttpTool.h"
#import "CXFormHeaderView.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "CXProjectCollaborationMessageModel.h"
#import "CXProjectCollaborationChattingCell.h"
#import "SDPermissionsDetectionUtils.h"
#import "IBActionSheet.h"
#import <AVFoundation/AVFoundation.h>

// 动画时长
#define kAnimationDuration .25

//toolView的高度
#define kToolViewHeight 45

#define kTableHeaderViewHeight 40.0

#define kHasRecordPermission ([SDPermissionsDetectionUtils checkCanRecordFree])

//13位时间戳
#define kTimestamp ((long long)([[NSDate date] timeIntervalSince1970] * 1000))

// 公共
#define CXIM_DOCUMENT_DIR NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

/** 项目协同语音目录 */
#define CXIM_PROJECT_COLLABORATION_VOICE_DIR [CXIM_DOCUMENT_DIR stringByAppendingPathComponent:@"ProjectCollaborationVoice"]

/** 项目协同本地语音目录 */
#define CXIM_PROJECT_COLLABORATION_LOCAL_VOICE_DIR @"/Documents/ProjectCollaborationVoice/"

/** 项目协同图片目录 */
#define CXIM_PROJECT_COLLABORATION_PICTURE_DIR [CXIM_DOCUMENT_DIR stringByAppendingPathComponent:@"ProjectCollaborationPicture"]

/** 项目协同图片目录 */
#define CXIM_PROJECT_COLLABORATION_LOCAL_PICTURE_DIR @"/Documents/ProjectCollaborationPicture/"

/** 项目协同图片发送目录 */
#define CXIM_PROJECT_COLLABORATION_PICTURE_SEND_DIR [CXIM_DOCUMENT_DIR stringByAppendingPathComponent:@"ProjectCollaborationPictureSend"]

#define kGetMessageModelArrayInterval 3.0

/** 图片压缩率 0(most)..1(least) */
#define CXIM_IMAGE_COMPRESS_RATE .5

#define kRecordTipImageViewWidth 150.0

@interface CXProjectCollaborationFormViewController ()<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,RecordingDelegate,NSURLSessionDownloadDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,IBActionSheetDelegate>

/** topView */
@property(strong, nonatomic) CXFormHeaderView *topView;
/** scrollContentView */
@property(strong, nonatomic) UIScrollView *scrollContentView;
/** 邀约项目 */
@property(strong, nonatomic) CXEditLabel *yyxmLabel;
/** 协作人 */
@property(strong, nonatomic) CXEditLabel *xzrLabel;
/** 项目说明 */
@property(strong, nonatomic) CXEditLabel *xmsmLabel;
/** 项目协同的tableView的头部View */
@property(strong, nonatomic) UIView *headerView;
/** 聊天tableView */
@property(strong, nonatomic) UITableView *tableView;
/** 是聊天键盘弹起 */
@property (nonatomic,assign) BOOL isTalkTextView;
/** 文本框底部线条 */
@property (nonatomic,strong) UIView *textViewBottomLine;
/** 底部操作栏 */
@property (nonatomic,strong) UIView *toolView;
/** 底部操作栏左边按钮（麦克风/键盘） */
@property (nonatomic,strong) UIButton *toolViewVoiceBtn;
/** 文本输入 */
@property (nonatomic,strong) UITextView *textView;
/** 麦克风录音 */ 
@property (nonatomic,strong) UIButton *toolViewRecordBtn;
/** 图片按钮 */
@property (nonatomic,strong) UIButton *toolViewImageBtn;
/** 录音提示 */ 
@property (nonatomic,strong) UIImageView *recordTipImageView;
/** 录音机 */ 
@property (nonatomic,strong) RecorderManager *recordManager;
/** 自动获取消息的定时器 */
@property (nonatomic, strong) NSTimer * getMessageModelArrayTimer;
/** 是否显示上滑取消图片 */
@property (nonatomic) BOOL showCancleRecordImage;
/** 消息数组 */
@property (nonatomic, strong) NSMutableArray<CXProjectCollaborationMessageModel *> * messagesArray;
/** downloadTask */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/** completionBlock */
@property(nonatomic, copy) void(^completionBlock)(CXProjectCollaborationMessageModel *messageModel, NSError *error);
/** progressBlock */
@property(nonatomic, copy) void(^progressBlock)(float);
/** 正在下载的voiceModel */
@property (nonatomic, strong) CXProjectCollaborationMessageModel * downloadingVoiceModel;
/** 图片选择器 */
@property (nonatomic,strong) UIImagePickerController *imagePicker;
/** cellHeights */
@property (nonatomic,strong) NSMutableDictionary *cellHeights;
/** 模板cell */
@property (nonatomic, strong) CXProjectCollaborationChattingCell *templateCell;

@end

@implementation CXProjectCollaborationFormViewController

#pragma mark - LazyLoad
- (NSMutableDictionary *)cellHeights{
    if (_cellHeights == nil) {
        _cellHeights = [NSMutableDictionary dictionary];
    }
    return _cellHeights;
}

- (CXProjectCollaborationFormModel *)model {
    if (!_model) {
        _model = [[CXProjectCollaborationFormModel alloc] init];
    }
    return _model;
}

- (CXFormHeaderView *)topView {
    if (!_topView) {
        _topView = [[CXFormHeaderView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIScrollView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        [_scrollContentView flashScrollIndicators];
        // 是否同时运动,lock
        _scrollContentView.directionalLockEnabled = YES;
        _scrollContentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_scrollContentView];
    }
    return _scrollContentView;
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

- (UIView *)toolView{
    if(!_toolView){
        // 底部操作栏
        _toolView = [[UIView alloc] init];
        _toolView.backgroundColor = [UIColor whiteColor];
        _toolView.hidden = NO;
        [self.view addSubview:_toolView];
        
        UIView * topLineView = [[UIView alloc] init];
        topLineView.frame = CGRectMake(0, 0, Screen_Width, 0.5);
        topLineView.backgroundColor = [UIColor lightGrayColor];
        [_toolView addSubview:topLineView];
        
        // 麦克风|键盘输入
        self.toolViewVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.toolViewVoiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [self.toolViewVoiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [self.toolViewVoiceBtn addTarget:self action:@selector(microphoneTapped) forControlEvents:UIControlEventTouchUpInside];
        self.toolViewVoiceBtn.frame = CGRectMake(8, (kToolViewHeight - 30)/2, 30, 30);
        [_toolView addSubview:self.toolViewVoiceBtn];
        
        // 图片
        self.toolViewImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.toolViewImageBtn setImage:[UIImage imageNamed:@"annex_image"] forState:UIControlStateNormal];
        [self.toolViewImageBtn setImage:[UIImage imageNamed:@"annex_image"] forState:UIControlStateSelected];
        [self.toolViewImageBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.toolViewImageBtn.hidden = NO;
        [_toolView addSubview:self.toolViewImageBtn];
        [self.toolViewImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.toolView).offset(-8);
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
        [_toolView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolView).offset(5);
            make.bottom.equalTo(self.toolView).offset(-5);
            make.leading.equalTo(self.toolViewVoiceBtn.mas_trailing).offset(5);
            make.trailing.equalTo(self.toolViewImageBtn.mas_leading).offset(-5);
        }];
        
        // 底部线条
        self.textViewBottomLine = [[UIView alloc] init];
        self.textViewBottomLine.backgroundColor = kColorWithRGB(174, 174, 174);
        [_toolView addSubview:self.textViewBottomLine];
        [self.textViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.leading.equalTo(self.textView);
            make.top.equalTo(self.textView.mas_bottom);
            make.trailing.equalTo(self.toolViewImageBtn).offset(-35);
        }];
    }
    return _toolView;
}

- (RecorderManager *)recordManager{
    if (_recordManager == nil) {
        _recordManager = [RecorderManager sharedManager];
        _recordManager.delegate = self;
    }
    return _recordManager;
}

- (NSTimer *)getMessageModelArrayTimer {
    if (_getMessageModelArrayTimer == nil) {
        _getMessageModelArrayTimer = [NSTimer scheduledTimerWithTimeInterval:kGetMessageModelArrayInterval target:self selector:@selector(getMessageModelArrayTimerFire) userInfo:nil repeats:YES];
        _getMessageModelArrayTimer.fireDate = [NSDate distantPast];
    }
    return _getMessageModelArrayTimer;
}

- (NSMutableArray<CXProjectCollaborationMessageModel *> *)messagesArray{
    if (_messagesArray == nil) {
        _messagesArray = @[].mutableCopy;
    }
    return _messagesArray;
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UITableView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIView * topLineView = [[UIView alloc] init];
        topLineView.frame = CGRectMake(0, 0, Screen_Width, 2);
        topLineView.backgroundColor = RGBACOLOR(218.0, 218.0, 218.0, 1.0);
        [_headerView addSubview:topLineView];
        
        UIView * middleLineView = [[UIView alloc] init];
        middleLineView.frame = CGRectMake(0, 10, Screen_Width, 2);
        middleLineView.backgroundColor = RGBACOLOR(218.0, 218.0, 218.0, 1.0);
        [_headerView addSubview:middleLineView];
        
        UILabel * xmxtLabel = [[UILabel alloc] init];
        xmxtLabel.frame = CGRectMake(0, 12, Screen_Width, kTableHeaderViewHeight - 12);
        xmxtLabel.backgroundColor = RGBACOLOR(242.0, 241.0, 247.0, 1.0);
        xmxtLabel.font = [UIFont systemFontOfSize:14.0];
        xmxtLabel.textAlignment = NSTextAlignmentCenter;
        xmxtLabel.text = @"项目协同";
        xmxtLabel.textColor = [UIColor blackColor];
        [_headerView addSubview:xmxtLabel];
        
        UIView * bottomLineView = [[UIView alloc] init];
        bottomLineView.frame = CGRectMake(0, kTableHeaderViewHeight - 1, Screen_Width, 1);
        bottomLineView.backgroundColor = RGBACOLOR(218.0, 218.0, 218.0, 1.0);
        [_headerView addSubview:bottomLineView];
        
        _headerView.userInteractionEnabled = NO;
        
        [self.view addSubview:_headerView];
    }
    return _headerView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        [self.view insertSubview:_tableView belowSubview:[self headerView]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UIImagePickerController *)imagePicker{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
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

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showCancleRecordImage = NO;
    
    // 创建目录
    BOOL success = YES;
    success = success && [self createDirectory:CXIM_PROJECT_COLLABORATION_VOICE_DIR];
    success = success && [self createDirectory:CXIM_PROJECT_COLLABORATION_PICTURE_DIR];
    success = success && [self createDirectory:CXIM_PROJECT_COLLABORATION_PICTURE_SEND_DIR];
    NSAssert(success, @"create directory failed");
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = kBackgroundColor;
    
    if (self.formType == CXFormTypeModify) {
        [self findDetailRequest];
    }else{
        [self setUpNavBar];
        [self setUpTopView];
        [self setUpScrollView];
    }
    
    [self addBottomBar];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.downloadTask) {
        NSLog(@"cancel download task");
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
    [self closeGetMessageModelArrayTimer];
    [[PlayerManager sharedManager] stopPlaying];
    [PlayerManager sharedManager].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [self closeGetMessageModelArrayTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 内部方法
- (BOOL)hasHadCXProjectCollaborationMessageModel:(CXProjectCollaborationMessageModel *)model
{
    if(self.messagesArray && [self.messagesArray count] > 0){
        for(CXProjectCollaborationMessageModel * messageModel in self.messagesArray){
            if([messageModel.eid integerValue] == [model.eid integerValue]){
                return YES;
            }
        }
    }
    return NO;
}

- (void)closeGetMessageModelArrayTimer
{
    [self.getMessageModelArrayTimer invalidate];
    self.getMessageModelArrayTimer = nil;
}

- (BOOL)createDirectory:(NSString *)directory {
    BOOL isDir = false;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDir];
    if (!(isDir && isDirExist)) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

// 点击麦克风按钮
-(void)microphoneTapped
{
    self.toolViewVoiceBtn.selected = !self.toolViewVoiceBtn.selected;
    if (self.toolViewVoiceBtn.selected) {
        [self.textView resignFirstResponder];
        [self setVoiceInputOn:YES];
    }
    else{
        // 文本模式
        [self setVoiceInputOn:NO];
        [self.textView becomeFirstResponder];
    }
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kTableViewLineColor;
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)rightItemEvent {
    [self saveProjectCollaborationRequest];
}

- (void)setUpDetail {
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserId:[self.model.ygId integerValue]];
    self.topView.avatar = userModel.icon;
    self.topView.name = userModel.name;
    self.topView.dept = [NSString stringWithFormat:@"%@ %@",self.model.ygDeptName,self.model.ygJob];
    self.topView.date = self.model.createTime;
    self.topView.number = self.model.serNo;
    
    self.yyxmLabel.content = self.model.title;
    self.yyxmLabel.allowEditing = YES;
    self.yyxmLabel.showDropdown = NO;
    
    self.xzrLabel.detailCCData = self.model.ccArray;
    self.xzrLabel.allowEditing = NO;
    self.xzrLabel.showDropdown = NO;
    if(self.model.ccArray && [self.model.ccArray count] > 0){
        NSMutableArray * selectedCCUsers = [[NSMutableArray alloc] initWithCapacity:0];
        for(CXCCUserModel * user in self.model.ccArray){
            CXUserModel * userModel = [[CXUserModel alloc] init];
            userModel.eid = [user.userId integerValue];
            userModel.name = user.userName;
            userModel.imAccount = user.imAccount;
            [selectedCCUsers addObject:userModel];
        }
        self.xzrLabel.detailCCData = selectedCCUsers;
    }
    
    self.xmsmLabel.allowEditing = YES;
    self.xmsmLabel.showDropdown = NO;
    self.xmsmLabel.content = self.model.remark;
    
    if([self.model.ygId integerValue] != [VAL_USERID integerValue]){
        self.yyxmLabel.allowEditing = NO;
        self.yyxmLabel.showDropdown = NO;
        
        self.xzrLabel.allowEditing = NO;
        self.xzrLabel.showDropdown = NO;
        
        self.xmsmLabel.allowEditing = NO;
        self.xmsmLabel.showDropdown = NO;
    }
}

- (void)sortMessageArray
{
    if(self.messagesArray && [self.messagesArray count] > 0){
        NSComparator cmptr = ^(CXProjectCollaborationMessageModel * message1, CXProjectCollaborationMessageModel * message2){
            if ([message1.eid integerValue] > [message2.eid integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([message1.eid integerValue] < [message2.eid integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        self.messagesArray = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:self.messagesArray] sortedArrayUsingComparator:cmptr]];
    }
}

- (NSArray<CXProjectCollaborationMessageModel *> *)sortMessageArrayWithArray:(NSArray<CXProjectCollaborationMessageModel *> *)array
{
    if(array && [array count] > 0){
        NSComparator cmptr = ^(CXProjectCollaborationMessageModel * message1, CXProjectCollaborationMessageModel * message2){
            if ([message1.eid integerValue] > [message2.eid integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([message1.eid integerValue] < [message2.eid integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray * sortedArray = [[NSArray arrayWithArray:array] sortedArrayUsingComparator:cmptr].copy;
        return sortedArray;
    }
    return array;
}

- (CXIMMessage *)changeCXProjectCollaborationMessageModelToCXIMMessageWithCXProjectCollaborationMessageModel:(CXProjectCollaborationMessageModel *)model
{
    CXIMMessage * message = [[CXIMMessage alloc] init];
    message.type = CXIMProtocolTypeGroupChat;
    message.ID = model.eid.stringValue;
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsContactsDicWithUserId:[model.ygId integerValue]];
    message.sender = userModel.imAccount;
    message.receiver = [CXIMService sharedInstance].chatManager.currentAccount;
    if([model.type integerValue] == 1){
        CXIMTextMessageBody *body = [[CXIMTextMessageBody alloc] init];
        body.textContent = model.content;
        message.body = body;
    }else if([model.type integerValue] == 2){
        // 创建对象
        CXIMImageMessageBody *body = [[CXIMImageMessageBody alloc] init];
        NSString * fileName = [NSString stringWithFormat:@"%zd.jpg", [model.eid integerValue]];
        NSString * filePath = [CXIM_PROJECT_COLLABORATION_PICTURE_DIR stringByAppendingPathComponent:fileName];
        NSString * localFilePath = [CXIM_PROJECT_COLLABORATION_LOCAL_PICTURE_DIR stringByAppendingPathComponent:fileName];
        body.localUrl = localFilePath;
        body.name = fileName;
        body.length = @(0);
        UIImage * image = [UIImage imageWithContentsOfFile:filePath];
        body.size = @(0);
        body.imageDimensions = [CXIMDimensionsInfo infoWithWidth:image.size.width height:image.size.height];
        message.body = body;
    }else if([model.type integerValue] == 3){
        CXIMVoiceMessageBody *body = [[CXIMVoiceMessageBody alloc] init];
        NSString * fileName = [NSString stringWithFormat:@"%zd.spx", [model.eid integerValue]];
        NSString * filePath = [CXIM_PROJECT_COLLABORATION_VOICE_DIR stringByAppendingPathComponent:fileName];
        NSString * localFilePath = [CXIM_PROJECT_COLLABORATION_LOCAL_VOICE_DIR stringByAppendingPathComponent:fileName];
        body.localUrl = localFilePath;
        body.name = [filePath lastPathComponent];
        body.length = model.length;
        NSNumber *size = @([[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize]);
        body.size = size;
        message.body = body;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *lastDate = [formatter dateFromString:model.createTime];
    long firstStamp = ([lastDate timeIntervalSince1970] * 1000);
    message.sendTime = @(firstStamp);
    message.status = CXIMMessageStatusSendSuccess;
    message.readFlag = CXIMMessageReadFlagReaded;
    message.openFlag = CXIMMessageReadFlagReaded;
    message.readAsk = CXIMMessageReadFlagReaded;
    return message;
}

- (void)scrollToBottom
{
    NSInteger row = [self tableView:self.tableView numberOfRowsInSection:0];
    if (row > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messagesArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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

- (void)imageBtnClick
{
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
    
    IBActionSheet * sendTypeActionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机", @"相册", nil];
    [sendTypeActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)collapseAll{
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.view];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
    if(point.y > CGRectGetMinY(_toolView.frame)){
        [self.view bringSubviewToFront:_toolView];
        self.isTalkTextView = YES;
    }else{
        [self collapseAll];
       self.isTalkTextView = NO;
    }
}

#pragma mark - setUpUI
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"项目协同"];
    
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    if(self.formType == CXFormTypeCreate || (self.formType == CXFormTypeModify && self.model && [self.model.ygId integerValue] == [VAL_USERID integerValue])){
        [rootTopView setUpRightBarItemTitle:@"提交"
                                  addTarget:self
                                     action:@selector(rightItemEvent)];
    }
}

- (void)setUpTopView {
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo([self getRootTopView].mas_bottom);
        make.height.mas_equalTo(CXFormHeaderViewHeight);
    }];
}

- (void)setUpScrollView {
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).mas_offset(navHigh);
        make.top.equalTo([self topView].mas_bottom).offset(5.f);
    }];
    
    BOOL isDetail = self.formType == CXFormTypeDetail;
    /// 左边距
    CGFloat leftMargin = 5.f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineBoldHeight = 2.f;
    CGFloat lineWidth = Screen_Width;
    
    @weakify(self);
    
    // 邀约项目
    _yyxmLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, 0.f, Screen_Width, viewHeight)];
    _yyxmLabel.title = @"邀约项目：";
    _yyxmLabel.allowEditing = !isDetail;
    _yyxmLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_yyxmLabel];
    _yyxmLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.model.title = editLabel.content;
    };
    
    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = CGRectMake(0.f, _yyxmLabel.bottom, lineWidth, lineHeight);
    
    // 协作人
    _xzrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width, viewHeight)];
    _xzrLabel.title = @"协作人：";
    _xzrLabel.allowEditing = !isDetail;
    _xzrLabel.inputType = CXEditLabelInputTypeXZR;
    [self.scrollContentView addSubview:_xzrLabel];
    _xzrLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for(CXUserModel * selectMember in editLabel.selectedCCUsers){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:@(selectMember.eid) forKey:@"eid"];
            [dic setValue:selectMember.name forKey:@"name"];
            [dic setValue:selectMember.imAccount forKey:@"imAccount"];
            [dataArray addObject:dic];
        }
        NSData *receiveData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:0];
        self.model.cc = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    };
    
    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = CGRectMake(0.f, _xzrLabel.bottom, lineWidth, lineBoldHeight);
    
    
    // 项目说明
    _xmsmLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight)];
    _xmsmLabel.allowEditing = !isDetail;
    _xmsmLabel.title = @"项目说明：";
    _xmsmLabel.scale = YES;
    _xmsmLabel.numberOfLines = 0;
    [self.scrollContentView addSubview:_xmsmLabel];
    _xmsmLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.model.remark = editLabel.content;
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, self.xmsmLabel.bottom);
    };
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _xmsmLabel.bottom);
    
}

- (void)addMessageLsitTable{
    self.headerView.frame = CGRectMake(0, Screen_Height/2 + navHigh, Screen_Width, kTableHeaderViewHeight);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), Screen_Width, Screen_Height - CGRectGetMaxY(self.headerView.frame) - kToolViewHeight);
    [self getMessageModelArrayTimer];
}

//添加BottomBar
-(void)addBottomBar
{
    if (self.formType == CXFormTypeModify) {
        self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight, Screen_Width, kToolViewHeight);
        self.toolView.hidden = NO;
    }else{
        self.toolView.hidden = YES;
    }
}

#pragma mark - 键盘伸缩通知
-(void)keyboardWillShow:(NSNotification *)aNotification{
    if(self.isTalkTextView){
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGFloat height = [aValue CGRectValue].size.height;
        self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight - height, Screen_Width, kToolViewHeight);
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }else{
        [self collapseAll];
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    self.textView.inputView = nil;
    self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight, Screen_Width, kToolViewHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self sendTextMessage];
        return NO;
    }
    return YES;
}

#pragma mark - Request
- (void)saveProjectCollaborationRequest {
    
    if (!self.model.title || ![self.model.title length]) {
        MAKE_TOAST_V(@"邀约项目不能为空");
        return;
    }
    if (!self.model.cc || ![self.model.cc length]) {
        MAKE_TOAST_V(@"请选择协作人");
        return;
    }
    if (!self.model.remark || ![self.model.remark length]) {
        MAKE_TOAST_V(@"项目说明不能为空");
        return;
    }
    
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT];
    self.model.ygId = userModel.userId;
    self.model.ygName = userModel.name;
    self.model.ygDeptId = userModel.deptId;
    self.model.ygDeptName = userModel.deptName;
    self.model.ygJob = userModel.job;
    NSMutableDictionary *param = [self.model yy_modelToJSONObject];
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@project/save", urlPrefix];
    HUD_SHOW(nil);
    [HttpTool postWithPath:url params:param success:^(id JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            TTAlert(@"提交成功!");
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@project/detail/%zd", urlPrefix,[self.model.eid integerValue]];
    HUD_SHOW(nil);
    [HttpTool getWithPath:url params:nil success:^(id JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            self.model = [CXProjectCollaborationFormModel yy_modelWithDictionary:JSON[@"data"][@"project"]];
            self.model.ccArray = [NSArray yy_modelArrayWithClass:CXCCUserModel.class json:JSON[@"data"][@"ccList"]];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for(CXUserModel * selectMember in self.model.ccArray){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:@(selectMember.userId) forKey:@"eid"];
                [dic setValue:selectMember.userName forKey:@"name"];
                [dataArray addObject:dic];
            }
            NSData *receiveData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:0];
            self.model.cc = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",self.model);
            
            NSString *url = [NSString stringWithFormat:@"%@project/record/list/%zd/all", urlPrefix,[self.model.eid integerValue]];
            NSMutableDictionary * params = @{}.mutableCopy;
            [params setValue:self.model.eid forKey:@"bid"];
            __weak __typeof(self)weakSelf = self;
            [self showHudInView:self.view hint:nil];
            [HttpTool postWithPath:url params:params success:^(id JSON) {
                if ([JSON[@"status"] integerValue] == 200) {
                    self.messagesArray = [NSArray yy_modelArrayWithClass:CXProjectCollaborationMessageModel.class json:JSON[@"data"]].mutableCopy;
                    [self sortMessageArray];
                    [self downLoadMessageWithIndex:0];
                    [weakSelf hideHud];
                }else{
                    [weakSelf hideHud];
                    TTAlert(JSON[@"msg"]);
                }
            } failure:^(NSError *error) {
                [weakSelf hideHud];
                CXAlert(KNetworkFailRemind);
            }];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)downLoadMessageWithIndex:(NSInteger)newIndex
{
    __weak __typeof(self)weakSelf = self;
    if (self.HUD == nil) {
        [self showHudInView:self.view hint:@"正在加载历史数据..."];
    }
    if(self.messagesArray && [self.messagesArray count] > 0){
        __block NSInteger index;
        if(newIndex){
            index = newIndex;
        }else{
            index = 0;
        }
        if([self.messagesArray[index].type integerValue] == 1){
            if([self.messagesArray[index].eid integerValue] == [[self.messagesArray lastObject].eid integerValue]){
                [self setUpNavBar];
                [self setUpTopView];
                [self setUpScrollView];
                [self setUpDetail];
                [self addMessageLsitTable];
                [weakSelf hideHud];
                return;
            }
            index++;
            [self downLoadMessageWithIndex:index];
        }else{
            [self downloadFileWithCXProjectCollaborationMessageModel:self.messagesArray[index] WithProgress:^(float progress) {
                
            } completion:^(CXProjectCollaborationMessageModel * messageModel, NSError * error) {
                index++;
                if([messageModel.eid integerValue] == [[self.messagesArray lastObject].eid integerValue]){
                    [self setUpNavBar];
                    [self setUpTopView];
                    [self setUpScrollView];
                    [self setUpDetail];
                    [self addMessageLsitTable];
                    [weakSelf hideHud];
                    return;
                }
                [self downLoadMessageWithIndex:index];
            }];
        }
    }else{
        [self setUpNavBar];
        [self setUpTopView];
        [self setUpScrollView];
        [self setUpDetail];
        [self getMessageModelArrayTimer];
        [weakSelf hideHud];
    }
}

- (void)getMessageModelArrayTimerFire
{
    NSString *url = [NSString stringWithFormat:@"%@project/record/list/%zd/forward", urlPrefix,[self.model.eid integerValue]];
    NSMutableDictionary * params = @{}.mutableCopy;
    [params setValue:self.model.eid forKey:@"bid"];
    if(self.messagesArray && [self.messagesArray count] > 0){
        [self sortMessageArray];
        [params setValue:[self.messagesArray lastObject].eid forKey:@"limitId"];
    }
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            NSArray * array = [NSArray yy_modelArrayWithClass:CXProjectCollaborationMessageModel.class json:JSON[@"data"][@"data"]].copy;
            NSArray<CXProjectCollaborationMessageModel *> * sortedArray = [self sortMessageArrayWithArray:array];
            [self sortMessageArray];
            NSInteger i = 0;
            for (; i < [sortedArray count]; i++) {
                [self addMessageLsitTable];
                if([sortedArray[i].type integerValue] == 1){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(![self hasHadCXProjectCollaborationMessageModel:sortedArray[i]]){
                            [self.messagesArray addObject:sortedArray[i]];
                            [self sortMessageArray];
                            [self.tableView reloadData];
                            [self scrollToBottom];
                        }
                    });
                }else{
                    [self downloadFileWithCXProjectCollaborationMessageModel:sortedArray[i] WithProgress:^(float progress) {
                        
                    } completion:^(CXProjectCollaborationMessageModel * messageModel, NSError * error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(![self hasHadCXProjectCollaborationMessageModel:sortedArray[i]]){
                                [self.messagesArray addObject:sortedArray[i]];
                                [self sortMessageArray];
                                [self.tableView reloadData];
                                [self scrollToBottom];
                            }
                        });
                    }];
                }
            }
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

#pragma mark - sendMessages
// 发送文本消息
-(void)sendTextMessage{
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length <= 0) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@sensitive/check", urlPrefix];
    NSMutableDictionary * params = @{}.mutableCopy;
    [params setValue:text forKey:@"name"];
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            [self sendTextMessageWithText:JSON[@"data"]];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

// 发送文字
-(void)sendTextMessageWithText:(NSString *)text{
    NSMutableDictionary * params = @{}.mutableCopy;
    [params setValue:self.model.eid forKey:@"bid"];
    [params setValue:VAL_USERID forKey:@"ygId"];
    [params setValue:@(1) forKey:@"type"];
    [params setValue:text forKey:@"content"];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    [HttpTool multipartPostWithPath:[NSString stringWithFormat:@"%@project/record/save",urlPrefix] params:params files:nil success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            [weakSelf hideHud];
            self.textView.text = @"";
        }
        else{
            [weakSelf hideHud];
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        TTAlert(KNetworkFailRemind);
    }];
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
    [params setValue:self.model.eid forKey:@"bid"];
    [params setValue:VAL_USERID forKey:@"ygId"];
    [params setValue:@(3) forKey:@"type"];
    [params setValue:len forKey:@"length"];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    NSDictionary *files = @{
                            @"files": @[model]
                            };
    [HttpTool multipartPostWithPath:[NSString stringWithFormat:@"%@project/record/save",urlPrefix] params:params files:files success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            [weakSelf hideHud];
        }
        else{
            [weakSelf hideHud];
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        TTAlert(KNetworkFailRemind);
    }];
}

// 发送图片
-(void)sendImageMessageWithImage:(UIImage *)image{
    // 保存图片
    NSData *imageData = UIImageJPEGRepresentation(image, CXIM_IMAGE_COMPRESS_RATE);
    NSString *fileName = [NSString stringWithFormat:@"%lld.jpg", kTimestamp];
    NSString *localURL = [CXIM_PROJECT_COLLABORATION_PICTURE_SEND_DIR stringByAppendingPathComponent:fileName];
    [imageData writeToFile:localURL atomically:YES];
    
    NSMutableDictionary * params = @{}.mutableCopy;
    NSData *picData = [[NSData alloc] initWithContentsOfFile:localURL];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *soundName = [dateFormatter stringFromDate:[NSDate date]];
    SDUploadFileModel *model = [[SDUploadFileModel alloc] init];
    model.fileName = [NSString stringWithFormat:@"%@.jpg", soundName];
    model.fileData = picData;
    model.mimeType = @"image/jpg";
    [params setValue:self.model.eid forKey:@"bid"];
    [params setValue:VAL_USERID forKey:@"ygId"];
    [params setValue:@(2) forKey:@"type"];
    [params setValue:@(image.size.width) forKey:@"width"];
    [params setValue:@(image.size.height) forKey:@"height"];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    NSDictionary *files = @{
                            @"fileShow": @[model]
                            };
    [HttpTool multipartPostWithPath:[NSString stringWithFormat:@"%@project/record/save",urlPrefix] params:params files:files success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            [weakSelf hideHud];
            [self getMessageModelArrayTimer];
        }
        else{
            [weakSelf hideHud];
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        TTAlert(KNetworkFailRemind);
    }];
}

#pragma mark - 下载CXProjectCollaborationMessageModel
- (void)downloadFileWithCXProjectCollaborationMessageModel:(CXProjectCollaborationMessageModel *)voiceModel WithProgress:(void (^)(float))progressBlock completion:(void (^)(CXProjectCollaborationMessageModel *, NSError *))completionBlock {
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
    NSString *fileName;
    // 文件路径
    NSString * filePath;
    if([self.downloadingVoiceModel.type integerValue] == 3){
        fileName = [NSString stringWithFormat:@"%zd.spx", [self.downloadingVoiceModel.eid integerValue]];
        filePath = [CXIM_PROJECT_COLLABORATION_VOICE_DIR stringByAppendingPathComponent:fileName];
    }else if([self.downloadingVoiceModel.type integerValue] == 2){
        fileName = [NSString stringWithFormat:@"%zd.jpg", [self.downloadingVoiceModel.eid integerValue]];
        filePath = [CXIM_PROJECT_COLLABORATION_PICTURE_DIR stringByAppendingPathComponent:fileName];
    }
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
    NSString *fileName;
    // 文件路径
    NSString * filePath;
    if([self.downloadingVoiceModel.type integerValue] == 3){
        fileName = [NSString stringWithFormat:@"%zd.spx", [self.downloadingVoiceModel.eid integerValue]];
        filePath = [CXIM_PROJECT_COLLABORATION_VOICE_DIR stringByAppendingPathComponent:fileName];
    }else if([self.downloadingVoiceModel.type integerValue] == 2){
        fileName = [NSString stringWithFormat:@"%zd.jpg", [self.downloadingVoiceModel.eid integerValue]];
        filePath = [CXIM_PROJECT_COLLABORATION_PICTURE_DIR stringByAppendingPathComponent:fileName];
    }
    BOOL isDir;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
    return exist && (!isDir);
}

#pragma mark - 录音流程
// 录音按下
-(void)toolViewRecordBtnTouchDown
{
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

#pragma mark 图片选择控制器 协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        //如果是图片
        if([mediaType isEqualToString:@"public.image"]){
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            [self sendImageMessageWithImage:image];
        }
    }];
}

#pragma mark - IBActionSheetDelegate
- (void)actionSheet:(IBActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
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

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXProjectCollaborationMessageModel * model = self.messagesArray[indexPath.row];
    CXIMMessage *message = [self changeCXProjectCollaborationMessageModelToCXIMMessageWithCXProjectCollaborationMessageModel:model];
    NSString *ID;
    ID = [CXProjectCollaborationChattingCell identifierForContentType:message.body.type];
    self.templateCell = [CXProjectCollaborationChattingCell createCellForIdentifier:ID];
    self.templateCell.indexPath = indexPath;
    NSInteger compareTime = 0;
    if(indexPath.row == 0){
        compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
    }
    else{
        CXProjectCollaborationMessageModel * lastModel = self.messagesArray[indexPath.row - 1];
        CXIMMessage *lastMessage = [self changeCXProjectCollaborationMessageModelToCXIMMessageWithCXProjectCollaborationMessageModel:lastModel];
        compareTime = [lastMessage sendTime].integerValue;
    }
    self.templateCell.compareTime = compareTime;
    self.templateCell.tableView = tableView;
    self.templateCell.message = message;
    return self.templateCell.cellHeight + 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID;
    CXProjectCollaborationMessageModel * model = self.messagesArray[indexPath.row];
    CXIMMessage *message = [self changeCXProjectCollaborationMessageModelToCXIMMessageWithCXProjectCollaborationMessageModel:model];
    ID = [CXProjectCollaborationChattingCell identifierForContentType:message.body.type];
    CXProjectCollaborationChattingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [CXProjectCollaborationChattingCell createCellForIdentifier:ID];
    }
    cell.isNotNeedShowReadOrUnRead = NO;
    cell.indexPath = indexPath;
    NSInteger compareTime = 0;
    if(indexPath.row == 0){
        compareTime = (NSInteger)([[NSDate date] timeIntervalSince1970] * 1000);
    }
    else{
        CXProjectCollaborationMessageModel * lastModel = self.messagesArray[indexPath.row - 1];
        CXIMMessage *lastMessage = [self changeCXProjectCollaborationMessageModelToCXIMMessageWithCXProjectCollaborationMessageModel:lastModel];
        compareTime = [lastMessage sendTime].integerValue;
    }
    cell.compareTime = compareTime;
    cell.tableView = tableView;
    cell.viewController = self;
    cell.job = [NSString stringWithFormat:@"%@ %@",model.deptName,model.job];
    cell.message = message;
    self.cellHeights[indexPath] = @(cell.cellHeight);
    return cell;
}

@end
