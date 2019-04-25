//
//  SDGroupChatViewController.m
//  SDMarketingManagement
//
//  Created by Rao on 15/8/31.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDGroupChatViewController.h"
#import "SDIMChatViewController.h"
#import "SDChatHeadView.h"
#import "SDGroupChatTableViewCell.h"
#import "SDMessageDropDownView.h"
#import "SDSendRangeViewController.h"
#import "SDVoiceManager.h"
#import "SDDataBaseHelper.h"
#import "SDMenuView.h"
#import "SDChatMessageManager.h"
#import "CXIMLib.h"
#import "SVProgressHUD.h"
#import "SDChatManager.h"
#import "CXIMHelper.h"

@interface SDGroupChatViewController () <UITableViewDataSource, UITableViewDelegate, SDMenuViewDelegate,UIGestureRecognizerDelegate,SDIMServiceDelegate,UIAlertViewDelegate>
/// 导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
/// 内容视图
@property (nonatomic, strong) UITableView* contentTableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray* sourceAry;

@property (nonatomic, strong) SDMessageDropDownView* messageDropDownView;

@property (nonatomic, strong) NSMutableArray *selectContactUserArr;

@property (strong, nonatomic) NSMutableArray* contactUserArr;
@property (copy, nonatomic) NSString* voiceConferenceTitle;

@property (copy, nonatomic)UILabel * numberOfGroupLabel;
/// 设置导航条
- (void)setUpNavBar;
/// 设置内容视图
- (void)setUpContentView;

/// 选择下拉菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
@property (nonatomic, strong) UIButton* selectedButton;
@property (nonatomic, strong) NSString* searchText;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL clickFlag;

@property (nonatomic,strong) UIAlertView* alertView;
@property (nonatomic, strong) NSArray* chatContactsArray;

@end

@implementation SDGroupChatViewController

//数据源
- (void)loadDataSource
{
    [self showHudInView:self.view hint:@"正在加载数据"];
    [[SDIMService sharedInstance] getJoinedGroupsWithAccount:VAL_HXACCOUNT completion:^(BOOL success, NSArray *groups, NSString *errMsg) {
        [self hideHud];
        if (!errMsg) {
            [_sourceAry removeAllObjects];
            for(SDGroupInfo * group in groups){
                if(group.groupType == SDGroupTypeNormal){
                    [_sourceAry addObject:group];
                }
            }
            [self.contentTableView reloadData];
        }
        else{
            TTAlert(@"获取群组列表失败");
        }
    }];
}

/// 设置内容视图
- (void)setUpContentView
{
    [self.view addSubview:self.contentTableView];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentTableView(_rootTopView)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentTableView, _rootTopView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rootTopView][_contentTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentTableView, _rootTopView)]];

    if (![self.sourceAry count]) {
        self.contentTableView.tableFooterView = [[UIView alloc] init];
    }
}

/// 内容视图
- (UITableView*)contentTableView
{
    if (nil == _contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        UseAutoLayout(_contentTableView);
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.rowHeight = 50.0;
        _contentTableView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.separatorInset = UIEdgeInsetsZero;
    }
    return _contentTableView;
}

/// 设置导航条
- (void)setUpNavBar
{
    _rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"工作群聊"];

    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];

    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(addBtnEvent:)];
}

