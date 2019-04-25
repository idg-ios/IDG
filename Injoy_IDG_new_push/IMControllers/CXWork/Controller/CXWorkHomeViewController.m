//
//  CXWorkHomeViewController.m
//  InjoyERP
//
//  Created by wtz on 16/11/18.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXWorkHomeViewController.h"
#import "SDMenuView.h"
#import "SDIMSearchVIewController.h"
#import "AppDelegate.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "SDIMChatViewController.h"
#import "CXIMHelper.h"
#import "SDIMAddFriendsViewController.h"
#import "CXScanViewController.h"
#import "SDIMReceiveAndPayMoneyViewController.h"
#import "UIImageView+EMWebCache.h"
#import "QRCodeGenerator.h"
#import "QLPreviewItemCustom.h"
#import "SDDataBaseHelper.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDIMMySettingViewController.h"
#import "SDIMPersonInfomationViewController.h"
#import "CXTransactionCommitViewController.h"
#import "CXBorrowingSubmissionViewController.h"
#import "CXPerformanceReportViewController.h"
#import "CXLeaveToSubmitViewController.h"
#import "CXSelectContactViewController.h"
#import "CXAllPeoplleWorkCircleViewController.h"
#import "CXCooperationPromotionViewController.h"
#import "CXPromotionActivitieViewController.h"
#import "CXGoodsPromotionViewController.h"
#import "CXPromotionSettingsViewController.h"
#import "CXWorkLogCommitViewController.h"
#import "CXLoaclDataManager.h"

#define kImageLeftSpacing ((SDCellHeight - kImageHeight)/2)
#define kImageHeight SDHeadWidth
#define kDarkTextColor RGBACOLOR(84.0, 84.0, 84.0, 1.0)
#define kBadgeImageWidth 10.0

@interface CXWorkHomeViewController ()<UITableViewDataSource, UITableViewDelegate, SDMenuViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

//导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) UITableView* tableView;
//选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
@property (strong, nonatomic) NSMutableArray* chatContactsArray;
//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;
@property (nonatomic, strong) UIAlertView* alertView;

@end

