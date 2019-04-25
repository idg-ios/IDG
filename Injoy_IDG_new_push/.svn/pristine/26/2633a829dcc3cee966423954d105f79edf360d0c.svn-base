//
//  CXDDXMeetingDetailInfoViewController.m
//  InjoyDDXXST
//
//  Created by wtz on 2017/10/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDDXMeetingDetailInfoViewController.h"
#import "SDCompanyUserModel.h"
#import "UIColor+Category.h"
#import "Masonry.h"
#import "CXIMMembersView.h"
#import "CXIMHelper.h"
#import "SDContactsDetailController.h"
#import "SDIMPersonInfomationViewController.h"
#import "HttpTool.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import "CXLoaclDataManager.h"
#import "CXDDXMeetingDetailInfoAllMembersViewController.h"
#import "CXDDXMeetingDetailInfoChangeMeetingNameViewController.h"
#import "CXXSTMeetingListViewController.h"

@interface CXDDXMeetingDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate,CXIMMembersViewDelegate>

/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 确认view */
@property (nonatomic,strong) UIView *deleteRecordConfirmView;
/** 遮盖view */
@property (nonatomic,strong) UIView *coverView;
/** 标题label */
@property (nonatomic,strong) UILabel * titleLabel;
/** SDRootTopView */
@property (nonatomic,strong) SDRootTopView *rootTopView;
/** CXIMMembersView */
@property (nonatomic, strong) CXIMMembersView *membersView;
/** 语音会议的创建者，只有创建者可以改会议议题 */
@property (nonatomic) BOOL isMeetingCreater;
/** 语音会议详情信息CXDDXVoiceMeetingDetailModel */
@property (nonatomic, strong) CXDDXVoiceMeetingDetailModel * model;
/** 结束会议Button */
@property (nonatomic,strong) UIButton * endMeetingBtn;

@end

@implementation CXDDXMeetingDetailInfoViewController

- (instancetype)initWithCXDDXVoiceMeetingDetailModel:(CXDDXVoiceMeetingDetailModel *)model;
{
    if (self = [super init]) {
        self.model = model;
        if([self.model.vedioMeetModel.ygId integerValue] == [VAL_USERID integerValue]){
            self.isMeetingCreater = YES;
        }else{
            self.isMeetingCreater = NO;
        }
    }
    return self;
}

- (CXIMMembersView *)membersView {
    if (!_membersView) {
        _membersView = [[CXIMMembersView alloc] init];
        _membersView.delegate = self;
        _membersView.deleteButtonEnable = NO;
        NSMutableArray * userModelArray = @[].mutableCopy;
        BOOL hasCreater = NO;
        for(CXDDXVoiceMeetingDetailUserModel * userModel in self.model.ccList){
            [userModelArray addObject:userModel.userId];
            if([userModel.userId integerValue] == [self.model.vedioMeetModel.ygId integerValue]){
                hasCreater = YES;
            }
        }
        if(!hasCreater){
            [userModelArray insertObject:self.model.vedioMeetModel.ygId atIndex:0];
        }
        _membersView.members = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserIdArray:userModelArray];
    }
    return _membersView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0,navHigh, Screen_Width, Screen_Height - navHigh);
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.rowHeight = SDMeCellHeight;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)endMeetingBtn{
    if(!_endMeetingBtn){
        _endMeetingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endMeetingBtn setTitle:@"结束会议" forState:UIControlStateNormal];
        [_endMeetingBtn setTitle:@"结束会议" forState:UIControlStateHighlighted];
        _endMeetingBtn.enabled = YES;
        [_endMeetingBtn setBackgroundImage:SDQuitOrDeleteBtnColor.image forState:UIControlStateNormal];
        _endMeetingBtn.frame = CGRectMake(15, 15, Screen_Width - 30, SDMeCellHeight);
        _endMeetingBtn.layer.cornerRadius = 5;
        _endMeetingBtn.layer.masksToBounds = YES;
        [_endMeetingBtn addTarget:self action:@selector(endMeetingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endMeetingBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChangeTitleNotification:) name:changeCXDDXMeetingTitleNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpView{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"会议信息")];
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backViewController)];
    self.tableView.hidden = NO;
    self.view.backgroundColor = SDBackGroudColor;
}

