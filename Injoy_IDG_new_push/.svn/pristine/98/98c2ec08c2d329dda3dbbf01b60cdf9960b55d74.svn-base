//
//  SDIMContactsViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/5/4.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "AppDelegate.h"
#import "CXFocusSignListViewControler.h"
#import "CXIMHelper.h"
#import "CXScanViewController.h"
#import "ChineseToPinyin.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "SDChatManager.h"
#import "SDContactsDetailController.h"
#import "SDDataBaseHelper.h"
#import "SDIMAddFriendsViewController.h"
#import "SDIMChatViewController.h"
#import "SDIMChatViewController.h"
#import "SDIMContactsViewController.h"
#import "SDIMGroupListViewController.h"
#import "SDIMNewFriendsApplicationListViewController.h"
#import "SDIMReceiveAndPayMoneyViewController.h"
#import "SDIMSearchVIewController.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "SDMenuView.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "YYModel.h"
#import "SDIMKefuListViewController.h"
#import "QRCodeGenerator.h"
#import "QLPreviewItemCustom.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import "CXLoaclDataManager.h"
#import "SDInviteViewController.h"
#import "CXDepartmentListViewController.h"
#import "CXYJNewColleaguesVIewControllerViewController.h"
#import "CXIDGBackGroundViewUtil.h"
#import "SDIMPersonInfomationViewController.h"
#import "Masonry.h"
#import "CXIDGGroupAddUsersViewController.h"

#define kBadgeImageWidth 10.0

#define kFilePath [NSString stringWithFormat:@"%@/Documents/QR", NSHomeDirectory()]

@interface SDIMContactsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SDMenuViewDelegate, UIGestureRecognizerDelegate>

//导航栏
@property (nonatomic, strong) SDRootTopView* rootTopView;

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UISearchBar* mySearchBar;
//数据源
@property (nonatomic, strong) NSMutableDictionary* dataSource;
//是否是搜索的
@property (nonatomic) BOOL isFromSearch;
//联系人数据源
@property (nonatomic, strong) NSMutableArray* contactsSource;
//右边索引数组
@property (nonatomic, strong) NSMutableArray* indexSectionAry;
//第一个section数组
@property (nonatomic, strong) NSMutableArray* firstSectionAry;
//第一个section图片数组
@property (nonatomic, strong) NSMutableArray* firstSectionImageAry;
//sectionTitle数组
@property (nonatomic, strong) NSMutableArray* sectionIndexTitlesArr;
//搜索的数据源
@property (nonatomic, strong) NSMutableArray* searchArray;
//选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;

@property (strong, nonatomic) NSMutableArray* chatContactsArray;
//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;

@property (nonatomic, strong) UIAlertView* alertView;

@property (nonatomic, strong) NSString * imageName;

//联系人table列表的背景颜色
@property (nonatomic, strong) UIView * contactsTableViewBackView;

@end

@implementation SDIMContactsViewController

#pragma mark - 懒加载
- (UIView *)contactsTableViewBackView{
    if(!_contactsTableViewBackView){
        _contactsTableViewBackView = [[UIView alloc] init];
        _contactsTableViewBackView.frame = self.tableView.frame;
        _contactsTableViewBackView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contactsTableViewBackView];
    }
    return _contactsTableViewBackView;
}

//索引数组
- (NSMutableArray*)indexSectionAry
{
    _indexSectionAry = [[NSMutableArray alloc] init];
    for (SDCompanyUserModel* buddy in _contactsSource) {
        NSString* firstLetter = [[[ChineseToPinyin pinyinFromChineseString:buddy.name] lowercaseString] substringWithRange:NSMakeRange(0, 1)];
        if([buddy.name length] > 0){
            if (0 == isalpha([firstLetter UTF8String][0])) {
                // 如果不是字母
                firstLetter = @"#";
            }
            
            if (![_indexSectionAry containsObject:firstLetter]) {
                [_indexSectionAry addObject:firstLetter];
            }
        }
    }
    // 按照字母升序
    [_indexSectionAry sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*)obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    
    if ([_indexSectionAry containsObject:@"#"]) {
        [_indexSectionAry removeObject:@"#"];
        [_indexSectionAry addObject:@"#"];
    }
    [_indexSectionAry insertObject:@"↑" atIndex:0];
    
    return _indexSectionAry;
}

