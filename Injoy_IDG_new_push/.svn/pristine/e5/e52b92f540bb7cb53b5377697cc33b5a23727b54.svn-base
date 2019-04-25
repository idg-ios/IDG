//
//  CXYMAddressBookViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/12/5.
//  Copyright © 2018 Injoy. All rights reserved.
//

#import "CXYMAddressBookViewController.h"
#import "CXYMAddressBookCell.h"
#import "SDMenuView.h"
#import "SDCompanyUserModel.h"
#import "CXBaseRequest.h"
#import "SDIMChatViewController.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "SDIMGroupListViewController.h"
#import "SDIMPersonInfomationViewController.h"
#import "CXIMHelper.h"
#import "CXIDGBackGroundViewUtil.h"
#import "MBProgressHUD+CXCategory.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "UIImageView+EMWebCache.h"
#import "IDGContactsViewController.h"

@interface CXYMAddressBookViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate,SDMenuViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *sortedArray;//区头首字母
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;
//选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
//选择的群聊人选数组
@property (strong, nonatomic) NSMutableArray* selectedGroupMembers;
//创建群组弹出的UIAlertView
@property (nonatomic, strong) UIAlertView* alertView;

@end
static NSString *const CXYMAddressBookViewCellIdentity = @"CXYMAddressBookViewCellIdentity";
@implementation CXYMAddressBookViewController

#pragma mark -- setter && getter
- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.frame = CGRectMake(0, 10, Screen_Width, 40);
        _searchBar.delegate = self;
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
        _tableView.sectionIndexColor = kIDGSectionIndexColor;//修改右边索引字体的颜色
        _tableView.backgroundColor = [CXIDGBackGroundViewUtil colorWithText:VAL_USERNAME AndTextColor:nil];//水印背景
        UIView *header = [[UIView alloc] initWithFrame:CGRectZero];
        header.backgroundColor = [UIColor whiteColor];
        header.bounds = CGRectMake(0, 0, 0, 140);
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = RGBACOLOR(250, 250, 250, 1.0);
        [header addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(60);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];

        UIButton *multipleChatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 59, Screen_Width, 80)];
        multipleChatButton.backgroundColor = [UIColor clearColor];
        [multipleChatButton setImage:[UIImage imageNamed:@"icon_QunLiao"] forState:0];
        [multipleChatButton setTitle:@"  群聊" forState:0];
        [multipleChatButton setTitleColor:[UIColor blackColor] forState:0];
        multipleChatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        multipleChatButton.titleEdgeInsets = UIEdgeInsetsMake(0, SDHeadImageViewLeftSpacing, 0, 0);
        multipleChatButton.imageEdgeInsets = UIEdgeInsetsMake(0, SDHeadImageViewLeftSpacing, 0, 0);
        [multipleChatButton addTarget:self action:@selector(multipleChatButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:multipleChatButton];
        [header addSubview:self.searchBar];
        _tableView.tableHeaderView = header;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXYMAddressBookCell class] forCellReuseIdentifier:CXYMAddressBookViewCellIdentity];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)sortedArray{
    if (_sortedArray == nil) {
        _sortedArray = [NSMutableArray array];
    }
    return _sortedArray;
}