- (void)popToController{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CXXSTMeetingListViewController class]]) {
            CXXSTMeetingListViewController * aController = (CXXSTMeetingListViewController *)controller;
            [self.navigationController popToViewController:aController animated:YES];
        }
    }
}

#pragma mark - 通知
- (void)receiveChangeTitleNotification:(NSNotification *)noti {
    NSString *title = noti.userInfo[@"title"];
    self.model.vedioMeetModel.title = title;
}

- (void)backViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 30;
    }
    else if(indexPath.row == 1){
        return self.membersView.viewHeight;
    }
    else if(indexPath.row == 3){
        return 80;
    }
    return SDMeCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isMeetingCreater && [self.model.vedioMeetModel.isEnd integerValue] == 1){
        return 4;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        [self removeAllSubViews:cell.contentView];
    }
    if(indexPath.row == 0){
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing, (30 - SDSectionTitleFont)/2, 200, SDSectionTitleFont);
        titleLabel.text = @"群成员";
        titleLabel.textColor = SDSectionTitleColor;
        titleLabel.font = [UIFont systemFontOfSize:SDSectionTitleFont];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
    }
    else if(indexPath.row == 1){
        self.membersView.frame = CGRectMake(0, 0, Screen_Width, self.membersView.viewHeight);
        self.membersView.isSystemGroup = YES;
        [cell.contentView addSubview:_membersView];
    }
    else if(indexPath.row == 2){
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 0.5, Screen_Width, 0.5);
        lineView.backgroundColor = RGBACOLOR(166, 166, 166, 0.3);
        [cell.contentView addSubview:lineView];
        
        [self setCellLabelWithText:[NSString stringWithFormat:@"全部成员(%zd)",[self.membersView.members count]] AndCell:cell];
    }
    else if(indexPath.row == 3){
        UIView * bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(0, 79, Screen_Width, 3);
        bottomView.backgroundColor = SDBackGroudColor;
        [cell.contentView addSubview:bottomView];
        [cell.contentView addSubview:self.endMeetingBtn];
    }
    if(indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 3){
        cell.contentView.backgroundColor = SDBackGroudColor;
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 2){
        CXDDXMeetingDetailInfoAllMembersViewController * meetingDetailInfoAllMembersViewController = [[CXDDXMeetingDetailInfoAllMembersViewController alloc] initWithCXDDXVoiceMeetingDetailAllMembersArray:self.membersView.members];
        [self.navigationController pushViewController:meetingDetailInfoAllMembersViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    //    else if(indexPath.row == 4){
    //        if(self.isMeetingCreater){
    //            CXDDXMeetingDetailInfoChangeMeetingNameViewController * meetingDetailInfoChangeMeetingNameViewController  = [[CXDDXMeetingDetailInfoChangeMeetingNameViewController alloc] initWithCXDDXVoiceMeetingDetailModel:self.model];
    //            [self.navigationController pushViewController:meetingDetailInfoChangeMeetingNameViewController animated:YES];
    //            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //            }
    //        }else{
    //            TTAlert(@"只有会议创建者才能修改会议议题");
    //        }
    //    }
}

#pragma mark 结束会议
- (void)endMeetingBtnClick{
    [self setDeleteRecordsConfirmViewDisplay:YES];
}

#pragma mark - 删除聊天记录确认View
//如果弹出聊天记录确认删除View则需要覆盖一层coverView
-(UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.hidden = YES;
        _coverView.backgroundColor = RGBACOLOR(0, 0, 0, .3);
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
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = [NSString stringWithFormat:@"确定要结束语音会议吗?"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_deleteRecordConfirmView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_deleteRecordConfirmView).offset(15);
            make.leading.equalTo(_deleteRecordConfirmView).offset(15);
            make.trailing.equalTo(_deleteRecordConfirmView).offset(-15);
        }];
        
        // 确认按钮
        UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        ensureBtn.titleLabel.font = _titleLabel.font;
        [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [ensureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [ensureBtn addTarget:self action:@selector(deleteRecordsConfirmViewEnsureBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_deleteRecordConfirmView addSubview:ensureBtn];
        [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(_deleteRecordConfirmView).offset(-15);
        }];
        
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.titleLabel.font = _titleLabel.font;
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

//删除聊天记录View的取消按钮点击事件
-(void)deleteRecordsConfirmViewCancelBtnTapped
{
    [self setDeleteRecordsConfirmViewDisplay:NO];
}

//删除聊天记录View的确认按钮点击事件
-(void)deleteRecordsConfirmViewEnsureBtnTapped{
    [self setDeleteRecordsConfirmViewDisplay:NO];
    NSString *url = [NSString stringWithFormat:@"%@vedioMeet/isEnd/%zd", urlPrefix,[self.model.vedioMeetModel.eid integerValue]];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    [HttpTool postWithPath:url params:nil success:^(id JSON) {
        if ([JSON[@"status"] integerValue] == 200) {
            [weakSelf hideHud];
            self.model.vedioMeetModel.isEnd = @(2);
            [self.tableView reloadData];
            [self popToController];
            [[UIApplication sharedApplication].keyWindow makeToast:@"结束会议成功!" duration:2 position:@"center"];
        }else if ([JSON[@"status"] intValue] == 400) {
            [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }else{
            [weakSelf hideHud];
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
    }];
}

//确定是否显示删除聊天记录View和CoverView
-(void)setDeleteRecordsConfirmViewDisplay:(BOOL)needShow
{
    _titleLabel.text = [NSString stringWithFormat:@"确定要结束语音会议吗?"];
    self.deleteRecordConfirmView.hidden = self.coverView.hidden = !needShow;
}

#pragma mark - CXIMMembersViewDelegate
- (void)imMembersView:(CXIMMembersView *)membersView didTappedMemberItem:(CXIMMemberItem *)memberItem {
    if([memberItem.userModel.imAccount isEqualToString:VAL_HXACCOUNT]){
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.canPopViewController = YES;
        pivc.imAccount = memberItem.userModel.imAccount;
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else{
        if(![[CXLoaclDataManager sharedInstance] checkIsFriendWithUserModel:memberItem.userModel]){
            //搜索人
            NSString *url = [NSString stringWithFormat:@"%@sysuser/getSysUser/%@", urlPrefix,memberItem.userModel.imAccount];
            __weak __typeof(self)weakSelf = self;
            [self showHudInView:self.view hint:nil];
            [HttpTool getWithPath:url params:nil success:^(id JSON) {
                [weakSelf hideHud];
                NSDictionary *jsonDict = JSON;
                if ([jsonDict[@"status"] integerValue] == 200) {
                    if(JSON[@"data"]){
                        memberItem.userModel = [SDCompanyUserModel yy_modelWithDictionary:JSON[@"data"]];
                        memberItem.userModel.hxAccount = memberItem.userModel.imAccount;
                        memberItem.userModel.realName = memberItem.userModel.name;
                    }
                    SDIMAddFriendsDetailsViewController * addFriendsDetailsViewController = [[SDIMAddFriendsDetailsViewController alloc] init];
                    addFriendsDetailsViewController.userModel = memberItem.userModel;
                    [weakSelf.navigationController pushViewController:addFriendsDetailsViewController animated:YES];
                    if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                        weakSelf.navigationController.interactivePopGestureRecognizer.delegate = nil;
                    }
                    
                }else{
                    MAKE_TOAST(JSON[@"msg"]);
                }
            } failure:^(NSError *error) {
                [weakSelf hideHud];
                CXAlert(KNetworkFailRemind);
            }];
        }else{
            SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
            pivc.imAccount = memberItem.userModel.imAccount;
            pivc.canPopViewController = YES;
            [self.navigationController pushViewController:pivc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
    }
}

- (void)removeAllSubViews:(UIView *)view
{
    if(view && [view.subviews count] > 0){
        for(UIView * subView in view.subviews){
            [subView removeFromSuperview];
        }
    }
}

- (void)setCellLabelWithText:(NSString *)text AndCell:(UITableViewCell *)cell
{
    UILabel * groupChatNameLabel = [[UILabel alloc] init];
    groupChatNameLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing, (SDMeCellHeight - SDMainMessageFont)/2, 200, SDMainMessageFont);
    groupChatNameLabel.textAlignment = NSTextAlignmentLeft;
    groupChatNameLabel.backgroundColor = [UIColor clearColor];
    groupChatNameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    groupChatNameLabel.text = text;
    groupChatNameLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:groupChatNameLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