- (NSMutableArray*)firstSectionImageAry
{
    _firstSectionImageAry = [[NSMutableArray alloc] initWithObjects: @"icon_QunLiao", nil];
    return _firstSectionImageAry;
}

/// 第一个section数组
- (NSMutableArray*)firstSectionAry
{
    _firstSectionAry = [[NSMutableArray alloc] initWithObjects: @"群聊", nil];
    return _firstSectionAry;
}

- (NSArray*)sectionIndexTitlesArr
{
    NSMutableArray* retArr = [[NSMutableArray alloc] init];
    [retArr addObject:@"↑"];
    for (int i = 65; i < 65 + 26; i++) {
        [retArr addObject:[NSString stringWithFormat:@"%C", (unichar)i]];
    }
    [retArr addObject:@"#"];
    _sectionIndexTitlesArr = [retArr copy];
    return _sectionIndexTitlesArr;
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.mySearchBar.text == nil || (self.mySearchBar.text != nil && [self.mySearchBar.text length] <= 0)) {
        [self.mySearchBar setShowsCancelButton:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.dataSource || [self.dataSource count] <= 0){
        [self refreshTable];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _dataSource = [[NSMutableDictionary alloc] init];
    _contactsSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setUpView];
    
    self.tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - TabBar_Height);
    self.tableView.bounces = YES;
    self.contactsTableViewBackView.frame = self.tableView.frame;
    self.tableView.backgroundColor = [CXIDGBackGroundViewUtil colorWithText:VAL_USERNAME AndTextColor:nil];
    [self.view bringSubviewToFront:self.tableView];
    
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 内部方法
- (void)setUpView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"通讯录")];//旧版通讯录
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, Screen_Width, Screen_Height - 66 - TabBar_Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60.0;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorColor = [UIColor clearColor];
    
    //修改索引颜色
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
    _tableView.sectionIndexColor = kIDGSectionIndexColor;//修改右边索引字体的颜色
    _tableView.sectionIndexTrackingBackgroundColor = kIDGSectionIndexColor;//修改右边索引点击时候的背景色
    
    // 索引背景透明
    if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_tableView];
    
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(downloadContact)];
    
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10.f, Screen_Width, 60)];
    self.mySearchBar.backgroundImage = [[UIImage alloc] init];
    self.mySearchBar.backgroundColor = [UIColor whiteColor];
    self.mySearchBar.delegate = self;
    self.mySearchBar.placeholder = @"搜索";
    UITextField *searchField = [self.mySearchBar valueForKey:@"searchField"];

    if (searchField) {
        searchField.backgroundColor = kColorWithRGB(245, 246, 248);
        searchField.font = [UIFont systemFontOfSize:14];
        searchField.layer.borderWidth = 2.0;
        searchField.layer.borderColor = kColorWithRGB(245, 246, 248).CGColor;
        searchField.layer.cornerRadius = 2;
        searchField.layer.masksToBounds = YES;
        searchField.frame = CGRectMake(15, 12, Screen_Width-39, 36);
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorWithRGB(245, 246, 248);
    line.frame = CGRectMake(0, 59, Screen_Width, 0.5);
    [self.mySearchBar addSubview:line];
    
    self.tableView.tableHeaderView = self.mySearchBar;
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

- (void)searchBtnClick
{
    SDIMSearchVIewController* searchVIewController = [[SDIMSearchVIewController alloc] init];
    [self.navigationController pushViewController:searchVIewController animated:YES];
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

#pragma mark - 获取通讯录数据源
- (void)downloadContact
{
    SDDataBaseHelper* helper = [SDDataBaseHelper shareDB];
    if ([helper deleteAllTable]) {
        NSString* url = [NSString stringWithFormat:@"%@/sysuser/list", urlPrefix];
        __weak typeof(self) wself = self;
        [HttpTool postWithPath:url
                        params:nil
                       success:^(id JSON) {
                           
                           NSDictionary* dic = JSON;
                           NSNumber* status = dic[@"status"];
                           if ([status intValue] == 200) {
                               // 保存到本地
                               dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                   NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                                   NSMutableArray *data = @[].mutableCopy;
                                   for (NSDictionary *u in JSON[@"data"]) {
                                       NSMutableDictionary *mutableU = u.mutableCopy;
                                       if ([mutableU[@"icon"] isKindOfClass:NSNull.class]) {
                                           mutableU[@"icon"] = @"";
                                       }
                                       [data addObject:mutableU];
                                   }
//                                   [[CXLoaclDataManager sharedInstance] saveLocalFriendsDataWithFriends:JSON[@"data"]];
                                   
                                   for (NSDictionary* userDic in JSON[@"data"]) {
                                       SDCompanyUserModel* userModel = [SDCompanyUserModel yy_modelWithDictionary:userDic];
                                       userModel.userId = @([userDic[@"userId"] integerValue]);
                                       [helper insertCompanyUser:userModel];
                                   }
                                   
                                   [userDefaults synchronize];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [wself hideHud];
                                       wself.isFromSearch = NO;
                                       [wself.mySearchBar resignFirstResponder];
                                       wself.mySearchBar.text = @"";
                                       [wself refreshTable];
                                   });
                               });
                           }
                           else{
                               [wself hideHud];
                               [wself.view makeToast:JSON[@"msg"] duration:2.0 position:@"center"];
                           }
                           [_tableView.legendHeader endRefreshing];
                       }
                       failure:^(NSError* error) {
                           [wself hideHud];
                           [_tableView.legendHeader endRefreshing];
                           TTAlertNoTitle(KNetworkFailRemind);
                       }];
        
    }
}

