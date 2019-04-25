//
//  CXCompanyCircleViewController.m
//  InjoyDDXWBG
//
//  Created by ^ on 2017/10/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXCompanyCircleViewController.h"
#import "Masonry.h"
#import "SDMenuView.h"
#import "CXScanViewController.h"
#import "CXWorkOutsideListViewController.h"
#import "CXBorrowingApplicationListViewController.h"
#import "CXLeaveApplicationListViewController.h"
#import "CXWorkLogListViewController.h"
#import "CXDDXVoiceMeetingListViewController.h"
#import "CXYunJingWorkCircleAllViewController.h"
#import "CXStatementOfAffairsViewController.h"
#import "CXProjectCollaborationListViewController.h"
#import "SDDataBaseHelper.h"
#import "UIView+CXCategory.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "SDIMChatViewController.h"
#import "CXIMHelper.h"
#import "SDInviteViewController.h"

@interface CXCompanyCircleViewController ()
        <
        UITableViewDataSource,
        UITableViewDelegate,
        SDMenuViewDelegate
        >
/// 列表
@property(strong, nonatomic) UITableView *listTableView;
@property(copy, nonatomic, readonly) NSArray *titleArr;
@property(copy, nonatomic, readonly) NSArray *imageArr;
/// 选择菜单
@property(nonatomic, strong) SDMenuView *selectMemu;
/// 用来判断右上角的菜单是否显示
@property(nonatomic) BOOL isSelectMenuSelected;
@property(strong, nonatomic) NSMutableArray *chatContactsArray;
@property(nonatomic, strong) UIAlertView *alertView;
@end

@implementation CXCompanyCircleViewController

#pragma mark - get & set

- (NSArray *)imageArr {
    return @[
            @[@"WorkCircle"],
            @[@"TransactionCommit", @"xmxt", @"yyhy"],
            @[@"gzwc", @"BorrowingSubmission", @"LeaveToSubmit"],
            @[@"workLog"]
    ];
}

- (NSArray *)titleArr {
    return @[
            @[@"公司圈"],
            @[@"事务报告", @"项目协同", @"语音会议"],
            @[@"工作外出", @"借支申请", @"请假申请"],
            @[@"工作日志"]
    ];
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listTableView.backgroundColor = SDBackGroudColor;
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.estimatedRowHeight = 0.f;
        _listTableView.estimatedSectionHeaderHeight = 0.f;
        _listTableView.estimatedSectionFooterHeight = 0.f;
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)tapGestureEvent:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGestureRecognizer locationInView:nil];
        //由于这里获取不到右上角的按钮，所以用location来获取到按钮的范围，把它排除出去
        if (![self.selectMemu pointInside:[self.selectMemu convertPoint:location fromView:self.view.window] withEvent:nil] && !(location.x > Screen_Width - 50 && location.y < navHigh)) {
            [self selectMenuViewDisappear];
        }
    }
}

- (void)selectMenuViewDisappear {
    _isSelectMenuSelected = NO;
    [_selectMemu removeFromSuperview];
    _selectMemu = nil;
}

- (BOOL)hasNewWorkCircleMessage {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *lastCommentCreateTime = [ud objectForKey:[NSString stringWithFormat:@"LSAT_COMMENT_CREATETIME_%@", VAL_HXACCOUNT]];
    NSArray *unReadComments;
    if (lastCommentCreateTime) {
        unReadComments = [[SDDataBaseHelper shareDB] getUnReadWorkCircleCommentPushModelArrayWithLastReadCommetCreateTime:@([lastCommentCreateTime longLongValue])];
    } else {
        unReadComments = [[SDDataBaseHelper shareDB] getWorkCircleCommentPushModelArray];
    }
    if ((unReadComments && [unReadComments count] > 0) || VAL_HAVE_UNREAD_WORKCIRCLE_MESSAGE) {
        return YES;
    }
    return NO;
}

