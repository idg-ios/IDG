/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>还没改

//第三个要改的，群组聊天信息页面
#import "ChatGroupDetailViewController.h"
#import "SDChatManager.h"
#import "ContactSelectionViewController.h"
#import "EMGroup.h"
#import "ContactView.h"
#import "GroupSubjectChangingViewController.h"
//#import "SDGroupSettingContainer.h"
#import "SDSelectUserChatViewController.h"
#import "SDSendRangeViewController.h"
#import "SDDataBaseHelper.h"
#import "UIImageView+EMWebCache.h"
#import "AppDelegate.h"

#pragma mark - ChatGroupDetailViewController

#define kColOfRow 4
#define kContactSize 70

@interface ChatGroupDetailViewController () <IChatManagerDelegate, EMChooseViewDelegate, UIActionSheetDelegate>

- (void)unregisterNotifications;
- (void)registerNotifications;

@property (nonatomic) GroupOccupantType occupantType;
@property (strong, nonatomic) EMGroup* chatGroup;

@property (strong, nonatomic) NSMutableArray* dataSource;
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIButton* addButton;

@property (strong, nonatomic) UIView* footerView;
@property (strong, nonatomic) UIButton* clearButton;
@property (strong, nonatomic) UIButton* exitButton;
@property (strong, nonatomic) UIButton* dissolveButton;
@property (strong, nonatomic) UIButton* configureButton;
@property (strong, nonatomic) UILongPressGestureRecognizer* longPress;
@property (strong, nonatomic) ContactView* selectedContact;
@property (nonatomic, strong) NSMutableArray* deptIdArr;
@property (nonatomic, strong) NSMutableArray* contactArray;
@property (nonatomic, strong) NSMutableArray* deptArray;

- (void)dissolveAction;
- (void)clearAction;
- (void)exitAction;
- (void)configureAction;

@end

@implementation ChatGroupDetailViewController

- (void)registerNotifications
{
    [self unregisterNotifications];
    //这里要干掉
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications
{
    //这里要干掉，这是用环信来获取当前用户的登陆信息
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc
{
    [self unregisterNotifications];
}

- (instancetype)initWithGroup:(EMGroup*)chatGroup
{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = GroupOccupantTypeMember;
        [self registerNotifications];
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString*)chatGroupId
{
    EMGroup* chatGroup = nil;
    //这里要干掉，这是用环信来获取当前用户的群组列表
    NSArray* groupArray = [[EaseMob sharedInstance].chatManager groupList];
    for (EMGroup* group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }

    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }

    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }

    return self;
}

- (void)viewDidLoad
{
    // 群组从部门增加人员后跳转到群组详情
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:groupHasSelectPersonJumpToGroupDetail
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification* note) {
                                                      NSArray* personAry = [note object];
                                                      NSMutableArray* selectPersonAry = [[NSMutableArray alloc] initWithCapacity:[personAry count]];
                                                      // 将SDCompanyUserModel转化成EMBuddy
                                                      for (SDCompanyUserModel* model in personAry) {
                                                          EMBuddy* buddy = [EMBuddy buddyWithUsername:model.hxAccount];
                                                          buddy.followState = eEMBuddyFollowState_FollowedBoth;
                                                          [selectPersonAry addObject:buddy];
                                                      }

                                                      [weakSelf viewController:nil didFinishSelectedSources:selectPersonAry];
                                                  }];

    [super viewDidLoad];

    self.tableView.tableFooterView = self.footerView;

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBansChanged) name:@"GroupBansChanged" object:nil];

    [self fetchGroupInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - getter

- (UIScrollView*)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, kContactSize)];
        _scrollView.tag = 0;

        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kContactSize - 10, kContactSize - 10)];
        [_addButton setImage:[UIImage imageNamed:@"group_participant_add"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"group_participant_addHL"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];

        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteContactBegin:)];
        _longPress.minimumPressDuration = 0.5;
    }

    return _scrollView;
}

