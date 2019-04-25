//
//  YunJingWorkCircleDetailViewController.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "YunJingWorkCircleDetailViewController.h"
#import "AppDelegate.h"
#import "CXIMHelper.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"
#import "UIView+Category.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXWorkCircleDetailModel.h"
#import "CXMyselfWorkTableViewCell.h"
#import "SDIMImageViewerController.h"
#import "PlayerManager.h"
#import "DXFaceView.h"
#import "CXWorkCircleDetailRecordModel.h"
#import "CXYunJingWorkCircleDetailTableViewCell.h"
#import "SDContactsDetailController.h"
#import "SDIMPersonInfomationViewController.h"
#import "CXLoaclDataManager.h"

#define kTableHeaderViewHeight 380
#define kWorkHeadImageLeftSpace 10
#define kWorkHeadImageTopSpace 15
#define kWorkHeadImageWidth 40.0
#define kNameLabelFontSize 15.0
#define kContentLabelFontSize 15.0
#define kContentLabelTopSpace 10.0
#define kTimeLabelFontSize 12.0
#define kTextColor [UIColor blackColor]
#define kWorkTimeLabelTopSpace 10
#define kWorkTimeLabelBottomSpace 15
#define kDetailImageWidthSpace 2.0
#define kDetailImageWidth (((Screen_Width - (CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace) - kWorkHeadImageLeftSpace) - 2*kDetailImageWidthSpace)/3)
#define kDetailVoiceImageWidth 25.0
#define kGrayBackGroundViewTextBottomSpace 15.0

#define kAudioNetWorkPath [NSString stringWithFormat:@"%@/Documents/NetWorkAudio", NSHomeDirectory()]

#define kOpinionBtnImageWidth 22
#define kOpinionBtnImageHeight 14
#define kOpinionBackGroundViewCornerRadius 5.0
#define kOpinionBackGroundViewWidth 208
#define kOpinionBackGroundViewHeight 33
#define kOpinionBackGroundViewSpace 1

#define kOpinionBackGroundViewImageLeftSpace 10
#define kOpinionBackGroundViewImageWidth 13
#define kOpinionBackGroundViewMiddleSpace 5
#define kOpinionBackGroundViewLabelFont kOpinionBackGroundViewImageWidth
#define kOpinionBackGroundViewLabelTextColor [UIColor whiteColor]
#define kOpinionBackGroundViewLineTopSpace 5

#define kSelfOpinionBackGroundViewWidth 64.0

// 表情键盘的高度
#define kHeightOfEmoji 200

// 动画时长
#define kAnimationDuration .25

//toolView的高度
#define kToolViewHeight 45

//toolViewFaceBtn的宽度
#define kToolViewFaceBtnWidth 30

//toolView的间隔
#define kToolViewSpace 10

#define kTextViewTopSpace 5

#define kTableFooterViewHeight 50.0

@interface YunJingWorkCircleDetailViewController ()<UITableViewDataSource, UITableViewDelegate,PlayingDelegate,DXFaceDelegate,UITextViewDelegate>

//导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView * tableHeaderView;

@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * nameBtn;

@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * moneyLabel;

@property (nonatomic, strong) CXWorkCircleDetailModel * detailModel;
//详情图片数组
@property (nonatomic, strong) NSMutableArray* detailImageArray;
//详情声音字典
@property (nonatomic, strong) NSMutableDictionary *detailVoiceDict;
//详情图片View的高度
@property (nonatomic) CGFloat detailImagesHeight;
//详情附件View的高度
@property (nonatomic) CGFloat detailVoiceAndAnnexViewHeight;
@property (nonatomic, strong) UIImageView * voiceImageView;

/*录音按钮，实现暂停播放的功能**/
@property (nonatomic,assign) BOOL isPlaySound;

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * opinionBackGroundView;
@property (nonatomic, strong) UIButton * opinionBtn;
@property (nonatomic, strong) UIView * bottomLineView;

@property (nonatomic, strong) UIImageView * agreeImageView;
@property (nonatomic, strong) UILabel * agreeLabel;
@property (nonatomic, strong) UIButton * agreeBtn;
@property (nonatomic, strong) UIView * firstLineView;

@property (nonatomic, strong) UIImageView * refuseImageView;
@property (nonatomic, strong) UILabel * refuseLabel;
@property (nonatomic, strong) UIButton * refuseBtn;
@property (nonatomic, strong) UIView * secondLineView;

