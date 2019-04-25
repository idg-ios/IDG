//
//  CXAllPeoplleWorkCircleViewController.m
//  InjoyERP
//
//  Created by wtz on 16/11/22.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXAllPeoplleWorkCircleViewController.h"
#import "AppDelegate.h"
#import "CXIMHelper.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"
#import "UIView+Category.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXAllPeoplleWorkCircleModel.h"
#import "CXAllPeoplleWorkCircleCell.h"
#import "CXMyselfWorkCircleViewController.h"

#import "ChatMoreView.h"
#import "Masonry.h"
#import "DXFaceView.h"

#import "CXWorkCircleDetailViewController.h"
#import "IBActionSheet.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"
#import "CXWorkCircleNewCommentListViewController.h"
#import "AliImageReshapeController.h"

#define kTableHeaderViewHeight ((Screen_Width*384.0/1242.0) + 35)

#define kRightImageSpace 15

#define kHeadImageWidth 65

#define kWorkHeadImageLeftSpace 10
#define kWorkHeadImageTopSpace 15
#define kWorkHeadImageWidth 40
#define kNameLabelFontSize 15.0
#define kTitleLabelFontSize 14.0
#define kTimeLabelFontSize 12.0
#define kTextColor [UIColor blackColor]
#define kGrayBackGroundViewTopSpace 3
#define kTypeImageLeftSpace 10
#define kTypeImageWidth 25
#define kGrayBackGroundViewMoveLeft 3
#define kWorkTimeLabelTopSpace 10
#define kWorkTimeLabelBottomSpace 15

#define kWorkCellHeight (kWorkHeadImageTopSpace + kNameLabelFontSize + kGrayBackGroundViewTopSpace + kTypeImageLeftSpace + kTypeImageWidth + kTypeImageLeftSpace + kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace)

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

#define kImageIconPath @"imageIconPath"

#define kNewCommentNotificationViewTopSpace 2.0

#define kCommentNotificationBackViewCornerRadios 4.0

#define kNewCommentNotificationViewImageViewTopSpace 5.0

#define kNewCommentNotificationViewHeadImageViewWidth 30.0

#define kNewCommentNotificationViewBottomSpace 10.0

#define kCommentNotificationLabelFontSize 14.0

#define kCommentNotificationLabelLeftSpace 10.0

@interface CXAllPeoplleWorkCircleViewController ()<UITableViewDataSource, UITableViewDelegate,DXFaceDelegate,UITextViewDelegate,IBActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ALiImageReshapeDelegate>

//导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView * tableHeaderView;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic) NSInteger page;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;
//表情的附加页面
@property (strong, nonatomic) DXFaceView *faceView;
// 文本框底部线条
@property (nonatomic,strong) UIView *textViewBottomLine;
// 表情
@property (nonatomic,strong) UIButton *toolViewFaceBtn;

@property (nonatomic, strong) IBActionSheet* standardIBAS;

@property (nonatomic, strong) UIImageView * tableHeaderImageView;

@property (nonatomic, strong) UIView * commentNotificationBackView;

@property (nonatomic, strong) UIImageView * commentNotificationHeadImageView;

@property (nonatomic, strong) UILabel * commentNotificationLabel;

@property (nonatomic, strong) UIButton * commentNotificationBackViewBtn;

@end

@implementation CXAllPeoplleWorkCircleViewController