- (SDMenuView *)selectMemu{
    if(!_selectMemu){
        NSArray* dataArray = @[ @"发起群聊"];
        NSArray* imageArray = @[ @"addGroupMessage"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    return _selectMemu;
}

- (UIAlertView *)alertView{
    if(!_alertView){
        _alertView = [[UIAlertView alloc] initWithTitle:@"设置群聊名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    return _alertView;
}

- (NSMutableArray *)selectedGroupMembers{
    if(!_selectedGroupMembers){
        _selectedGroupMembers = @[].mutableCopy;
    }
    return _selectedGroupMembers;
}

#pragma mark -- view circle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.RootTopView setNavTitle:@"通讯录"];
    [self.RootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add"] addTarget:self action:@selector(rightClick)];
    
    [self setupSubview];
    //点击屏幕selectMemu隐藏
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

#pragma mark -- SDMenuView
- (void)rightClick{
    if (!self.isSelectMenuSelected) {
        self.isSelectMenuSelected = YES;
        self.selectMemu.hidden = NO;
    }
    else {
        [self selectMenuViewDisappear];
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

- (void)selectMenuViewDisappear
{
    self.isSelectMenuSelected = NO;
    [self.selectMemu removeFromSuperview];
    self.selectMemu = nil;
}
- (void)multipleChatButtonClick{
    SDIMGroupListViewController* groupChatVC = [[SDIMGroupListViewController alloc] init];
    [self.navigationController pushViewController:groupChatVC animated:YES];
}

#pragma mark --SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName{
    [self selectMenuViewDisappear];
    if (cardID == 0) {
        [self showHudInView:self.view hint:@"加载中"];
        __weak typeof(self) weakSelf = self;
        CXIDGGroupAddUsersViewController* selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
        selectColleaguesViewController.navTitle = @"发起群聊";
        selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[[CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]]]];
        selectColleaguesViewController.selectContactUserCallBack = ^(NSArray* selectContactUserArr) {
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
                weakSelf.selectedGroupMembers = [selectContactUserArr mutableCopy];
                [weakSelf.alertView show];
            }
        };
        [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
        [self hideHud];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField* textField = [self.alertView textFieldAtIndex:0];
        NSString* groupName = trim(textField.text);
        if (groupName.length <= 0) {
            TTAlert(@"群组名称不能为空");
            return;
        }
        if([self.selectedGroupMembers count] > 49){
            [self.view makeToast:@"群聊人数最多50人，请重新选择！" duration:2 position:@"center"];
            return;
        }
        NSMutableArray* hxAccount = [[self.selectedGroupMembers valueForKey:@"hxAccount"] mutableCopy];
        
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

#pragma mark -- action
- (void)setupSubview{
    //Screen_Height - navHigh - TabBar_Height
//    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navHigh);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [self.view bringSubviewToFront:self.tableView];
   
}
- (void)totalButtonClick{
    if (self.dataArray.count == 0) {//拉取失败,重新请求
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

       NSString *url = [NSString stringWithFormat:@"%@/sysuser/list",urlPrefix];
       [CXBaseRequest  postResultWithUrl:url param:nil success:^(id responseObj) {
           NSInteger status = [responseObj[@"status"] integerValue];
           if (status == 200) {
               [[CXLoaclDataManager sharedInstance] saveLocalFriendsDataWithFriends:responseObj[@"data"]];
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self loadData];//重新分区
               });
               
           }else{
               [MBProgressHUD toastAtCenterForView:self.view text:@"获取通讯录信息失败,请稍后重试" duration:2];
           }
       } failure:^(NSError *error) {
           [MBProgressHUD toastAtCenterForView:self.view text:@"获取通讯录信息失败,请稍后重试" duration:2];
       }];
       
        });
    }
}
- (void)loadData{
    [self.sortedArray removeAllObjects];
    
    self.dataArray = [NSArray arrayWithArray:[[CXLoaclDataManager sharedInstance] getContacts]];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (SDCompanyUserModel *user in self.dataArray) {
        NSString *name = [user.name substringWithRange:NSMakeRange(0, 1)];
        //处理特殊姓氏
        if ([name isEqualToString:@"曾"]) {
            user.name = [NSString stringWithFormat:@"z%@",user.name];
        }
        if ([name isEqualToString:@"沈"]) {
            user.name = [NSString stringWithFormat:@"s%@",user.name];
        }
        [dataArray addObject:user];
    }
    self.dataArray = [dataArray copy];
    self.collation = [UILocalizedIndexedCollation currentCollation];

    for (int i = 0; i < self.collation.sectionTitles.count; i++) {
        NSMutableArray *mutArray = [NSMutableArray array];
        [self.sortedArray addObject:mutArray];
    }

    for (SDCompanyUserModel *user in self.dataArray) {
        NSInteger position = [self.collation sectionForObject:user collationStringSelector:@selector(name)];
        [self.sortedArray[position] addObject:user];
    }

    [self.sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [self.collation sortedArrayFromArray:obj collationStringSelector:@selector(name)];
        self.sortedArray[idx] = array;
    }];
    
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    
    [self.tableView reloadData];
}