- (UIButton*)clearButton
{
    if (_clearButton == nil) {
        _clearButton = [[UIButton alloc] init];
        [_clearButton setTitle:NSLocalizedString(@"group.removeAllMessages", @"remove all messages") forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
        [_clearButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
    }

    return _clearButton;
}

- (UIButton*)dissolveButton
{
    if (_dissolveButton == nil) {
        _dissolveButton = [[UIButton alloc] init];
        [_dissolveButton setTitle:NSLocalizedString(@"group.destroy", @"dissolution of the group") forState:UIControlStateNormal];
        [_dissolveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dissolveButton addTarget:self action:@selector(dissolveAction) forControlEvents:UIControlEventTouchUpInside];
        [_dissolveButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
    }

    return _dissolveButton;
}

- (UIButton*)exitButton
{
    if (_exitButton == nil) {
        _exitButton = [[UIButton alloc] init];
        [_exitButton setTitle:NSLocalizedString(@"group.leave", @"quit the group") forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        [_exitButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
    }

    return _exitButton;
}

- (UIView*)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 160)];
        _footerView.backgroundColor = [UIColor clearColor];

        self.clearButton.frame = CGRectMake(20, 40, _footerView.frame.size.width - 40, 35);
        [_footerView addSubview:self.clearButton];

        self.dissolveButton.frame = CGRectMake(20, CGRectGetMaxY(self.clearButton.frame) + 30, _footerView.frame.size.width - 40, 35);

        self.exitButton.frame = CGRectMake(20, CGRectGetMaxY(self.clearButton.frame) + 30, _footerView.frame.size.width - 40, 35);
    }

    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.occupantType == GroupOccupantTypeOwner) {
        return 5;
    }
    else {
        return 4;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.scrollView];
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"group.id", @"group ID");
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = _chatGroup.groupId;
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"group.occupantCount", @"members count");
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i / %i", (int)[_chatGroup.occupants count], (int)_chatGroup.groupSetting.groupMaxUsersCount];
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"title.groupSetting", @"Group Setting");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = NSLocalizedString(@"title.groupSubjectChanging", @"Change group name");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 5) {
        // cell.textLabel.text = NSLocalizedString(@"title.groupBlackList", @"Group black list");
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    int row = (int)indexPath.row;
    if (row == 0) {
        return self.scrollView.frame.size.height + 40;
    }
    else {
        return 50;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 3) {
//        SDGroupSettingContainer* settingController = [[SDGroupSettingContainer alloc] initWithGroup:_chatGroup];
//        [self.navigationController pushViewController:settingController animated:YES];
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//        }
    }
    else if (indexPath.row == 4) {
        GroupSubjectChangingViewController* changingController = [[GroupSubjectChangingViewController alloc] initWithGroup:_chatGroup];
        [self.navigationController pushViewController:changingController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

#pragma mark - EMChooseViewDelegate
- (void)viewController:(EMChooseViewController*)viewController didFinishSelectedSources:(NSArray*)selectedSources
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.addingOccupant", @"add a group member...")];

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray* source = [NSMutableArray array];
        for (EMBuddy* buddy in selectedSources) {
            [source addObject:buddy.username];
        }
        
        //这里要干掉，这是用环信来获取当前用户的登陆信息
        NSDictionary* loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString* username = [loginInfo objectForKey:kSDKUsername];
        NSString* messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join group \'%@\'"), username, weakSelf.chatGroup.groupSubject];
        EMError* error = nil;
        //这里要干掉，这是用环信来邀请用户加入群组
        weakSelf.chatGroup = [[EaseMob sharedInstance].chatManager addOccupants:source toGroup:weakSelf.chatGroup.groupId welcomeMessage:messageStr error:&error];
        if (!error) {
            [weakSelf reloadDataSource];
        }
    });
}

- (void)groupBansChanged
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    [self refreshScrollView];
}

#pragma mark - data

- (void)fetchGroupInfo
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    //这里要干掉，这是用环信来获取群组详细信息
    [[EaseMob sharedInstance]
            .chatManager asyncFetchGroupInfo:_chatGroup.groupId
                                  completion:^(EMGroup* group, EMError* error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [weakSelf hideHud];
                                          if (!error) {
                                              weakSelf.chatGroup = group;
                                              [weakSelf reloadDataSource];
                                          }
                                          else {
                                              [weakSelf showHint:NSLocalizedString(@"group.fetchInfoFail", @"failed to get the group details, please try again later")];
                                              //                [weakSelf reloadDataSource];
                                          }
                                      });
                                  } onQueue:nil];
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];

    self.occupantType = GroupOccupantTypeMember;
    //这里要干掉，这是用环信来获取当前用户的登陆信息
    NSDictionary* loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString* loginUsername = [loginInfo objectForKey:kSDKUsername];
    if ([self.chatGroup.owner isEqualToString:loginUsername]) {
        self.occupantType = GroupOccupantTypeOwner;
    }

    if (self.occupantType != GroupOccupantTypeOwner) {
        for (NSString* str in self.chatGroup.members) {
            if ([str isEqualToString:loginUsername]) {
                self.occupantType = GroupOccupantTypeMember;
                break;
            }
        }
    }

    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshScrollView];
        [self refreshFooterView];
        [self hideHud];
    });
}

