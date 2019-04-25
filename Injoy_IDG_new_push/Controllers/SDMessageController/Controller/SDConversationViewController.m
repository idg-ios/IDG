//
//  SDConversationViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/3/31.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDConversationViewController.h"
#import "SDIMLib.h"
#import "SDConversationCell.h"
#import "SDIMChatViewController.h"
#import "SDChatManager.h"
#import "SDMenuView.h"
#import "SDSendRangeViewController.h"
#import "SDChatMessageManager.h"
#import "SDDataBaseHelper.h"
#import "SDSignInViewController.h"
#import "SDInviteViewController.h"
#import "SDMailRemindViewController.h"
#import "SDSocketCacheManager.h"
#import "SDChatListCell.h"
#import "SDMailAccountSettingController.h"
#import "SDGroupNoticeListController.h"
#import "SDAnnounceViewController.h"
#import "SDVoiceConferenceListViewController.h"
#import "CXHomeController.h"
#import "AppDelegate.h"

#define KF_ACCOUNT_KEY @"sdim.kfaccount"

@interface SDConversationViewController ()<UITableViewDataSource,UITableViewDelegate,SDMenuViewDelegate,UIGestureRecognizerDelegate,SDIMServiceDelegate>

@property (nonatomic,strong) SDRootTopView *rootTopView;

@property (nonatomic,strong) NSMutableArray *conversations;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) SDIMConversation *conversation;

//选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;


/// 群组
@property (nonatomic, strong) NSMutableArray* groupAry;
/// 第一个section的元素
@property (nonatomic, strong) NSMutableArray* firstSectionAry;
/// 数据源
@property (nonatomic, strong) NSMutableDictionary* sourceDict;
//网络状态View
@property (nonatomic, strong) UIView* networkStateView;
/// 数据源
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) UIButton* selectedButton;
@property (nonatomic, strong) NSArray* chatContactsArray;
@property (strong, nonatomic) NSMutableArray* contactUserArr;

// 标记
// 是否第一次加载
@property (nonatomic, assign) BOOL isConversationFirstLoad;


@end

@implementation SDConversationViewController

#pragma mark - 生命周期

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataSources];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:socketNotify object:nil];
    [self refreshDataSource];
    [self.tableView reloadData];
}

- (void)notificationAction:(NSNotification*)nsnotifi
{
    NSMutableDictionary* params = [[nsnotifi object] mutableCopy];
    for (NSString* key in [params allKeys]) {
        if ([key isEqualToString:sysnotice_socket]) {
            //公告
            SDChatListCell* cell = (SDChatListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            NSInteger flag = [[SDSocketCacheManager shareCacheManager] getNumFromSocketType:sysnotice_socket];
            cell.unreadCount = flag;
        }
        else if ([key isEqualToString:notice_socket]) {
            //消息通知
            SDChatListCell* cell = (SDChatListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            NSInteger flag = [[SDSocketCacheManager shareCacheManager] getNumFromSocketType:notice_socket];
            cell.unreadCount = flag;
        }
    }
    [_tableView reloadData];
}


/// 刷新数据源
- (void)refreshDataSource
{
    self.dataSource = self.conversations;
    
    [self.sourceDict setValue:self.firstSectionAry forKey:@"0"];
    [self.sourceDict setValue:self.dataSource forKey:@"1"];
    [self.tableView reloadData];
}

- (void)reloadMsgTableView:(UITableView*)sender
{
    [sender reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(reloadMsgTableView:) withObject:self.tableView afterDelay:0.5f];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SDIMService sharedInstance] addDelegate:self];
    self.isConversationFirstLoad = YES;
    [self setupView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jumpToSDMailRemindViewController:)
                                                 name:@"jumpToMailList"
                                               object:nil];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)jumpToSDMailRemindViewController:(id)sender
{
    SDMailRemindViewController* mailVC = [[SDMailRemindViewController alloc] init];
    [self.navigationController pushViewController:mailVC animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark-UIGestureRecognizerDelegate
- (void)tapGestureEvent:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGestureRecognizer locationInView:nil];
        if (![_selectMemu pointInside:[_selectMemu convertPoint:location fromView:self.view.window] withEvent:nil]) {
            _selectedButton.selected = NO;
            [_selectMemu removeFromSuperview];
        }
    }
}

/// 数据源
- (NSMutableDictionary*)sourceDict
{
    if (nil == _sourceDict) {
        _sourceDict = [[NSMutableDictionary alloc] init];
    }
    return _sourceDict;
}

/// 第一个section的元素
- (NSMutableArray*)firstSectionAry
{
    NSArray* ary = @[ LocalString(@"公告"), LocalString(@"邮箱提醒"), LocalString(@"消息通知"), @"语音会议" ];
    return [ary mutableCopy];
}