- (void)sendMsgBtnEvent:(UIButton *)sender {
    if (!_isSelectMenuSelected) {
        _isSelectMenuSelected = YES;
        NSArray *dataArray = @[@"发起群聊"];
        NSArray *imageArray = @[@"addGroupMessage"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
        [self addGestureRecognizerFunction];
    } else {
        [self selectMenuViewDisappear];
    }
}

- (void)reloadTableViewEvent {
    [self.listTableView reloadData];
}

- (void)addGestureRecognizerFunction {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setUpTableViewLine:(UIView *)contentView {
    UIView *line = [UIView new];
    line.backgroundColor = SDBackGroudColor;
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView).offset(10.f);
        make.right.equalTo(contentView).offset(-10.f);
        make.height.mas_equalTo(1.f);
    }];
}

- (void)setUpNavBar {
    [[self getRootTopView] setNavTitle:LocalString(@"工作")];

    [[self getRootTopView] setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.mas_equalTo(navHigh);
    }];
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }

    adjustsScrollViewInsets(self.listTableView);
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;

    [self setUpNavBar];
    [self setUpTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableViewEvent)
                                                 name:receiveReloadHomeViewRedViewNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableViewEvent)
                                                 name:kReceivePushNotificationKey
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    NSString *title = self.titleArr[indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    NSString *pngName = self.imageArr[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:pngName];

    [cell.contentView removeBadge];
    if ([title isEqualToString:@"事务报告"]) {
        [self setUpTableViewLine:cell];
    }

    if ([title isEqualToString:@"项目协同"]) {
        [self setUpTableViewLine:cell];
    }

    if ([title isEqualToString:@"语音会议"]) {
    }

    if ([title isEqualToString:@"工作外出"]) {
        [self setUpTableViewLine:cell];
    }

    if ([title isEqualToString:@"借支申请"]) {
        [self setUpTableViewLine:cell];
    }

    if ([title isEqualToString:@"请假申请"]) {
        if (VAL_PUSHES_HAVE_NEW(IM_PUSH_QJ)) {
            VAL_AddNumBadge(IM_PUSH_QJ);
        }
    }

    if ([title isEqualToString:@"工作日志"]) {
    }

    if ([title isEqualToString:@"公司圈"] &&
            (YES == [self hasNewWorkCircleMessage])) {
        [cell.contentView addBadge];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SDCellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = RGBACOLOR(84.0, 84.0, 84.0, 1.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.titleArr[indexPath.section][indexPath.row];

    SDRootViewController *tempViewController = nil;

    if ([@"公司圈" isEqualToString:title]) {
        // 公司圈
        [[tableView cellForRowAtIndexPath:indexPath] removeBadge];
        CXYunJingWorkCircleAllViewController *workHomeViewController = [[CXYunJingWorkCircleAllViewController alloc] init];
        [self.navigationController pushViewController:workHomeViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }

    if ([@"事务报告" isEqualToString:title]) {
        CXStatementOfAffairsViewController *statementOfAffairsViewController = [[CXStatementOfAffairsViewController alloc] init];
        statementOfAffairsViewController.isSuperSearch = NO;
        [self.navigationController pushViewController:statementOfAffairsViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }

    if ([@"项目协同" isEqualToString:title]) {
        CXProjectCollaborationListViewController *projectCollaborationListViewController = [[CXProjectCollaborationListViewController alloc] init];
        projectCollaborationListViewController.isSuperSearch = NO;
        [self.navigationController pushViewController:projectCollaborationListViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }

    if ([@"语音会议" isEqualToString:title]) {
        CXDDXVoiceMeetingListViewController *voiceMeetingListViewController = [[CXDDXVoiceMeetingListViewController alloc] init];
        voiceMeetingListViewController.isSuperSearch = NO;
        [self.navigationController pushViewController:voiceMeetingListViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }

    if ([@"工作外出" isEqualToString:title]) {
        CXWorkOutsideListViewController *vc = [[CXWorkOutsideListViewController alloc] init];
        tempViewController = vc;
    }

    if ([@"借支申请" isEqualToString:title]) {
        CXBorrowingApplicationListViewController *vc = [[CXBorrowingApplicationListViewController alloc] init];
        tempViewController = vc;
    }

    if ([@"请假申请" isEqualToString:title]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CK);
        CXLeaveApplicationListViewController *vc = [[CXLeaveApplicationListViewController alloc] init];
        tempViewController = vc;
    }

    if ([@"工作日志" isEqualToString:title]) {
        CXWorkLogListViewController *vc = [[CXWorkLogListViewController alloc] init];
        tempViewController = vc;
    }

    if (tempViewController) {
        [self.navigationController pushViewController:tempViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

#pragma mark - SDMenuViewDelegate

- (void)returnCardID:(NSInteger)cardID withCardName:(NSString *)cardName {
    [self selectMenuViewDisappear];

    if ([@"发起群聊" isEqualToString:cardName]) {
        [self showHudInView:self.view hint:@"加载中"];
        __weak typeof(self) weakSelf = self;
        CXIDGGroupAddUsersViewController *selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
        selectColleaguesViewController.navTitle = @"发起群聊";
        selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[[CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]]]];
        selectColleaguesViewController.selectContactUserCallBack = ^(NSArray *selectContactUserArr) {
            if (selectContactUserArr.count == 1) {
                //单聊
                NSMutableArray *hxAccount = [[selectContactUserArr valueForKey:@"hxAccount"] mutableCopy];

                SDIMChatViewController *chat = [[SDIMChatViewController alloc] init];
                chat.chatter = hxAccount[0];
                NSString *name = [CXIMHelper getRealNameByAccount:hxAccount[0]];
                chat.chatterDisplayName = name;
                chat.isGroupChat = NO;
                [weakSelf.navigationController pushViewController:chat animated:YES];
            } else {
                //群聊
                weakSelf.chatContactsArray = [selectContactUserArr mutableCopy];

                _alertView = [[UIAlertView alloc] initWithTitle:@"设置群聊名称" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [_alertView show];
            }

        };
        [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
        [self hideHud];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *textField = [_alertView textFieldAtIndex:0];
        NSString *groupName = trim(textField.text);
        if (groupName.length <= 0) {
            TTAlert(@"群组名称不能为空");
            return;
        }
        if([_chatContactsArray count] > 49){
            [self.view makeToast:@"群聊人数最多50人，请重新选择！" duration:2 position:@"center"];
            return;
        }
        NSMutableArray *hxAccount = [[_chatContactsArray valueForKey:@"hxAccount"] mutableCopy];

        if (hxAccount.count) {
            NSMutableArray *members = [NSMutableArray array];
            [hxAccount enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                [members addObject:obj];
            }];
            [self showHudInView:self.view hint:@"正在创建群组"];
            __weak typeof(self) weakSelf = self;
            [[CXIMService sharedInstance].groupManager erpCreateGroupWithName:groupName type:CXGroupTypeNormal owner:[[CXLoaclDataManager sharedInstance] getGroupUserFromLocalContactsDicWithIMAccount:VAL_HXACCOUNT] members:[[CXLoaclDataManager sharedInstance] getGroupUsersFromLocalContactsDicWithIMAccountArray:members] completion:^(CXGroupInfo *group, NSError *error) {
                [weakSelf hideHud];
                if (!error) {
                    SDIMChatViewController *chat = [[SDIMChatViewController alloc] init];
                    chat.chatter = group.groupId;
                    chat.chatterDisplayName = groupName;
                    chat.isGroupChat = YES;
                    [weakSelf.navigationController pushViewController:chat animated:YES];
                } else {
                    TTAlert(@"创建失败");
                }

            }];
        }
    } else {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isSelectMenuSelected == YES) {
        [self selectMenuViewDisappear];
    }
}

@end