@implementation CXWorkHomeViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
    if (VAL_SHOW_ADD_FRIENDS) {
        [vc.tabBar.items[2] setBadgeValue:@" "];
    }
    else {
        [vc.tabBar.items[2] setBadgeValue:@""];
    }
    [self loadWorkCircleUnReadComments];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewWorkCircleComment) name:receiveNewWorkCircleCommentNotification object:nil];
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
- (BOOL)loadWorkCircleUnReadComments
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSString * lastCommentCreateTime = [ud objectForKey:[NSString stringWithFormat:@"LSAT_COMMENT_CREATETIME_%@",VAL_HXACCOUNT]];
    NSArray * unReadComments;
    if(lastCommentCreateTime){
        unReadComments = [[SDDataBaseHelper shareDB]  getUnReadWorkCircleCommentPushModelArrayWithLastReadCommetCreateTime:@([lastCommentCreateTime longLongValue])];
    }else{
        unReadComments = [[SDDataBaseHelper shareDB] getWorkCircleCommentPushModelArray];
    }
    RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
    if((unReadComments && [unReadComments count] > 0) || VAL_HAVE_UNREAD_WORKCIRCLE_MESSAGE){
        //[vc.tabBar.items[2] setBadgeValue:@" "];
        return YES;
    }else{
        //[vc.tabBar.items[2] setBadgeValue:@""];
        return NO;
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

- (void)setupView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"公司圈")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
//    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:AppDelegate.class action:@selector(jumpBackFromIMModule)];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(Screen_Width - 90, 20 + 7, 40, 40);
    [searchBtn setImage:[UIImage imageNamed:@"msgSearch"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"msgSearch"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.rootTopView addSubview:searchBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - TabBar_Height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = SDBackGroudColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.bounces = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = SDBackGroudColor;
}

- (void)searchBtnClick
{
    SDIMSearchVIewController * searchVIewController = [[SDIMSearchVIewController alloc] init];
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
        NSArray* dataArray = @[ @"发起群聊"];
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

- (void)setCellWithImageName:(NSString *)imageName Text:(NSString *)text Color:(UIColor *)color AndCell:(UITableViewCell *)cell
{
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(kImageLeftSpacing, (SDCellHeight - kImageHeight)/2, kImageHeight, kImageHeight);
    imageView.image = [UIImage imageNamed:imageName];
    imageView.highlightedImage = [UIImage imageNamed:imageName];
    [cell.contentView addSubview:imageView];
    
    UILabel * cellLabel = [[UILabel alloc] init];
    cellLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + kImageLeftSpacing, (SDCellHeight - SDMainMessageFont)/2, 300, SDMainMessageFont);
    cellLabel.textColor = color;
    cellLabel.backgroundColor = [UIColor clearColor];
    cellLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    cellLabel.text = text;
    cellLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:cellLabel];
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    [self selectMenuViewDisappear];
    
    if (cardID == 0) {
        [self showHudInView:self.view hint:@"加载中"];
        __weak typeof(self) weakSelf = self;
        CXIDGGroupAddUsersViewController * selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
        selectColleaguesViewController.navTitle = @"发起群聊";
        selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[[CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]]]];
        selectColleaguesViewController.selectContactUserCallBack = ^(NSArray * selectContactUserArr){
            if (selectContactUserArr.count == 1) {
                //单聊
                NSMutableArray* hxAccount = [[selectContactUserArr valueForKey:@"hxAccount"] mutableCopy];
                
                SDIMChatViewController* chat = [[SDIMChatViewController alloc] init];
                chat.chatter = hxAccount[0];
                NSString* name = [CXIMHelper getRealNameByAccount:hxAccount[0]];
                chat.chatterDisplayName = name;
                chat.isGroupChat = NO;
                [weakSelf.navigationController pushViewController:chat animated:YES];
            }
            else {
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"CXWorkHomeCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
    }
    if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 12){
        cell.contentView.backgroundColor = SDBackGroudColor;
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(indexPath.row == 1){
        [self setCellWithImageName:@"WorkCircle" Text:@"公司圈" Color:[UIColor blackColor] AndCell:cell];
        if ([self loadWorkCircleUnReadComments]) {
            UIView* redView = [[UIView alloc] init];
            redView.frame = CGRectMake(kImageLeftSpacing + kImageHeight - kBadgeImageWidth / 2, (SDCellHeight - kImageHeight)/2 - kBadgeImageWidth / 2, kBadgeImageWidth, kBadgeImageWidth);
            redView.backgroundColor = [UIColor redColor];
            redView.layer.cornerRadius = kBadgeImageWidth / 2;
            redView.clipsToBounds = YES;
            [cell.contentView addSubview:redView];
            [cell.contentView bringSubviewToFront:redView];
        }
        
    }else if(indexPath.row == 3){
        [self setCellWithImageName:@"workLog" Text:@"工作日志" Color:kDarkTextColor AndCell:cell];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(8, SDCellHeight - 1, Screen_Width - 16, 1);
        lineView.backgroundColor = RGBACOLOR(215, 215, 215, 1.0);
        [cell.contentView addSubview:lineView];
    }else if(indexPath.row == 4){
        UIView * toplineView = [[UIView alloc] init];
        toplineView.frame = CGRectMake(8, 0, Screen_Width - 16, 1);
        toplineView.backgroundColor = RGBACOLOR(215, 215, 215, 1.0);
        [cell.contentView addSubview:toplineView];
        
        [self setCellWithImageName:@"TransactionCommit" Text:@"事务报告" Color:kDarkTextColor AndCell:cell];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(8, SDCellHeight - 0.5, Screen_Width - 16, 0.5);
        lineView.backgroundColor = RGBACOLOR(200, 199, 204, 1.0);
        [cell.contentView addSubview:lineView];
    }else if(indexPath.row == 5){
        [self setCellWithImageName:@"PerformanceReport" Text:@"业绩报告" Color:kDarkTextColor AndCell:cell];
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(8, SDCellHeight - 0.5, Screen_Width - 16, 0.5);
        lineView.backgroundColor = RGBACOLOR(200, 199, 204, 1.0);
        [cell.contentView addSubview:lineView];
    }else if(indexPath.row == 6){
        [self setCellWithImageName:@"BorrowingSubmission" Text:@"借支申请" Color:kDarkTextColor AndCell:cell];
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(8, SDCellHeight - 0.5, Screen_Width - 16, 0.5);
        lineView.backgroundColor = RGBACOLOR(200, 199, 204, 1.0);
        [cell.contentView addSubview:lineView];
    }else if(indexPath.row == 7){
        [self setCellWithImageName:@"LeaveToSubmit" Text:@"请假申请" Color:kDarkTextColor AndCell:cell];
    }else if(indexPath.row == 9){
        [self setCellWithImageName:@"Secretlanguage" Text:@"密语" Color:[UIColor blackColor] AndCell:cell];
        UILabel * burnAfterReadLabel = [[UILabel alloc] init];
        burnAfterReadLabel.frame = CGRectMake(100, (SDCellHeight - 13)/2, 200, 13);
        burnAfterReadLabel.text = @"(阅后即焚)";
        burnAfterReadLabel.textColor = RGBACOLOR(176.0, 177.0, 176.0, 1.0);
        burnAfterReadLabel.textAlignment = NSTextAlignmentLeft;
        burnAfterReadLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:burnAfterReadLabel];
    }
    else if(indexPath.row == 11){
        [self setCellWithImageName:@"scanIt" Text:@"扫一扫" Color:[UIColor blackColor] AndCell:cell];
    }
    else if(indexPath.row == 12){
        UIView * coverView = [[UIView alloc] init];
        coverView.frame = CGRectMake(0, 8, Screen_Width, 4);
        coverView.backgroundColor = SDBackGroudColor;
        [cell.contentView addSubview:coverView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 12){
        return 10;
    }
    return SDCellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1){
        CXAllPeoplleWorkCircleViewController* allPeoplleWorkCircleViewController = [[CXAllPeoplleWorkCircleViewController alloc] init];
        [self.navigationController pushViewController:allPeoplleWorkCircleViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 3){
        CXWorkLogCommitViewController * workLogViewController = [[CXWorkLogCommitViewController alloc] init];
        [self.navigationController pushViewController:workLogViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 4){
        CXTransactionCommitViewController * transactionCommitViewController = [[CXTransactionCommitViewController alloc] init];
        [self.navigationController pushViewController:transactionCommitViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 5){
        CXPerformanceReportViewController * performanceReportViewController = [[CXPerformanceReportViewController alloc] init];
        [self.navigationController pushViewController:performanceReportViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 6){
        CXBorrowingSubmissionViewController * borrowingSubmissionViewController = [[CXBorrowingSubmissionViewController alloc] init];
        [self.navigationController pushViewController:borrowingSubmissionViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 7){
        CXLeaveToSubmitViewController * leaveToSubmitViewController = [[CXLeaveToSubmitViewController alloc] init];
        [self.navigationController pushViewController:leaveToSubmitViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 9){
        CXSelectContactViewController * selectContactViewController = [[CXSelectContactViewController alloc] init];
        selectContactViewController.type = CXSecretLanguageType;
        [self.navigationController pushViewController:selectContactViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if(indexPath.row == 11){
        // 扫一扫
        CXScanViewController *scanVC = [[CXScanViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
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

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (_isSelectMenuSelected == YES) {
        [self selectMenuViewDisappear];
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

- (void)receiveNewWorkCircleComment
{
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
