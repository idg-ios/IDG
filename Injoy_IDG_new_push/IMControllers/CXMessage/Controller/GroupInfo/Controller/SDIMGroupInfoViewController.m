//
//  CXGroupInfoNewViewController.m
//  SDIMApp
//
//  Created by wtz on SDMainMessageFont/3/SDMainMessageFont.
//  Copyright © 20SDMainMessageFont年 Rao. All rights reserved.
//
#import "CXIDGGroupAddUsersViewController.h"
#import "SDCompanyUserModel.h"
#import "SDIMGroupInfoViewController.h"
#import "SDIMDeleteGroupMembersViewController.h"
#import "UIColor+Category.h"
#import "Masonry.h"
#import "SDIMShieldGroupMessageViewController.h"
#import "SDIMChangeGroupNameViewController.h"
#import "CXIMMembersView.h"
#import "CXIMHelper.h"
#import "SDIMAllGroupChatMembersViewController.h"
#import "SDContactsDetailController.h"
#import "SDIMPersonInfomationViewController.h"
#import "HttpTool.h"
#import "SDDataBaseHelper.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import "CXLoaclDataManager.h"

#define ShieldingGroupMessages @"ShieldingGroupMessages"

@interface SDIMGroupInfoViewController ()<UITableViewDataSource,UITableViewDelegate,CXIMMembersViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CXGroupInfo *groupDetailInfo;

@property (nonatomic,strong) UIButton *dissmissGroupBtn; // 退出群组/解散群组

// 删除聊天记录确认view
@property (nonatomic,strong) UIView *deleteRecordConfirmView;

// 遮盖view
@property (nonatomic,strong) UIView *coverView;

@property (nonatomic,strong) NSString * buttonType;
//确认viewType
@property (nonatomic,strong) NSString * viewType;
//标题label
@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) SDRootTopView *rootTopView;

//存放添加了群主之后的群成员数组
@property (nonatomic,strong) NSMutableArray * memberIDArray;

@property (nonatomic, strong) CXIMMembersView *membersView;

@property (nonatomic,copy) NSString *groupId;

//是否是系统群，如果是系统群，则没有添加删除成员按钮
@property (nonatomic) BOOL isSystemGroup;


@end

@implementation SDIMGroupInfoViewController

- (instancetype)initSDIMGroupInfoViewControllerWithGroupId:(NSString *)groupId
{
    if (self = [super init]) {
        self.groupId = groupId;
        self.isSystemGroup = NO;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchGroupDetailInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (CXIMMembersView *)membersView {
    if (!_membersView) {
        _membersView = [[CXIMMembersView alloc] init];
        _membersView.delegate = self;
    }
    _membersView.isSystemGroup = self.isSystemGroup;
    return _membersView;
}

-(void)setupView{
    
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"聊天信息")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backViewController)];
    
    
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
    self.view.backgroundColor = SDBackGroudColor;
}