- (void)refreshScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView removeGestureRecognizer:_longPress];
    [self.addButton removeFromSuperview];

    BOOL showAddButton = NO;
    if (self.occupantType == GroupOccupantTypeOwner) {
        [self.scrollView addGestureRecognizer:_longPress];
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    else if (self.chatGroup.groupSetting.groupStyle == eGroupStyle_PrivateMemberCanInvite && self.occupantType == GroupOccupantTypeMember) {
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }

    int tmp = ([self.dataSource count] + 1) % kColOfRow;
    int row = (int)([self.dataSource count] + 1) / kColOfRow;
    row += tmp == 0 ? 0 : 1;
    self.scrollView.tag = row;
    self.scrollView.frame = CGRectMake(10, 20, self.tableView.frame.size.width - 20, row * kContactSize);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, row * kContactSize);

    //这里要干掉，这是用环信来获取当前用户的登陆信息
    NSDictionary* loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString* loginUsername = [loginInfo objectForKey:kSDKUsername];

    int i = 0;
    int j = 0;
    float wd = (self.scrollView.contentSize.width - 4 * kContactSize) / 5.0f;
    BOOL isEditing = self.addButton.hidden ? YES : NO;
    BOOL isEnd = NO;
    for (i = 0; i < row; i++) {
        for (j = 0; j < kColOfRow; j++) {
            NSInteger index = i * kColOfRow + j;
            if (index < [self.dataSource count]) {
                NSString* username = [self.dataSource objectAtIndex:index];
                ContactView* contactView = [[ContactView alloc] initWithFrame:CGRectMake(j * kContactSize + (j + 1) * wd, i * kContactSize + 5, kContactSize, kContactSize)];
                contactView.hxAccount = username;
                contactView.index = i * kColOfRow + j;
                contactView.image = [UIImage imageNamed:@"temp_user_head"];
                contactView.remark = [[[SDChatManager sharedChatManager] searchUserByHxAccount:username] realName];
                if (![username isEqualToString:loginUsername]) {
                    contactView.editing = isEditing;
                }else{
                    contactView.remark = [[SDDataBaseHelper shareDB]getUserName:[[AppDelegate getUserID] integerValue]];
                }

                __weak typeof(self) weakSelf = self;
                [contactView setDeleteContact:^(NSInteger index) {

                    NSMutableArray* occupants = [[NSArray arrayWithObject:[weakSelf.dataSource objectAtIndex:index]] mutableCopy];
                    //这里要干掉，这是用环信来获取当前用户的登陆信息
                    NSDictionary* loginInfo = [[EaseMob sharedInstance].chatManager loginInfo];
                    BOOL isContainer = NO;
                    if (YES == [occupants containsObject:loginInfo[kSDKUsername]]) {
                        isContainer = YES;
                        [weakSelf showHint:@"不能删除自己"];
                    }

                    if (NO == isContainer) {
                        [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"group.removingOccupant", @"deleting member...")];
                    }
                    
                    //这里要干掉，这是用环信来将某些人请出群组
                    [[EaseMob sharedInstance]
                            .chatManager asyncRemoveOccupants:occupants
                                                    fromGroup:weakSelf.chatGroup.groupId
                                                   completion:^(EMGroup* group, EMError* error) {
                                                       [weakSelf hideHud];
                                                       if (!error) {
                                                           weakSelf.chatGroup = group;
                                                           if (NO == isContainer) {
                                                               [weakSelf.dataSource removeObjectAtIndex:index];
                                                           }
                                                           [weakSelf refreshScrollView];
                                                       }
                                                       else {
                                                           [weakSelf showHint:error.description];
                                                       }
                                                   } onQueue:nil];
                }];

                [self.scrollView addSubview:contactView];
            }
            else {
                if (showAddButton && index == self.dataSource.count) {
                    self.addButton.frame = CGRectMake(j * kContactSize + (j + 1) * wd, i * kContactSize + 5, kContactSize - 18, kContactSize - 20);
                }

                isEnd = YES;
                break;
            }
        }

        if (isEnd) {
            break;
        }
    }

    [self.tableView reloadData];
}