/// 群组
- (NSMutableArray*)groupAry
{
    if (nil == _groupAry) {
        _groupAry = [[NSMutableArray alloc] init];
    }
    return _groupAry;
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        // 没连接
        self.tableView.tableHeaderView = [self networkStateView];
    }
    else {
        self.tableView.tableHeaderView = nil;
    }
}

- (UIView*)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (NSMutableArray*)dataSource
{
    if (nil == _dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)loadDataSources{
    NSString *kfAccount = [[NSUserDefaults standardUserDefaults] objectForKey:KF_ACCOUNT_KEY];
    self.conversations = [[[SDIMService sharedInstance] loadConversations] mutableCopy];
    
    if (self.isConversationFirstLoad) {
        if (kfAccount) {
            [[SDIMService sharedInstance] removeConversationForChatter:kfAccount];
            self.conversations = [[[SDIMService sharedInstance] loadConversations] mutableCopy];
        }
        
        NSArray* kfArr = [[SDDataBaseHelper shareDB] getKeFuArr];
        if (!kfArr.count) {
            return;
        }
        
        SDCompanyUserModel *kfUserModel = kfArr.firstObject;
        SDIMConversation *kfConversation = [[SDIMService sharedInstance] createConversationForChatter:kfUserModel.hxAccount displayName:kfUserModel.realName];
        [self.conversations insertObject:kfConversation atIndex:0];
        self.isConversationFirstLoad = NO;
        [[NSUserDefaults standardUserDefaults] setObject:kfUserModel.hxAccount forKey:KF_ACCOUNT_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 创建消息
        SDIMMessage *message = [[SDIMMessage alloc] init];
        message.type = SDIMMessageTypeChat;
        message.contentType = SDIMMessageContentTypeText;
        message.sender = kfUserModel.hxAccount;
        message.senderDisplayName = kfUserModel.realName;
        message.receiver = VAL_HXACCOUNT;
        NSString *myRealName = [[SDChatManager sharedChatManager] searchUserByHxAccount:VAL_HXACCOUNT].realName;
        myRealName = myRealName && myRealName.length ? myRealName : VAL_HXACCOUNT;
        message.receiverDisplayName = myRealName;
        NSString *content = [NSString stringWithFormat:@"您好,我是超享%@,欢迎您使用超享企业工作平台,有问题请咨询",kfUserModel.realName];
        message.body = [SDIMTextMessageBody bodyWithTextContent:content];
        [[SDIMService sharedInstance] saveMessageToDB:message];
        self.conversations = [[[SDIMService sharedInstance] loadConversations] mutableCopy];
    }
    else{
        SDIMConversation *kfConversation = nil;
        for (SDIMConversation *conversation in self.conversations) {
            if ([conversation.chatter isEqualToString:kfAccount]) {
                kfConversation = conversation;
                break;
            }
        }
        if (kfConversation) {
            [self.conversations removeObject:kfConversation];
            [self.conversations insertObject:kfConversation atIndex:0];
        }
    }
}

-(void)setupView{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"企信")];
    //[self.rootTopView setTopLogoImageViewShow];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backToHomeViewController:)];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - TabBar_Height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.bounces = YES;
    [self.view addSubview:self.tableView];
}

- (void)selectMenuViewDisappear
{
    _selectedButton.selected = NO;
    [_selectMemu removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:socketNotify object:nil];
}

