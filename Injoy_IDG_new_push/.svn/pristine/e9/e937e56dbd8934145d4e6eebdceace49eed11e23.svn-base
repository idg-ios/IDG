//
//  CXNewIDGSearchViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewIDGSearchViewController.h"
#import "SDMenuView.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "SDIMChatViewController.h"
#import "SDChatManager.h"
#import "SDDataBaseHelper.h"
#import "SDIMSearchResultCell.h"
#import "CXIMHelper.h"
#import "SDIMAddFriendsViewController.h"
#import "SDIMReceiveAndPayMoneyViewController.h"
#import "CXMysugestListViewController.h"
#import "CXScanViewController.h"
#import "AppDelegate.h"
#import "CXVoiceConferenceTableViewCell.h"
#import "SDVoiceManager.h"
#import "CXLoaclDataManager.h"
#import "CXIMVoiceConferenceDDXDetailViewController.h"
#import "CXLoaclDataManager.h"
#import "NSString+TextHelper.h"
#import "UIView+Category.h"
#import "UIImageView+EMWebCache.h"
#import "HttpTool.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import "SDIMPersonInfomationViewController.h"

#define kBtnSpacing (Screen_Width - 65*3)/4
#define kSectionTitleHeight 50
#define kSDIMSearchResultCellHeight 60

@interface CXNewIDGSearchViewController ()<UIGestureRecognizerDelegate,SDMenuViewDelegate,UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
//选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;
//群组array
@property (nonatomic, strong) NSArray* chatContactsArray;

@property (nonatomic, strong) UIAlertView* alertView;
//搜索栏
@property (nonatomic,strong) UISearchBar * searchBar;
//table
@property (nonatomic,strong) UITableView * tableView;
//搜索控制器
@property (nonatomic,strong) UISearchDisplayController *sdc;
//搜索类型
@property (nonatomic) SDIMIDGSearchType searchType;

@property (nonatomic,strong) UIView *footerView;
//群聊搜索按钮
@property (nonatomic,strong) UIButton * groupChatSearchBtn;
//群聊搜索Label
@property (nonatomic,strong) UILabel * groupChatSearchLabel;
//单聊搜索按钮
@property (nonatomic,strong) UIButton * singleChatSearchBtn;
//单聊搜索Label
@property (nonatomic,strong) UILabel * singleChatSearchLabel;
//语音会议搜索按钮
@property (nonatomic,strong) UIButton * voiceConferenceSearchBtn;
//语音会议搜索Label
@property (nonatomic,strong) UILabel * voiceConferenceSearchLabel;
//群聊数组
@property (nonatomic,strong) NSMutableArray * groupChatArray;
//单聊数组
@property (nonatomic,strong) NSMutableArray * singleChatArray;
//语音会议数组
@property (nonatomic,strong) NSMutableArray * voiceConferenceArray;

@end