#pragma mark 刷新通讯录数据table
- (void)refreshTable
{
    NSArray* sourceAry = [NSArray arrayWithArray:[[CXLoaclDataManager sharedInstance] getAllKJDepContacts]];
    [_indexSectionAry removeAllObjects];
    _indexSectionAry = nil;
    [self.contactsSource removeAllObjects];
    [self.dataSource removeAllObjects];
    self.contactsSource = [NSMutableArray arrayWithArray:sourceAry];
    NSMutableArray* indexTitleAry = self.indexSectionAry;
    __weak typeof(self) weakSelf = self;
    [indexTitleAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [weakSelf.dataSource setValue:[NSMutableArray array] forKey:(NSString*)obj];
    }];
    [self.dataSource setValue:self.firstSectionAry forKey:@"↑"];
    
    for (NSString* firstLetter in indexTitleAry) {
        @autoreleasepool {
            // 字母对应的人员数组
            NSMutableArray* valAry = self.dataSource[firstLetter];
            for (SDCompanyUserModel* buddy in self.contactsSource) {
                if ([firstLetter isEqualToString:[[[ChineseToPinyin pinyinFromChineseString:buddy.name] lowercaseString] substringWithRange:NSMakeRange(0, 1)]]) {//排序条件
                    if (![valAry containsObject:buddy]) {
                        [valAry addObject:buddy];
                    }
                }
                else if ([buddy.name length] > 0 && 0 == isalpha([[ChineseToPinyin pinyinFromChineseString:buddy.name] UTF8String][0])) {
                    // 如果是#
                    NSMutableArray* tempAry = self.dataSource[@"#"];
                    if (NO == [tempAry containsObject:buddy]) {
                        [tempAry addObject:buddy];
                    }
                }
            }
        }
    }
    [self sectionIndexTitlesArr];
    [self indexSectionAry];
    [self firstSectionAry];
    [self firstSectionImageAry];
    [self sortContactsDataSource:self.dataSource.copy];
    [self.tableView reloadData];
}

