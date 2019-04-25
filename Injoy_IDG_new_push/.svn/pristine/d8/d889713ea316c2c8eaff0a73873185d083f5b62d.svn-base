//
//  SDIMCallViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/8.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMCallViewController.h"
#import "SDMenuView.h"
#import "AppDelegate.h"
#import "SDIMVoiceAndVideoCallViewController.h"
#import "SDPermissionsDetectionUtils.h"
#import "CXIMHelper.h"
#import "SDIMCallListCell.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "SDIMChatViewController.h"
#import "SDChatManager.h"
#import "SDIMAddFriendsViewController.h"
#import "SDIMReceiveAndPayMoneyViewController.h"
#import "SDIMSearchVIewController.h"
#import "CXScanViewController.h"
#import "CXMysugestListViewController.h"
#import "SDIMAllGroupChatMembersViewController.h"
#import "UIView+CXCategory.h"

@interface SDIMCallViewController () <SDMenuViewDelegate, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

/**
 *  顶部视图
 */
@property (nonatomic, strong) SDRootTopView *rootTopView;

/**
 *  选择菜单
 */
@property (nonatomic, strong) SDMenuView *selectMemu;

/**
 *  表格视图
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  通话记录列表
 */
@property (nonatomic, strong) NSMutableArray<CXIMCallRecord *> *callRecords;


@property (nonatomic, strong) NSArray* chatContactsArray;

//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;
@property (nonatomic, strong) UIAlertView* alertView;

//最近通话的headerView
@property (nonatomic, strong) UIView * headerView;
@end

@implementation SDIMCallViewController

static NSString *cellID = @"SDIMCallListItemCell";

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadConversations];
    NSMutableArray * callRecords = [[[CXIMService sharedInstance].chatManager loadCallRecords] mutableCopy];
    for(CXIMCallRecord * callRecord in callRecords){
        if(!callRecord.responded){
            [[CXIMService sharedInstance].chatManager setCallRecordResponded:callRecord.ID];
        }
    }
//    [self loadUnReadCalls];
    self.callRecords = [[[CXIMService sharedInstance].chatManager loadCallRecords] mutableCopy];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isSelectMenuSelected = NO;
    
    [self setupView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
}

#pragma mark - 内部方法
- (void)loadConversations
{
    NSArray* arr = [[CXIMService sharedInstance].chatManager loadConversations];
    NSMutableArray * allConversationsArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(CXIMConversation * conversation in arr){
        if(!conversation.isVoiceConference){
            [allConversationsArray addObject:conversation];
        }
    }
    NSInteger unread = 0;
    for (CXIMConversation * conversation in allConversationsArray) {
        unread += conversation.unreadNumber;
    }
    //I_ChatCount
    NSInteger I_ChatCount = [self.view countNumBadge:IM_PUSH_GT,IM_PUSH_ZBKB,IM_PUSH_GSXW,IM_PUSH_NEWSLETTER,/*CX_NK_Push,*/nil];
    unread += I_ChatCount;
    NSInteger sysUnreadCount = 0;

    sysUnreadCount = [self.view countNumBadge:IM_SystemMessage,nil];//新版的系统消息推送,显示具体的数量,不再显示0或者1
    unread = unread + sysUnreadCount;
    NSString * bage = unread > 0 ? @(unread).stringValue : nil;
    RDVTabBarController *vc = [AppDelegate get_RDVTabBarController];
    [vc.tabBar.items[1] setBadgeValue:bage];
    if(VAL_SHOW_ADD_FRIENDS){
        [vc.tabBar.items[2] setBadgeValue:@" "];
    }else{
        [vc.tabBar.items[2] setBadgeValue:@""];
    }
}

- (void)loadUnReadCalls
{
    NSArray * callRecords = [[[CXIMService sharedInstance].chatManager loadCallRecords] mutableCopy];
    
    NSInteger unread = 0;
    for(CXIMCallRecord * callRecord in callRecords){
        if(!callRecord.responded){
            unread++;
        }
    }
    RDVTabBarController *vc = [AppDelegate get_RDVTabBarController];
    if(unread > 0){
        [vc.tabBar.items[1] setBadgeValue:@" "];
    }else{
        [vc.tabBar.items[1] setBadgeValue:@""];
    }
}

- (void)tapGestureEvent:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGestureRecognizer locationInView:nil];
        //由于这里获取不到右上角的按钮，所以用location来获取到按钮的范围，把它排除出去
        if (![_selectMemu pointInside:[_selectMemu convertPoint:location fromView:self.view.window] withEvent:nil] && !(location.x > Screen_Width - 50 && location.y < navHigh)) {
            [self selectMenuViewDisappear];
        }
    }
}