@property (nonatomic, strong) UIImageView * commentImageView;
@property (nonatomic, strong) UILabel * commentLabel;
@property (nonatomic, strong) UIButton * commentBtn;

//表情的附加页面
@property (strong, nonatomic) DXFaceView *faceView;
// 文本框底部线条
@property (nonatomic,strong) UIView *textViewBottomLine;
// 表情
@property (nonatomic,strong) UIButton *toolViewFaceBtn;
// 底部操作栏
@property (nonatomic,strong) UIView *toolView;
// 文本输入
@property (nonatomic,strong) UITextView *textView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;


@end

@implementation YunJingWorkCircleDetailViewController

-(DXFaceView *)faceView{
    if (_faceView == nil) {
        _faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeightOfEmoji)];
        _faceView.delegate = self;
        self.faceView.backgroundColor = [UIColor lightGrayColor];
    }
    return _faceView;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isPlaySound = YES;
    
    self.detailImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.detailVoiceDict = [[NSMutableDictionary alloc] init];
    
    [self setupView];
}

- (void)setupView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserId:[self.model.userId integerValue]];
    
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"公司圈")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    self.tableHeaderView = [[UIView alloc] init];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    self.headImageView = [[UIImageView alloc]init];
    self.headImageView.frame = CGRectMake(kWorkHeadImageLeftSpace, kWorkHeadImageTopSpace, kWorkHeadImageWidth, kWorkHeadImageWidth);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[userModel.icon isKindOfClass:[NSNull class]]?@"":userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick)];
    [self.headImageView addGestureRecognizer:tap];
    self.headImageView.userInteractionEnabled = YES;
    [_tableHeaderView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:kNameLabelFontSize];
    _nameLabel.textColor = RGBACOLOR(91.0, 106.0, 140.0, 1.0);
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, kWorkHeadImageTopSpace, _nameLabel.size.width, kNameLabelFontSize);
    [_tableHeaderView addSubview:_nameLabel];
    
    _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nameBtn addTarget:self action:@selector(headImageViewClick) forControlEvents:UIControlEventTouchUpInside];
    _nameBtn.frame = _nameLabel.frame;
    [_tableHeaderView addSubview:_nameBtn];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:kContentLabelFontSize];
    _contentLabel.textColor = kTextColor;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = [NSString stringWithFormat:@"%@",self.detailModel.remark];
    CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(Screen_Width - (CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace) - kWorkHeadImageLeftSpace, LONG_MAX)];
    _contentLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + kContentLabelTopSpace, contentLabelSize.width, contentLabelSize.height);
    [_tableHeaderView addSubview:_contentLabel];
    
    self.detailImagesHeight = [self addDetailImages];
    
    self.detailVoiceAndAnnexViewHeight = [self addDetailVoiceAndAnnexView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
    _timeLabel.textColor = SDCellTimeColor;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.text = self.detailModel.createTime;
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, CGRectGetMaxY(_contentLabel.frame) + self.detailImagesHeight + self.detailVoiceAndAnnexViewHeight + kWorkTimeLabelTopSpace, _timeLabel.size.width, kTimeLabelFontSize);
    [_tableHeaderView addSubview:_timeLabel];
    
    _opinionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _opinionBtn.selected = NO;
    [_opinionBtn addTarget:self action:@selector(opinionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _opinionBtn.frame = CGRectMake(Screen_Width - kWorkHeadImageLeftSpace - kOpinionBtnImageWidth, CGRectGetMaxY(_contentLabel.frame) + self.detailImagesHeight + self.detailVoiceAndAnnexViewHeight + kWorkTimeLabelTopSpace - (kOpinionBtnImageHeight - kTimeLabelFontSize)/2, kOpinionBtnImageWidth, kOpinionBtnImageHeight);
    [_opinionBtn setBackgroundImage:[UIImage imageNamed:@"opinionBtnImage"] forState:UIControlStateNormal];
    [_opinionBtn setBackgroundImage:[UIImage imageNamed:@"opinionBtnImage"] forState:UIControlStateHighlighted];
    [_opinionBtn setBackgroundImage:[UIImage imageNamed:@"opinionBtnImage"] forState:UIControlStateSelected];
    [_tableHeaderView addSubview:_opinionBtn];
    
    _opinionBackGroundView = [[UIView alloc] init];
    _opinionBackGroundView.backgroundColor = RGBACOLOR(77.0, 82.0, 84.0, 1.0);
    _opinionBackGroundView.layer.cornerRadius = kOpinionBackGroundViewCornerRadius;
    _opinionBackGroundView.clipsToBounds = YES;
    _opinionBackGroundView.hidden = YES;
    _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kOpinionBackGroundViewWidth, CGRectGetMaxY(_contentLabel.frame) + self.detailImagesHeight + self.detailVoiceAndAnnexViewHeight + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
    [_tableHeaderView addSubview:_opinionBackGroundView];
    
    
    self.tableHeaderView.frame = CGRectMake(0, 0, Screen_Width, CGRectGetMaxY(_timeLabel.frame) + kWorkTimeLabelBottomSpace);
    
    UIView * tableFootView = [[UIView alloc] init];
    tableFootView.frame = CGRectMake(0, 0, Screen_Width, kTableFooterViewHeight);
    tableFootView.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = tableFootView;
    self.tableView.bounces = YES;
    
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = SDBackGroudColor;
    
    [self downloadData];
    
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(downloadData)];
    
    [self addBottomBar];
}

