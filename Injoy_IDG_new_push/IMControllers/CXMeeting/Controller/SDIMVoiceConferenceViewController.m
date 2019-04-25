//
//  SDIMVoiceConferenceViewController.m
//  InjoyCRM
//
//  Created by wtz on 16/8/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMVoiceConferenceViewController.h"
#import "CXIMHelper.h"
//#import "CXIMVoiceConferenceDetailViewController.h"
#import "CXMysugestListViewController.h"
#import "CXScanViewController.h"
#import "CXVoiceConferenceListCell.h"
#import "SDConversationCell.h"
#import "SDDataBaseHelper.h"
#import "SDIMAddFriendsViewController.h"
#import "SDIMChatViewController.h"
#import "SDIMReceiveAndPayMoneyViewController.h"
#import "SDIMSearchVIewController.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "CXIMService.h"
#import "SDIMVoiceConferenceViewController.h"
#import "SDMenuView.h"
#import "SDVoiceManager.h"
#import "UIView+CXCategory.h"

#import "CXIMVoiceConferenceDDXDetailViewController.h"


@interface SDIMVoiceConferenceViewController()<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, CXIMChatDelegate, CXIMGroupDelegate, SDMenuViewDelegate, UIGestureRecognizerDelegate>

/// 导航条
@property (strong, nonatomic) SDRootTopView* rootTopView;
/// 已选用户
@property (copy, nonatomic) NSArray* selectUserArr;
/// 表格
@property (strong, nonatomic) UITableView* contentTableView;
/// 数据源
@property (strong, nonatomic) NSMutableArray* dataSource;
/// 选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
/// 用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;
/// alertView
@property (nonatomic, strong) UIAlertView* alertView;

@end

@implementation SDIMVoiceConferenceViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [[CXIMService sharedInstance].chatManager addDelegate:self];
    [[CXIMService sharedInstance].groupManager addDelegate:self];
    
    [[self getRootTopView] setNavTitle:@"语音会议"];
    [[self getRootTopView] setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(popView)];
    [[self getRootTopView] setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.contentTableView.backgroundColor = SDBackGroudColor;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.tableFooterView = [[UIView alloc] init];
    self.contentTableView.bounces = YES;
    
    //修复UITableView的分割线偏移的BUG
    if ([self.contentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contentTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.contentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.contentTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.contentTableView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadConversations];
//    [self loadUnReadCalls];
    [[CXIMService sharedInstance].groupManager getJoinedGroups:^(NSArray<CXGroupInfo *> *groups, NSError *error) {
        if (!error) {
            if (self.dataSource) {
                [self.dataSource removeAllObjects];
            }
            /// 取出语音会议数组
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"groupType == %d", CXGroupTypeVoiceConference];
            self.dataSource = [[groups filteredArrayUsingPredicate:predicate] mutableCopy];
            [self sortDataSource];
            [self.contentTableView reloadData];
        }
        else {
            CXAlert(@"获取群组列表失败");
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
}

- (void)dealloc
{
    [[CXIMService sharedInstance].chatManager removeDelegate:self];
    [[CXIMService sharedInstance].groupManager removeDelegate:self];
}

#pragma mark - 内部方法
- (void)pushLocalNotification:(NSString*)inviter;
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        return;
    }
    //设置本地通知的触发时间（如果要立即触发，无需设置）
    localNotification.fireDate = [NSDate date];
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置通知的内容
    localNotification.alertBody = [NSString stringWithFormat:@"%@邀请你加入语音会议", inviter];
    //设置通知动作按钮的标题
    localNotification.alertAction = @"查看";
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //立即触发一个通知
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

//按照创建时间倒序排序
- (void)sortDataSource
{
    NSSortDescriptor* createTimeDesc = [NSSortDescriptor sortDescriptorWithKey:@"createTimeMillisecond" ascending:NO];
    NSArray* tempArr = [self.dataSource sortedArrayUsingDescriptors:@[ createTimeDesc]];
    self.dataSource = [tempArr mutableCopy];
}

- (void)loadConversations
{
    NSArray* arr = [[CXIMService sharedInstance].chatManager loadConversations];
    NSMutableArray* allConversationsArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (CXIMConversation * conversation in arr) {
        if (!conversation.isVoiceConference) {
            [allConversationsArray addObject:conversation];
        }
    }
    NSInteger unread = 0;
    for (CXIMConversation * conversation in allConversationsArray) {
        unread += conversation.unreadNumber;
    }
    //I_ChatCount
    NSInteger I_ChatCount = [self.view countNumBadge:IM_PUSH_GT,IM_PUSH_ZBKB,IM_PUSH_GSXW,IM_PUSH_NEWSLETTER/*,CX_NK_Push*/,nil];
    unread += I_ChatCount;
    NSInteger sysUnreadCount = 0;

    sysUnreadCount = [self.view countNumBadge:IM_SystemMessage,nil];//新版的系统消息推送,显示具体的数量,不再显示0或者1

    unread = unread + sysUnreadCount;
    NSString* bage = unread > 0 ? @(unread).stringValue : nil;
    RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
    [vc.tabBar.items[1] setBadgeValue:bage];
    if (VAL_SHOW_ADD_FRIENDS) {
        [vc.tabBar.items[2] setBadgeValue:@" "];
    }
    else {
        [vc.tabBar.items[2] setBadgeValue:@""];
    }
}

- (void)loadUnReadCalls
{
    NSArray* callRecords = [[[CXIMService sharedInstance].chatManager loadCallRecords] mutableCopy];
    
    NSInteger unread = 0;
    for (CXIMCallRecord* callRecord in callRecords) {
        if (!callRecord.responded) {
            unread++;
        }
    }
    RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
    if (unread > 0) {
        [vc.tabBar.items[1] setBadgeValue:@" "];
    }
    else {
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

- (void)searchBtnClick
{
    SDIMSearchVIewController* searchVIewController = [[SDIMSearchVIewController alloc] init];
    [self.navigationController pushViewController:searchVIewController animated:YES];
}

- (void)selectMenuViewDisappear
{
    _isSelectMenuSelected = NO;
    [_selectMemu removeFromSuperview];
    _selectMemu = nil;
}

- (void)sendMsgBtnEvent:(UIButton*)sender
{
    if (!_isSelectMenuSelected) {
        _isSelectMenuSelected = YES;
        NSArray* dataArray = @[ @"发起会议"];
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

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    [self selectMenuViewDisappear];
    
    if (cardID == 0) {
        [self showHudInView:self.view hint:nil];
        //发起会议
        __weak typeof(self) weakSelf = self;
        CXIDGGroupAddUsersViewController* selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
        selectColleaguesViewController.navTitle = @"发起会议";
        selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[ [CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]] ]];
        selectColleaguesViewController.selectContactUserCallBack = ^(NSArray* selectContactUserArr) {
            weakSelf.selectUserArr = [selectContactUserArr copy];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"设置会议名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = 1001;
            [alertView show];
        };
        [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
        [self hideHud];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString * cellName = @"CXVoiceConferenceListCell";
    CXVoiceConferenceListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[CXVoiceConferenceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    [cell setGroup:self.dataSource[indexPath.row]];
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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    CXGroupInfo* model = self.dataSource[indexPath.row];
    /// 判断语音会议是否结束
    BOOL result = [[[SDVoiceManager sharedVoiceManager] getValue:model.groupId] boolValue];
    VoiceConferenceType type = 0;
    if (result) {
        // 结束就播放
        type = playVoice;
    }
    else {
        // 没结束就录音
        type = recordingVoice;
    }
    if (model.groupType == CXGroupTypeVoiceConference) {
        CXIMVoiceConferenceDDXDetailViewController* infoVC = [[CXIMVoiceConferenceDDXDetailViewController alloc] initWithVoiceConferenceType:type groupInfo:model];
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else {
        UITextField* textFd = [alertView textFieldAtIndex:0];
        if (!textFd.text.length) {
            CXAlert(@"语音会议名称不能为空");
        }
        else {
            [self showHudInView:self.view hint:@"正在创建语音会议"];
            __weak typeof(self) weakSelf = self;
            [[CXIMService sharedInstance].groupManager createGroupWithName:textFd.text type:CXGroupTypeVoiceConference members:[self.selectUserArr valueForKey:@"hxAccount"] companyId:VAL_companyId completion:^(CXGroupInfo *group, NSError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //跳转到语音会议界面
                    CXIMVoiceConferenceDDXDetailViewController* IMVoiceConferenceDetailVC = [[CXIMVoiceConferenceDDXDetailViewController alloc] initWithVoiceConferenceType:recordingVoice groupInfo:group];
                    [self.navigationController pushViewController:IMVoiceConferenceDetailVC animated:YES];
                }
            }];
        }
    }
}

#pragma mark - CXIMServiceDelegate
- (void)CXIMService:(CXIMService*)service didAddedIntoGroup:(NSString*)groupName groupId:(NSString*)groupId inviter:(NSString*)inviter time:(NSNumber*)time;
{
    CXGroupInfo* group = [[CXIMService sharedInstance].groupManager loadGroupForId:groupId];
    group.createTimeMillisecond = time;
    if (group.groupType == CXGroupTypeVoiceConference) {
        SDCompanyUserModel* model = [[SDDataBaseHelper shareDB] getUserByhxAccount:group.owner];
        [self pushLocalNotification:model.realName];
        [self.dataSource insertObject:group atIndex:0];
        [self sortDataSource];
        [self.contentTableView reloadData];
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:KIMVoiceGroup];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [[AppDelegate get_RDVTabBarController].tabBar.items[tabBar_IMVoice] addBadge];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (_isSelectMenuSelected == YES) {
        [self selectMenuViewDisappear];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
