//
//  SDIMGroupListViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/25.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMGroupListViewController.h"
#import "SDMenuView.h"
#import "SDIMChatViewController.h"
#import "CXIMHelper.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "SDIMGroupListCell.h"
#import "SDIMAddFriendsViewController.h"
#import "SDIMReceiveAndPayMoneyViewController.h"
#import "SDIMSearchVIewController.h"
#import "CXScanViewController.h"
#import "CXMysugestListViewController.h"
#import "AppDelegate.h"
#import "CXLoaclDataManager.h"

@interface SDIMGroupListViewController()<UITableViewDataSource, UITableViewDelegate, SDMenuViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

/// 导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
/// 内容视图
@property (nonatomic, strong) UITableView* tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray* sourceAry;

@property (nonatomic, strong) NSMutableArray *selectContactUserArr;

@property (copy, nonatomic)UILabel * numberOfGroupLabel;

@property (nonatomic, strong) SDMenuView* selectMemu;

@property (nonatomic, strong) NSArray* chatContactsArray;
//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;
@property (nonatomic, strong) UIAlertView* alertView;

@end

@implementation SDIMGroupListViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataSource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sourceAry = [[NSMutableArray alloc] initWithCapacity:0];
    _isSelectMenuSelected = NO;
    [self setupView];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //修复群组头像不显示
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
}

- (void)dealloc
{
    
}

#pragma mark - 内部方法
- (void)setupView
{
    self.view.backgroundColor = SDBackGroudColor;
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"群聊")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(Screen_Width - 90, 20 + 7, 40, 40);
    [searchBtn setImage:[UIImage imageNamed:@"msgSearch"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"msgSearch"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.rootTopView addSubview:searchBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.tableView.backgroundColor = SDBackGroudColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
}

- (void)searchBtnClick
{
    SDIMSearchVIewController * searchVIewController = [[SDIMSearchVIewController alloc] init];
    [self.navigationController pushViewController:searchVIewController animated:YES];
}

//数据源
- (void)loadDataSource
{
    [self showHudInView:self.view hint:@"正在加载数据"];
    __weak typeof(self) wself = self;
    NSLog(@"%@",VAL_HXACCOUNT);
    [[CXIMService sharedInstance].groupManager getJoinedGroups:^(NSArray<CXGroupInfo *> *groups, NSError *error) {
        [wself hideHud];
        if (!error) {
            [_sourceAry removeAllObjects];
            for(CXGroupInfo * group in groups){
                if(group.groupType == CXGroupTypeNormal){
                    [_sourceAry addObject:group];
                }
            }
            [wself.tableView reloadData];
        }
        else{
            TTAlert(@"获取群组列表失败");
        }
    }];
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

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return [self.sourceAry count] + 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row <[self.sourceAry count]){
        static NSString * cellName = @"SDIMGroupListCell";
        SDIMGroupListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell){
            cell = [[SDIMGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        [cell setGroup:self.sourceAry[indexPath.row]];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }else if(indexPath.row == [self.sourceAry count]){
        static NSString * cellName = @"GroupCellName";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            _numberOfGroupLabel = [[UILabel alloc] init];
            _numberOfGroupLabel.frame = CGRectMake(0, 0, Screen_Width, SDCellHeight);
            _numberOfGroupLabel.backgroundColor = [UIColor clearColor];
            _numberOfGroupLabel.textColor = SDSectionTitleColor;
            _numberOfGroupLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:_numberOfGroupLabel];
        }
        
        UIView * bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = SDBackGroudColor;
        bottomView.frame = CGRectMake(0, SDCellHeight - 2, Screen_Width, 6);
        [cell addSubview:bottomView];
        
        _numberOfGroupLabel.text = [NSString stringWithFormat:@"%lu个群聊",(unsigned long)[self.sourceAry count]];
        cell.contentView.backgroundColor = SDBackGroudColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
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
    if(indexPath.row < [self.sourceAry count]){
        CXGroupInfo *group = self.sourceAry[indexPath.row];
        SDIMChatViewController *chatVC = [[SDIMChatViewController alloc] init];
        chatVC.isGroupChat = YES;
        chatVC.chatter = group.groupId;
        chatVC.chatterDisplayName = group.groupName;
        [self.navigationController pushViewController:chatVC animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
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

@end