- (void)headImageViewClick
{
    SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsContactsDicWithUserId:[_model.userId integerValue]];
    pivc.imAccount = userModel.imAccount;
    pivc.canPopViewController = YES;
    [self.navigationController pushViewController:pivc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

//添加BottomBar
-(void)addBottomBar
{
    // 底部操作栏
    self.toolView = [[UIView alloc] init];
    self.toolView.backgroundColor = [UIColor whiteColor];
    self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight, Screen_Width, kToolViewHeight);
    self.toolView.hidden = YES;
    [self.view addSubview:self.toolView];
    
    // 表情
    self.toolViewFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toolViewFaceBtn setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    [self.toolViewFaceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
    [self.toolViewFaceBtn addTarget:self action:@selector(faceTapped) forControlEvents:UIControlEventTouchUpInside];
    self.toolViewFaceBtn.hidden = NO;
    self.toolViewFaceBtn.frame = CGRectMake(Screen_Width - kToolViewFaceBtnWidth - 5, (kToolViewHeight - kToolViewFaceBtnWidth)/2, kToolViewFaceBtnWidth, kToolViewFaceBtnWidth);
    //    [self.toolView addSubview:self.toolViewFaceBtn];
    
    // 输入框
    self.textView = [[UITextView alloc] init];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.frame = CGRectMake(kToolViewSpace, kTextViewTopSpace, Screen_Width - kToolViewSpace*2, kToolViewHeight - kTextViewTopSpace*2);
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 3.0;
    self.textView.text = @"评论";
    self.textView.textColor = [UIColor grayColor];
    [self.toolView addSubview:self.textView];
}

// 点击表情按钮
-(void)faceTapped
{
    self.toolViewFaceBtn.selected = !self.toolViewFaceBtn.selected;
    if (self.toolViewFaceBtn.selected) {
        // 切换文本输入
        self.textView.hidden = self.textViewBottomLine.hidden = NO;
        self.textView.inputView = self.faceView;
    }
    else{
        self.textView.inputView = nil;
    }
    [self.textView reloadInputViews];
    [self.textView becomeFirstResponder];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 键盘伸缩通知
-(void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [aValue CGRectValue].size.height;
    self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight - height, Screen_Width, kToolViewHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    self.textView.inputView = nil;
    self.toolViewFaceBtn.selected = NO;
    self.toolView.frame = CGRectMake(0, Screen_Height - kToolViewHeight, Screen_Width, kToolViewHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)downloadData
{
    NSString *url = [NSString stringWithFormat:@"%@workRecord/findDetail/%zd",urlPrefix,[self.model.eid integerValue]];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [HttpTool multipartPostFileDataWithPath:url params:nil dataAry:nil success:^(id JSON) {
        [weakSelf hideHud];
        [_tableView.legendHeader endRefreshing];
        [self.dataSource removeAllObjects];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            self.model.userId = JSON[@"data"][@"userId"];
            CXWorkCircleDetailModel * detailModel = [CXWorkCircleDetailModel yy_modelWithDictionary:JSON[@"data"]];
            self.detailModel = detailModel;
            
            self.dataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CXWorkCircleDetailRecordModel class] json:JSON[@"data"][@"recordList"]]];
            
            SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsContactsDicWithUserId:[self.detailModel.userId integerValue]];
            
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            
            _nameLabel.text = [NSString stringWithFormat:@"%@",self.detailModel.sendName];
            [_nameLabel sizeToFit];
            _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, kWorkHeadImageTopSpace, _nameLabel.size.width, kNameLabelFontSize);
            
            _nameBtn.frame = _nameLabel.frame;
            
            [self setAnnexListWithAnnexList:self.detailModel.annexList];
            
            _contentLabel.text = [NSString stringWithFormat:@"%@",self.detailModel.remark];
            CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(Screen_Width - (CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace) - kWorkHeadImageLeftSpace, LONG_MAX)];
            _contentLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + kContentLabelTopSpace, contentLabelSize.width, contentLabelSize.height);
            
            self.detailImagesHeight = [self addDetailImages];
            
            self.detailVoiceAndAnnexViewHeight = [self addDetailVoiceAndAnnexView];
            
            _timeLabel.text = self.detailModel.createTime;
            [_timeLabel sizeToFit];
            _timeLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, CGRectGetMaxY(_contentLabel.frame) + self.detailImagesHeight + self.detailVoiceAndAnnexViewHeight + kWorkTimeLabelTopSpace, _timeLabel.size.width, kTimeLabelFontSize);
            
            _opinionBtn.frame = CGRectMake(Screen_Width - kWorkHeadImageLeftSpace - kOpinionBtnImageWidth, CGRectGetMaxY(_contentLabel.frame) + self.detailImagesHeight + self.detailVoiceAndAnnexViewHeight + kWorkTimeLabelTopSpace - (kOpinionBtnImageHeight - kTimeLabelFontSize)/2, kOpinionBtnImageWidth, kOpinionBtnImageHeight);
            
            if(true){
                _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kSelfOpinionBackGroundViewWidth, CGRectGetMaxY(_contentLabel.frame) + self.detailImagesHeight + self.detailVoiceAndAnnexViewHeight + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kSelfOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
                
                if(_commentImageView){
                    [_commentImageView removeFromSuperview];
                    _commentImageView = nil;
                }
                _commentImageView = [[UIImageView alloc] init];
                _commentImageView.image = [UIImage imageNamed:@"commentBtnImage"];
                _commentImageView.highlightedImage = [UIImage imageNamed:@"commentBtnImage"];
                _commentImageView.frame = CGRectMake(kOpinionBackGroundViewImageLeftSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewImageWidth)/2, kOpinionBackGroundViewImageWidth, kOpinionBackGroundViewImageWidth);
                [_opinionBackGroundView addSubview:_commentImageView];
                
                if(_commentLabel){
                    [_commentLabel removeFromSuperview];
                    _commentLabel = nil;
                }
                _commentLabel = [[UILabel alloc] init];
                _commentLabel.font = [UIFont systemFontOfSize:kOpinionBackGroundViewLabelFont];
                _commentLabel.textColor = kOpinionBackGroundViewLabelTextColor;
                _commentLabel.backgroundColor = [UIColor clearColor];
                _commentLabel.textAlignment = NSTextAlignmentLeft;
                _commentLabel.text = @"意见";
                [_commentLabel sizeToFit];
                _commentLabel.frame = CGRectMake(CGRectGetMaxX(_commentImageView.frame) + kOpinionBackGroundViewMiddleSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewLabelFont)/2, _commentLabel.size.width, kOpinionBackGroundViewLabelFont);
                [_opinionBackGroundView addSubview:_commentLabel];
                
                if(_commentBtn){
                    [_commentBtn removeFromSuperview];
                    _commentBtn = nil;
                }
                _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _commentBtn.frame = CGRectMake(0, 0, kOpinionBackGroundViewImageLeftSpace + kOpinionBackGroundViewImageWidth + kOpinionBackGroundViewMiddleSpace + _commentLabel.size.width + kOpinionBackGroundViewImageLeftSpace, kOpinionBackGroundViewHeight);
                [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [_opinionBackGroundView addSubview:_commentBtn];
                
            }else{
                _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kOpinionBackGroundViewWidth, CGRectGetMaxY(_contentLabel.frame) + self.detailImagesHeight + self.detailVoiceAndAnnexViewHeight + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
                
                if(_agreeImageView){
                    [_agreeImageView removeFromSuperview];
                    _agreeImageView = nil;
                }
                _agreeImageView = [[UIImageView alloc] init];
                _agreeImageView.image = [UIImage imageNamed:@"agreeBtnImage"];
                _agreeImageView.highlightedImage = [UIImage imageNamed:@"agreeBtnImage"];
                _agreeImageView.frame = CGRectMake(kOpinionBackGroundViewImageLeftSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewImageWidth)/2, kOpinionBackGroundViewImageWidth, kOpinionBackGroundViewImageWidth);
                [_opinionBackGroundView addSubview:_agreeImageView];
                
                if(_agreeLabel){
                    [_agreeLabel removeFromSuperview];
                    _agreeLabel = nil;
                }
                _agreeLabel = [[UILabel alloc] init];
                _agreeLabel.font = [UIFont systemFontOfSize:kOpinionBackGroundViewLabelFont];
                _agreeLabel.textColor = kOpinionBackGroundViewLabelTextColor;
                _agreeLabel.backgroundColor = [UIColor clearColor];
                _agreeLabel.textAlignment = NSTextAlignmentLeft;
                _agreeLabel.text = @"同意";
                [_agreeLabel sizeToFit];
                _agreeLabel.frame = CGRectMake(CGRectGetMaxX(_agreeImageView.frame) + kOpinionBackGroundViewMiddleSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewLabelFont)/2, _agreeLabel.size.width, kOpinionBackGroundViewLabelFont);
                [_opinionBackGroundView addSubview:_agreeLabel];
                
                if(_agreeBtn){
                    [_agreeBtn removeFromSuperview];
                    _agreeBtn = nil;
                }
                _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _agreeBtn.frame = CGRectMake(0, 0, kOpinionBackGroundViewImageLeftSpace + kOpinionBackGroundViewImageWidth + kOpinionBackGroundViewMiddleSpace + _agreeLabel.size.width + kOpinionBackGroundViewImageLeftSpace, kOpinionBackGroundViewHeight);
                [_agreeBtn addTarget:self action:@selector(aggreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [_opinionBackGroundView addSubview:_agreeBtn];
                
                if(_firstLineView){
                    [_firstLineView removeFromSuperview];
                    _firstLineView = nil;
                }
                _firstLineView = [[UIView alloc] init];
                _firstLineView.backgroundColor = [UIColor blackColor];
                _firstLineView.frame = CGRectMake(CGRectGetMaxX(_agreeLabel.frame) + kOpinionBackGroundViewImageLeftSpace + 1, kOpinionBackGroundViewLineTopSpace, 1, kOpinionBackGroundViewHeight - 2*kOpinionBackGroundViewLineTopSpace);
                [_opinionBackGroundView addSubview:_firstLineView];
                
                if(_refuseImageView){
                    [_refuseImageView removeFromSuperview];
                    _refuseImageView = nil;
                }
                _refuseImageView = [[UIImageView alloc] init];
                _refuseImageView.image = [UIImage imageNamed:@"refuseBtnImage"];
                _refuseImageView.highlightedImage = [UIImage imageNamed:@"refuseBtnImage"];
                _refuseImageView.frame = CGRectMake(CGRectGetMaxX(_firstLineView.frame) + kOpinionBackGroundViewImageLeftSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewImageWidth)/2, kOpinionBackGroundViewImageWidth, kOpinionBackGroundViewImageWidth);
                [_opinionBackGroundView addSubview:_refuseImageView];
                
                if(_refuseLabel){
                    [_refuseLabel removeFromSuperview];
                    _refuseLabel = nil;
                }
                _refuseLabel = [[UILabel alloc] init];
                _refuseLabel.font = [UIFont systemFontOfSize:kOpinionBackGroundViewLabelFont];
                _refuseLabel.textColor = kOpinionBackGroundViewLabelTextColor;
                _refuseLabel.backgroundColor = [UIColor clearColor];
                _refuseLabel.textAlignment = NSTextAlignmentLeft;
                _refuseLabel.text = @"不同意";
                [_refuseLabel sizeToFit];
                _refuseLabel.frame = CGRectMake(CGRectGetMaxX(_refuseImageView.frame) + kOpinionBackGroundViewMiddleSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewLabelFont)/2, _refuseLabel.size.width, kOpinionBackGroundViewLabelFont);
                [_opinionBackGroundView addSubview:_refuseLabel];
                
                if(_refuseBtn){
                    [_refuseBtn removeFromSuperview];
                    _refuseBtn = nil;
                }
                _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _refuseBtn.frame = CGRectMake(CGRectGetMaxX(_firstLineView.frame), 0, kOpinionBackGroundViewImageLeftSpace + kOpinionBackGroundViewImageWidth + kOpinionBackGroundViewMiddleSpace + _refuseLabel.size.width + kOpinionBackGroundViewImageLeftSpace, kOpinionBackGroundViewHeight);
                [_refuseBtn addTarget:self action:@selector(refuseBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [_opinionBackGroundView addSubview:_refuseBtn];
                
                if(_secondLineView){
                    [_secondLineView removeFromSuperview];
                    _secondLineView = nil;
                }
                _secondLineView = [[UIView alloc] init];
                _secondLineView.backgroundColor = [UIColor blackColor];
                _secondLineView.frame = CGRectMake(CGRectGetMaxX(_refuseLabel.frame) + kOpinionBackGroundViewImageLeftSpace + 1, kOpinionBackGroundViewLineTopSpace, 1, kOpinionBackGroundViewHeight - 2*kOpinionBackGroundViewLineTopSpace);
                [_opinionBackGroundView addSubview:_secondLineView];
                
                if(_commentImageView){
                    [_commentImageView removeFromSuperview];
                    _commentImageView = nil;
                }
                _commentImageView = [[UIImageView alloc] init];
                _commentImageView.image = [UIImage imageNamed:@"commentBtnImage"];
                _commentImageView.highlightedImage = [UIImage imageNamed:@"commentBtnImage"];
                _commentImageView.frame = CGRectMake(CGRectGetMaxX(_secondLineView.frame) + kOpinionBackGroundViewImageLeftSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewImageWidth)/2, kOpinionBackGroundViewImageWidth, kOpinionBackGroundViewImageWidth);
                [_opinionBackGroundView addSubview:_commentImageView];
                
                if(_commentLabel){
                    [_commentLabel removeFromSuperview];
                    _commentLabel = nil;
                }
                _commentLabel = [[UILabel alloc] init];
                _commentLabel.font = [UIFont systemFontOfSize:kOpinionBackGroundViewLabelFont];
                _commentLabel.textColor = kOpinionBackGroundViewLabelTextColor;
                _commentLabel.backgroundColor = [UIColor clearColor];
                _commentLabel.textAlignment = NSTextAlignmentLeft;
                _commentLabel.text = @"意见";
                [_commentLabel sizeToFit];
                _commentLabel.frame = CGRectMake(CGRectGetMaxX(_commentImageView.frame) + kOpinionBackGroundViewMiddleSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewLabelFont)/2, _commentLabel.size.width, kOpinionBackGroundViewLabelFont);
                [_opinionBackGroundView addSubview:_commentLabel];
                
                if(_commentBtn){
                    [_commentBtn removeFromSuperview];
                    _commentBtn = nil;
                }
                _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _commentBtn.frame = CGRectMake(CGRectGetMaxX(_secondLineView.frame), 0, kOpinionBackGroundViewImageLeftSpace + kOpinionBackGroundViewImageWidth + kOpinionBackGroundViewMiddleSpace + _commentLabel.size.width + kOpinionBackGroundViewImageLeftSpace, kOpinionBackGroundViewHeight);
                [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [_opinionBackGroundView addSubview:_commentBtn];
            }
            
            
            self.tableHeaderView.frame = CGRectMake(0, 0, Screen_Width, CGRectGetMaxY(_timeLabel.frame) + kWorkTimeLabelBottomSpace);
            
            [self.tableView setTableHeaderView:self.tableHeaderView];
            
            [self.tableView reloadData];
            
            [self collapseAll];
            _opinionBtn.selected = NO;
            _opinionBackGroundView.hidden = YES;
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        [_tableView.legendHeader endRefreshing];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)setAnnexListWithAnnexList:(NSArray *)annexList
{
    [self.detailImageArray removeAllObjects];
    [self.detailVoiceDict removeAllObjects];
    for (NSMutableDictionary *dict in annexList) {
        if ([dict[@"type"] isEqualToString:@"jpg"] || [dict[@"type"] isEqualToString:@"png"]) {
            [self.detailImageArray addObject:dict];
        }
        if ([dict[@"type"] isEqualToString:@"spx"]) {
            [_detailVoiceDict setValue:dict[@"path"] forKey:@"voicePath"];
            [_detailVoiceDict setValue:dict[@"srcName"] forKey:@"srcName"];
        }
    }
}