- (void)backViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取数据
-(void)fetchGroupDetailInfo{
    [[CXIMService sharedInstance].groupManager getGroupDetailInfoWithGroupId:self.groupId completion:^(CXGroupInfo *group, NSError *error) {
        if (!error) {
            [[CXLoaclDataManager sharedInstance] updateLocalDataWithGroupId:self.groupId AndGroup:group];
            self.groupDetailInfo = group;
            
            if([_groupDetailInfo.owner hasPrefix:@"100000"]){
                self.isSystemGroup = YES;
            }
            
            //memberIDArray用来存群成员的userID
            _memberIDArray = [[NSMutableArray alloc]initWithCapacity:0];
            for(CXGroupMember * member in self.groupDetailInfo.members){
                [_memberIDArray addObject:member.userId];
            }
            BOOL ownerIn = NO;
            for (NSString * userID in _memberIDArray) {
                if ([userID isEqualToString:self.groupDetailInfo.owner]) {
                    ownerIn = YES;
                    break;
                }
            }
            if(!ownerIn){
                [_memberIDArray insertObject:self.groupDetailInfo.owner atIndex:0];
            }
            //如果我是群主
            if([self.groupDetailInfo.owner isEqualToString:VAL_HXACCOUNT]){
                _membersView.deleteButtonEnable = YES;
            }else{
                _membersView.deleteButtonEnable = NO;
            }
            if(_memberIDArray && [_memberIDArray count] > 10){
                NSArray * interceptionMem = [_memberIDArray subarrayWithRange:NSMakeRange(0, 10)];
                _membersView.members = [[CXLoaclDataManager sharedInstance]getUsersFromLocalGroupsWithGroupId:self.groupId AndMemberIMAccounts:interceptionMem];
            }else{
                _membersView.members = [[CXLoaclDataManager sharedInstance]getUsersFromLocalGroupsWithGroupId:self.groupId AndMemberIMAccounts:_memberIDArray];
            }
            BOOL isGroupOwner = [VAL_HXACCOUNT isEqualToString:self.groupDetailInfo.owner];
            
            [_dissmissGroupBtn setTitle:isGroupOwner ? @"解散群组" : @"退出群组" forState:UIControlStateNormal];
            _buttonType = [NSString stringWithFormat:@"%@",isGroupOwner ? @"解散群组" : @"退出群组"];
            _dissmissGroupBtn.enabled = YES;
            [_tableView reloadData];
        }
        else{
            TTAlert(@"加载失败");
        }
    }];
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
        return 15;
    }else if(indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6){
        return SDMeCellHeight;
    }else{
        return 80;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_groupDetailInfo.owner hasPrefix:@"100000"] && ![_groupDetailInfo.groupName containsString:@"推广"]){
        return 7;
    }
    return 8;
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
        [cell.contentView addSubview:_membersView];
    }
    else if(indexPath.row == 2){
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 0.5, Screen_Width, 0.5);
        lineView.backgroundColor = RGBACOLOR(166, 166, 166, 0.3);
        [cell.contentView addSubview:lineView];
        
        [self setCellLabelWithText:[NSString stringWithFormat:@"全部成员(%zd)",[_memberIDArray count]] AndCell:cell];
    }
    else if(indexPath.row == 4){
        [self setCellLabelWithText:@"清空聊天信息" AndCell:cell];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(5, SDMeCellHeight - 0.5, Screen_Width - 10, 0.5);
        lineView.backgroundColor = RGBACOLOR(166, 166, 166, 0.3);
        [cell.contentView addSubview:lineView];
        
    }
    else if(indexPath.row == 5){
        [self setCellLabelWithText:@"修改群名称" AndCell:cell];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(5, SDMeCellHeight - 0.5, Screen_Width - 10, 0.5);
        lineView.backgroundColor = RGBACOLOR(166, 166, 166, 0.3);
        [cell.contentView addSubview:lineView];
    }
    else if(indexPath.row == 6){
        [self setCellLabelWithText:@"屏蔽群消息" AndCell:cell];
    }
    else if(indexPath.row == 7){
        UIView * bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(0, 79, Screen_Width, 3);
        bottomView.backgroundColor = SDBackGroudColor;
        [cell.contentView addSubview:bottomView];
        
        // 解散群组
        _dissmissGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dissmissGroupBtn setTitle:_buttonType forState:UIControlStateNormal];
        [_dissmissGroupBtn setTitle:_buttonType forState:UIControlStateHighlighted];
        _dissmissGroupBtn.enabled = YES;
        [_dissmissGroupBtn setBackgroundImage:SDQuitOrDeleteBtnColor.image forState:UIControlStateNormal];
        _dissmissGroupBtn.frame = CGRectMake(15, 15, Screen_Width - 30, SDMeCellHeight);
        _dissmissGroupBtn.layer.cornerRadius = 5;
        _dissmissGroupBtn.layer.masksToBounds = YES;
        
        [_dissmissGroupBtn addTarget:self action:@selector(dismissGroupBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_dissmissGroupBtn];
    }
    if(indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 7){
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
        SDIMAllGroupChatMembersViewController * groupAllMembersViewController = [[SDIMAllGroupChatMembersViewController alloc] init];
        groupAllMembersViewController.groupId = self.groupId;
        groupAllMembersViewController.isSendCall = NO;
        groupAllMembersViewController.isSystemGroup = self.isSystemGroup;
        [self.navigationController pushViewController:groupAllMembersViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 4){
        [self setDeleteRecordsConfirmViewDisplay:YES AndType:@"删除本群的聊天记录"];
    }
    else if(indexPath.row == 5){
        if([_groupDetailInfo.owner isEqualToString:VAL_HXACCOUNT]){
            SDIMChangeGroupNameViewController * changeGroupNameViewController  = [[SDIMChangeGroupNameViewController alloc] initWithGroup:self.groupDetailInfo];
            [self.navigationController pushViewController:changeGroupNameViewController animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }else{
            TTAlert(@"只有群主才能修改群名称");
        }
        
    }
    else if(indexPath.row == 6){
        SDIMShieldGroupMessageViewController * shieldGroupMessageViewController = [[SDIMShieldGroupMessageViewController alloc] initWithGroup:_groupDetailInfo];
        [self.navigationController pushViewController:shieldGroupMessageViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        
    }
}

#pragma mark 解散群组/退出群组
-(void)dismissGroupBtnTapped:(UIButton *)sender{
    [self setDeleteRecordsConfirmViewDisplay:YES AndType:_buttonType];
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
        if([self.viewType isEqualToString:@"删除本群的聊天记录"]){
            _titleLabel.text = [NSString stringWithFormat:@"确定删除本群的聊天记录吗?"];
        }else if([self.viewType isEqualToString:@"解散群组"]){
            _titleLabel.text = [NSString stringWithFormat:@"确定解散群聊吗?"];
        }else if([self.viewType isEqualToString:@"退出群组"]){
            _titleLabel.text = [NSString stringWithFormat:@"确定退出群聊吗?"];
        }
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
    [self setDeleteRecordsConfirmViewDisplay:NO AndType:self.viewType];
}

//删除聊天记录View的确认按钮点击事件
-(void)deleteRecordsConfirmViewEnsureBtnTapped{
    [self setDeleteRecordsConfirmViewDisplay:NO AndType:self.viewType];
    if([self.viewType isEqualToString:@"删除本群的聊天记录"]){
        BOOL success = [[CXIMService sharedInstance].chatManager removeMessagesForChatter:self.groupId];
        if (success) {
            //因为清空聊天记录之后返回群组聊天页面之后，无法刷新页面，所以这里发通知给chatViewController
            [[NSNotificationCenter defaultCenter] postNotificationName:deleteGroupHistoryChatMessageNotification object:nil userInfo:nil];
            
            TTAlert(@"清空聊天记录成功");
        }
        else{
            TTAlert(@"清空聊天记录失败");
        }
    }else if([self.viewType isEqualToString:@"解散群组"]){
        [self showHudInView:self.view hint:@"正在解散群组"];
        __weak typeof(self) wself = self;
        [[CXIMService sharedInstance].groupManager dismissGroup:_groupDetailInfo.groupId completion:^(NSError *error) {
            [wself hideHud];
            if (!error) {
                [wself.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                TTAlert(@"解散群组失败");
            }
        }];
    }else if([self.viewType isEqualToString:@"退出群组"]){
        [self showHudInView:self.view hint:@"正在退出群组"];
        __weak typeof(self) wself = self;
        [[CXIMService sharedInstance].groupManager exitGroup:_groupDetailInfo.groupId completion:^(NSError *error) {
            if (!error) {
                [wself hideHud];
                if([_groupDetailInfo.owner hasPrefix:@"100000"] && [_groupDetailInfo.groupName containsString:@"推广"]){
                    NSString * path = [NSString stringWithFormat:@"%@group/reduceNum",urlPrefix];
                    __weak __typeof(self)weakSelf = self;
                    [HttpTool postWithPath:path params:@{@"groupId":self.groupId} success:^(NSDictionary *JSON) {
                        if ([JSON[@"status"] integerValue] == 200) {
                            
                        }
//                        else if ([JSON[@"status"] intValue] == 400) {
//                            [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//                        }
                        else{
                            [weakSelf.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
                        }
                    } failure:^(NSError *error) {
                        CXAlert(KNetworkFailRemind);
                    }];
                }
                [wself.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                [wself hideHud];
                TTAlert(@"退出群组失败");
            }
        }];
        
    }
}

//确定是否显示删除聊天记录View和CoverView
-(void)setDeleteRecordsConfirmViewDisplay:(BOOL)needShow AndType:(NSString *)type
{
    self.viewType = [NSString stringWithFormat:@"%@",type];
    if([self.viewType isEqualToString:@"删除本群的聊天记录"]){
        _titleLabel.text = [NSString stringWithFormat:@"确定删除本群的聊天记录吗?"];
    }else if([self.viewType isEqualToString:@"解散群组"]){
        _titleLabel.text = [NSString stringWithFormat:@"确定解散群聊吗?"];
    }else if([self.viewType isEqualToString:@"退出群组"]){
        _titleLabel.text = [NSString stringWithFormat:@"确定退出群聊吗?"];
    }
    
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

- (void)imMembersView:(CXIMMembersView *)membersView didTappedAddButton:(void *)none {
    [self showHudInView:self.view hint:@"加载中"];
    __weak typeof(self) wself = self;
    CXIDGGroupAddUsersViewController * selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
    selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:[[CXLoaclDataManager sharedInstance]getUsersFromLocalGroupsWithGroupId:self.groupId AndMemberIMAccounts:_memberIDArray]];
    selectColleaguesViewController.navTitle = @"添加成员";
    selectColleaguesViewController.selectContactUserCallBack = ^(NSArray * selectContactUserArr){
        NSMutableArray<NSString *> *members = [NSMutableArray array];
        for (SDCompanyUserModel *user in selectContactUserArr) {
            [members addObject:user.imAccount];
        }
        if (members.count) {
            [[CXIMService sharedInstance].groupManager erpAddGroupMembersWithGroupId:wself.groupId members:[CXIMHelper getGroupMembersByIMAcocountArray:members] user:[CXIMHelper getGroupMemberByIMAcocount:VAL_HXACCOUNT] completion:^(NSArray<CXGroupMember *> *newMembers, NSError *error) {
                if (!error) {
                    [wself fetchGroupDetailInfo];
                }
                else {
                    TTAlert(error.localizedDescription);
                }
            }];
        }
    };
    
    [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
    [self hideHud];
}

- (void)imMembersView:(CXIMMembersView *)membersView didTappedDeleteButton:(void *)none {
    __weak typeof(self) wself = self;
    SDIMDeleteGroupMembersViewController *vc = [[SDIMDeleteGroupMembersViewController alloc] init];
    vc.groupId = wself.groupId;
    [wself.navigationController pushViewController:vc animated:YES];
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