- (void)refreshFooterView
{
    if (self.occupantType == GroupOccupantTypeOwner) {
        [_exitButton removeFromSuperview];
        [_footerView addSubview:self.dissolveButton];
    }
    else {
        [_dissolveButton removeFromSuperview];
        [_footerView addSubview:self.exitButton];
    }
}

#pragma mark - action

- (void)tapView:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        if (self.addButton.hidden) {
            [self setScrollViewEditing:NO];
        }
    }
}

- (void)deleteContactBegin:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //这里要干掉，这是用环信来获取当前用户的登陆信息
        NSDictionary* loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString* loginUsername = [loginInfo objectForKey:kSDKUsername];
        for (ContactView* contactView in self.scrollView.subviews) {
            CGPoint locaton = [longPress locationInView:contactView];
            if (CGRectContainsPoint(contactView.bounds, locaton)) {
                if ([contactView isKindOfClass:[ContactView class]]) {
                    if ([contactView.remark isEqualToString:loginUsername]) {
                        return;
                    }
                    _selectedContact = contactView;
                    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"delete", @"deleting member..."), nil];
                    [sheet showInView:self.view];
                }
            }
        }
    }
}

- (void)setScrollViewEditing:(BOOL)isEditing
{
    //这里要干掉，这是用环信来获取当前用户的登陆信息
    NSDictionary* loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString* loginUsername = [loginInfo objectForKey:kSDKUsername];

    for (ContactView* contactView in self.scrollView.subviews) {
        if ([contactView isKindOfClass:[ContactView class]]) {
            if ([contactView.remark isEqualToString:loginUsername]) {
                continue;
            }

            [contactView setEditing:isEditing];
        }
    }

    self.addButton.hidden = isEditing;
}