-(DXFaceView *)faceView{
    if (_faceView == nil) {
        _faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kHeightOfEmoji)];
        _faceView.delegate = self;
        self.faceView.backgroundColor = [UIColor lightGrayColor];
    }
    return _faceView;
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAVE_UNREAD_WORKCIRCLE_MESSAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self receiveNewCommentReloadTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAVE_UNREAD_WORKCIRCLE_MESSAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setupView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewWorkCircleComment) name:receiveNewWorkCircleCommentNotification object:nil];
    
    
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"公司圈")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    self.page = 1;
    
    self.tableHeaderView = [[UIView alloc] init];
    self.tableHeaderView.frame = CGRectMake(0, 0, Screen_Width, kTableHeaderViewHeight);
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _tableHeaderImageView = [[UIImageView alloc] init];
    _tableHeaderImageView.image = [UIImage imageNamed:@"workCircleTopBackImage"];
    _tableHeaderImageView.highlightedImage = [UIImage imageNamed:@"workCircleTopBackImage"];
    _tableHeaderImageView.frame = CGRectMake(0, 0, Screen_Width, kTableHeaderViewHeight - 20);
    _tableHeaderImageView.userInteractionEnabled = YES;
    [self.tableHeaderView addSubview:_tableHeaderImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeaderImageViewClick)];
    [_tableHeaderImageView addGestureRecognizer:tap];
    
    SDCompanyUserModel * userModel = [CXIMHelper getUserByIMAccount:VAL_HXACCOUNT];
    
    UILabel * nameLabel = [[UILabel alloc] init];
    nameLabel.text = userModel.name;
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(Screen_Width - kRightImageSpace - kHeadImageWidth - kRightImageSpace - nameLabel.size.width,Screen_Width<=321?70:90, nameLabel.size.width, 15.0);
    [self.tableHeaderView addSubview:nameLabel];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + kRightImageSpace, CGRectGetMinY(nameLabel.frame), kHeadImageWidth, kHeadImageWidth);
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[userModel.icon isKindOfClass:[NSNull class]]?@"":userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    _headImageView.userInteractionEnabled = YES;
    [self.tableHeaderView addSubview:_headImageView];
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick)];
    [_headImageView addGestureRecognizer:imageTap];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self addBottomBar];
}

- (BOOL)isHaveUnReadComment
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSString * lastCommentCreateTime = [ud objectForKey:[NSString stringWithFormat:@"LSAT_COMMENT_CREATETIME_%@",VAL_HXACCOUNT]];
    NSArray * unReadComments;
    if(lastCommentCreateTime){
        unReadComments = [[SDDataBaseHelper shareDB]  getUnReadWorkCircleCommentPushModelArrayWithLastReadCommetCreateTime:@([lastCommentCreateTime longLongValue])];
    }else{
        unReadComments = [[SDDataBaseHelper shareDB] getWorkCircleCommentPushModelArray];
    }
    if(unReadComments && [unReadComments count] > 0){
        return YES;
    }else{
        return NO;
    }
}