@implementation CXNewIDGSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = SDBackGroudColor;
    
    self.searchType = SDIMIDGSearchTypeAll;
    
    self.isSelectMenuSelected = NO;
    
    _groupChatArray = [[NSMutableArray alloc] initWithCapacity:0];
    _singleChatArray = [[NSMutableArray alloc] initWithCapacity:0];
    _voiceConferenceArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setUpView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setUpView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"搜索")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    //tableView
    if(_tableView){
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height -navHigh);
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    //搜索条
    if(_searchBar){
        [_searchBar removeFromSuperview];
        _searchBar = nil;
    }
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0, Screen_Width, kSDIMSearchResultCellHeight);
    _searchBar.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _searchBar;
    
    //footerView
    if(_footerView){
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    _footerView = [[UIView alloc] init];
    _footerView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height -navHigh - kSDIMSearchResultCellHeight);
    
    //群聊搜索按钮
    if(_groupChatSearchBtn){
        [_groupChatSearchBtn removeFromSuperview];
        _groupChatSearchBtn = nil;
    }
    _groupChatSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _groupChatSearchBtn.frame = CGRectMake(kBtnSpacing, 50, 65, 65);
    [_groupChatSearchBtn setBackgroundImage:[UIImage imageNamed:@"groupChatBtnImage"] forState:UIControlStateNormal];
    [_groupChatSearchBtn setBackgroundImage:[UIImage imageNamed:@"groupChatBtnImage"] forState:UIControlStateHighlighted];
    [_groupChatSearchBtn addTarget:self action:@selector(groupChatSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_groupChatSearchBtn];
    
    //群聊Label
    if(_groupChatSearchLabel){
        [_groupChatSearchLabel removeFromSuperview];
        _groupChatSearchLabel = nil;
    }
    _groupChatSearchLabel = [[UILabel alloc] init];
    _groupChatSearchLabel.frame = CGRectMake(_groupChatSearchBtn.frame.origin.x, CGRectGetMaxY(_groupChatSearchBtn.frame) + 15, 65, SDSelectMenuTextFont);
    _groupChatSearchLabel.backgroundColor = [UIColor clearColor];
    _groupChatSearchLabel.font = [UIFont systemFontOfSize:SDSelectMenuTextFont];
    _groupChatSearchLabel.textColor = SDTextDarkColor;
    _groupChatSearchLabel.text = @"群聊";
    _groupChatSearchLabel.textAlignment = NSTextAlignmentCenter;
    [_footerView addSubview:_groupChatSearchLabel];
    
    //单聊搜索按钮
    if(_singleChatSearchBtn){
        [_singleChatSearchBtn removeFromSuperview];
        _singleChatSearchBtn = nil;
    }
    _singleChatSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _singleChatSearchBtn.frame = CGRectMake(kBtnSpacing*2 + 65, 50, 65, 65);
    [_singleChatSearchBtn setBackgroundImage:[UIImage imageNamed:@"singleChatImage"] forState:UIControlStateNormal];
    [_singleChatSearchBtn setBackgroundImage:[UIImage imageNamed:@"singleChatImage"] forState:UIControlStateHighlighted];
    [_singleChatSearchBtn addTarget:self action:@selector(singleChatSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_singleChatSearchBtn];
    
    //单聊Label
    if(_singleChatSearchLabel){
        [_singleChatSearchLabel removeFromSuperview];
        _singleChatSearchLabel = nil;
    }
    _singleChatSearchLabel = [[UILabel alloc] init];
    _singleChatSearchLabel.frame = CGRectMake(_singleChatSearchBtn.frame.origin.x, CGRectGetMaxY(_singleChatSearchBtn.frame) + 15, 65, SDSelectMenuTextFont);
    _singleChatSearchLabel.backgroundColor = [UIColor clearColor];
    _singleChatSearchLabel.font = [UIFont systemFontOfSize:SDSelectMenuTextFont];
    _singleChatSearchLabel.textColor = SDTextDarkColor;
    _singleChatSearchLabel.text = @"单聊";
    _singleChatSearchLabel.textAlignment = NSTextAlignmentCenter;
    [_footerView addSubview:_singleChatSearchLabel];
    
    //语音会议搜索按钮
    if(_voiceConferenceSearchBtn){
        [_voiceConferenceSearchBtn removeFromSuperview];
        _voiceConferenceSearchBtn = nil;
    }
    _voiceConferenceSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceConferenceSearchBtn.frame = CGRectMake(kBtnSpacing*3 + 65*2, 50, 65, 65);
    [_voiceConferenceSearchBtn setBackgroundImage:[UIImage imageNamed:@"SearchLXR"] forState:UIControlStateNormal];
    [_voiceConferenceSearchBtn setBackgroundImage:[UIImage imageNamed:@"SearchLXR"] forState:UIControlStateHighlighted];
    [_voiceConferenceSearchBtn addTarget:self action:@selector(voiceConferenceSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_voiceConferenceSearchBtn];
    
    //语音会议Label
    if(_voiceConferenceSearchLabel){
        [_voiceConferenceSearchLabel removeFromSuperview];
        _voiceConferenceSearchLabel = nil;
    }
    _voiceConferenceSearchLabel = [[UILabel alloc] init];
    _voiceConferenceSearchLabel.frame = CGRectMake(_voiceConferenceSearchBtn.frame.origin.x, CGRectGetMaxY(_voiceConferenceSearchBtn.frame) + 15, 65, SDSelectMenuTextFont);
    _voiceConferenceSearchLabel.backgroundColor = [UIColor clearColor];
    _voiceConferenceSearchLabel.font = [UIFont systemFontOfSize:SDSelectMenuTextFont];
    _voiceConferenceSearchLabel.textColor = SDTextDarkColor;
    _voiceConferenceSearchLabel.text = @"联系人";
    _voiceConferenceSearchLabel.textAlignment = NSTextAlignmentCenter;
    [_footerView addSubview:_voiceConferenceSearchLabel];
    
    _tableView.tableFooterView = _footerView;
    
    // 搜索控制器
    _sdc = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _sdc.searchResultsDataSource = self;
    _sdc.searchResultsDelegate = self;
    _sdc.delegate = self;
}

#pragma mark - Action

- (void)groupChatSearchBtnClick
{
    self.sdc.active = YES;
    [_searchBar becomeFirstResponder];
    self.searchType = SDIMIDGSearchTypeGroupChat;
}

- (void)singleChatSearchBtnClick
{
    self.sdc.active = YES;
    [_searchBar becomeFirstResponder];
    self.searchType = SDIMIDGSearchTypeSingleChat;
}

- (void)voiceConferenceSearchBtnClick
{
    self.sdc.active = YES;
    [_searchBar becomeFirstResponder];
    self.searchType = SDIMIDGSearchTypeContactConference;
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

- (void)selectMenuViewDisappear
{
    _isSelectMenuSelected = NO;
    [_selectMemu removeFromSuperview];
    _selectMemu = nil;
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBtnClick
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

#pragma mark - 搜索
- (void)searchMessagesWithFilter:(NSString *)filterString {
    NSArray<CXIMMessage *> *messages = [[CXIMService sharedInstance].chatManager searchMessagesByContent:filterString];
    
    NSMutableArray* searchDataSource = [NSMutableArray array];
    NSArray<SDCompanyUserModel *> * users = [[CXLoaclDataManager sharedInstance] getAllDepContacts];
    for (SDCompanyUserModel* userModel in users) {
        if ([NSString containWithSelectedStr:[self toLower:userModel.realName] contain:[self toLower:filterString]]) {
            [searchDataSource addObject:userModel];
        }else if([NSString containWithSelectedStr:[self toUpper:userModel.realName] contain:[self toUpper:filterString]]){
            [searchDataSource addObject:userModel];
        }
    }
    self.voiceConferenceArray = searchDataSource;
    
    for(SDCompanyUserModel* contactUserModel in users){
        if([NSString containWithSelectedStr:contactUserModel.telephone contain:filterString] || [NSString containWithSelectedStr:contactUserModel.phone contain:filterString]){
            BOOL isNotINSearchDataSource = YES;
            for(SDCompanyUserModel* userModel in self.voiceConferenceArray){
                if([contactUserModel.imAccount isEqualToString:userModel.imAccount]){
                    isNotINSearchDataSource = NO;
                }
            }
            if(isNotINSearchDataSource){
                [self.voiceConferenceArray addObject:contactUserModel];
            }
        }
    }
    
    // 单聊
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.type = %d", CXIMMessageTypeChat];
    // 群聊
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.type = %d", CXIMMessageTypeGroupChat];
    
    self.singleChatArray = [[messages filteredArrayUsingPredicate:predicate] mutableCopy];
    self.groupChatArray = [[messages filteredArrayUsingPredicate:predicate2] mutableCopy];
}

-(NSString *)toLower:(NSString *)str{
    for (NSInteger i=0; i<str.length; i++) {
        if ([str characterAtIndex:i]>='A'&[str characterAtIndex:i]<='Z') {
            //A  65  a  97
            char  temp=[str characterAtIndex:i]+32;
            NSRange range=NSMakeRange(i, 1);
            str=[str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}

-(NSString *)toUpper:(NSString *)str{
    for (NSInteger i=0; i<str.length; i++) {
        if ([str characterAtIndex:i]>='a'&[str characterAtIndex:i]<='z') {
            //A  65  a  97
            char  temp=[str characterAtIndex:i]-32;
            NSRange range=NSMakeRange(i, 1);
            str=[str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
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
            HUD_SHOW(@"正在创建群组");
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView != _tableView){
        if(self.searchType == SDIMIDGSearchTypeAll){
            if([_singleChatArray count] > 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] > 0){
                if(section == 0){
                    return [_singleChatArray count];
                }else if(section == 1){
                    return [_groupChatArray count];
                }else if(section == 2){
                    return [_voiceConferenceArray count];
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] > 0){
                if(section == 0){
                    return [_groupChatArray count];
                }else if(section == 1){
                    return [_voiceConferenceArray count];
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] > 0){
                if(section == 0){
                    return [_singleChatArray count];
                }else if(section == 1){
                    return [_voiceConferenceArray count];
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] == 0){
                if(section == 0){
                    return [_singleChatArray count];
                }else if(section == 1){
                    return [_groupChatArray count];
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] > 0){
                if(section == 0){
                    return [_voiceConferenceArray count];
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                if(section == 0){
                    return [_singleChatArray count];
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] == 0){
                if(section == 0){
                    return [_groupChatArray count];
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                return 0;
            }
        }else if(self.searchType == SDIMIDGSearchTypeSingleChat){
            return [_singleChatArray count];
        }else if(self.searchType == SDIMIDGSearchTypeGroupChat){
            return [_groupChatArray count];
        }else if(self.searchType == SDIMIDGSearchTypeContactConference){
            return [_voiceConferenceArray count];
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView != _tableView){
        if(self.searchType == SDIMIDGSearchTypeAll){
            if([_singleChatArray count] > 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] > 0){
                return 3;
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] > 0){
                return 2;
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] > 0){
                return 2;
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] == 0){
                return 2;
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] > 0){
                return 1;
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                return 1;
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] == 0){
                return 1;
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                return 0;
            }
        }else if(self.searchType == SDIMIDGSearchTypeSingleChat){
            return 1;
        }else if(self.searchType == SDIMIDGSearchTypeGroupChat){
            return 1;
        }else if(self.searchType == SDIMIDGSearchTypeContactConference){
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SDCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView != _tableView){
        if(self.searchType == SDIMIDGSearchTypeAll){
            if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                return 0;
            }else{
                return 24;
            }
        }else if(self.searchType == SDIMIDGSearchTypeSingleChat){
            if([_singleChatArray count] == 0){
                return 0;
            }else{
                return 24;
            }
        }else if(self.searchType == SDIMIDGSearchTypeGroupChat){
            if([_groupChatArray count] == 0){
                return 0;
            }else{
                return 24;
            }
        }else if(self.searchType == SDIMIDGSearchTypeContactConference){
            if([_voiceConferenceArray count] == 0){
                return 0;
            }else{
                return 24;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView != _tableView){
        UIView * backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, Screen_Width, 24);
        backView.backgroundColor = SDBackGroudColor;
        UILabel * titleLable = [[UILabel alloc] init];
        titleLable.font = [UIFont systemFontOfSize:12];
        titleLable.frame = CGRectMake(0, 6, 200, 12);
        if(self.searchType == SDIMIDGSearchTypeAll){
            if([_singleChatArray count] > 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] > 0){
                if(section == 0){
                    titleLable.text = @"   单聊";
                }else if(section == 1){
                    titleLable.text = @"   群聊";
                }else if(section == 2){
                    titleLable.text = @"   联系人";
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] > 0){
                if(section == 0){
                    titleLable.text = @"   群聊";
                }else if(section == 1){
                    titleLable.text = @"   联系人";
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] > 0){
                if(section == 0){
                    titleLable.text = @"   单聊";
                }else if(section == 1){
                    titleLable.text = @"   联系人";
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] == 0){
                if(section == 0){
                    titleLable.text = @"   单聊";
                }else if(section == 1){
                    titleLable.text = @"   群聊";
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] > 0){
                if(section == 0){
                    titleLable.text = @"   联系人";
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                if(section == 0){
                    titleLable.text = @"   单聊";
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] == 0){
                if(section == 0){
                    titleLable.text = @"   群聊";
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                return nil;
            }
        }else if(self.searchType == SDIMIDGSearchTypeSingleChat){
            if([_singleChatArray count] == 0){
                return nil;
            }else{
                titleLable.text = @"   单聊";
            }
        }else if(self.searchType == SDIMIDGSearchTypeGroupChat){
            if([_groupChatArray count] == 0){
                return nil;
            }else{
                titleLable.text = @"   群聊";
            }
        }else if(self.searchType == SDIMIDGSearchTypeContactConference){
            if([_voiceConferenceArray count] == 0){
                return nil;
            }else{
                titleLable.text = @"   联系人";
            }
        }
        [backView addSubview:titleLable];
        return backView;
    }
    return nil;
}

static NSString* SDConversationCellID = @"SDConversationCellID_Voice";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != _tableView){
        static NSString * searchResultMessageCellName = @"searchResultMessageCellName";
        SDIMSearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:searchResultMessageCellName];
        if(cell == nil){
            cell = [[SDIMSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchResultMessageCellName];
        }
        
        static NSString* cellName = @"ContactsCellName";
        UITableViewCell * contactsCell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!contactsCell) {
            contactsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        else {
            for (UIView* subView in contactsCell.contentView.subviews) {
                [subView removeFromSuperview];
            }
        }
        
        if(self.searchType == SDIMIDGSearchTypeAll){
            if([_singleChatArray count] > 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] > 0){
                if(indexPath.section == 0){
                    cell.message = _singleChatArray[indexPath.row];
                }else if(indexPath.section == 1){
                    cell.message = _groupChatArray[indexPath.row];
                }else if(indexPath.section == 2){
                    //头像
                    UIImageView* headImageView = [[UIImageView alloc] init];
                    headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
                    [contactsCell.contentView addSubview:headImageView];
                    
                    //部门
                    UILabel* departmentLabel = [[UILabel alloc] init];
                    departmentLabel.font = [UIFont systemFontOfSize:13.0];
                    departmentLabel.textColor = [UIColor blackColor];
                    departmentLabel.backgroundColor = [UIColor clearColor];
                    [contactsCell.contentView addSubview:departmentLabel];
                    
                    //名字
                    UILabel* nameLabel = [[UILabel alloc] init];
                    nameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
                    nameLabel.textColor = [UIColor blackColor];
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    [contactsCell.contentView addSubview:nameLabel];
                    
                    SDCompanyUserModel* userModel = self.voiceConferenceArray[indexPath.row];
                    [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
                    [departmentLabel sizeToFit];
                    departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
                    departmentLabel.y = (SDCellHeight - 13) / 2;
                    
                    nameLabel.text = userModel.realName;
                    nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDMainMessageFont);
                    contactsCell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    return contactsCell;
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] > 0){
                if(indexPath.section == 0){
                    cell.message = _groupChatArray[indexPath.row];
                }else if(indexPath.section == 1){
                    //头像
                    UIImageView* headImageView = [[UIImageView alloc] init];
                    headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
                    [contactsCell.contentView addSubview:headImageView];
                    
                    //部门
                    UILabel* departmentLabel = [[UILabel alloc] init];
                    departmentLabel.font = [UIFont systemFontOfSize:13.0];
                    departmentLabel.textColor = [UIColor blackColor];
                    departmentLabel.backgroundColor = [UIColor clearColor];
                    [contactsCell.contentView addSubview:departmentLabel];
                    
                    //名字
                    UILabel* nameLabel = [[UILabel alloc] init];
                    nameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
                    nameLabel.textColor = [UIColor blackColor];
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    [contactsCell.contentView addSubview:nameLabel];
                    
                    SDCompanyUserModel* userModel = self.voiceConferenceArray[indexPath.row];
                    [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
                    [departmentLabel sizeToFit];
                    departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
                    departmentLabel.y = (SDCellHeight - 13) / 2;
                    
                    nameLabel.text = userModel.realName;
                    nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDMainMessageFont);
                    contactsCell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    return contactsCell;
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] > 0){
                if(indexPath.section == 0){
                    cell.message = _singleChatArray[indexPath.row];
                }else if(indexPath.section == 1){
                    //头像
                    UIImageView* headImageView = [[UIImageView alloc] init];
                    headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
                    [contactsCell.contentView addSubview:headImageView];
                    
                    //部门
                    UILabel* departmentLabel = [[UILabel alloc] init];
                    departmentLabel.font = [UIFont systemFontOfSize:13.0];
                    departmentLabel.textColor = [UIColor blackColor];
                    departmentLabel.backgroundColor = [UIColor clearColor];
                    [contactsCell.contentView addSubview:departmentLabel];
                    
                    //名字
                    UILabel* nameLabel = [[UILabel alloc] init];
                    nameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
                    nameLabel.textColor = [UIColor blackColor];
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    [contactsCell.contentView addSubview:nameLabel];
                    
                    SDCompanyUserModel* userModel = self.voiceConferenceArray[indexPath.row];
                    [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
                    [departmentLabel sizeToFit];
                    departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
                    departmentLabel.y = (SDCellHeight - 13) / 2;
                    
                    nameLabel.text = userModel.realName;
                    nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDMainMessageFont);
                    contactsCell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    return contactsCell;
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] == 0){
                if(indexPath.section == 0){
                    cell.message = _singleChatArray[indexPath.row];
                }else if(indexPath.section == 1){
                    cell.message = _groupChatArray[indexPath.row];
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] > 0){
                if(indexPath.section == 0){
                    //头像
                    UIImageView* headImageView = [[UIImageView alloc] init];
                    headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
                    [contactsCell.contentView addSubview:headImageView];
                    
                    //部门
                    UILabel* departmentLabel = [[UILabel alloc] init];
                    departmentLabel.font = [UIFont systemFontOfSize:13.0];
                    departmentLabel.textColor = [UIColor blackColor];
                    departmentLabel.backgroundColor = [UIColor clearColor];
                    [contactsCell.contentView addSubview:departmentLabel];
                    
                    //名字
                    UILabel* nameLabel = [[UILabel alloc] init];
                    nameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
                    nameLabel.textColor = [UIColor blackColor];
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    [contactsCell.contentView addSubview:nameLabel];
                    
                    SDCompanyUserModel* userModel = self.voiceConferenceArray[indexPath.row];
                    [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
                    [departmentLabel sizeToFit];
                    departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
                    departmentLabel.y = (SDCellHeight - 13) / 2;
                    
                    nameLabel.text = userModel.realName;
                    nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDMainMessageFont);
                    contactsCell.contentView.backgroundColor = [UIColor whiteColor];
                    
                    return contactsCell;
                }
            }else if([_singleChatArray count] > 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                if(indexPath.section == 0){
                    cell.message = _singleChatArray[indexPath.row];
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] > 0 && [_voiceConferenceArray count] == 0){
                if(indexPath.section == 0){
                    cell.message = _groupChatArray[indexPath.row];
                }
            }else if([_singleChatArray count] == 0 && [_groupChatArray count] == 0 && [_voiceConferenceArray count] == 0){
                return nil;
            }
        }else if(self.searchType == SDIMIDGSearchTypeSingleChat){
            cell.message = _singleChatArray[indexPath.row];
        }else if(self.searchType == SDIMIDGSearchTypeGroupChat){
            cell.message = _groupChatArray[indexPath.row];
        }else if(self.searchType == SDIMIDGSearchTypeContactConference){
            //头像
            UIImageView* headImageView = [[UIImageView alloc] init];
            headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
            [contactsCell.contentView addSubview:headImageView];
            
            //部门
            UILabel* departmentLabel = [[UILabel alloc] init];
            departmentLabel.font = [UIFont systemFontOfSize:13.0];
            departmentLabel.textColor = [UIColor blackColor];
            departmentLabel.backgroundColor = [UIColor clearColor];
            [contactsCell.contentView addSubview:departmentLabel];
            
            //名字
            UILabel* nameLabel = [[UILabel alloc] init];
            nameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [contactsCell.contentView addSubview:nameLabel];
            
            SDCompanyUserModel* userModel = self.voiceConferenceArray[indexPath.row];
            [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            [departmentLabel sizeToFit];
            departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
            departmentLabel.y = (SDCellHeight - 13) / 2;
            
            nameLabel.text = userModel.realName;
            nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDMainMessageFont);
            contactsCell.contentView.backgroundColor = [UIColor whiteColor];
            
            return contactsCell;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView != _tableView){
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if([cell isKindOfClass:[SDIMSearchResultCell class]]){
            SDIMSearchResultCell * searchCell = (SDIMSearchResultCell *)cell;
            CXIMMessage *message = searchCell.message;
            CXIMConversation *conv = [[CXIMService sharedInstance].chatManager loadConversationWithMessageId:message.ID];
            if (message.type == CXIMMessageTypeChat) {
                SDIMChatViewController *chatVC = [[SDIMChatViewController alloc] init];
                chatVC.chatter = conv.chatter;
                chatVC.chatterDisplayName = [CXIMHelper getRealNameByAccount:conv.chatter];
                chatVC.isGroupChat = NO;
                chatVC.searchMessage = message;
                [self.navigationController pushViewController:chatVC animated:YES];
            }
            else if (message.type == CXIMMessageTypeGroupChat) {
                SDIMChatViewController *chatVC = [[SDIMChatViewController alloc] init];
                chatVC.chatter = conv.chatter;
                chatVC.chatterDisplayName = [[CXIMService sharedInstance].groupManager loadGroupForId:conv.chatter].groupName;
                chatVC.isGroupChat = YES;
                chatVC.searchMessage = message;
                [self.navigationController pushViewController:chatVC animated:YES];
            }
        }else{
            __block SDCompanyUserModel* userModel = self.voiceConferenceArray[indexPath.row];
            userModel.hxAccount = userModel.imAccount;
            if(![[CXLoaclDataManager sharedInstance] checkIsFriendWithUserModel:userModel]){
                //搜索人
                NSString *url = [NSString stringWithFormat:@"%@sysuser/getSysUser/%@", urlPrefix,userModel.imAccount];
                __weak __typeof(self)weakSelf = self;
                [self showHudInView:self.view hint:nil];
                [HttpTool getWithPath:url params:nil success:^(id JSON) {
                    [weakSelf hideHud];
                    NSDictionary *jsonDict = JSON;
                    if ([jsonDict[@"status"] integerValue] == 200) {
                        if(JSON[@"data"]){
                            userModel = [SDCompanyUserModel yy_modelWithDictionary:JSON[@"data"]];
                            userModel.hxAccount = userModel.imAccount;
                            userModel.realName = userModel.name;
                        }
                        SDIMAddFriendsDetailsViewController * addFriendsDetailsViewController = [[SDIMAddFriendsDetailsViewController alloc] init];
                        addFriendsDetailsViewController.userModel = userModel;
                        [weakSelf.navigationController pushViewController:addFriendsDetailsViewController animated:YES];
                        if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                            weakSelf.navigationController.interactivePopGestureRecognizer.delegate = nil;
                        }
                    }else{
                        TTAlert(JSON[@"msg"]);
                    }
                } failure:^(NSError *error) {
                    [weakSelf hideHud];
                    CXAlert(KNetworkFailRemind);
                }];
            }else{
                SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
                pivc.imAccount = userModel.imAccount;
                pivc.canPopViewController = YES;
                [self.navigationController pushViewController:pivc animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }
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

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    for(UIView * searchView in [searchBar subviews]){
        for(UIView * subView in [searchView subviews]){
            if([subView isKindOfClass:[UITextField class]]){
                UITextField * textField = (UITextField *)subView;
                if(!textField.text || [textField.text length] == 0){
                    self.searchType = SDIMIDGSearchTypeAll;
                }
            }
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchMessagesWithFilter:searchText];
}

#pragma mark - UISearchDisplayDelegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [self.view bringSubviewToFront:self.rootTopView];
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y + 45, tableView.frame.size.width, tableView.frame.size.height - 45);
    tableView.backgroundColor = SDBackGroudColor;
    
    //修复UITableView的分割线偏移的BUG
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, Screen_Width, 0);
    tableView.tableFooterView = footerView;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y - 45, tableView.frame.size.width, tableView.frame.size.height + 45);
}

- (NSDateFormatter*)dateFormatter
{
    static NSDateFormatter* fm = nil;
    if (fm == nil) {
        fm = [[NSDateFormatter alloc] init];
        [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return fm;
}


@end