//这里做删除和添加操作，群组的 群组的群组的群组的群组的群组的群组的
- (void)addContact:(id)sender
{
    //    SDSelectUserChatViewController* selectUserChatVC = [[SDSelectUserChatViewController alloc] init];

    // 将环信的用户名转换成SDCompanyUserModel数组
    NSMutableArray* userContactAry = [[NSMutableArray alloc] initWithCapacity:[[self.chatGroup occupants] count]];
    //这里要干掉，这是用环信来获取当前用户的登陆信息
    NSDictionary* loginInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString* loginUserName = loginInfo[kSDKUsername];

    for (NSString* hxAccount in _chatGroup.occupants) {
        if ([loginUserName isEqualToString:hxAccount] ||
            [[SDChatManager sharedChatManager] searchUserByHxAccount:hxAccount] == nil) {
            // 如果登录名和环信用户相同
            continue;
        }
        [userContactAry addObject:[[SDChatManager sharedChatManager] searchUserByHxAccount:hxAccount]];
    }
    //    selectUserChatVC.isGroupAddPerson = YES;
    //    selectUserChatVC.hasSelecteUserAry = userContactAry;
    //
    __weak typeof(self) weakSelf = self;
    //
    //    // 已选人员回调
    //    selectUserChatVC.selectPersonAryBlock = ^(NSArray* personAry) {
    //
    //        NSMutableArray *selectPersonAry = [[NSMutableArray alloc] initWithCapacity:[personAry count]];
    //        // 将SDCompanyUserModel转化成EMBuddy
    //        for(SDCompanyUserModel *model in personAry){
    //            EMBuddy *buddy = [EMBuddy buddyWithUsername:model.hxAccount];
    //            buddy.followState = eEMBuddyFollowState_FollowedBoth;
    //            [selectPersonAry addObject:buddy];
    //        }
    //
    //        [weakSelf viewController:nil didFinishSelectedSources:selectPersonAry];
    //    };

    SDSendRangeViewController* sendRangeVC = [[SDSendRangeViewController alloc] init];
    sendRangeVC.titleVal = @"选择同事";
    sendRangeVC.selectedCallBack = ^(NSArray* contactArray, NSArray* deptArray, NSArray* deptIDArray) {
        _contactArray = [NSMutableArray arrayWithArray:contactArray];
        _deptArray = [NSMutableArray arrayWithArray:deptArray];
        _deptIdArr = [NSMutableArray arrayWithArray:deptIDArray];

        NSMutableArray* arr = [NSMutableArray array];
        for (SDCompanyUserModel* model in _contactArray) {
            [arr addObject:model];
        }
        //            [arr addObjectsFromArray:_contactArray];
        //            [arr addObjectsFromArray:_deptArray];
        for (NSArray* ary in _deptArray) {
            for (SDCompanyUserModel* model in ary) {
                [arr addObject:model];
            }
        }

        NSSet* set = [NSSet setWithArray:arr];
        NSMutableArray* array = [NSMutableArray arrayWithArray:[set allObjects]];

        NSMutableArray* deleteArr = [NSMutableArray arrayWithArray:array];
        //        [deleteArr addObjectsFromArray:array];
        for (SDCompanyUserModel* model in deleteArr) {
            for (SDCompanyUserModel* model2 in userContactAry) {
                if (model.userId == model2.userId) {
                    [array removeObject:model];
                }
            }
        }

        NSMutableArray* selectPersonAry = [[NSMutableArray alloc] initWithCapacity:[array count]];
        // 将SDCompanyUserModel转化成EMBuddy
        for (SDCompanyUserModel* model in array) {
            EMBuddy* buddy = [EMBuddy buddyWithUsername:model.hxAccount];
            buddy.followState = eEMBuddyFollowState_FollowedBoth;
            [selectPersonAry addObject:buddy];
        }

        if (selectPersonAry.count) {
            [weakSelf viewController:nil didFinishSelectedSources:selectPersonAry];
        }else{
            [weakSelf reloadDataSource];
        }
    };
    sendRangeVC.contactsArray = userContactAry;
    sendRangeVC.deptID = _deptIdArr;
    [self.navigationController pushViewController:sendRangeVC animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

//清空聊天记录
- (void)clearAction
{
    __weak typeof(self) weakSelf = self;
    [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                            message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
                    completionBlock:^(NSUInteger buttonIndex, EMAlertView* alertView) {
                        if (buttonIndex == 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:weakSelf.chatGroup.groupId];
                        }
                    }
                  cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                  otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
}

//解散群组
- (void)dissolveAction
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.destroy", @"dissolution of the group")];
    //这里要干掉，这是用环信来解散群组
    [[EaseMob sharedInstance]
            .chatManager asyncDestroyGroup:_chatGroup.groupId
                                completion:^(EMGroup* group, EMGroupLeaveReason reason, EMError* error) {
                                    [weakSelf hideHud];
                                    if (error) {
                                        [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
                                    }
                                    else {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
                                    }
                                } onQueue:nil];

    //    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatGroup.groupId];
}

//设置群组
- (void)configureAction
{
    //这里要干掉，这是用环信来屏蔽接收群的推送消息
    // todo
    [[[EaseMob sharedInstance] chatManager] asyncIgnoreGroupPushNotification:_chatGroup.groupId
                                                                    isIgnore:_chatGroup.isPushNotificationEnabled];
}

//退出群组
- (void)exitAction
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
    //这里要干掉，这是用环信来退出群组
    [[EaseMob sharedInstance]
            .chatManager asyncLeaveGroup:_chatGroup.groupId
                              completion:^(EMGroup* group, EMGroupLeaveReason reason, EMError* error) {
                                  [weakSelf hideHud];
                                  if (error) {
                                      [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
                                  }
                                  else {
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
                                  }
                              } onQueue:nil];

    //    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_chatGroup.groupId];
}

- (void)didIgnoreGroupPushNotification:(NSArray*)ignoredGroupList error:(EMError*)error
{
    // todo
    NSLog(@"ignored group list:%@.", ignoredGroupList);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = _selectedContact.index;
    if (buttonIndex == 0) {
        //delete
        _selectedContact.deleteContact(index);
    }
    else if (buttonIndex == 1) {
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
    _selectedContact = nil;
}

- (void)actionSheetCancel:(UIActionSheet*)actionSheet
{
    _selectedContact = nil;
}
@end