- (void)sortContactsDataSource:(NSMutableDictionary *)dataSource
{
    [dataSource enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSArray<SDCompanyUserModel *> * obj, BOOL * _Nonnull stop) {
        if(dataSource[key] && [dataSource[key] count] > 0){
            NSMutableArray * sortArray = [dataSource[key] copy];
            NSArray * sortedArray = [sortArray sortedArrayUsingComparator:^NSComparisonResult(SDCompanyUserModel *  _Nonnull obj1, SDCompanyUserModel *  _Nonnull obj2) {
                //给对象排序
                NSComparisonResult result = [obj1.name compare:obj2.name];
                return result;
            }];
            self.dataSource[key] = sortedArray;
        }
    }];
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    [self selectMenuViewDisappear];
    
    if (cardID == 0) {
        [self showHudInView:self.view hint:@"加载中"];
        __weak typeof(self) weakSelf = self;
        CXIDGGroupAddUsersViewController* selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
        selectColleaguesViewController.navTitle = @"发起群聊";
        selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[ [CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]] ]];
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
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (!self.isFromSearch) {
        return (NSInteger)[[self.dataSource allKeys] count];
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isFromSearch) {
        if(section == ([[self.dataSource allKeys] count] - 1)){
            return (NSInteger)[[self.dataSource valueForKey:_indexSectionAry[section]] count] + 1;
        }
        return (NSInteger)[[self.dataSource valueForKey:_indexSectionAry[section]] count];
    }
    else {
        return self.searchArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"CellName";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
        for (UIView* subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    
    //头像
    UIImageView* headImageView = [[UIImageView alloc] init];
    headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    [cell.contentView addSubview:headImageView];
    
    //部门
    UILabel* departmentLabel = [[UILabel alloc] init];
    departmentLabel.font = [UIFont systemFontOfSize:13.0];
    departmentLabel.textColor = [UIColor blackColor];
    departmentLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:departmentLabel];
    
    //名字
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    nameLabel.textColor = SDChatterDisplayNameColor;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:nameLabel];
    
    if (!self.isFromSearch) {
        if(indexPath.row == [self.dataSource[_indexSectionAry[indexPath.section]] count]){
            static NSString* countCellName = @"countCellName";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:countCellName];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:countCellName];
            }
            else {
                for (UIView* subView in cell.contentView.subviews) {
                    [subView removeFromSuperview];
                }
                cell.contentView.backgroundColor = [UIColor clearColor];
            }
            
            UIView * rightBackView = [[UIView alloc] init];
            rightBackView.frame = CGRectMake(Screen_Width - 30, 0, 30, SDCellHeight + 2);
            rightBackView.backgroundColor = SDBackGroudColor;
            [cell addSubview:rightBackView];
            
            UILabel * countLabel = [[UILabel alloc] init];
            countLabel.text = [NSString stringWithFormat:@"%zd位联系人",[self.contactsSource count]];
            countLabel.frame = CGRectMake(0, 0, Screen_Width, SDCellHeight);
            countLabel.backgroundColor = [UIColor clearColor];
            countLabel.textColor = SDSectionTitleColor;
            countLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:countLabel];
            
            UIView * bottomView = [[UIView alloc] init];
            bottomView.backgroundColor = SDBackGroudColor;
            bottomView.frame = CGRectMake(0, SDCellHeight - 2, Screen_Width, 6);
            [cell addSubview:bottomView];
            cell.contentView.backgroundColor = SDBackGroudColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            if (indexPath.section == 0) {
                headImageView.image = [UIImage imageNamed:self.firstSectionImageAry[indexPath.row]];
                headImageView.highlightedImage = [UIImage imageNamed:self.dataSource[_indexSectionAry[indexPath.section]][indexPath.row]];
                
                nameLabel.text = self.dataSource[_indexSectionAry[indexPath.section]][indexPath.row];
                nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, 0, 300, SDCellHeight);
                
                if(indexPath.row != 0){
                    UIView * bottomWhiteView = [[UIView alloc] init];
                    bottomWhiteView.frame = CGRectMake(10, SDCellHeight - 0.5, Screen_Width - 10*2, 0.5);
                    bottomWhiteView.backgroundColor = RGBACOLOR(214.0, 214.0, 214.0, 1.0);;
                    [cell.contentView addSubview:bottomWhiteView];
                }
                
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.backgroundColor = [UIColor whiteColor];
            }
            else {
                SDCompanyUserModel* userModel = self.dataSource[_indexSectionAry[indexPath.section]][indexPath.row];
                [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
                [departmentLabel sizeToFit];
                departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
                departmentLabel.y = (SDCellHeight - 13) / 2;
                
                nameLabel.text = userModel.name;
                nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, 0, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDCellHeight);
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];
                
                if(indexPath.row < [self.dataSource[_indexSectionAry[indexPath.section]] count] - 1){
                    UIView * bottomWhiteView = [[UIView alloc] init];
                    bottomWhiteView.frame = CGRectMake(10, SDCellHeight - 0.5, Screen_Width - 10*2, 0.5);
                    bottomWhiteView.backgroundColor = RGBACOLOR(214.0, 214.0, 214.0, 1.0);;
                    [cell.contentView addSubview:bottomWhiteView];
                }
                
            }
        }
    }
    else {
        SDCompanyUserModel* userModel = self.searchArray[indexPath.row];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        [departmentLabel sizeToFit];
        departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
        departmentLabel.y = (SDCellHeight - 13) / 2;
        
        nameLabel.text = userModel.name;
        nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, 0, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDCellHeight);
        
        if(indexPath.row < [self.searchArray count] - 1){
            UIView * bottomWhiteView = [[UIView alloc] init];
            bottomWhiteView.frame = CGRectMake(10, SDCellHeight - 0.5, Screen_Width - 10*2, 0.5);
            bottomWhiteView.backgroundColor = RGBACOLOR(214.0, 214.0, 214.0, 1.0);;
            [cell.contentView addSubview:bottomWhiteView];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 16.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 16.0)];
    lable.backgroundColor = RGBACOLOR(245.0, 246.0, 248.0, 1.0);
    if (!self.isFromSearch) {
        NSString* title = [_indexSectionAry[section] uppercaseString];
        lable.text = [NSString stringWithFormat:@"    %@", title];
        lable.textColor = RGBACOLOR(132.0, 142.0, 153.0, 1.0);
        lable.font = [UIFont systemFontOfSize:14.0f];
        if ([title isEqualToString:@"↑"]) {
            lable.text = @"";
        }
    }
    else {
        lable.text = nil;
    }
    return lable;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    if (!self.isFromSearch) {
        return [self sectionIndexTitlesArr];
    }
    else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return [[_indexSectionAry valueForKey:@"uppercaseString"] indexOfObject:title];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.isFromSearch) {
        if(indexPath.row == [self.dataSource[_indexSectionAry[indexPath.section]] count]){
            
        }else{
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    SDIMGroupListViewController* groupChatVC = [[SDIMGroupListViewController alloc] init];
                    [self.navigationController pushViewController:groupChatVC animated:YES];
                    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                    }
                }
            }
            else {
                __block SDCompanyUserModel* userModel = self.dataSource[_indexSectionAry[indexPath.section]][indexPath.row];
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
                                userModel.name = userModel.name;
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
    else {
        __block SDCompanyUserModel* userModel = self.searchArray[indexPath.row];
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
                        userModel.name = userModel.name;
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

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.mySearchBar resignFirstResponder];
    return indexPath;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self selectMenuViewDisappear];
    [self.mySearchBar setShowsCancelButton:YES];
    return YES;
}