- (CGFloat)addDetailImages
{
    if([self.detailImageArray count] > 0){
        for(NSInteger i = 0; i < [self.detailImageArray count]; i++){
            NSDictionary * detailImageDic = self.detailImageArray[i];
            UIImageView * detailImageView = [[UIImageView alloc] init];
            [detailImageView sd_setImageWithURL:[NSURL URLWithString:detailImageDic[@"path"]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            if(i >= 0 && i <= 2){
                detailImageView.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame) + (kDetailImageWidth + kDetailImageWidthSpace)*(i%3), CGRectGetMaxY(_contentLabel.frame) + kContentLabelTopSpace, kDetailImageWidth, kDetailImageWidth);
            }
            else if(i >= 3 && i <= 5){
                detailImageView.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame) + (kDetailImageWidth + kDetailImageWidthSpace)*(i%3), CGRectGetMaxY(_contentLabel.frame) + kContentLabelTopSpace + (kDetailImageWidth + kDetailImageWidthSpace)*1, kDetailImageWidth, kDetailImageWidth);
            }
            else if(i >= 6 && i <= 8){
                detailImageView.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame) + (kDetailImageWidth + kDetailImageWidthSpace)*(i%3),CGRectGetMaxY(_contentLabel.frame) + kContentLabelTopSpace + (kDetailImageWidth + kDetailImageWidthSpace)*2, kDetailImageWidth, kDetailImageWidth);
            }
            detailImageView.userInteractionEnabled = YES;
            [_tableHeaderView addSubview:detailImageView];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailImageViewClick:)];
            [detailImageView addGestureRecognizer:tap];
        }
        if([self.detailImageArray count] > 0 && [self.detailImageArray count] <= 3){
            return kContentLabelTopSpace + kDetailImageWidth;
        }
        else if([self.detailImageArray count] > 3 && [self.detailImageArray count] <= 6){
            return kContentLabelTopSpace + kDetailImageWidth*2 + kDetailImageWidthSpace;
        }
        else if([self.detailImageArray count] > 6 && [self.detailImageArray count] <= 9){
            return kContentLabelTopSpace + kDetailImageWidth*3 + kDetailImageWidthSpace*2;
        }
    }
    return 0;
}