- (void)backToHomeViewController:(UIButton*)sender
{
    CXHomeController *homeVC = [[CXHomeController alloc] init];
    AppDelegate *appDelegate =   [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = homeVC;
}

- (void)sendMsgBtnEvent:(UIButton*)sender
{
    if (self.isFromExternal) {
        
        __weak typeof(self) weakSelf = self;
        //发起聊天
        SDSendRangeViewController* srvc = [[SDSendRangeViewController alloc] init];
        srvc.isFromExternStaff = YES;
        
        //-----------------------------这个要修改---------------------------
        srvc.selectContactUserCallBack = ^(NSArray* selectContactUserArr) {
            [[SDChatMessageManager sharedChatMessageManager] analyticalArr:selectContactUserArr
                                                                 chatOrNot:YES
                                                            viewController:weakSelf
                                                      voiceConferenceTitle:nil
                                                                  groupAry:weakSelf.groupAry];
        };
        //-----------------------------这个要修改---------------------------
        
        srvc.isChat = YES;
        srvc.titleVal = @"选择同事";
        [self presentViewController:srvc
                           animated:YES
                         completion:^{
                             //
                         }];
    }
    else {
        
        _selectedButton = sender;
        //        _selectedButton.tag = ! _selectedButton.tag;
        _selectedButton.selected = !_selectedButton.selected;
        
        if (_selectedButton.selected == YES) {
            
            NSArray* dataArray = @[ @"发起聊天", @"发起会议", @"签到", @"邀请加入", @"超享客服" ];
            NSArray* imageArray = @[ @"add_chat", @"add_metting", @"menu_signin", @"menu_invite", @"menu_service" ];
            _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
            _selectMemu.delegate = self;
            [self.view addSubview:_selectMemu];
            [self.view bringSubviewToFront:_selectMemu];
        }
        else {
            [_selectMemu removeFromSuperview];
        }
    }
}

#pragma mark - SDIMServiceDelegate
- (void)sdIMService:(SDIMService *)service didReceiveChatMessage:(SDIMMessage *)message{
    [self loadDataSources];
    [self.tableView reloadData];
}

- (void)sdIMService:(SDIMService *)service didReceiveDelGroupMessageWithGroupId:(NSString *)groupId groupName:(NSString *)groupName time:(NSNumber *)time{
    [self loadDataSources];
    [self.tableView reloadData];
}

- (void)sdIMService:(SDIMService *)service didReceiveDismissGroupMessageWithGroupId:(NSString *)groupId dismissTime:(NSNumber *)dismissTime{
    [self loadDataSources];
    [self.tableView reloadData];
}

- (void)sdIMService:(SDIMService *)service didReceiveExitGroupWithGroupId:(NSString *)groupId{
    
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    //    _selectedButton.selected = NO;
    [_selectMemu removeFromSuperview];
    
    if (cardID == 0) {
        __weak typeof(self) weakSelf = self;
        //发起聊天
        SDSendRangeViewController* srvc = [[SDSendRangeViewController alloc] init];
        
        //-----------------------------这个要修改---------------------------
        
        srvc.selectContactUserCallBack = ^(NSArray* selectContactUserArr) {
            
            if (selectContactUserArr.count == 1) {
                [[SDChatMessageManager sharedChatMessageManager] analyticalArr:selectContactUserArr
                                                                     chatOrNot:YES
                                                                viewController:weakSelf
                                                          voiceConferenceTitle:nil
                                                                      groupAry:weakSelf.groupAry];
                //-----------------------------这个要修改-------------------
                
            }
            else {
                
                weakSelf.chatContactsArray = [selectContactUserArr mutableCopy];
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"设置群聊名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 1000;
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alertView show];
            }
        };
        srvc.isChat = YES;
        srvc.titleVal = @"选择同事";
        [self presentViewController:srvc
                           animated:YES
                         completion:^{
                             //
                         }];
    }
    else if (cardID == 1) {
        //发起会议
        __weak typeof(self) weakSelf = self;
        SDSendRangeViewController* sendRangeVC = [[SDSendRangeViewController alloc] init];
        sendRangeVC.isVoiceConference = YES;
        
        //-----------------------------这个要修改---------------------------
        sendRangeVC.selectContactUserCallBack = ^(NSArray* selectContactUserArr) {
            
            if (selectContactUserArr.count) {
                weakSelf.contactUserArr = [selectContactUserArr mutableCopy];
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"设置会议名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 1001;
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alertView show];
            }
            
        };
        //-----------------------------这个要修改---------------------------
        
        sendRangeVC.titleVal = @"通讯录";
        sendRangeVC.isChat = YES;
        [self presentViewController:sendRangeVC
                           animated:YES
                         completion:^{
                             //
                         }];
    }
    else if (cardID == 2) {
        SDSignInViewController* myloca = [[SDSignInViewController alloc] init];
        [self.navigationController pushViewController:myloca animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if (cardID == 3) {
        SDInviteViewController* invite = [[SDInviteViewController alloc] init];
        [self.navigationController pushViewController:invite animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return [self.firstSectionAry count];
    }
    return self.conversations.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString* identify = @"chatListCell";
        SDChatListCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[SDChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.currentPath = indexPath;
        cell.isFromChat = NO;
        
        id obj = [[self.sourceDict valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
        cell.name = @"";
        cell.time = @"";
        cell.imageURL = nil;
        cell.detailMsg = @"";
        cell.msgText = @"";
        
        cell.placeholderImage = nil;
        cell.cellIdentification = @"";
        if ([obj isKindOfClass:[NSString class]]) {
            cell.detailMsg = obj;
            
            if (self.isFromExternal) {
                cell.hidden = YES;
            }
            
            if ([obj isEqualToString:@"邮箱提醒"]) {
                cell.placeholderImage = [UIImage imageNamed:@"email.png"];
                cell.cellIdentification = @"cell";
            }
            else if ([obj isEqualToString:@"消息通知"]) {
                cell.placeholderImage = [UIImage imageNamed:@"messageRemind.png"];
                cell.cellIdentification = @"cell";
                cell.unreadCount = [[SDSocketCacheManager shareCacheManager] getNumFromSocketType:notice_socket];
            }
            else if ([obj isEqualToString:@"公告"]) {
                cell.placeholderImage = [UIImage imageNamed:@"notice.png"];
                cell.cellIdentification = @"cell";
                cell.unreadCount = [[SDSocketCacheManager shareCacheManager] getNumFromSocketType:sysnotice_socket];
            }
            else if ([obj isEqualToString:@"语音会议"]) {
                cell.placeholderImage = [UIImage imageNamed:@"voiceConference.png"];
                cell.cellIdentification = @"cell";
            }
        }
        // 刷新当前cell
        [cell reloadCurrentCellAction];
        return cell;
    }
    else{
        static NSString *ID = @"SDConversationCell";
        SDConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[SDConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.conversation = self.conversations[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(self.isFromExternal){
            return 0;
        }else{
            return 60;
        }
    }
    return kConversationCellHeight;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section)
        return 7;
    else
        return 0;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 14)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return footerView;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            NSString* userID = VAL_USERID;
            NSString* filePath = [NSString stringWithFormat:@"%@/%@emailArchiver.data", kMailFilePath, userID];
            NSData* unarchiverData = [[NSFileManager defaultManager] contentsAtPath:filePath];
            
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unarchiverData];
            NSString* emailAccount = [unarchiver decodeObjectForKey:KMailAccount];
            [unarchiver finishDecoding];
            
            if (emailAccount != nil) {
                /// 邮件列表
                SDMailRemindViewController* mailVc = [[SDMailRemindViewController alloc] init];
                [self.navigationController pushViewController:mailVc animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }
            else {
                /// 邮箱账号设置
                SDMailAccountSettingController* mailVC = [[SDMailAccountSettingController alloc] init];
                [self presentViewController:mailVC animated:YES completion:nil];
            }
        }
        else if (indexPath.row == 1) {
            /// 消息通知
            SDGroupNoticeListController* gnlc = [[SDGroupNoticeListController alloc] init];
            if (![self.parentViewController.navigationController.viewControllers containsObject:gnlc]) {
                [self.parentViewController.navigationController pushViewController:gnlc animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }
            SDChatListCell* currentCell = (SDChatListCell*)[tableView cellForRowAtIndexPath:indexPath];
            [currentCell setUnreadCount:0];
            [[SDSocketCacheManager shareCacheManager] setTypeValueFromSocketType:notice_socket];
        }
        else if (indexPath.row == 2) {
            /// 公告
            SDAnnounceViewController* announceVc = [[SDAnnounceViewController alloc] init];
            if (![self.parentViewController.navigationController.viewControllers containsObject:announceVc]) {
                [self.parentViewController.navigationController pushViewController:announceVc animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }
            SDChatListCell* currentCell = (SDChatListCell*)[tableView cellForRowAtIndexPath:indexPath];
            [currentCell setUnreadCount:0];
            [[SDSocketCacheManager shareCacheManager] setTypeValueFromSocketType:sysnotice_socket];
        }
        else if (indexPath.row == 3) {
            /// 语音会议
            SDVoiceConferenceListViewController* workVC = [[SDVoiceConferenceListViewController alloc] init];
            if (![self.parentViewController.navigationController.viewControllers containsObject:workVC])
                [self.parentViewController.navigationController pushViewController:workVC animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SDIMConversation *conversation = self.conversations[indexPath.row];
        SDIMChatViewController * chatViewController = [[SDIMChatViewController alloc] init];
        chatViewController.chatter = conversation.chatter;
        chatViewController.chatterDisplayName = [[[SDChatManager sharedChatManager] searchUserByHxAccount:conversation.chatter] realName] ? [[[SDChatManager sharedChatManager] searchUserByHxAccount:conversation.chatter] realName] : conversation.chatter;
        chatViewController.isGroupChat = conversation.type == SDIMMessageTypeGroupChat;
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SDIMConversation *conversation = self.conversations[indexPath.row];
        [[SDIMService sharedInstance] removeConversationForId:@(conversation.ID).stringValue];
        [self loadDataSources];
        [self.tableView reloadData];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (_selectedButton.selected == YES) {
        _selectedButton.selected = NO;
        [_selectMemu removeFromSuperview];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:goBackJumpToChatVC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpToMailList" object:nil];
}

@end