- (void)menuView:(SDMenuView *)menuView returnCardID:(NSInteger)cardID withCardName:(NSString *)cardName{
    [menuView removeFromSuperview];
    menuView = nil;
    //业务跳转
   
    
}
#pragma mark --UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];

}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    SDCompanyUserModel;//name,phone,telephone,telePhone,account
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name CONTAINS [cd] %@ or telePhone CONTAINS %@ or telephone CONTAINS %@  or phone CONTAINS %@ or account CONTAINS %@",self.searchBar.text,self.searchBar.text,self.searchBar.text,self.searchBar.text,self.searchBar.text];
    self.searchArray = [self.dataArray filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}
#pragma mark --UITableViewDelegate,UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
     if (self.searchBar.text.length) {//搜索
         return 1;
     }else{
         return self.sortedArray.count + 1;//最后的联系人个数,27+1;
     }
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == self.sortedArray.count) {
        return 60.0;
    } else {
        NSArray *array = self.sortedArray[section];
        if (array.count == 0) {
            return 0;
        } else {
            return 20;
        }
    }
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchBar.text.length) {//搜索
        return self.searchArray.count;
    }else if(section == self.sortedArray.count){//最后的联系人个数
        return 0;
    }else{
        return [self.sortedArray[section] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:CXYMAddressBookViewCellIdentity forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
  
    SDCompanyUserModel *user;
    if (self.searchBar.text.length) {//搜索
        user = self.searchArray[indexPath.row];
    }else if(indexPath.section == self.sortedArray.count){
        user = [SDCompanyUserModel new];
    }else{//最后的联系人个数
        user = self.sortedArray[indexPath.section][indexPath.row];
    }
    [cell.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    //还原
    NSString *name = [user.name substringWithRange:NSMakeRange(0, 2)];
    if ([name isEqualToString:@"z曾"] || [name isEqualToString:@"s沈"]) {
        cell.nameLabel.text = [user.name substringWithRange:NSMakeRange(1, user.name.length - 1)];
    }else{
        cell.nameLabel.text = user.name;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectZero];
    
    if (self.searchBar.text.length) {
        return nil;
    } else {
        if (section == self.sortedArray.count) {//最后的联系人个数
            header.text = [NSString stringWithFormat:@"共有%lu个联系人",(unsigned long)self.dataArray.count];
            header.textColor = RGBACOLOR(31.0, 34.0, 40.0, 1.0);
            header.font = [UIFont systemFontOfSize:17];
            header.textAlignment = NSTextAlignmentCenter;
        }else{
            header.backgroundColor = RGBACOLOR(245.0, 246.0, 248.0, 1.0);
            header.textColor = RGBACOLOR(132.0, 142.0, 153.0, 1.0);
            header.font = [UIFont systemFontOfSize:14];
            header.text = [NSString stringWithFormat:@"  %@",[self.sortedArray[section] count] == 0 ? @"" : self.collation.sectionTitles[section]];
        }
        return header;
    }
}
//右侧索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.collation.sectionTitles;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SDCompanyUserModel *user;
    if (self.searchArray.count > 0) {
        user = self.searchArray[indexPath.row];
    } else {
        user = self.sortedArray[indexPath.section][indexPath.row];
    }
    SDIMPersonInfomationViewController *personInfomationViewController = [SDIMPersonInfomationViewController new];
    personInfomationViewController.imAccount = user.imAccount;
    personInfomationViewController.canPopViewController = true;
    [self.navigationController pushViewController:personInfomationViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.isSelectMenuSelected == YES) {
        [self selectMenuViewDisappear];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