- (CGFloat)addDetailVoiceAndAnnexView
{
    if(_detailVoiceDict[@"voicePath"]){
        self.voiceImageView = [[UIImageView alloc] init];
        self.voiceImageView.image = [UIImage imageNamed:@"OldAnnex_voice_y"];
        self.voiceImageView.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame),CGRectGetMaxY(_contentLabel.frame) + kContentLabelTopSpace + self.detailImagesHeight, kDetailVoiceImageWidth, kDetailVoiceImageWidth);
        self.voiceImageView.userInteractionEnabled = YES;
        [_tableHeaderView addSubview:self.voiceImageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceImageViewClick)];
        [self.voiceImageView addGestureRecognizer:tap];
        return kContentLabelTopSpace + kDetailVoiceImageWidth;
    }
    return 0;
}

- (void)detailImageViewClick:(UITapGestureRecognizer *)tap
{
    UIImageView * tapView = (UIImageView *)tap.view;
    SDIMImageViewerController *vc = [[SDIMImageViewerController alloc] init];
    vc.image = tapView.image;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)opinionBtnClick
{
    _opinionBtn.selected = !_opinionBtn.selected;
    if(_opinionBtn.selected){
        _opinionBackGroundView.hidden = NO;
    }else{
        _opinionBackGroundView.hidden = YES;
    }
}