- (void)newCommentNotificationViewClick
{
    NSArray * comments = [[SDDataBaseHelper shareDB] getWorkCircleCommentPushModelArray];
    if(comments && [comments count] > 0){
        CXWorkCircleCommentPushModel * model = (CXWorkCircleCommentPushModel *)comments[0];
        NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
        //保存最后一条未读评论的时间戳，用来判断是否有未读评论
        [ud setObject:model.createTime forKey:[NSString stringWithFormat:@"LSAT_COMMENT_CREATETIME_%@",VAL_HXACCOUNT]];
        [ud synchronize];
        //这里push新页面
        CXWorkCircleNewCommentListViewController * workCircleNewCommentListViewController = [[CXWorkCircleNewCommentListViewController alloc] init];
        [self.navigationController pushViewController:workCircleNewCommentListViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else{
        TTAlert(@"没有新评论");
        return;
    }
}

- (void)receiveNewWorkCircleComment
{
    [self receiveNewCommentReloadTable];
}

- (void)receiveNewCommentReloadTable
{
    if([self isHaveUnReadComment]){
        self.tableHeaderView.frame = CGRectMake(0, 0, Screen_Width, kTableHeaderViewHeight + kNewCommentNotificationViewTopSpace + kNewCommentNotificationViewImageViewTopSpace + kNewCommentNotificationViewHeadImageViewWidth + kNewCommentNotificationViewImageViewTopSpace + kNewCommentNotificationViewBottomSpace);
        
        if(_commentNotificationBackView){
            [_commentNotificationBackView removeFromSuperview];
            _commentNotificationBackView = nil;
        }
        _commentNotificationBackView = [[UIView alloc] init];
        _commentNotificationBackView.backgroundColor = RGBACOLOR(87.0, 87.0, 87.0, 1.0);
        _commentNotificationBackView.layer.cornerRadius = kCommentNotificationBackViewCornerRadios;
        _commentNotificationBackView.clipsToBounds = YES;
        [self.tableHeaderView addSubview:_commentNotificationBackView];
        
        if(_commentNotificationHeadImageView){
            [_commentNotificationHeadImageView removeFromSuperview];
            _commentNotificationHeadImageView = nil;
        }
        _commentNotificationHeadImageView = [[UIImageView alloc] init];
        _commentNotificationHeadImageView.frame = CGRectMake(kNewCommentNotificationViewImageViewTopSpace, kNewCommentNotificationViewImageViewTopSpace, kNewCommentNotificationViewHeadImageViewWidth, kNewCommentNotificationViewHeadImageViewWidth);
        NSArray * comments = [[SDDataBaseHelper shareDB] getWorkCircleCommentPushModelArray];
        CXWorkCircleCommentPushModel * model = (CXWorkCircleCommentPushModel *)comments[0];
        [_commentNotificationHeadImageView sd_setImageWithURL:[NSURL URLWithString:[model.icon isKindOfClass:[NSNull class]]?@"":model.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        [_commentNotificationBackView addSubview:_commentNotificationHeadImageView];
        
        if(_commentNotificationLabel){
            [_commentNotificationLabel removeFromSuperview];
            _commentNotificationLabel = nil;
        }
        _commentNotificationLabel = [[UILabel alloc] init];
        _commentNotificationLabel.font = [UIFont systemFontOfSize:kCommentNotificationLabelFontSize];
        NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
        NSString * lastCommentCreateTime = [ud objectForKey:[NSString stringWithFormat:@"LSAT_COMMENT_CREATETIME_%@",VAL_HXACCOUNT]];
        NSArray * unReadComments;
        if(lastCommentCreateTime){
            unReadComments = [[SDDataBaseHelper shareDB]  getUnReadWorkCircleCommentPushModelArrayWithLastReadCommetCreateTime:@([lastCommentCreateTime longLongValue])];
        }else{
            unReadComments = [[SDDataBaseHelper shareDB] getWorkCircleCommentPushModelArray];
        }
        _commentNotificationLabel.text = [NSString stringWithFormat:@"%zd条新消息",[unReadComments count]];
        [_commentNotificationLabel sizeToFit];
        _commentNotificationLabel.backgroundColor = [UIColor clearColor];
        _commentNotificationLabel.textColor = [UIColor whiteColor];
        _commentNotificationLabel.frame = CGRectMake(CGRectGetMaxX(_commentNotificationHeadImageView.frame) + kCommentNotificationLabelLeftSpace, (kNewCommentNotificationViewImageViewTopSpace + kNewCommentNotificationViewHeadImageViewWidth + kNewCommentNotificationViewImageViewTopSpace - kCommentNotificationLabelFontSize)/2, _commentNotificationLabel.size.width, _commentNotificationLabel.size.height);
        [_commentNotificationBackView addSubview:_commentNotificationLabel];
        
        _commentNotificationBackView.frame = CGRectMake((Screen_Width - (kNewCommentNotificationViewImageViewTopSpace + kNewCommentNotificationViewHeadImageViewWidth + kCommentNotificationLabelLeftSpace + _commentNotificationLabel.size.width + kCommentNotificationLabelLeftSpace))/2, CGRectGetMaxY(_headImageView.frame) + kNewCommentNotificationViewTopSpace, kNewCommentNotificationViewImageViewTopSpace + kNewCommentNotificationViewHeadImageViewWidth + kCommentNotificationLabelLeftSpace + _commentNotificationLabel.size.width + kCommentNotificationLabelLeftSpace, kNewCommentNotificationViewImageViewTopSpace + kNewCommentNotificationViewHeadImageViewWidth + kNewCommentNotificationViewImageViewTopSpace);
        
        if(_commentNotificationBackViewBtn){
            [_commentNotificationBackViewBtn removeFromSuperview];
            _commentNotificationBackViewBtn = nil;
        }
        _commentNotificationBackViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentNotificationBackViewBtn.frame = _commentNotificationBackView.bounds;
        [_commentNotificationBackViewBtn addTarget:self action:@selector(newCommentNotificationViewClick) forControlEvents:UIControlEventTouchUpInside];
        [_commentNotificationBackView addSubview:_commentNotificationBackViewBtn];
        
        [self.tableView setTableHeaderView:_tableHeaderView];
    }else{
        self.tableHeaderView.frame = CGRectMake(0, 0, Screen_Width, kTableHeaderViewHeight);
        if(_commentNotificationBackView){
            [_commentNotificationBackView removeFromSuperview];
            _commentNotificationBackView = nil;
        }
        [self.tableView setTableHeaderView:_tableHeaderView];
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

- (void)tableHeaderImageViewClick
{
    self.standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"请选择操作方式" otherButtonTitles:@"照相", @"相册", nil];
    [self.standardIBAS setFont:[UIFont systemFontOfSize:17.f]];
    [self.standardIBAS setButtonTextColor:[UIColor blackColor]];
    [self.standardIBAS setButtonBackgroundColor:[UIColor redColor] forButtonAtIndex:3];
    [self.standardIBAS setButtonTextColor:[UIColor lightGrayColor] forButtonAtIndex:0];
    [self.standardIBAS showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headImageViewClick
{
    CXMyselfWorkCircleViewController * myselfWorkCircleViewController = [[CXMyselfWorkCircleViewController alloc] init];
    [self.navigationController pushViewController:myselfWorkCircleViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
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

- (void)downloadData
{
    self.toolView.hidden = YES;
    self.page = 1;
    NSString *url = [NSString stringWithFormat:@"%@workRecord/findPageMyWordAndReceive/%zd",urlPrefix,self.page];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [HttpTool multipartPostFileDataWithPath:url params:nil dataAry:nil success:^(id JSON) {
        [weakSelf hideHud];
        [_tableView.legendHeader endRefreshing];
        [self.dataSource removeAllObjects];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            self.page = [JSON[@"page"] integerValue];
            self.dataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXAllPeoplleWorkCircleModel.class json:JSON[@"data"]]];
            [_tableHeaderImageView sd_setImageWithURL:[NSURL URLWithString:(!JSON[@"otherData"][@"workImg"] || [JSON[@"otherData"][@"workImg"] isKindOfClass:[NSNull class]])?@"":JSON[@"otherData"][@"workImg"]] placeholderImage:[UIImage imageNamed:@"workCircleTopBackImage"] options:EMSDWebImageRetryFailed];
            if ([self.dataSource count] <= 0) {
                [self.view makeToast:@"暂无数据" duration:1 position:@"center"];
            }
            [self.tableView reloadData];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        [_tableView.legendHeader endRefreshing];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)loadMoreData
{
    self.toolView.hidden = YES;
    NSString *url = [NSString stringWithFormat:@"%@workRecord/findPageMyWordAndReceive/%zd",urlPrefix,self.page + 1];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [HttpTool multipartPostFileDataWithPath:url params:nil dataAry:nil success:^(id JSON) {
        [weakSelf hideHud];
        [_tableView.legendFooter endRefreshing];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            [_tableHeaderImageView sd_setImageWithURL:[NSURL URLWithString:(!JSON[@"otherData"][@"workImg"] || [JSON[@"otherData"][@"workImg"] isKindOfClass:[NSNull class]])?@"":JSON[@"otherData"][@"workImg"]] placeholderImage:[UIImage imageNamed:@"workCircleTopBackImage"] options:EMSDWebImageRetryFailed];
            self.page = [JSON[@"page"] integerValue];
            NSMutableArray * moreData = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:CXAllPeoplleWorkCircleModel.class json:JSON[@"data"]]];
            [self.dataSource addObjectsFromArray:moreData];
            if ([moreData count] <= 0) {
                [self.view makeToast:@"没有更多了" duration:1 position:@"center"];
                self.page--;
            }
            [self.tableView reloadData];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        [_tableView.legendFooter endRefreshing];
        CXAlert(KNetworkFailRemind);
    }];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"CXAllPeoplleWorkCircleCell";
    CXAllPeoplleWorkCircleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[CXAllPeoplleWorkCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    [cell setCXAllPeoplleWorkCircleModel:self.dataSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kWorkCellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self collapseAll];
    CXWorkCircleDetailViewController * workCircleDetailViewController = [[CXWorkCircleDetailViewController alloc] init];
    workCircleDetailViewController.model = (CXAllPeoplleWorkCircleModel *)self.dataSource[indexPath.row];
    [self.navigationController pushViewController:workCircleDetailViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
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
    self.textView.text = @"";
}

- (void)sendCommentWithComment:(NSString *)comment
{
    NSString *url = [NSString stringWithFormat:@"%@workRecord/record",urlPrefix];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:self.commentModel.eid forKey:@"l_bid"];
    [params setValue:self.commentModel.btype forKey:@"l_type"];
    [params setValue:comment forKey:@"s_remark"];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [HttpTool multipartPostFileDataWithPath:url params:params dataAry:nil success:^(id JSON) {
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            TTAlert(@"发送评论成功");
            [self collapseAll];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(IBActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self takePhoto];
            }
            else {
                
                [self.view makeToast:@"模拟其中无法打开照相机,请在真机中使用" duration:2 position:@"center"];
            }
            
        } break;
        case 2: {
            //相册选取
            [self chooseImageFromLibary];
        } break;
        default:
            break;
    }
}

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)chooseImageFromLibary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ALiImageReshapeDelegate

- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
    [self requestWithHeadImage:image];
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
    vc.sourceImage = image;
    vc.reshapeScale = 1242./384.;
    vc.delegate = self;
    [picker pushViewController:vc animated:YES];
}

#pragma mark 压缩图片
- (UIImage*)compressImage:(UIImage*)compressImage
{
    const CGFloat compressRate = 1.0;
    CGFloat width = compressImage.size.width * compressRate;
    CGFloat height = compressImage.size.height * compressRate;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [compressImage drawInRect:CGRectMake(0, 0, width, height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)requestWithHeadImage:(UIImage *)headImage
{
    headImage = [self compressImage:headImage];
    NSData* imageData = UIImageJPEGRepresentation(headImage, 0.5);
    NSString* url = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", url, kImageIconPath];
    //获取整个程序所在目录
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString* imagePath = [NSString stringWithFormat:@"%@/myicon.jpg", filePath];
    
    if ([imageData writeToFile:imagePath atomically:YES])
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        long fileNameNumber = [str longLongValue];
        NSString* fileName = [NSString stringWithFormat:@"%ld.jpg", fileNameNumber];
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        SDUploadFileModel *uploadFileModel = [[SDUploadFileModel alloc] init];
        uploadFileModel.fileData = data;
        uploadFileModel.fileName = fileName;
        uploadFileModel.mimeType = @"image/jpg";
        [self showHudInView:self.view hint:@"更改中..."];
        
        [HttpTool multipartPostWithPath:[NSString stringWithFormat:@"%@workRecord/file", urlPrefix] params:nil files:@{@"img":@[uploadFileModel]} success:^(id JSON) {
            [self hideHud];
            if ([JSON[@"status"] intValue] == 200)
            {
                [self.view makeToast:@"修改成功" duration:2 position:@"center"];
                [_tableHeaderImageView sd_setImageWithURL:[NSURL URLWithString:JSON[@"data"]] placeholderImage:[UIImage imageNamed:@"workCircleTopBackImage"] options:EMSDWebImageRetryFailed];
            }
            
        } failure:^(NSError *error) {
            [self hideHud];
            
            [self.view makeToast:[error localizedFailureReason] duration:2 position:@"center"];
        }];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