//取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self.mySearchBar resignFirstResponder];
    [self.mySearchBar setShowsCancelButton:NO];
    self.mySearchBar.text = nil;
    self.isFromSearch = NO;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    //搜索内容随着输入及时地显示出来
    if ([searchText length] == 0) {
        [self.mySearchBar setShowsCancelButton:NO];
        UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
        _mySearchBar.tintColor = [UIColor blackColor];
        self.isFromSearch = NO;
        [self.tableView reloadData];
        return;
    }
    else {
        [self.mySearchBar setShowsCancelButton:YES];
        UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
        _mySearchBar.tintColor = [UIColor blackColor];
        self.isFromSearch = YES;
        [self handleSearchBarContent:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self.mySearchBar resignFirstResponder];
    [self.mySearchBar setShowsCancelButton:YES];
    [self handleSearchBarContent:searchBar.text];
}

#pragma mark 重新加载搜索到数据
- (void)handleSearchBarContent:(NSString*)searchStr
{
    NSMutableArray* searchDataSource = [NSMutableArray array];
    for (SDCompanyUserModel* userModel in self.contactsSource) {
        if ([NSString containWithSelectedStr:[self toLower:userModel.name] contain:[self toLower:searchStr]]) {
            [searchDataSource addObject:userModel];
        }else if([NSString containWithSelectedStr:[self toUpper:userModel.name] contain:[self toUpper:searchStr]]){
            [searchDataSource addObject:userModel];
        }
    }
    self.searchArray = searchDataSource;
    
    for(SDCompanyUserModel* contactUserModel in self.contactsSource){
        if([NSString containWithSelectedStr:contactUserModel.telephone contain:searchStr] || [NSString containWithSelectedStr:contactUserModel.phone contain:searchStr]){
            BOOL isNotINSearchDataSource = YES;
            for(SDCompanyUserModel* userModel in self.searchArray){
                if([contactUserModel.imAccount isEqualToString:userModel.imAccount]){
                    isNotINSearchDataSource = NO;
                }
            }
            if(isNotINSearchDataSource){
                [self.searchArray addObject:contactUserModel];
            }
        }
    }
    
    [self.tableView reloadData];
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

@end