- (void)aggreeBtnClick
{
    self.textView.text = @"同意";
    [self clearTextViewWithToolViewHidden:YES];
    [self sendCommentWithComment:@"同意"];
    
}

- (void)refuseBtnBtnClick
{
    self.textView.text = @"不同意";
    [self clearTextViewWithToolViewHidden:YES];
    [self sendCommentWithComment:@"不同意"];
}

- (void)commentBtnClick
{
    [self clearTextViewWithToolViewHidden:NO];
}

- (void)clearTextViewWithToolViewHidden:(BOOL)hidden
{
    _opinionBtn.selected = NO;
    _opinionBackGroundView.hidden = YES;
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
    self.toolView.hidden = hidden;
}

- (void)voiceImageViewClick
{
    [self voicePlay];
}

-(void)collapseAll{
    self.textView.inputView = nil;
    [self.textView resignFirstResponder];
    self.toolView.hidden = YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self collapseAll];
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

// 发送文本消息
-(void)sendTextMessage{
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length <= 0) {
        return;
    }
    [self sendCommentWithComment:text];
}

- (void)sendCommentWithComment:(NSString *)comment
{
    NSString *url = [NSString stringWithFormat:@"%@workRecord/record",urlPrefix];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:self.model.eid forKey:@"l_bid"];
    [params setValue:self.model.btype forKey:@"l_type"];
    [params setValue:comment forKey:@"s_remark"];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [HttpTool multipartPostFileDataWithPath:url params:params dataAry:nil success:^(id JSON) {
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            TTAlert(@"发送评论成功");
            [self collapseAll];
            CXWorkCircleDetailRecordModel * recordModel = [[CXWorkCircleDetailRecordModel alloc] init];
            recordModel.userId = VAL_USERID;
            recordModel.remark = self.textView.text;
            recordModel.imAccount = VAL_HXACCOUNT;
            recordModel.send_icon = VAL_Icon;
            recordModel.userName = VAL_USERNAME;
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            NSString *dateTime = [formatter stringFromDate:date];
            recordModel.createTime = dateTime;
            [self.dataSource addObject:recordModel];
            [self.tableView reloadData];
            self.textView.text = @"评论";
        }else{
            TTAlert(JSON[@"msg"]);
            self.textView.text = @"评论";
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
        self.textView.text = @"评论";
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"评论"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"评论";
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"CXWorkCircleDetailCommentTableViewCell";
    CXYunJingWorkCircleDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[CXYunJingWorkCircleDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    CXWorkCircleDetailRecordModel * model = (CXWorkCircleDetailRecordModel *)[self.dataSource objectAtIndex:indexPath.row];
    [cell setCXWorkCircleDetailRecordModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CXWorkCircleDetailRecordModel * model = (CXWorkCircleDetailRecordModel *)[self.dataSource objectAtIndex:indexPath.row];
    CGFloat cellHeight = [CXYunJingWorkCircleDetailTableViewCell getCellHeightWithCXWorkCircleDetailRecordModel:model];
    return cellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//此代理方法用来重置cell分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 声音播放
- (void)voicePlay
{
    if(self.isPlaySound){
        NSLog(@"点击声音");
        self.isPlaySound = NO;
        NSString* voicePath = [NSString stringWithFormat:@"%@",self.detailVoiceDict[@"voicePath"]];
        NSString* voiceSrcName = self.detailVoiceDict[@"srcName"];
        
        //来自添加界面，直接播放录音
        if (![voicePath hasPrefix:@"http"]) {
            [self playNetWorkAudioByPath:voicePath];
        }else{
            
            //如果本地文件有录音，直接读取
            NSString* directoryVoicePath = [NSString stringWithFormat:@"%@/%@", kAudioNetWorkPath, voiceSrcName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:directoryVoicePath]) {
                [self playNetWorkAudioByPath:directoryVoicePath];
            }
            else {
                [self downloadNetWorkAudioByPath:voicePath withSrcName:voiceSrcName];
            }
        }
    }else{
        //暂停录音播放
        self.isPlaySound = YES;
        [self playingStoped];
    }
}
// 播放录音文件
-(void)playNetWorkAudioByPath:(NSString *)audioPath
{
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager playAudioWithFileName:audioPath delegate:self];
}

// 网络下载录音文件
- (void)downloadNetWorkAudioByPath:(NSString*)netWorkPath withSrcName:(NSString*)voiceSrcName
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:netWorkPath]];
    [request setTimeoutInterval:60.f];
    [request addValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
                               
                               if (![[NSFileManager defaultManager] fileExistsAtPath:kAudioNetWorkPath]) {
                                   [[NSFileManager defaultManager] createDirectoryAtPath:kAudioNetWorkPath withIntermediateDirectories:YES attributes:nil error:nil];
                               }
                               
                               if (data) {
                                   NSString* filePath = [NSString stringWithFormat:@"%@/%@", kAudioNetWorkPath, voiceSrcName];
                                   [data writeToFile:filePath atomically:NO];
                                   [self playNetWorkAudioByPath:filePath];
                               }
                           }];
}
//停止播放录音
-(void)playingStoped
{
    self.isPlaySound = YES;
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager stopPlaying];
}

-(void)dealloc
{
    //暂停录音播放
    [self playingStoped];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