- (void)addBtnEvent:(UIButton*)sender
{
    _selectedButton = sender;
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        NSArray* dataArray = @[ @"添加",  @"工作享团队" ];
        NSArray* imageArray = @[ @"add_chat", @"menu_service" ];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    else {
        [_selectMemu removeFromSuperview];
    }
}
#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    _selectedButton.selected = NO;
    [_selectMemu removeFromSuperview];

    if (cardID == 0) {
        __weak typeof(self) weakSelf = self;
        //发起聊天
        SDSendRangeViewController* srvc = [[SDSendRangeViewController alloc] init];
        srvc.isClientSelectEnabled = YES;
        
        srvc.selectContactUserCallBack = ^(NSArray* selectContactUserArr) {
            
            if (selectContactUserArr.count == 1) {
                //单聊
                NSMutableArray* hxAccount = [[selectContactUserArr valueForKey:@"hxAccount"] mutableCopy];
                
                SDIMChatViewController * chat = [[SDIMChatViewController alloc] init];
                chat.chatter = hxAccount[0];
                chat.chatterDisplayName = [[SDChatManager sharedChatManager] searchUserByHxAccount:hxAccount[0]].realName ? [[SDChatManager sharedChatManager] searchUserByHxAccount:hxAccount[0]].realName : hxAccount[0];
                chat.isGroupChat = NO;
                [self.navigationController pushViewController:chat animated:YES];
            }
            else {
                //群聊
                weakSelf.chatContactsArray = [selectContactUserArr mutableCopy];
                
                _alertView = [[UIAlertView alloc] initWithTitle:@"设置群聊名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [_alertView show];
            }
        };
        srvc.isChat = YES;
        srvc.titleVal = @"选择同事";
        [self presentViewController:srvc
                           animated:YES
                         completion:^{
                             
                         }];

    }
    else if (cardID == 1) {
        
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        UITextField * textField = [_alertView textFieldAtIndex:0];
        NSString *groupName = trim(textField.text);
        if (groupName.length <= 0) {
            [SVProgressHUD showErrorWithStatus:@"群组名称不能为空"];
            return;
        }
        NSMutableArray* hxAccount = [[_chatContactsArray valueForKey:@"hxAccount"] mutableCopy];
        
        if (hxAccount.count) {
            [SVProgressHUD showWithStatus:@"正在创建群组"];
            SDCreateGroupActionModel *model = [[SDCreateGroupActionModel alloc] init];
            model.companyId = VAL_companyId;
            model.groupType = SDGroupTypeNormal;
            NSMutableArray *members = [NSMutableArray array];
            [hxAccount enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                [members addObject:obj];
            }];
            model.members = members;
            model.owner = VAL_HXACCOUNT;
            model.groupName = groupName;
            [[SDIMService sharedInstance] createGroupWithActionModel:model completion:^(BOOL success, SDCreateGroupActionModel *result, NSString *errMsg) {
                if (success) {
                    [SVProgressHUD showSuccessWithStatus:@"创建成功"];
                    SDIMChatViewController * chat = [[SDIMChatViewController alloc] init];
                    chat.chatter = result.groupId;
                    chat.chatterDisplayName = groupName;
                    chat.isGroupChat = YES;
                    [self.navigationController pushViewController:chat animated:YES];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:@"创建失败"];
                }
            }];
        }
    }
    else {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpContentView];
    
    self.sourceAry = [[NSMutableArray alloc]initWithCapacity:0];
    [[SDIMService sharedInstance] addDelegate:self];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark -- 下拉菜单隐藏功能
-(void)tapAction:(UITapGestureRecognizer *)tapGseture
{
    _selectedButton.selected = NO;
    [_selectMemu removeFromSuperview];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self.view];
    if (CGRectContainsPoint(_selectMemu.frame, location) || CGRectContainsPoint(_selectedButton.frame, location)) {
        return NO;
    }
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataSource];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sourceAry count] + 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row <[self.sourceAry count]){
        static NSString* cellID = @"CELLID";
        SDGroupChatTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[SDGroupChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentTableView.rowHeight - 1, Screen_Width, 1)];
            lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [cell.contentView addSubview:lineLabel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SDGroupInfo* group = self.sourceAry[indexPath.row];
        cell.textLabel.text = group.groupName;
        
        //组聊头像
        NSString* imageName = @"groupPublicHeader";
        UIImage* headImage = nil;
        
        headImage = [[CXIMHelper sharedInstance] getImageFromGroup:group];
        
        
        if (headImage != nil) {
            cell.imageView.image = headImage;
        }
        else {
            cell.imageView.image = [UIImage imageNamed:imageName];
        }
        
        return cell;
    }else if(indexPath.row == [self.sourceAry count]){
        static NSString * cellName = @"cellName";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            _numberOfGroupLabel = [[UILabel alloc] init];
            _numberOfGroupLabel.frame = CGRectMake(0, 0, Screen_Width, 50);
            _numberOfGroupLabel.backgroundColor = [UIColor clearColor];
            _numberOfGroupLabel.textColor = RGBACOLOR(100, 100, 100, 1.0);
            _numberOfGroupLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:_numberOfGroupLabel];
        }
        _numberOfGroupLabel.text = [NSString stringWithFormat:@"%lu个群聊",(unsigned long)[self.sourceAry count]];
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    _selectedButton.selected = NO;
    [_selectMemu removeFromSuperview];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row < [self.sourceAry count]){
        if (_selectedButton.selected == YES) {
            _selectedButton.selected = NO;
            [_selectMemu removeFromSuperview];
        }
        
        SDGroupInfo *group = self.sourceAry[indexPath.row];
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

#pragma mark - UIScrollViewDelegate
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (_selectedButton.selected == YES) {
        _selectedButton.selected = NO;
        [_selectMemu removeFromSuperview];
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
    [[SDIMService sharedInstance]removeDelegate:self];
}
@end