- (void)setupView {
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"通话"];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add"] addTarget:self action:@selector(rightBarItemTapped:)];
//    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:AppDelegate.class action:@selector(jumpBackFromIMModule)];
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(Screen_Width - 90, 20 + 7, 40, 40);
    [searchBtn setImage:[UIImage imageNamed:@"msgSearch"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"msgSearch"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.rootTopView addSubview:searchBtn];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - 49);
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    _headerView = [[UIView alloc] init];
    _headerView.frame = CGRectMake(0, 0, Screen_Width, 30);
    _headerView.backgroundColor = SDBackGroudColor;
    UILabel * recentCallsLabel = [[UILabel alloc] init];
    recentCallsLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing, (30 - SDSectionTitleFont)/2, 200, SDSectionTitleFont);
    recentCallsLabel.text = @"最近通话";
    recentCallsLabel.textAlignment = NSTextAlignmentLeft;
    recentCallsLabel.font = [UIFont systemFontOfSize:SDSectionTitleFont];
    recentCallsLabel.textColor = SDSectionTitleColor;
    [_headerView addSubview:recentCallsLabel];
    
    self.tableView.tableHeaderView = _headerView;
    
    self.tableView.backgroundColor = SDBackGroudColor;
}

- (void)searchBtnClick
{
    SDIMSearchVIewController * searchVIewController = [[SDIMSearchVIewController alloc] init];
    [self.navigationController pushViewController:searchVIewController animated:YES];
}

- (void)rightBarItemTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!_isSelectMenuSelected) {
        _isSelectMenuSelected = YES;
        NSArray* dataArray = @[ @"发起通话"];
        NSArray* imageArray = @[ @"addGroupMessage"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    else {
        [self selectMenuViewDisappear];
    }
}

- (void)selectMenuViewDisappear
{
    _isSelectMenuSelected = NO;
    [_selectMemu removeFromSuperview];
    _selectMemu = nil;
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    [self selectMenuViewDisappear];
    
    if (cardID == 0) {
        SDIMAllGroupChatMembersViewController * groupAllMembersViewController = [[SDIMAllGroupChatMembersViewController alloc] init];
        groupAllMembersViewController.isSendCall = YES;
        [self presentViewController:groupAllMembersViewController animated:YES completion:nil];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (_isSelectMenuSelected == YES) {
        [self selectMenuViewDisappear];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.callRecords.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SDCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellName = @"SDIMCallListCell";
    SDIMCallListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[SDIMCallListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
   
    [cell setCallRecord:self.callRecords[indexPath.row]];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CXIMCallRecord * record = self.callRecords[indexPath.row];
    if (![SDPermissionsDetectionUtils checkCanRecordFree]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音权限" message:@"您可以在“隐私设置”中开启语音权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        SDIMVoiceAndVideoCallViewController * videoCallController = [[SDIMVoiceAndVideoCallViewController alloc] initWithInitiateOrAcceptCallType:SDIMCallInitiateType];
        videoCallController.audioOrVideoType= CXIMMediaCallTypeAudio;
        videoCallController.chatter = record.chatter;
        videoCallController.chatterDisplayName = [CXIMHelper getRealNameByAccount:record.chatter];
        [self presentViewController:videoCallController animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CXIMCallRecord *record = self.callRecords[indexPath.row];
        BOOL isSuccess = [[CXIMService sharedInstance].chatManager removeCallRecordForId:record.ID];
        if (isSuccess) {
            [self.callRecords removeObject:record];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField* textField = [_alertView textFieldAtIndex:0];
        NSString* groupName = trim(textField.text);
        if (groupName.length <= 0) {
            TTAlert(@"群组名称不能为空");
            return;
        }
        if([_chatContactsArray count] > 49){
            [self.view makeToast:@"群聊人数最多50人，请重新选择！" duration:2 position:@"center"];
            return;
        }
        NSMutableArray* hxAccount = [[_chatContactsArray valueForKey:@"hxAccount"] mutableCopy];
        
        if (hxAccount.count) {
            NSMutableArray* members = [NSMutableArray array];
            [hxAccount enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL* stop) {
                [members addObject:obj];
            }];
            [self showHudInView:self.view hint:@"正在创建群组"];
            __weak typeof(self) weakSelf = self;
            [[CXIMService sharedInstance].groupManager erpCreateGroupWithName:groupName type:CXGroupTypeNormal owner:[[CXLoaclDataManager sharedInstance] getGroupUserFromLocalContactsDicWithIMAccount:VAL_HXACCOUNT] members:[[CXLoaclDataManager sharedInstance]  getGroupUsersFromLocalContactsDicWithIMAccountArray:members] completion:^(CXGroupInfo *group, NSError *error) {
                [weakSelf hideHud];
                if (!error) {
                    SDIMChatViewController* chat = [[SDIMChatViewController alloc] init];
                    chat.chatter = group.groupId;
                    chat.chatterDisplayName = groupName;
                    chat.isGroupChat = YES;
                    [weakSelf.navigationController pushViewController:chat animated:YES];
                }
                else {
                    TTAlert(@"创建失败");
                }
                
            }];
        }
    }
    else {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end
